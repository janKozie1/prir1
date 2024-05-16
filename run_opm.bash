#!/bin/bash

# Check if the number of command-line arguments is correct
if [ $# -ne 3 ]; then
    echo "Usage: $0 <number_of_runs> <number_of_processes> <number_of_threads>"
    exit 1
fi

# Clear the results file if it exists
results_file="results_omp.txt"
if [ -f "$results_file" ]; then
    > "$results_file"  # Truncate the file
fi

# Extract command-line arguments
number_of_runs=$1
number_of_processes=$2
number_of_threads=$3

# Run the program "trapez_omp" with mpirun n times sequentially
for ((i=1; i<=$number_of_runs; i++)); do
    echo "Running iteration $i"
    mpirun -n "$number_of_processes" ./trapez_omp "$number_of_threads" >> "$results_file"
done
