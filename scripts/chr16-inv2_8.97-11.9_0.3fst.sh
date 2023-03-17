#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=inv2

subset_pca.py \
	-p chr16-inv2_8.97-11.9_0.3fst \
	-c CM050707.1 \
	-s 8970000 \
	-e 11900000 \
	-l 0.3 \
	-r /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna \
	-i /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050707.1_global.beagle.gz \
	-f inversion_fsts.txt \
	-b /home/ltimm/Anoplopoma_fimbria/Afim_filtered_bamslist.txt
