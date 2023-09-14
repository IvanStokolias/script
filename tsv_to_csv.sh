#!/bin/bash

# Input TSV file name
input_file="challenge.tsv"

# Output CSV file name
output_file="challenge.csv"

# Use awk to replace tabs with commas and save the result to the CSV file
awk -F'\t' -v OFS=',' '{ print $0 }' "$input_file" > "$output_file"

echo "Conversion complete. Output saved as $output_file."
