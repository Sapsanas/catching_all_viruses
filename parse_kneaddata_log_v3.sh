#!/bin/bash

#Creator: Arnau Vich
#Year: 2017
#Description: Extracts information about number of reads before QC and number of human reads in the sample
#Updated by: Sana
#Year: 2019 
#Reason: changes in kneaddata.log
#Run: ./parse_kneaddata_log_v2.sh `cat sample.list`

echo -e "SID\tRaw Reads 1\tRaw Reads 2\tClean Reads 1\tClean Read 2\tHuman content 1\tHuman content 2" >> kneaddata_reads_stat.txt
for SAMPLE in $@;
do
  	echo `basename ${SAMPLE}` >> tmp
        less ../SAMPLES/${SAMPLE}/clean_reads/${SAMPLE}.log | grep "Initial number of reads" | awk -F ":" '{print $7}' >> tmp
        less ../SAMPLES/${SAMPLE}/clean_reads/${SAMPLE}.log | grep "INFO: READ COUNT: final pair" | awk -F ":" '{print $7}' >> tmp
        less ../SAMPLES/${SAMPLE}/clean_reads/${SAMPLE}.log | grep "Total contaminate" | awk -F ":" '{print $5}' | head -2 >> tmp
       	less tmp | paste -s >> tmp2
        paste -d "\n" tmp2 >> kneaddata_reads_stat.txt
        rm tmp*
done
