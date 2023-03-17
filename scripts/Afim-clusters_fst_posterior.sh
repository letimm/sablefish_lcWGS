#!/bin/bash

#SBATCH --cpus-per-task=20
#SBATCH --time=3-00:00:00
#SBATCH --job-name=fst-sig
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/AFIMclusters_fst-sigtest_%A-%a.out
#SBATCH --array=1-50%25

for iteration in {1..50}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${iteration} ]]; then
		break
	fi
done

/home/ltimm/bin/generate_fst_posterior.py --full_bamslist /home/ltimm/Anoplopoma_fimbria/Afim_filtered_bamslist.txt --sites_file /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites --population_details E:17,B:29,D:6,A:18,F:19,C:30 --population_pairs A-B,A-C,A-D,A-E,A-F,B-C,B-D,B-E,B-F,C-D,C-E,C-F,D-E,D-F,E-F --reference_genome /home/ltimm/ref_genomes/Afim_chromosome-level_refgenome.fna --iteration ${iteration}
