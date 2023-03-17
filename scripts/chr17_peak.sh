#!/bin/bash

subset_pca.py \
	-p chr17_peak \
	-c CM050708.1 \
	-s 12122500 \
	-e 12123200 \
	-r /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna \
	-i /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050708.1_global.beagle.gz \
	-b /home/ltimm/Anoplopoma_fimbria/Afim_filtered_bamslist.txt
