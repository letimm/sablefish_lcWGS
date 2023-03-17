# The Sablefish (_Anoplopoma fimbria_) Workflow:  assembly, analysis, and visualization/graphing

## Assembly
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

## Analyses
### PCA
I generated a PCA for the whole genome with [Afim_wholegenome_pcangsd.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_wholegenome_pcangsd.sh). Two outliers (ABLG1633 and ABLG1634) were determined to be a duplicated sample, so I re-ran the PCA with one outlier (ABLG1633) removed with [Afim_wholegenome_pcangsd-keep119.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_wholegenome_pcangsd-keep119.sh). As this resolved the issue, I re-ran steps 6 and 7 above with ABLG1633 excluded.
Six clusters remained in teh PCA. To clarify where this signal came from within the genome, I ran a PCA for every chromosome with [Afim_pcangsdARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_pcangsdARRAY.sh) which ran over the array [Afim_pcangsdARRAY_input.txt](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_pcangsdARRAY_input.txt).
Signal came from chromosome 16. A new "whole genome" beagle file was generated by concatenating likelihood data from all chromosomes **except** chromosome 16 with [Afim_concatenate_beagles-nix16.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_concatenate_beagles-nix16.sh) and a new PCA was generated ([Afim_wholegenome_pcangsd-nix16.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_wholegenome_pcangsd-nix16.sh)).
PCAs were visualized with [plot_pca.R](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/plot_pca.R).

### Population-level _FST_
Individuals were organized in two ways that were informative for the research questions: by region (Bering Sea and Aleutian Islands - BSAI, western Gulf of Alaska - wGOA, eastern Gulf of Alaska - eGOA, and the Washington State coast - south) and by cluster (A-F representing the six clusters in the whole genome PCA, from left to right).
_FST_ values were calculated for all population pairs within these schemes using [Afim_summaryFST-pt1_ARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt1_ARRAY.sh) and [Afim_summaryFST-pt2_ARRAY.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt2_ARRAY.sh). 
Within each script, an array file specifies the populations and population pairs.
| Scheme | groups | pt1 array | pt2 array |
| ------ | ------ | ------ | ------ |
| regions | BSAI, wGOA,eGOA, south | [Afim_summaryFST-pt1_ARRAY_input-regions.txt] | [Afim_summaryFST-pt2_ARRAY_input-regions.txt] |
| clusters | A, B, C, D, E, F | [Afim_summaryFST-pt1_ARRAY_input-clusters.txt] | [Afim_summaryFST-pt2_ARRAY_input-clusters.txt] |

To examine the statistical significance of the calculated _FST_ values, I ran a permutation test for every population pair. Briefly, given the four populations BSAI (n = 25), wGOA (n = 17), eGOA (n = 28), and south (n = 49), for each permutation all 119 individuals are randomly shuffled into these four populations, maintaining sample sizes. Pairwise population-level _FST_ values are calculated for this new arrangement of individuals. After the permutations have concluded and we have a distribution of _FST_ values for each population pair, we calculate the mean of each distribution and use it to estimate the cumulative distribution function (CDF) of the _FST_ result for the population pair under an exponential distribution. P-val is estimated as 1 - CDF.

Distributions were generated with [Afim-regions_fst_posterior.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-regions_fst_posterior.sh) and [Afim-clusters_fst_posterior.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-clusters_fst_posterior.sh).
Significance was tested with [Afim-regions_fst_sig_test_wrapper.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-regions_fst_sig_test_wrapper.sh) and [Afim-clusters_fst_sig_test_wrapper.sh](https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim-clusters_fst_sig_test_wrapper.sh) (these scripts call [fst_significance_test.py](https://github.com/letimm/WGSfqs-to-genolikelihoods/blob/main/fst_significance_test.py)).


[Afim_summaryFST-pt1_ARRAY_input-regions.txt]: <https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt1_ARRAY_input-regions.txt>
[Afim_summaryFST-pt2_ARRAY_input-regions.txt]: <https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt2_ARRAY_input-regions.txt>
[Afim_summaryFST-pt1_ARRAY_input-clusters.txt]: <https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt1_ARRAY_input-clusters.txt>
[Afim_summaryFST-pt2_ARRAY_input-clusters.txt]: <https://github.com/letimm/sablefish_lcWGS/blob/main/scripts/Afim_summaryFST-pt2_ARRAY_input-clusters.txt>
