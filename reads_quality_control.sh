#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --output=QC.out
#SBATCH --error=QC.err
#SBATCH --mem=10gb
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1

SAMPLE_ID=$1
echo "SAMPLE_ID=${SAMPLE_ID}"

##### MODULES #####
module load FastQC

# Examining the raw sequencing data

fastqc ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_1.fq.gz
fastqc ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_2.fq.gz

mv ../SAMPLES/${SAMPLE_ID}/*fastqc.* ../OUTPUT/FastQC_reports/before_QC/ 
