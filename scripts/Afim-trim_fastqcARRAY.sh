#!/bin/bash

#SBATCH --job-name=fqc_array_Afim
#SBATCH --cpus-per-task=1
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim-trim_fastqc_%A-%a.out
#SBATCH --time=3-00:00:00
#SBATCH --array=1-246%24

module unload bio/fastqc/0.11.9
module load bio/fastqc/0.11.9

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim-trim_fqcARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	fq=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

fastqc ${fq} -o /home/ltimm/Anoplopoma_fimbria/fastqc/trimmed/
