# The Sablefish (_Anoplopoma fimbria_) Workflow:  assembly, analysis, and visualization/graphing

### Assembly
1) Index the [reference genome](https://ftp.ncbi.nlm.nih.gov/genomes/genbank/vertebrate_other/Anoplopoma_fimbria/latest_assembly_versions/GCA_027596085.2_Afim_UVic_2022/GCA_027596085.2_Afim_UVic_2022_genomic.fna.gz):
[GCA_027596085.1_Afim_UVic_2022_genomic_bwa-indexSLURM.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/GCA_027596085.1_Afim_UVic_2022_genomic_bwa-indexSLURM.sh)
[GCA_027596085.1_Afim_UVic_2022_genomic_faiSLURM.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/GCA_027596085.1_Afim_UVic_2022_genomic_faiSLURM.sh)
2) Quality-check  raw fastqs:
[Afim-raw_fastqcARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-raw_fastqcARRAY.sh) ran with the array input [Afim-raw_fqcARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-raw_fqcARRAY_input.txt).
After this script ran, results were collated with [Afim-raw_multiqcSLURM.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-raw_multiqcSLURM.sh).
3) Trim adapters and re-run the quality-check:
[Afim_trimARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_trimARRAY.sh) ran with the array input [Afim_trimARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_trimARRAY_input.txt).
After these ran, quality was checked for individual trimmed fastqs with
[Afim-trim_fastqcARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-trim_fastqcARRAY.sh) ran with the array input [Afim-trim_fqcARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-trim_fqcARRAY_input.txt).
After this script ran, results were collated with [Afim-trim_multiqcSLURM.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-trim_multiqcSLURM.sh)
4) Align trimmed fastqs to reference genome, sort reads, remove duplicates, and clip overlap:
[Afim_alignARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_alignARRAY.sh) ran with [Afim_alignARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_alignARRAY_input.txt).
5) Check the mean alignment depth for each individual:
[Afim_depthsARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_depthsARRAY.sh) ran with the array input [Afim_depthsARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_depthsARRAY_input.txt).
Mean depths were visualized with [mean_depths_byInd.R](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/mean_depths_byInd.R).
Three individuals fell below the mean depth threshold of 1x (ABLG1671, ABLG1816, ABLG1836) and were blacklisted from genotype likelihood calculation.
6) Calculate genotype likelihoods:
across polymorphic sites with [Afim_polymorphicARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_polymorphicARRAY.sh) and across all sites with [Afim_globalARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_globalARRAY.sh). Both scripts ran with the array input [Afim_angsdARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_angsdARRAY_input.txt).
7) Concatenate chromosome-level data:
[Afim_concatenate_beagles.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_concatenate_beagles.sh) to join likelihood data.
[Afim_concatenate_mafs.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_concatenate_mafs.sh) to join MAF data.
