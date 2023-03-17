#!/bin/bash

source /home/ltimm/bin/sciencesnake/bin/activate
python3 /home/ltimm/bin/fst_significance_test.py \
	-d /home/ltimm/Anoplopoma_fimbria/Afim-clusters_fst_posteriors.txt \
	-f /home/ltimm/Anoplopoma_fimbria/Afim-clusters_fst_results.txt \
	-p /home/ltimm/Anoplopoma_fimbria/Afim-clusters \
	--weighted
