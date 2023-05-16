#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=chr22-inv1_pca
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/chr22-inv1_4.13-8.19_0.3fst_pca.out

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

pcangsd.py -threads 5 -beagle /home/ltimm/Anoplopoma_fimbria/chr22_inversions/chr22-inv1_4.13-8.19_0.3fst.beagle.gz -o /home/ltimm/Anoplopoma_fimbria/chr22_inversions/chr22-inv1_4.13-8.19_0.3fst_pca -sites_save -pcadapt
