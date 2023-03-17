#!/bin/bash

#SBATCH --cpus-per-task=20
#SBATCH --time=0-12:00:00
#SBATCH --job-name=sfst2
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/generate_dist_test/job_outfiles/Afim_summaryFST-pt2_%A-%a.out
#SBATCH --array=1-21%21

module unload bio/angsd/0.933
module load bio/angsd/0.933

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/generate_dist_test/scripts/Afim_summaryFST-pt2_ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	pop1=$(echo ${sample_line} | awk -F ":" '{print $2}')
	pop2=$(echo ${sample_line} | awk -F ":" '{print $3}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

realSFS /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}.saf.idx /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop2}.saf.idx -P 10 -maxIter 30 > /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}-${pop2}.ml
realSFS fst index /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}.saf.idx /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop2}.saf.idx -sfs /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}-${pop2}.ml -fstout /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}-${pop2}
realSFS fst stats /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}-${pop2}.fst.idx > /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${pop1}-${pop2}.global.fst
