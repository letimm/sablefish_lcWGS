#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --job-name=fai_GCA_027596085.1_Afim_UVic_2022_genomic
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/fai_GCA_027596085.1_Afim_UVic_2022_genomic.out

module unload bio/samtools/1.11
module load bio/samtools/1.11

samtools faidx /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna
