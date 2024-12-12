#!/bin/bash

ProjectDir="/cygdrive/c/Users/Administrator/Desktop/CL Fall 2024/MSU-NLP-CL/APLN553 Text Analysis Tools/Project"
output_file="$ProjectDir/Results.txt"

# Activate the scripts
chmod +x 00_pipeline.sh
chmod +x 01_overall.sh
chmod +x 02_medication.sh
chmod +x 03_age_gender.sh

# Step 1: Data Cleaning Script
echo "Data Cleaning in Progress..." 
./00_pipeline.sh

echo "Starting Data Analysis Now..."
# Step 2: Get Overall Prevalence
echo "Getting Overall Prevalence for Adverse Drug Events (ADEs)..." 
./01_overall.sh

# Step 3: Get ADE Prevalence by Medication
echo "Getting ADE Prevalence by Medication..." 
./02_medication.sh

# Step 4: Get ADE Prevalence by Gender and Age
echo "Get ADE Prevalence by Gender and Age..." 
./03_age_gender.sh

echo "====================================================================="
echo "Reports COMPLETED. Press  ↓ or SPACEBAR to preview Results ... 'Q' to quit"
echo "======================================================================"

# Results Preview
while true; do
    read -n 1 -s key 
    if [[ "$key" != "Q" && "$key" != "q" ]]; then
        less "$output_file"
    elif [[ "$key" == "Q" || "$key" == "q" ]]; then
        echo "Data Cleaning & Analysis COMPLETED. Results are Expoted to $ProjectDir"
        break
    fi
done