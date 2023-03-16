#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=7-00:00:00
#SBATCH --job-name=Afim_concat-beagles
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim_concatenate-beagles-nix16_%A.out

zcat /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050692.1_polymorphic.beagle.gz | head -n 1 > /home/ltimm/Anoplopoma_fimbria/gls/Afim-wholegenome_polymorphic-nix16.beagle; for i in /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050692.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050693.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050694.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050695.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050696.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050697.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050698.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050699.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050700.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050701.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050702.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050703.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050704.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050705.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050706.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050708.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050709.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050710.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050711.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050712.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050713.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050714.1_polymorphic.beagle.gz /home/ltimm/Anoplopoma_fimbria/gls/Afim_CM050715.1_polymorphic.beagle.gz; do zcat $i | tail -n +2 -q >> /home/ltimm/Anoplopoma_fimbria/gls/Afim-wholegenome_polymorphic-nix16.beagle; done
gzip /home/ltimm/Anoplopoma_fimbria/gls/Afim-wholegenome_polymorphic-nix16.beagle
