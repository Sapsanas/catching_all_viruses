#!/bin/bash

#Description: Extract information about alignment rate to the conserved singlecopy bacterial cpn60 chaperonin gene
#Author: Sana
#Year: 2019

echo -e "SID\tcpn60\tconcordantly\tconcordantly1\tdiscordantly\tsingle\tsingle1" > cpn60_alignment_stat.txt

for SAMPLE in $@;
do
	echo `basename ${SAMPLE}` >> tmp
	grep "overall alignment rate" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	grep "concordantly exactly 1 time" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	grep "concordantly >1 times" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	grep "aligned discordantly 1 time" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	grep "aligned exactly 1 time" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	grep "aligned >1 times" ../SAMPLES/${SAMPLE}/bowtie2.cpn60db.log | awk -F " " '{print $1}' >> tmp
	less tmp | paste -s >> tmp2
	paste -d "\n" tmp2 >> cpn60_alignment_stat.txt
	rm tmp*
done
