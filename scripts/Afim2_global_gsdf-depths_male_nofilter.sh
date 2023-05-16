#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --job-name=male
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_global_gsdf-depths_male_nofilter.out

module unload bio/angsd/0.933
module load bio/angsd/0.933

angsd \
	-b /home/ltimm/Anoplopoma_fimbria/Afim_genetic_males_bams.txt \
	-ref /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna \
	-r NC_072462.1:12118191-12123064 \
	-out /home/ltimm/Anoplopoma_fimbria/gls/Afim2_global_gsdf-depths_male_nofilter -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 1 -doDepth 1 -dumpCounts 1 -only_proper_pairs 1
