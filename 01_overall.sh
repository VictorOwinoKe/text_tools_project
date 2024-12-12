#!/bin/bash

ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
input_file="$ProjectDir/dataset_clean.csv"
output_file="$ProjectDir/Results.txt"  
> "$output_file"


total_records=$(($(wc -l < "$input_file") - 1))  
ade_records=$(awk -F',' 'NR > 1 && $NF != "No ADE" {count++} END {print count+0}' "$input_file")

if [ "$total_records" -gt 0 ]; then
    prevalence=$(awk -v ade="$ade_records" -v total="$total_records" 'BEGIN {printf "%.1f", (ade / total) * 100}')
    echo "Total Records: $total_records" >> "$output_file"
    echo "Records with Adverse Drug Events (ADEs): $ade_records" >> "$output_file"
    echo "Prevalence of ADEs: $prevalence%" >> "$output_file"
else
    echo "Error: No records found in the input file."
    exit 1
fi

# Prevalence of all ADEs (Table1)

echo -e "\nTable1: Prevalence of all ADEs" >> "$output_file"
echo "=====================================================================" >> "$output_file"
echo -e "ADE Cases         Total Cases    Prevalence(%)" >> "$output_file" 
echo "====================================================================="  >> "$output_file"

awk -F',' '
NR > 1 && $NF != "No ADE" {
    split($NF, ade_list, ",")
    for (ade in ade_list) {
        freq[tolower(ade_list[ade])]++
    }
}
END {
    for (ade in freq) {
        printf "%-20s%-15d%-10.1f%%\n", ade, freq[ade], (freq[ade] / (NR - 1)) * 100  
    }
}
' "$input_file" | sort -t$'\t' -k2nr >> "$output_file"

