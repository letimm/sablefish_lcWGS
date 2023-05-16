#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --job-name=bwa_index_GCF_027596085.1_Afim_UVic_2022_genomic
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/bwa-index_GCF_027596085.1_Afim_UVic_2022_genomic.out

module unload aligners/bwa/0.7.17
module load aligners/bwa/0.7.17

bwa index -p /home/ltimm/Anoplopoma_fimbria/bwa/GCF_027596085.1_Afim_UVic_2022_genomic /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna
