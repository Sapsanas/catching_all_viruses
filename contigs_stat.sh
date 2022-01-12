#!/bin/bash

echo -e "SID\tContigs\tContigs_filtered" >> cont_stat.txt

for SAMPLE in $@; 
do
	echo ${SAMPLE} >> tmp
	grep -o ">" ../SAMPLES/${SAMPLE}/${SAMPLE}_scaffolds.fasta | wc -l >> tmp
	grep -o ">" ../SAMPLES/${SAMPLE}/${SAMPLE}_scaffolds.min1000.fasta | wc -l >> tmp
	less tmp | paste -s >> tmp2
	paste -d "\n" tmp2 >> cont_stat.txt
	rm tmp*
done 
 
