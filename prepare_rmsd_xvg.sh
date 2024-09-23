#!/bin/bash
#This script do the following 
#1. read each .xvg file for rmsd in the provided directory
#2. remove the comments begin with @ and #
#3. remove any white spaces before the actual values
#4. assign two columns for time and rmsd (expected both in ns)
# Check if the input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [csv|txt]"
  exit 1
fi

input_dir="$1"
output_format="${2:-csv}"  # Default format is csv if not specified

# Loop through all .xvg files in the specified directory
for input_file in "$input_dir"/*.xvg; do
  if [ -f "$input_file" ]; then
    echo "Processing: $input_file"

    temp_file="temp_xvg_file.txt"
    
    # Remove lines starting with @ or # and remove leading whitespaces
    grep -v '^[@#]' "$input_file" | sed 's/^[ \t]*//' > "$temp_file"

    # Check if the output format is CSV or TXT
    if [ "$output_format" == "csv" ]; then
      # Create CSV file
      output_file="${input_file%.xvg}.csv"
      # Add the new header line and convert space-delimited to comma-delimited
      echo "Time_(ns),RMSD_(nm)" > "$output_file"
      cat "$temp_file" | tr -s ' ' ',' >> "$output_file"
      echo "CSV file saved as: $output_file"

    elif [ "$output_format" == "txt" ]; then
      # Create tab-delimited text file
      output_file="${input_file%.xvg}.txt"
      # Add the new header line
      echo -e "Time_(ns)\tRMSD_(nm)" > "$output_file"
      cat "$temp_file" >> "$output_file"
      echo "Text file saved as: $output_file"

    else
      echo "Invalid format specified. Use 'csv' or 'txt'."
      rm "$temp_file"
      exit 1
    fi

    # Clean up temporary file
    rm "$temp_file"
  else
    echo "No .xvg files found in directory."
  fi
done
#!/bin/bash

# Check if the input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [csv|txt]"
  exit 1
fi

