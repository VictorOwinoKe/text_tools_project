#!/bin/bash

ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
input_file="$ProjectDir/dataset_clean.csv"
output_file="$ProjectDir/Results.txt"  

# Prevalence by medication (Table2)
echo -e "\nTable2: ADE Prevalence by Medication" >> "$output_file"
echo "=====================================================================" >> "$output_file"
echo -e "Medication   #Patients   #ADE Cases  #ADE Prevalence(%)" >> "$output_file"  
echo "=====================================================================" >> "$output_file"

awk -F',' '
NR > 1 {
    medication = $5  
    if ($NF != "No ADE") {
        ade_count[medication]++
        patient_count[medication]++
    } else {
        patient_count[medication]++
    }
}
END {
    for (medication in patient_count) {
        ade_cases = ade_count[medication] ? ade_count[medication] : 0
        patients = patient_count[medication]
        prevalence = (patients > 0) ? (ade_cases / patients) * 100 : 0
        printf  "%-10s%-10d%-10d%.1f%%\n", medication, patients, ade_cases, prevalence
    }
}
' "$input_file" | sort -t$'\t' -k3nr >> "$output_file" 