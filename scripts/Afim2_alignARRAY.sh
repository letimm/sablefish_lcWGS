#!/bin/bash

#SBATCH --job-name=align
#SBATCH --cpus-per-task=10
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_alignment_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --time=3-00:00:00
#SBATCH --array=1-123%48

module unload aligners/bwa/0.7.17 bio/samtools/1.11 bio/bamtools/2.5.1 bio/picard/2.23.9 bio/bamutil/1.0.5
module load aligners/bwa/0.7.17 bio/samtools/1.11 bio/bamtools/2.5.1 bio/picard/2.23.9 bio/bamutil/1.0.5

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim2_alignARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq_r1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	fq_r2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

sample_id=$(echo $fq_r1 | sed 's!^.*/!!')
sample_id=${sample_id%%_*}

bwa mem -M -t 10 /home/ltimm/Anoplopoma_fimbria/bwa/GCF_027596085.1_Afim_UVic_2022_genomic ${fq_r1} ${fq_r2} 2> /home/ltimm/Anoplopoma_fimbria/bwa/Afim2_${sample_id}_bwa-mem.out > /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.sam

samtools view -bS -F 4 /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.sam > /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.bam
rm /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.sam

samtools view -h /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.bam | samtools view -buS - | samtools sort -o /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted.bam
rm /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.bam

java -jar $PICARD MarkDuplicates I=/home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted.bam O=/home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup.bam M=/home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_dups.log VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true
rm /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted.bam

bam clipOverlap --in /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup.bam --out /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup_clipped.bam --stats
rm /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup.bam

samtools depth -aa /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup_clipped.bam | cut -f 3 | gzip > /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}.depth.gz

samtools index /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_${sample_id}_sorted_dedup_clipped.bam