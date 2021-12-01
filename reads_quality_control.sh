#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --output=QC.out
#SBATCH --error=QC.err
#SBATCH --mem=16gb
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4

SAMPLE_ID=$1
echo "SAMPLE_ID=${SAMPLE_ID}"

export PATH=$PATH:/home/umcg-sgarmaeva/.local

##### MODULES #####
#module load FastQC
module load Java/11-LTS
module load Python/3.7.4-GCCcore-7.3.0-bare


# Examining the raw sequencing data

#fastqc ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_1.fq.gz
#fastqc ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_2.fq.gz

#mv ../SAMPLES/${SAMPLE_ID}/*fastqc.* ../OUTPUT/FastQC_reports/before_QC/ 

# adapter trimming 

mkdir ../SAMPLES/${SAMPLE_ID}/raw_reads
mkdir ../SAMPLES/${SAMPLE_ID}/clean_reads

/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/bbmap/bbduk.sh \
	in1=../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_1.fq.gz \
	in2=../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_2.fq.gz \
	out1=../SAMPLES/${SAMPLE_ID}/raw_reads/${SAMPLE_ID}_AdaptTr_QualTr_1.fq.gz \
	out2=../SAMPLES/${SAMPLE_ID}/raw_reads/${SAMPLE_ID}_AdaptTr_QualTr_2.fq.gz \
	ref=/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/next_cohort_adapters.fa \
	ktrim=r k=23 mink=11 hdist=1 tpe tbo \
	threads=${SLURM_CPUS_PER_TASK} \
	-Xmx1g
	
# quality trimming & removal of human reads

kneaddata \
	--input ../SAMPLES/${SAMPLE_ID}/raw_reads/${SAMPLE_ID}_AdaptTr_QualTr_1.fq.gz \
	--input ../SAMPLES/${SAMPLE_ID}/raw_reads/${SAMPLE_ID}_AdaptTr_QualTr_2.fq.gz \
	--bypass-trf \
	--threads 4 \
	--processes 6 \
	-db /groups/umcg-llnext/tmp01/tmp_tools/hg37dec_v0.1 \
	--sequencer-source none \
	--output-prefix ${SAMPLE_ID}_kneaddata \
	--output ../SAMPLES/${SAMPLE_ID}/raw_reads/ \
	--log ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}.log \


