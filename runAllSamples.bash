#!/bin/bash

for SAMPLE in $@; do
        #sbatch --output ./out/${SAMPLE}.out --error ./err/${SAMPLE}.err --job-name ${SAMPLE} reads_quality_control.sh ${SAMPLE} 
	#sbatch --output ./out/${SAMPLE}.out --error ./err/${SAMPLE}.err --job-name ${SAMPLE} assembly.sh ${SAMPLE}
	sbatch --output ./out/${SAMPLE}.out --error ./err/${SAMPLE}.err --job-name ${SAMPLE} continue_assembly.sh ${SAMPLE}
	#sbatch --output ./out/${SAMPLE}.out --error ./err/${SAMPLE}.err --job-name ${SAMPLE} reads_error_correction.sh ${SAMPLE}
done
