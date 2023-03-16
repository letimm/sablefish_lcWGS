#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=0-01:00:00
#SBATCH --job-name=Afim_wgp-pca-admix
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim-wholegenome_polymorphic-keep119_%A.out

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

pcangsd.py -threads 10 -beagle /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.beagle.gz -o /home/ltimm/Anoplopoma_fimbria/pca/Afim_wholegenome-polymorphic-keep119 -sites_save -pcadapt -filter /home/ltimm/Anoplopoma_fimbria/keep119.txt

