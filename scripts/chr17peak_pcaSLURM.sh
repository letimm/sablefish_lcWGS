#!/bin/bash

#SBATCH --partition=himem
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=24
#SBATCH --job-name=Afim-chr17peak_pca
#SBATCH --output=Afim-chr17peak_pca.out

module unload bio/angsd/0.933 bio/pcangsd/0.99
module load bio/angsd/0.933 bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

angsd sites index Afim-chr17peak.txt

angsd -b Afim_filtered_bamslist.txt -ref /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -r CM050708.1: -out Afim-chr17peak -nThreads 24 -C 50 -doCounts 1 -GL 1 -doGlf 2 -doMajorMinor 3 -doMaf 1 -doPost 1 -sites Afim-chr17peak.txt -doBcf 1 --ignore-RG 0 -doGeno 1

pcangsd.py -threads 24 -beagle Afim-chr17peak.beagle.gz -o Afim-chr17peak_pca -e 2 -admix -admix_alpha 50 -selection -tree
