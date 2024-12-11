#!/bin/bash

# Project directory path
ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
input_file="$ProjectDir/dataset_raw.csv"
output_file="$ProjectDir/dataset_clean.csv"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found!" 
    exit 1
fi

# Create output file if not exists
if [ ! -f "$output_file" ]; then
    touch "$output_file"
fi

# Create "ade" column header in the output file
head -n 1 "$input_file" > "$output_file"
echo "ade" >> "$output_file"  

# ADE pattern for matching
adverse_events="nausea|dizziness|stomach upset|rash|itching|drowsiness|dry mouth|bruising|nosebleeds|muscle pain|insomnia|sweating|mood swings|appetite increase"

# Count the total number of lines
total_lines=$(wc -l < "$input_file")
total_lines=$((total_lines - 1))

current_line=0

# ========================Process the dataset===========================================================
#1. grep to find lines with adverse events
#2. sed to extract the matched events 
#3. awk to combine them with the original data
#===============================================================================================
tail -n +2 "$input_file" | \
while IFS=, read -r id age gender med dosage route freq diagnosis notes; 
do
    # Step 1: Extract ADEs from the Notes field using grep and sed
    ade=$(echo "$notes" | grep -oP "(?i)($adverse_events)" | tr '\n' ',' | sed 's/,$//')
    if [ -z "$ade" ]; then
        ade="No ADE"
    fi
    # Step 2: Append the data to the output file
    echo "$id,$age,$gender,$med,$dosage,$route,$freq,$diagnosis,$notes,$ade" >> "$output_file"


# ===============================Progress Update=============================================
   
    percent=$(echo "$current_line $total_lines" | awk '{print int($1 * 100 / $2)}')

    if [ $((percent % 10)) -eq 0 ] && [ "$percent" -ne "$last_percent" ]; then
        echo "Processing: $percent% complete"
        last_percent=$percent
    fi
done
echo "Processing complete. Output written to $output_file"
