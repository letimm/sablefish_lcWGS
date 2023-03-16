# Specify working directory and input files

# path to where pairwise comparison data files are that are labeled with the two population names in the comparison POP1_POP2.fst.txt
# (i.e., Russia-Kodiak.fst.txt)
DATADIR <- "C:/Users/laura.timm/Desktop/Anoplopoma_fimbria/" 

# Tab-delimited table that has two columns chrom name (chr; i.e., NC_044048.1) and a simplified name (chr_num; i.e., chr_1)
CHROMFILE <- paste0(DATADIR, "fst/chrom_meta_data.txt") 
chrom_df <- read.table(CHROMFILE, header = TRUE)

# Full path to sampling location metadata with two columns one for pop and the other for my region designation
# (e.g., pop = Russia, region = Bering Sea)
METAFILE <- read_xlsx(paste0(DATADIR, "sablefish_metadata.xlsx"), sheet = "sheet1")
METADATA <- METAFILE[METAFILE$final_dataset == 1,]

PREFIX <- "Afim"

#################################################################################
#plot the whole genome
pca <- as.matrix(read.table(paste0(DATADIR, "pca/", PREFIX, "_wholegenome-polymorphic.cov")))
pca_e <- eigen(pca)
first3pcs <- data.frame(pca_e$vectors[,1:3])
labeled_first3pcs <- cbind(METADATA, first3pcs)

wg_pca <- ggplot(data = labeled_first3pcs, aes(x = X1, y = X2, colour = region)) + 
  geom_point(size = 2, alpha = 0.75) +
  ggtitle("PCA - whole genome") +
  xlab(paste0("PC1 - ", sprintf("%0.2f", pca_e$values[1]), "%")) +
  ylab(paste0("PC2 - ", sprintf("%0.2f", pca_e$values[2]), "%")) +
  theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
ggsave(paste0(DATADIR, "pca/", PREFIX, "_wholegenome-polymorphic_pca.jpeg"), plot = wg_pca, width = 6, height = 6, units = "in")


#################################################################################
# plot by chromosome
for(i in 1:length(unique(chrom_df$chr_num))){
  plotChrom <- unique(chrom_df$chr_num)[i]
  pca <- as.matrix(read.table(paste0(DATADIR, "pca/", PREFIX, "_", unique(chrom_df$chr)[i], "_polymorphic.cov")))
  pca_e <- eigen(pca)
  first3pcs <- data.frame(pca_e$vectors[,1:3])
  labeled_first3pcs <- cbind(METADATA, first3pcs)
  
  chr_pca <- ggplot(data = labeled_first3pcs, aes(x = X1, y = X2, colour = region)) + 
    geom_point(size = 2, alpha = 0.75) +
    #xlim(-0.1,0.025) +
    ggtitle(paste0("PCA - ", unique(chrom_df$chr)[i])) +
    xlab(paste0("PC1 - ", sprintf("%0.2f", pca_e$values[1]), "%")) +
    ylab(paste0("PC2 - ", sprintf("%0.2f", pca_e$values[2]), "%")) +
    theme_bw() + 
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
  ggsave(paste0(DATADIR, "pca/", PREFIX, "_pca_", plotChrom, ".jpeg"), plot = chr_pca, width = 6, height = 6, units = "in")
}
