#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=7-00:00:00
#SBATCH --job-name=global_Afim
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim_global_%A-%a.out
#SBATCH --array=1-24%24

module unload bio/angsd/0.933
module load bio/angsd/0.933

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim_angsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	contig=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b /home/ltimm/Anoplopoma_fimbria/Afim_filtered_bamslist.txt -ref /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -r ${contig}: -out /home/ltimm/Anoplopoma_fimbria/gls/Afim_${contig}_global -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 119 -setmaxDepth 2380.0 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 1 -doDepth 1 -dumpCounts 3 -only_proper_pairs 1