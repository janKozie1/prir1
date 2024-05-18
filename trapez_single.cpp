#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cmath>

void saveToFile(const std::string& filename, const std::string& lineToAdd) {
  std::ofstream file(filename, std::ios::app);
  file << lineToAdd << std::endl;
  file.close();
}

long double f(long double x) {
  return x * x * sin(x * x);
}

long double trapezoidalRule(long double a, long double b, int n) {
  long double h = (b - a) / n;
  long double sum = 0.5 * (f(a) + f(b));

  for (int i = 1; i < n; i++) {
      sum += f(a + i * h);
  }

  return h * sum;
}

int main(int argc, char* argv[]) {
  std::ifstream file("constants.txt");

  int a, b, steps;
  std::string line;

  if (getline(file, line)) { a = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }
  if (getline(file, line)) { b = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }
  if (getline(file, line)) { steps = std::stoi(line); } else { std::cerr << "Unparsable config file" << std::endl; return 1; }

  auto start = std::chrono::high_resolution_clock::now();

  long double integral_estimate = trapezoidalRule(a, b, steps);

  auto stop = std::chrono::high_resolution_clock::now();
  auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);

  std::cout << "Estimated value of the integral using a trapezoidal rule: " << integral_estimate << std::endl;
  std::cout << "Time taken: " << duration.count() << " ms" << std::endl;

  saveToFile("./results_single.txt", std::to_string(a) + "," + std::to_string(b) + "," + std::to_string(steps) + "," + std::to_string(duration.count()));

  return 0;
}
