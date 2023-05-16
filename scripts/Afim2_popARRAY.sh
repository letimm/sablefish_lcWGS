#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=1-00:00:00
#SBATCH --job-name=pop_Afim2
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_pop-analyses_%A-%a.out
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --array=1-24%24

module unload bio/angsd/0.933 bio/ngstools/202202
module load bio/angsd/0.933 bio/ngstools/202202

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/scripts/Afim2_angsdARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	chrom=$(echo ${sample_line} | awk -F ":" '{print $2}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b /home/ltimm/Anoplopoma_fimbria/Afim2_BSAI_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 25 -setmaxDepth 500.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /home/ltimm/Anoplopoma_fimbria/Afim2_eGOA_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 28 -setmaxDepth 560.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /home/ltimm/Anoplopoma_fimbria/Afim2_south_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 49 -setmaxDepth 980.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

angsd -b /home/ltimm/Anoplopoma_fimbria/Afim2_wGOA_bams.txt -r ${chrom}: -sites /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.sites -ref /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -anc /home/ltimm/ref_genomes/GCF_027596085.1_Afim_UVic_2022_genomic.fna -out /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded -nThreads 10 -uniqueOnly 1 -remove_bads 1 -trim 0 -C 50 -minMapQ 15 -doCounts 1 -setminDepth 17 -setmaxDepth 340.0 -GL 1 -doGlf 3 -doMaf 1 -doMajorMinor 1 -doSaf 1 -only_proper_pairs 1

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-eGOA_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-eGOA_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-eGOA_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-eGOA_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-eGOA_polymorphic_folded.sfs.pbs.fst.txt

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-south_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-south_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-south_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-south_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-south_polymorphic_folded.sfs.pbs.fst.txt

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-wGOA_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_BSAI_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-wGOA_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-wGOA_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-wGOA_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_BSAI-wGOA_polymorphic_folded.sfs.pbs.fst.txt

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-south_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-south_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-south_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-south_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-south_polymorphic_folded.sfs.pbs.fst.txt

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-wGOA_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_eGOA_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-wGOA_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-wGOA_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-wGOA_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_eGOA-wGOA_polymorphic_folded.sfs.pbs.fst.txt

realSFS /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_south-wGOA_polymorphic_folded.sfs
realSFS fst index /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_south_polymorphic_folded.saf.idx -fold 1 /home/ltimm/Anoplopoma_fimbria/diversity/Afim2_${chrom}_wGOA_polymorphic_folded.saf.idx -fold 1 -sfs /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_south-wGOA_polymorphic_folded.sfs -fstout /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_south-wGOA_polymorphic_folded.sfs.pbs -whichFst 1
realSFS fst stats2 /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_south-wGOA_polymorphic_folded.sfs.pbs.fst.idx -win 1 -step 1 > /home/ltimm/Anoplopoma_fimbria/fst/Afim2_${chrom}_south-wGOA_polymorphic_folded.sfs.pbs.fst.txt

