#!/bin/bash

# Define the Fortran source files and the output executable name
MODULE_FILE="variables.f90"
TDMA_FILE="TDMA.f90"
SOURCE_FILE="Linear_advection.f90"
OUTPUT_FILE="Linear_advection"
PLOT_SCRIPT="plot.py"
DATA_FILE="data.txt"

# Compile the module
gfortran -c "$MODULE_FILE"
if [ $? -ne 0 ]; then
    echo "Module compilation failed."
    exit 1
fi

# Compile the TDMA subroutine
gfortran -c "$TDMA_FILE"
if [ $? -ne 0 ]; then
    echo "TDMA compilation failed."
    exit 1
fi

# Compile the main program
gfortran -c "$SOURCE_FILE"
if [ $? -ne 0 ]; then
    echo "Main program compilation failed."
    exit 1
fi

# Link the object files to create the executable
gfortran -o "$OUTPUT_FILE" Linear_advection.o TDMA.o variables.o
if [ $? -eq 0 ]; then
    echo "Compilation successful. Running the program..."
    ./"$OUTPUT_FILE"
else
    echo "Linking failed."
    exit 1
fi

# Run the Python plotting script
if [ -f "$PLOT_SCRIPT" ]; then
    echo "Running the plotting script..."
    python3 "$PLOT_SCRIPT"
else
    echo "Plotting script not found."
    exit 1
fi

# Remove the object files and other generated files
echo "Cleaning up..."
rm -f Linear_advection.o TDMA.o variables.o variables.mod "$OUTPUT_FILE"
rm -f "$DATA_FILE"  # Remove data.txt

echo "Done."

