#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=0-05:00:00
#SBATCH --job-name=Afim2_wgp-pca
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_wholegenome_polymorphic_%A.out

module unload bio/pcangsd/0.99
module load bio/pcangsd/0.99
source /opt/bioinformatics/venv/pcangsd-0.99/bin/activate

pcangsd.py -threads 10 -beagle /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.beagle.gz -o /home/ltimm/Anoplopoma_fimbria/pca/Afim2_wholegenome-polymorphic -sites_save -pcadapt

