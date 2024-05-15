# Compilers
CC = mpic++
CXX = /opt/homebrew/opt/llvm/bin/clang++

# Flags for compilers
CFLAGS = -std=c++11 -fopenmp -I/opt/homebrew/opt/open-mpi/include -L/opt/homebrew/opt/open-mpi/lib -lmpi
CXXFLAGS = -std=c++17 -fopenmp

# Name of the executables
TARGET1 = trapez_single
TARGET2 = trapez_omp

# Source files
SOURCES1 = trapez_single.cpp
SOURCES2 = trapez_omp.cpp

# Object files
OBJECTS1 = $(SOURCES1:.cpp=.o)
OBJECTS2 = $(SOURCES2:.cpp=.o)

# Default target
all: $(TARGET1) $(TARGET2)

# Rule for the first target (clang++)
$(TARGET1): $(OBJECTS1)
	$(CXX) $(OBJECTS1) $(CXXFLAGS) -o $@

$(OBJECTS1): $(SOURCES1)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule for the second target (mpic++)
$(TARGET2): $(OBJECTS2)
	$(CC) $(CFLAGS) -o $@ $(SOURCES2)

$(OBJECTS2): $(SOURCES2)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up
clean:
	rm -f $(TARGET1) $(TARGET2) $(OBJECTS1) $(OBJECTS2)

.PHONY: all clean
