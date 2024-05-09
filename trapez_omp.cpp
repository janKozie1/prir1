#include <iostream>
#include <cstdlib>
#include <omp.h>
#include <mpi.h>
#include <fstream>
#include <map>
#include <chrono>


void addLineToFile(const std::string& filename, const std::string& lineToAdd) {
  std::ofstream file(filename, std::ios::app);

  if (file.is_open()) {
      file << lineToAdd << std::endl;
      file.close();
  } else {
      std::cerr << "Unable to open file: " << filename << std::endl;
  }
}

long double f(long double x) {
  return x * x * sin(x * x);
}

long double trapezoidalRule(long double a, long double b, int n, int num_of_threads) {
  long double h = (b - a) / n;
  long double sum = 0.5 * (f(a) + f(b));

  omp_set_num_threads(num_of_threads);
  #pragma omp parallel for reduction(+:sum) num_threads(num_of_threads)
  for (int i = 1; i < n; i++) {
      sum += f(a + i * h);
  }

  return h * sum;
}

int main(int argc, char* argv[]) {
  MPI_Init(&argc, &argv);

  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  if (argc != 3) {
    std::cout << "Usage: " << argv[0] << " <number_of_threads> <number_of_processes>" << std::endl;
    MPI_Finalize();
    return 1;
  }

  int num_of_threads = std::atoi(argv[1]);
  int num_of_processes = std::atoi(argv[2]);

  std::ifstream file("constants.txt");
  int a, b, steps;

  if (rank == 0) {
    std::string line;
    if (getline(file, line)) { a = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }
    if (getline(file, line)) { b = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }
    if (getline(file, line)) { steps = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }
  }

  MPI_Bcast(&a, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&b, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&steps, 1, MPI_INT, 0, MPI_COMM_WORLD);

  int local_n = steps / size;
  long double local_a = a + rank * local_n * ((b - a) / (double)steps);
  long double local_b = local_a + local_n * ((b - a) / (double)steps);

  auto start = std::chrono::high_resolution_clock::now();

  long double local_integral = trapezoidalRule(local_a, local_b, local_n, num_of_threads);

  long double total_integral = 0;
  MPI_Reduce(&local_integral, &total_integral, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

  auto stop = std::chrono::high_resolution_clock::now();

  if (rank == 0) {
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);

    std::cout << "Estimated value of the integral using a trapezoidal rule: " << total_integral << std::endl;
    std::cout << "Time taken: " << duration.count() << " ms" << std::endl;

    addLineToFile("./results_omp.txt", std::to_string(a) + "," + std::to_string(b) + "," + std::to_string(steps) + "," + std::to_string(duration.count()) + "," + std::to_string(num_of_threads) + "," + std::to_string(num_of_processes));
  }

  return 0;
}
