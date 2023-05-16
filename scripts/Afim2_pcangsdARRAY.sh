#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=0-05:00:00
#SBATCH --job-name=pca_Afim2
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_pcangsd_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --array=1-24%24

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim2_pcangsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	beagle_file=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

chrom=$(echo $beagle_file | sed 's!^.*/!!')
chrom=${chrom%.beagle.gz}

pcangsd.py -threads 10 -beagle ${beagle_file} -o /home/ltimm/Anoplopoma_fimbria/pca/${chrom} -sites_save -pcadapt