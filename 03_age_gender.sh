#!/bin/bash

ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
input_file="$ProjectDir/dataset_clean.csv"
output_file="$ProjectDir/Results.txt"  

echo -e "\nTable 3.1: ADE Prevalence by Gender" >> "$output_file"
echo "==========================================================" >> "$output_file"
echo -e "Gender  #Patients  #ADE Cases  #ADE Prevalence(%)" >> "$output_file"
echo "==========================================================" >> "$output_file"

awk -F',' '
NR > 1 {
    gender = $4  
    if ($NF != "No ADE") {
        ade_count_gender[gender]++
        patient_count_gender[gender]++
    } else {
        patient_count_gender[gender]++
    }
}
END {
    for (gender in patient_count_gender) {
        ade_cases = ade_count_gender[gender] ? ade_count_gender[gender] : 0
        patients = patient_count_gender[gender]
        prevalence = (patients > 0) ? (ade_cases / patients) * 100 : 0
        printf "%-10s%-10d%-10d%.1f%%\n", gender, patients, ade_cases, prevalence
    }
}
' "$input_file" | sort -k3,3nr >> "$output_file"

echo -e "\nTable 3.2: ADE Prevalence by Age Group" >> "$output_file"
echo "==========================================================" >> "$output_file"
echo -e "AgeGroup    #Patients    #ADE Cases    #ADE Prevalence(%)" >> "$output_file"
echo "==========================================================" >> "$output_file"

awk -F',' '
NR > 1 {
    agegroup = $3  
    if ($NF != "No ADE") {
        ade_count_agegroup[agegroup]++
        patient_count_agegroup[agegroup]++
    } else {
        patient_count_agegroup[agegroup]++
    }
}
END {
    for (agegroup in patient_count_agegroup) {
        ade_cases = ade_count_agegroup[agegroup] ? ade_count_agegroup[agegroup] : 0
        patients = patient_count_agegroup[agegroup]
        prevalence = (patients > 0) ? (ade_cases / patients) * 100 : 0
        printf "%-12s%-15d%-15d%.1f%%\n", agegroup, patients, ade_cases, prevalence
    }
}
' "$input_file" | sort -t$'\t' -k3nr  >> "$output_file"

