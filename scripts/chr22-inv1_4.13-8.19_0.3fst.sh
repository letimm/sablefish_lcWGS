#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=inv1
#SBATCH --time=3-00:00:00
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/chr22-inv1_4.13-8.19_0.3fst.out

subset_pca.py \
	-p /home/ltimm/Anoplopoma_fimbria/chr22_inversions/chr22-inv1_4.13-8.19_0.3fst \
	-c NC_072470.1 \
	-s 4130000 \
	-e 8190000 \
	-l 0.3 \
	-r /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna \
	-i /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072470.1_global.beagle.gz \
	-f /home/ltimm/Anoplopoma_fimbria/chr22_inversions/inversion_fsts.txt \
	-b /home/ltimm/Anoplopoma_fimbria/Afim2_filtered_bamslist.txt
