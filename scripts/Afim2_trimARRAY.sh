#!/bin/bash

#SBATCH --job-name=trim
#SBATCH --cpus-per-task=4
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_trimming_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --time=0-12:00:00
#SBATCH --array=1-123%48

module unload bio/trimmomatic/0.39
module load bio/trimmomatic/0.39

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim2_trimARRAY_input.txt
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

java -jar ${TRIMMOMATIC} PE -threads 4 -phred33 ${fq_r1} ${fq_r2} /home/ltimm/Anoplopoma_fimbria/trimmed/${sample_id}_trimmed_R1_paired.fq.gz /home/ltimm/Anoplopoma_fimbria/trimmed/${sample_id}_trimmed_R1_unpaired.fq.gz /home/ltimm/Anoplopoma_fimbria/trimmed/${sample_id}_trimmed_R2_paired.fq.gz /home/ltimm/Anoplopoma_fimbria/trimmed/${sample_id}_trimmed_R2_unpaired.fq.gz ILLUMINACLIP:/home/ltimm/NexteraPE-PE.fa:2:30:10:1:true MINLEN:40
