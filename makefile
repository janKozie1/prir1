# ARCH_FLAGS := -arch armv7 -arch armv7s
# VALID_ARCH_FLAGS := -march=armv6 -march=armv7 -march=armv7s -march=arm64
CXX=/opt/homebrew/opt/llvm/bin/clang++  # Path to the clang++ compiler
CXXFLAGS=-std=c++17 -fopenmp # $(ARCH_FLAGS)  # Use C++17 standard, enable OpenMP, add arch flags
#LDFLAGS=-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++ # Add any necessary linker flags here, potentially $(ARCH_FLAGS)

# Names of the final executables
TARGET1=trapez_single
#TARGET2=trapez_omp

# List of source files
SOURCES1=trapez_single.cpp
#SOURCES2=trapez_omp.cpp

# List of object files
OBJECTS1=$(SOURCES1:.cpp=.o)
#OBJECTS2=$(SOURCES2:.cpp=.o)

# Default target
all: $(TARGET1) #$(TARGET2)

# Rules for the first target
$(TARGET1): $(OBJECTS1)
	$(CXX) $(OBJECTS1) $(CXXFLAGS) $(LDFLAGS) -o $@

$(OBJECTS1): $(SOURCES1)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rules for the second target
# $(TARGET2): $(OBJECTS2)
# 	$(CXX) $(OBJECTS2) $(CXXFLAGS) $(LDFLAGS) -o $@

# $(OBJECTS2): $(SOURCES2)
# 	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean target
clean:
	rm -f $(TARGET1) $(OBJECTS1)
# $(TARGET2) $(OBJECTS2)

.PHONY: all clean
