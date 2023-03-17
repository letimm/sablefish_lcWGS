#!/bin/bash

#SBATCH --cpus-per-task=20
#SBATCH --time=0-12:00:00
#SBATCH --job-name=sfst1
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/generate_dist_test/job_outfiles/Afim_summaryFST-pt1_%A-%a.out
#SBATCH --array=1-7%12

module unload bio/angsd/0.933
module load bio/angsd/0.933

JOBS_FILE=/home/ltimm/Anoplopoma_fimbria/generate_dist_test/scripts/Afim_summaryFST-pt1_ARRAY_input.txt
IDS=$(cat ${JOBS_FILE})

for sample_line in ${IDS}
do
	job_index=$(echo ${sample_line} | awk -F ":" '{print $1}')
	population=$(echo ${sample_line} | awk -F ":" '{print $2}')
	bamfile=$(echo ${sample_line} | awk -F ":" '{print $3}')
	n=$(echo ${sample_line} | awk -F ":" '{print $4}')
	if [[ ${SLURM_ARRAY_TASK_ID} == ${job_index} ]]; then
		break
	fi
done

angsd -b ${bamfile} \
	-ref /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna \
	-anc /home/ltimm/ref_genomes/GCA_027596085.1_Afim_UVic_2022_genomic.fna \
	-out /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${population} \
	-sites /home/ltimm/Anoplopoma_fimbria/generate_dist_test/Afim_1e6_polymorphic.sites \
	-nThreads 20 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 0 \
	-C 50 \
	-minMapQ 15 \
	-doCounts 1 \
	-setminDepth ${n} \
	-setmaxDepth $((n * 20)) \
	-GL 1 \
	-doGlf 1 \
	-doMaf 1 \
	-minMaf 0.05 \
	-SNP_pval 1e-10 \
	-doMajorMinor 1 \
	-dumpCounts 3 \
	-doDepth 1 \
	-doSaf 1 \
	-only_proper_pairs 1

realSFS /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${population}.saf.idx > /home/ltimm/Anoplopoma_fimbria/generate_dist_test/fst/Afim_${population}.sfs
