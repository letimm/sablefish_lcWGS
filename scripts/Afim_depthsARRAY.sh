#!/bin/bash

#SBATCH --job-name=depth
#SBATCH --cpus-per-task=5
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afimdepths_%A-%a.out
#SBATCH --time=7-00:00:00
#SBATCH --array=1-123%48

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim_depthsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	depth_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

touch /home/ltimm/Anoplopoma_fimbria/bamtools/Afim_depths.csv
mean_cov_ind.py -i ${depth_file} -o /home/ltimm/Anoplopoma_fimbria/bamtools/Afim_depths.csv
