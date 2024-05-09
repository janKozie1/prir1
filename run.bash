#!/bin/bash

# Check for minimum required arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 <program path> <number of runs> <program argument>"
    exit 1
fi

# First argument is the path to the executable program
PROGRAM="$1"

# Second argument is the number of times the program should run
N="$2"

# The rest are arguments for the program
PROGRAM_ARGS="${@:3}"

# Check if N is a valid number
if ! [[ "$N" =~ ^[0-9]+$ ]]; then
    echo "Error: '$N' is not a valid number."
    exit 1
fi

# Check if the program exists and is executable
if [ ! -f "$PROGRAM" ] || [ ! -x "$PROGRAM" ]; then
    echo "Error: Program '$PROGRAM' does not exist or is not executable."
    exit 1
fi

# Loop to run the program N times with the argument
for (( i=1; i<=N; i++ ))
do
    $PROGRAM $PROGRAM_ARGS
    # Optionally check the exit status to handle errors
    if [ $? -ne 0 ]; then
        echo "Error: Program failed during run #$i"
        exit 1
    fi
done

