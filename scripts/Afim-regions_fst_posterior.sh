#!/bin/bash

#SBATCH --cpus-per-task=20
#SBATCH --time=7-00:00:00
#SBATCH --job-name=fst-sig
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim-regions_fst-sigtest_%A-%a.out
#SBATCH --array=1-50%25

for iteration in {1..50}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${iteration} ]]; then
		break
	fi
done

/home/ltimm/bin/generate_fst_posterior.py --full_bamslist /home/ltimm/Anoplopoma_fimbria/Afim_filtered_bamslist.txt --sites_file /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites --population_details wGOA:17,eGOA:28,BSAI:25,south:49 --population_pairs BSAI-eGOA,BSAI-south,BSAI-wGOA,eGOA-south,eGOA-wGOA,south-wGOA --reference_genome /home/ltimm/ref_genomes/Afim_chromosome-level_refgenome.fna --iteration ${iteration}
