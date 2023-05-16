#!/bin/bash

#SBATCH --cpus-per-task=5
#SBATCH --time=0-03:00:00
#SBATCH --job-name=fig
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim_genomescan_regions-wGOA.out

module unload R/4.0.3
module load R/4.0.3

Rscript --vanilla /home/ltimm/bin/fst_genomescan_regions-wGOA.R
