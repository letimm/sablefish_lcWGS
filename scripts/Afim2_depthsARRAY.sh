#!/bin/bash

#SBATCH --job-name=depth
#SBATCH --cpus-per-task=5
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2depths_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --time=0-12:00:00
#SBATCH --array=1-123%24

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim2_depthsARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	depth_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

touch /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_depths.csv
mean_cov_ind.py -i ${depth_file} -o /home/ltimm/Anoplopoma_fimbria/bamtools/Afim2_depths.csv
