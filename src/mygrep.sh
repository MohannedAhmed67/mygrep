#!/bin/bash

# Usage information
usage() {
    echo "Usage: $0 [options] <search_string> <file>"
    echo "Options:"
    echo "  -n       Show line numbers for each match"
    echo "  -v       Invert the match (print lines that do not match)"
    echo "  --help   Display this help message"
    exit 1
}

# If no args or --help flag is provided, show usage
if [ "$#" -eq 0 ] || [ "$1" == "--help" ]; then
    usage
fi

# Initialize flags
show_line_numbers=false
invert_match=false

# Parse options using getopts
while getopts ":nv" opt; do
    case $opt in
        n)
            show_line_numbers=true
            ;;
        v)
            invert_match=true
            ;;
        *)
            usage
            ;;
    esac
done

# Remove the options from the positional parameters
shift $((OPTIND - 1))

# Validate that search string and filename are provided
if [ "$#" -lt 2 ]; then
    echo "Error: Missing search string or file."
    usage
fi

search_string=$1
file=$2

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Build the grep command
grep_cmd="grep -i"
if $invert_match; then
    grep_cmd+=" -v"
fi
if $show_line_numbers; then
    grep_cmd+=" -n"
fi

# Execute the grep command
eval "$grep_cmd \"$search_string\" \"$file\""