#!/bin/bash

ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
input_file="$ProjectDir/dataset_raw.csv"
output_file="$ProjectDir/test_dataset.csv"

if [ ! -f "$output_file" ]; then
    touch "$output_file"
fi
header=$(head -n 1 "$input_file")
echo "$header,ade" > "$output_file"


total_lines=$(wc -l < "$input_file")
total_lines=$((total_lines - 1)) 
current_line=0
last_percent=-1

# ======================== Assign AgeGroup and Extract adverse events from notes =====================================
adverse_events="nausea|dizziness|stomach upset|rash|itching|drowsiness|dry mouth|bruising|nosebleeds|muscle pain|insomnia|sweating|mood swings|appetite increase"
tail -n +2 "$input_file" | \
while IFS=, read -r id age gender med dosage route freq diagnosis notes; do
    if [ "$age" -le 18 ]; then
        age_group="0-18"
    elif [ "$age" -le 35 ]; then
        age_group="19-35"
    elif [ "$age" -le 50 ]; then
        age_group="36-50"
    elif [ "$age" -le 65 ]; then
        age_group="51-65"
    else
        age_group="66+"
    fi
    
    ade=$(echo "$notes" | grep -oP "(?i)($adverse_events)" | tr '\n' ',' | sed 's/,$//')
    if [ -z "$ade" ]; then
        ade="No ADE"
    fi
    echo "$id,$age,$age_group,$gender,$med,$dosage,$route,$freq,$diagnosis,$notes,$ade" >> "$output_file"

# =============================== Progress Update =============================================
    current_line=$((current_line + 1))
    percent=$((current_line * 100 / total_lines))

    if [ $((percent % 10)) -eq 0 ] && [ "$percent" -ne "$last_percent" ]; then
        echo "Processing: $percent% complete"
        last_percent=$percent
    fi
done



