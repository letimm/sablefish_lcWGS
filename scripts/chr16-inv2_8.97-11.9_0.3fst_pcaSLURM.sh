#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=chr16-inv2_8.97-11.9_0.3fst_pca
#SBATCH --output=chr16-inv2_8.97-11.9_0.3fst_pca.out

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

pcangsd.py -threads 5 -beagle chr16-inv2_8.97-11.9_0.3fst.beagle.gz -o chr16-inv2_8.97-11.9_0.3fst_pca -sites_save -pcadapt