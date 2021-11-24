#!/bin/bash

for SAMPLE in $@; do
        sbatch --output >> ./out/${SAMPLE}.out --error >> ./err/${SAMPLE}.err --job-name ${SAMPLE} reads_quality_control.sh ${SAMPLE} 
done
