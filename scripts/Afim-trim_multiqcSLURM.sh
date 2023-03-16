#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --job-name=multiQC
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim-trim_multiQC.out

source /home/ltimm/bin/hydraQC/bin/activate
multiqc /home/ltimm/Anoplopoma_fimbria/fastqc/trimmed/
