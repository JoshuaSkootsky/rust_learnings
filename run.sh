#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to print usage information
print_usage() {
    echo "Usage: $0 [-r] [-d] [-o output_name] <filename.rs>"
    echo "       $0 clean [<filename.rs>]"
    echo "  -r: Run only (don't recompile if binary exists and is newer than source)"
    echo "  -d: Debug mode (compile with debug symbols)"
    echo "  -o: Specify output binary name"
    echo "  clean: Remove the binary for the specified file, or all 'rbin_*' if no file specified"
    exit 1
}

# Prefix to indicate that this is a Rust binary
PREFIX=rbin

# Clean function
clean_binaries() {
    if [ -z "$1" ]; then
        echo "Cleaning up all Rust binaries..."
        find . -type f -name "${PREFIX}_*" -delete
        echo "All Rust binaries cleaned up."
    else
        local basename="${1%.*}"
        local binary_name="${PREFIX}_${basename}"
        if [ -f "$binary_name" ]; then
            echo "Removing binary: $binary_name"
            rm "$binary_name"
            echo "Binary removed."
        else
            echo "No binary found for $1"
        fi
    fi
}

# Check if the first argument is 'clean'
if [ "$1" = "clean" ]; then
    shift
    clean_binaries "$1"
    exit 0
fi

# Default values
run_only=false
debug_mode=false
output_name=""

# Parse command line options
while getopts ":rdo:" opt; do
    case $opt in
        r) run_only=true ;;
        d) debug_mode=true ;;
        o) output_name="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2; print_usage ;;
    esac
done

# Shift to the filename argument
shift $((OPTIND-1))

# Check if a filename was provided
if [ $# -eq 0 ]; then
    echo "Error: No Rust file specified." >&2
    print_usage
fi

filename="$1"
basename="${filename%.*}"

# Generate a distinct name for the binary
if [ -z "$output_name" ]; then
    output_name="${PREFIX}_${basename}"
else
    output_name="${PREFIX}_${output_name}"
fi

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "Error: File $filename does not exist." >&2
    exit 1
fi

# Compile function
compile() {
    echo "Compiling $filename..."
    if [ "$debug_mode" = true ]; then
        rustc -g "$filename" -o "$output_name"
    else
        rustc -O "$filename" -o "$output_name"
    fi
    echo "Compilation successful."
}

# Compile if necessary
if [ "$run_only" = false ] || [ ! -f "$output_name" ] || [ "$filename" -nt "$output_name" ]; then
    compile
fi

# Run the program
echo "Running $output_name..."
"./$output_name"

echo "Done."