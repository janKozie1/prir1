#!/bin/bash

# Check if the number of command-line arguments is correct
if [ $# -ne 1 ]; then
    echo "Usage: $0 <number_of_runs>"
    exit 1
fi

# Clear the results file if it exists
results_file="results_single.txt"
if [ -f "$results_file" ]; then
    > "$results_file"  # Truncate the file
fi

# Run the program "trapez_single" n times sequentially
number_of_runs=$1
for ((i=1; i<=$number_of_runs; i++)); do
    echo "Running iteration $i"
    ./trapez_single
done
