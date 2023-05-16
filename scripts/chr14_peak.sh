#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=peak
#SBATCH --time=3-00:00:00
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/chr14_peak.out

subset_pca.py \
	-p /home/ltimm/Anoplopoma_fimbria/chr14_sex/chr14_peak \
	-c NC_072462.1 \
	-s 12122500 \
	-e 12123200 \
	-r /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna \
	-i /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072462.1_global.beagle.gz \
	-b /home/ltimm/Anoplopoma_fimbria/Afim2_filtered_bamslist.txt
