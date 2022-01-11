#!/bin/bash
#SBATCH --job-name=QC
#SBATCH --output=QC.out
#SBATCH --error=QC.err
#SBATCH --mem=128gb
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=8

SAMPLE_ID=$1
echo "SAMPLE_ID=${SAMPLE_ID}"

## continue assembly only in case you are confident that the only reason the assembly stopped was the time limit
#/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/SPAdes-3.15.3-Linux/bin/metaspades.py \
/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/SPAdes-3.15.3-Linux/bin/spades.py \
	--restart-from last \
    	-o ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out \
	--threads ${SLURM_CPUS_PER_TASK}

## assembly from corrected reads:
#rm -r ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out 
#/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/SPAdes-3.15.3-Linux/bin/metaspades.py \
#	--only-assembler \
#	-1 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_1.fq \
#	-2 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_2.fq \
#	-o ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out \
#	--threads ${SLURM_CPUS_PER_TASK}


## assembly from deduplicated reads:
#/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/SPAdes-3.15.3-Linux/bin/metaspades.py \
#	--only-assembler \
# 	-1 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_1.fq \
#	-2 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_2.fq \
#	-o ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out \
#	--threads ${SLURM_CPUS_PER_TASK}


## assembly from deduplicated reads using single cell mode:
#/groups/umcg-llnext/tmp01/umcg-agulyaeva/NEXT_ASSEMBLY/SOFTWARE/SPAdes-3.15.3-Linux/bin/spades.py \
#	--only-assembler \
#	--sc \
#	-1 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_1.fq \
#	-2 ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_2.fq \
#	-o ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out \
#	--threads ${SLURM_CPUS_PER_TASK}

## assembly quality assessment

module load PythonPlus/3.7.4-foss-2018b-v20.11.1
/groups/umcg-llnext/tmp01/umcg-sgarmaeva/SOFTWARE/quast-5.0.2/quast.py \
	-o ../SAMPLES/${SAMPLE_ID}/quast_out \
	--min-contig 1000 \
	--threads ${SLURM_CPUS_PER_TASK} \
	../SAMPLES/${SAMPLE_ID}/metaSPAdes_out/scaffolds.fasta

## gzipping the clean reads and removing intermediate spades results to save space; filtering and renaming scaffolds.fasta for the ease of downstream analysis

if [ -f ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out/scaffolds.fasta ]
then 
	#gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_kneaddata_paired_1.fastq
	#gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_kneaddata_paired_2.fastq
	#gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_1.fq
	#gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_corr_2.fq
	gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_1.fq
	gzip ../SAMPLES/${SAMPLE_ID}/clean_reads/${SAMPLE_ID}_clean_dedup_2.fq
	
	mv ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out/scaffolds.fasta ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_scaffolds.fasta
	mv ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out/contigs.fasta ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_contigs.fasta
	mv ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out/spades.log ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_spades.log
	rm -rf ../SAMPLES/${SAMPLE_ID}/metaSPAdes_out
	chmod 666 ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_*
	
	/groups/umcg-lld/tmp01/other-users/umcg-sgarmaeva/scripts/filter_contigs.pl 1000 ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_scaffolds.fasta > ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_scaffolds.min1000.fasta

	sed -i 's/>NODE/>'${SAMPLE_ID}'_NODE/g' ../SAMPLES/${SAMPLE_ID}/${SAMPLE_ID}_scaffolds.min1000.fasta 
fi

