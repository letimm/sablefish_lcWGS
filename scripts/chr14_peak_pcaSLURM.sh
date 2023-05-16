#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --job-name=chr14_peak_pca
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/chr14_peak_pca.out

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

pcangsd.py -threads 5 -beagle /home/ltimm/Anoplopoma_fimbria/chr14_sex/chr14_peak.beagle.gz -o /home/ltimm/Anoplopoma_fimbria/chr14_sex/chr14_peak_pca -sites_save -pcadapt
