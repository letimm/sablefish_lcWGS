#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=1-00:00:00
#SBATCH --job-name=pop_AFIMsex
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/AFIMsex_pop-analyses_%A-%a.out
#SBATCH --array=1-24%24

module unload bio/angsd/0.933 bio/ngstools/202202
module load bio/angsd/0.933 bio/ngstools/202202

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim_angsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	chrom=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b /home/ltimm/Anoplopoma_fimbria/AFIMsex_female_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_female_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 28 -setmaxDepth 560.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /home/ltimm/Anoplopoma_fimbria/AFIMsex_male_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_male_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 21 -setmaxDepth 420.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_female_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_male_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/AFIMsex_${chrom}_female-male_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_female_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/AFIMsex_${chrom}_male_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/AFIMsex_${chrom}_female-male_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/AFIMsex_${chrom}_female-male_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/AFIMsex_${chrom}_female-male_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/AFIMsex_${chrom}_female-male_polymorphic_folded.sfs.pbs.fst.txt

