#!/bin/bash
# This script does the following:
# 1. Read each .xvg file for RMSD or RMSF in the provided directory
# 2. Remove comments beginning with @ and #
# 3. Remove any white spaces before the actual values
# 4. Assign columns for time and RMSD or residue and RMSF based on the file type

# Check if the input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [csv|txt] [rmsd|rmsf]"
  exit 1
fi

input_dir="$1"
output_format="${2:-csv}"  # Default format is csv if not specified
file_type="${3:-rmsd}"      # Default type is rmsd if not specified

# Loop through all .xvg files in the specified directory
for input_file in "$input_dir"/*.xvg; do
  if [ -f "$input_file" ]; then
    echo "Processing: $input_file"

    temp_file="temp_xvg_file.txt"
    
    # Remove lines starting with @ or # and remove leading whitespaces
    grep -v '^[@#]' "$input_file" | sed 's/^[ \t]*//' > "$temp_file"

    # Check the file type to determine headers and columns
    if [ "$file_type" == "rmsd" ]; then
      # Create output file for RMSD
      if [ "$output_format" == "csv" ]; then
        output_file="${input_file%.xvg}.csv"
        echo "Time_(ns),RMSD_(nm)" > "$output_file"
        cat "$temp_file" | tr -s ' ' ',' >> "$output_file"
        echo "CSV file saved as: $output_file"
      elif [ "$output_format" == "txt" ]; then
        output_file="${input_file%.xvg}.txt"
        echo -e "Time_(ns)\tRMSD_(nm)" > "$output_file"
        cat "$temp_file" >> "$output_file"
        echo "Text file saved as: $output_file"
      else
        echo "Invalid format specified. Use 'csv' or 'txt'."
        rm "$temp_file"
        exit 1
      fi
    elif [ "$file_type" == "rmsf" ]; then
      # Create output file for RMSF
      if [ "$output_format" == "csv" ]; then
        output_file="${input_file%.xvg}.csv"
        echo "Residue,RMSF_(nm)" > "$output_file"
        cat "$temp_file" | tr -s ' ' ',' >> "$output_file"
        echo "CSV file saved as: $output_file"
      elif [ "$output_format" == "txt" ]; then
        output_file="${input_file%.xvg}.txt"
        echo -e "Residue\tRMSF_(nm)" > "$output_file"
        cat "$temp_file" >> "$output_file"
        echo "Text file saved as: $output_file"
      else
        echo "Invalid format specified. Use 'csv' or 'txt'."
        rm "$temp_file"
        exit 1
      fi
    else
      echo "Invalid file type specified. Use 'rmsd' or 'rmsf'."
      rm "$temp_file"
      exit 1
    fi

    # Clean up temporary file
    rm "$temp_file"
  else
    echo "No .xvg files found in directory."
  fi
done
