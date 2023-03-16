#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --job-name=Afim_concat-mafs
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim_concatenate-mafs_%A.out

module unload bio/angsd/0.933
module load bio/angsd/0.933

for i in /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050692.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050693.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050694.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050695.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050696.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050697.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050698.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050699.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050700.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050701.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050702.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050703.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050704.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050705.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050706.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050707.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050708.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050709.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050710.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050711.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050712.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050713.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050714.1_polymorphic.mafs.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050715.1_polymorphic.mafs.gz
do zcat $i | tail -n +2 -q >> /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.mafs; done
cut -f 1,2,3,4 /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.mafs > /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites
gzip /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.mafs

angsd sites index /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites
