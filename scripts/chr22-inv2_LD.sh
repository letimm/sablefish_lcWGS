#!/bin/bash
#SBATCH --job-name=LD2
#SBATCH --time=3-00:00:00
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/chr22-inv2_LD.out
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov

module unload bio/ngsld/1.1.1
module load bio/ngsld/1.1.1

BASEDIR=/home/ltimm/Anoplopoma_fimbria/chr22_inversions/ld
CHROMBEAGLE=/home/ltimm/Anoplopoma_fimbria/gls/Afim2_NC_072470.1_global.beagle.gz
BEAGLEIN=/home/ltimm/Anoplopoma_fimbria/chr22_inversions/chr22-inv2_8.97-11.9_0.3fst
BEAGLEOUT=chr22-inv2_ld
#INVNAME=chr22-inv2
CHROM=NC_072470.1

#Make the beagle file for inversion 1 (found specific pos and line numbers with grep)
#get 500 sites of the boring bit before the inversion
zcat $CHROMBEAGLE | grep -i -B 500 "NC_072470.1_8970157	" > $BASEDIR/$BEAGLEOUT.beagle

#get the interesting bit
#./${BEAGLEIN}.sh

#and subset
#awk 'NR % 200 == 0' ${BEAGLEIN}_full.beagle >> $BASEDIR/$BEAGLEOUT.beagle
#OR don't
tail -n +2 ${BEAGLEIN}.beagle >> $BASEDIR/$BEAGLEOUT.beagle

#get 500 sites of the boring bit after the inversion
zcat $CHROMBEAGLE | grep -i -A 500 "NC_072470.1_11899666	" >> $BASEDIR/$BEAGLEOUT.beagle

##get the pos associated with the beagle
awk '{print $1}' $BASEDIR/$BEAGLEOUT.beagle > \
	$BASEDIR/$BEAGLEOUT.pos
sed -i 's/.1_/.1\t/g' $BASEDIR/$BEAGLEOUT.pos

##remove the first columns of the beagle file
cut -f 4- $BASEDIR/$BEAGLEOUT.beagle | \
	gzip > $BASEDIR/$BEAGLEOUT.beagle.gz

##Get number of sites and individuals
NSITES=`wc -l $BASEDIR/$BEAGLEOUT.pos`
NCOLS=`zcat $BASEDIR/$BEAGLEOUT.beagle.gz | awk -F '\t' '{print NF; exit}'`
((NINDS=NCOLS/3))

##Run ngsLD
ngsLD \
	--geno $BASEDIR/$BEAGLEOUT.beagle.gz \
	--pos $BASEDIR/$BEAGLEOUT.pos \
	--n_ind $NINDS \
	--n_sites $NSITES \
	--max_kb_dist 0 \
	--probs \
	--n_threads 20 \
	--out $BASEDIR/$BEAGLEOUT.ld

##Format for plotting
sed -i "s/${CHROM}://g" $BASEDIR/$BEAGLEOUT.ld

##Plot the output
module unload R
module load R

Rscript --vanilla /home/ltimm/bin/ldplot_general.R $BASEDIR/ $BEAGLEOUT
