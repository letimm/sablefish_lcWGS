#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --job-name=multiQC
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2-raw_multiQC.out

source /home/ltimm/bin/hydraQC/bin/activate
multiqc /home/ltimm/Anoplopoma_fimbria/fastqc/raw/