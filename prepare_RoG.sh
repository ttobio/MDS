#!/bin/bash
# This script processes ROG (Radius of Gyration) .xvg files that begin with "gyrate"
# It extracts two columns: Time (Ps) and ROG (nm)
# It does the following:
# 1. Reads each gyrate .xvg file in the provided directory
# 2. Removes comments that begin with @ and #
# 3. Removes any white spaces before the actual values
# 4. Extracts the Time and ROG columns (1st and 2nd columns)
# 5. Saves the output in either CSV or TXT format

# Check if the input directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [csv|txt]"
  exit 1
fi

input_dir="$1"
output_format="${2:-csv}"  # Default format is CSV if not specified

# Loop through all .xvg files starting with "gyrate" in the specified directory
for input_file in "$input_dir"/gyrate*.xvg; do
  if [ -f "$input_file" ]; then
    echo "Processing: $input_file"

    temp_file="temp_xvg_file.txt"
    
    # Remove lines starting with @ or # and remove leading whitespaces
    grep -v '^[@#]' "$input_file" | sed 's/^[ \t]*//' > "$temp_file"

    # Only keep the first two columns (Time and RoG)
    awk '{print $1, $2}' "$temp_file" > "${temp_file}_filtered"

    # Check if the output format is CSV or TXT
    if [ "$output_format" == "csv" ]; then
      # Create CSV file
      output_file="${input_file%.xvg}.csv"
      # Add the new header line and convert space-delimited to comma-delimited
      echo "Time_(Ps),ROG_(nm)" > "$output_file"
      cat "${temp_file}_filtered" | tr -s ' ' ',' >> "$output_file"
      echo "CSV file saved as: $output_file"

    elif [ "$output_format" == "txt" ]; then
      # Create tab-delimited text file
      output_file="${input_file%.xvg}.txt"
      # Add the new header line
      echo -e "Time_(Ps)\tROG_(nm)" > "$output_file"
      cat "${temp_file}_filtered" >> "$output_file"
      echo "Text file saved as: $output_file"

    else
      echo "Invalid format specified. Use 'csv' or 'txt'."
      rm "$temp_file"
      exit 1
    fi

    # Clean up temporary files
    rm "$temp_file" "${temp_file}_filtered"
  else
    echo "No gyrate .xvg files found in directory."
  fi
done
