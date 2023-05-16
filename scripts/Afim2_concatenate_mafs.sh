#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --job-name=Afim2_concat-mafs
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_concatenate-mafs_%A.out

module unload bio/angsd/0.933
module load bio/angsd/0.933

for i in /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072449.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072450.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072451.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072452.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072453.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072454.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072455.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072456.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072457.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072458.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072459.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072460.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072461.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072462.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072463.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072464.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072465.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072466.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072467.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072468.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072469.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072470.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072471.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072472.1_polymorphic.mafs.gz
do zcat $i | tail -n +2 -q >> /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.mafs; done
cut -f 1,2,3,4 /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.mafs > /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites
gzip /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.mafs

angsd sites index /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites
