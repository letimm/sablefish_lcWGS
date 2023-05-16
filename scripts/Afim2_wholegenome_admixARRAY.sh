#!/bin/bash

#SBATCH --cpus-per-task=10
#SBATCH --time=0-20:00:00
#SBATCH --job-name=Afim2_wgp-admix
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=laura.timm@noaa.gov
#SBATCH --output=/home/ltimm/Anoplopoma_fimbria/job_outfiles/Afim2_wholegenome_polymorphic_%A-%a.out

#SBATCH --array=1-7%12

module unload bio/ngsadmix
module load bio/ngsadmix

for k_val in {1..7}
do
	if [[ ${SLURM_ARRAY_TASK_ID} == ${k_val} ]]; then
		break
	fi
done

NGSadmix -likes /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /home/ltimm/Anoplopoma_fimbria/admixture/Afim2_wholegenome-polymorphic_k${k_val}-0 -P 10 -minMaf 0
NGSadmix -likes /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /home/ltimm/Anoplopoma_fimbria/admixture/Afim2_wholegenome-polymorphic_k${k_val}-1 -P 10 -minMaf 0
NGSadmix -likes /home/ltimm/Anoplopoma_fimbria/gls/Afim2_wholegenome_polymorphic.beagle.gz -K ${k_val} -outfiles /home/ltimm/Anoplopoma_fimbria/admixture/Afim2_wholegenome-polymorphic_k${k_val}-2 -P 10 -minMaf 0
