#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --output=QC.out
#SBATCH --error=QC.err
#SBATCH --mem=16gb
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4

SAMPLE_ID=$1
echo "SAMPLE_ID=${SAMPLE_ID}"

export PATH=$PATH:/home/umcg-sgarmaeva/.local

##### MODULES #####
module load Java/11-LTS

## reads error correction
## reads error correction is used for samples for which spades fail at the step of internal read error correction
## and for samples that need specific read error correction due to the use of MDA

/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/bbmap/tadpole.sh \
	in=../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_kneaddata_paired_1.fastq \
	in2=../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_kneaddata_paired_2.fastq \
	out=../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_1.fq \
	out2=../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_2.fq \
	mode=correct \
	ecc=t \
	prefilter=2 \
	threads=${SLURM_CPUS_PER_TASK} \
	-Xmx16g

# cleaning
rm ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_kneaddata_paired_*.fastq
	
