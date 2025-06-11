#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
fi

# Function to check if an argument is a file
is_file() {
    if [ -f "$1" ]; then
        echo "$1 is a file."
    else
        echo "$1 is not a file."
    fi
}

# Function to check if an argument is a directory
is_directory() {
    if [ -d "$1" ]; then
        echo "$1 is a directory."
    else
        echo "$1 is not a directory."
    fi
}

# Function to check if an argument is an executable file
is_executable() {
    if [ -x "$1" ]; then
        echo "$1 is an executable file."
    else
        echo "$1 is not an executable file."
    fi
}

# Function to check if an argument is a text file
is_text_file() {
    if file "$1" | grep -q "text"; then
        echo "$1 is a text file."
    else
        echo "$1 is not a text file."
    fi
}

# Function to check if an argument is an integer
is_integer() {
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        echo "$1 is an integer."
    else
        echo "$1 is not an integer."
    fi
}

# Function to check if a string has n characters
has_n_characters() {
    local string="$1"
    local n="$2"
    if [ "${#string}" -eq "$n" ]; then
        echo "The string '$string' has $n characters."
    else
        echo "The string '$string' does not have $n characters."
    fi
}

# Function to check if a string contains a specific character
contains_character() {
    local string="$1"
    local char="$2"
    if [[ "$string" == *"$char"* ]]; then
        echo "The string '$string' contains the character '$char'."
    else
        echo "The string '$string' does not contain the character '$char'."
    fi
}

# Function to validate an IP address
is_valid_ip() {
    local ip="$1"
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "$ip is a valid IP address."
    else
        echo "$ip is not a valid IP address."
    fi
}