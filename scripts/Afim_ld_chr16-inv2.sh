#!/bin/bash
#SBATCH --job-name=LD
#SBATCH --time=3-00:00:00
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim_ld_chr16-inv2.out
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov

module unload bio/ngsld/1.1.1
module load bio/ngsld/1.1.1

BASEDIR=/home/ltimm/Anoplopoma_fimbria/chr16_inversions/ld
BEAGLEIN=chr16-inv2_8.97-11.9_0.3fst
INVNAME=Afim_chr16-inv2

#Make a beagle file for inversion 1
#./home/ltimm/Anoplopoma_fimbria/ld/chr16-inv1_4.13-8.19_0.3fst.sh

#subsample every 10th snp for the beagle
#awk 'NR % 10 == 0' ${BASEDIR}/${BEAGLE}.beagle > tmp.beagle
#OR don't
tail -n +2 $BASEDIR/$BEAGLEIN.beagle > \
	$BASEDIR/$INVNAME.beagle

#get the pos associated with the beagle
awk '{print $1}' $BASEDIR/$INVNAME.beagle > \
	$BASEDIR/$INVNAME.pos
sed -i 's/_/\t/g' $BASEDIR/$INVNAME.pos

#remove the first columns of the beagle file
cut -f 4- $BASEDIR/$INVNAME.beagle | \
	gzip > $BASEDIR/$INVNAME.beagle.gz
#rm tmp.beagle

#Get number of sites and individuals
NSITES=`wc -l $BASEDIR/$INVNAME.pos`
NCOLS=`zcat $BASEDIR/$INVNAME.beagle.gz | awk -F '\t' '{print NF; exit}'`
((NINDS=NCOLS/3))

#Run ngsLD
ngsLD \
	--geno $BASEDIR/$INVNAME.beagle.gz \
	--pos $BASEDIR/$INVNAME.pos \
	--n_ind $NINDS \
	--n_sites $NSITES \
	--max_kb_dist 0 \
	--probs \
	--n_threads 20 \
	--out $BASEDIR/$INVNAME.ld

#Plot the output
module unload R
module load R

Rscript --vanilla /home/ltimm/bin/ldplot_general.R $BASEDIR/ $INVNAME
