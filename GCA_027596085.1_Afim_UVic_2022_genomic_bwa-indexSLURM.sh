#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --job-name=bwa_index_GCA_027596085.1_Afim_UVic_2022_genomic
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/bwa-index_GCA_027596085.1_Afim_UVic_2022_genomic.out

module unload aligners/bwa/0.7.17
module load aligners/bwa/0.7.17

bwa index -p /home/ltimm/Anoplopoma_fimbria/bwa/GCA_027596085.1_Afim_UVic_2022_genomic /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna
