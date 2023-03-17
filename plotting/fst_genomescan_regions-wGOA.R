######################################
### INSTALL PACKAGES & LOAD FUNCTIONS

packages_needed <- c("ggplot2", "scales", "tidyverse", "RColorBrewer")

for(i in 1:length(packages_needed)){
  if(!(packages_needed[i] %in% installed.packages())){install.packages(packages_needed[i])}
  library(packages_needed[i], character.only = TRUE)
}
#################################################################################

#################################################################################
# Specify working directory and input files

  # path to where pairwise comparison data files are that are labeled with the two population names in the comparison POP1_POP2.fst.txt
  # (i.e., Russia-Kodiak.fst.txt)
  DATADIR <- "/home/ltimm/Anoplopoma_fimbria/fst/" 
  
  # Tab-delimited table that has two columns chrom name (chr; i.e., NC_044048.1) and a simplified name (chr_num; i.e., chr_1)
  CHROMFILE <- "/home/ltimm/Anoplopoma_fimbria/fst/chrom_meta_data.txt" 

  # Full path to sampling location metadata with two columns one for pop and the other for my region designation
  # (e.g., pop = Russia, region = Bering Sea)
  METAFILE <- "/home/ltimm/Anoplopoma_fimbria/fst/fst_metadata_4regions.txt"

  # Specify the population you would like to focus on, and a full list of population names
  FOCALPOP <- "wGOA"
  
  # Specify output location for plotting
  OUTFILE <- "/home/ltimm/Anoplopoma_fimbria/fst/figures/"
  
#################################################################################

#################################################################################
# Read in files
  chrom_df <- read.table(CHROMFILE, header = TRUE)
  meta_df <- read.delim(METAFILE, header = TRUE) 

# Specify the order of some factors for plotting later
  meta_df$pop <- factor(meta_df$pop, levels = meta_df$pop)
  meta_df$region <- factor(meta_df$region, levels = unique(meta_df$region))
  
  # THIS MAY NEED UPDATING DEPENDING ON YOUR COLOR PALETTE NEEDS
  mypalette <- brewer.pal(4, "Dark2")
  meta_df$mypalette <- mypalette
  meta_df$mypalette <- factor(meta_df$mypalette, levels = meta_df$mypalette)
  POPLIST <- unique(meta_df$pop)

#################################################################################

#################################################################################
# identify files for combining

  COMPARISONS <- subset(POPLIST, !(POPLIST %in% FOCALPOP))
  setwd(DATADIR)
  WILDCARD1 <- paste0(FOCALPOP,"-*.fst.txt") ## THIS MAY NEED CHANGING DEPENDING ON YOUR NAMING SCHEME
  WILDCARD2 <- paste0("*-",FOCALPOP,".fst.txt") ## THIS MAY NEED CHANGING DEPENDING ON YOUR NAMING SCHEME
  FILENAMES <- Sys.glob(c(WILDCARD1,WILDCARD2)) 
  file_list <- as.list(FILENAMES)


################################################################################################
### 
# Read in pairwise comparison data files   
  fst_df <- file_list %>%
    set_names(nm = FILENAMES) %>%
    map_dfr(
      ~ read_delim(.x, skip = 1, col_types = cols(), col_names = c("region", "chr", "midpos", "nsites", "fst"), delim = "\t"),
      .id = "comparison"
    )

  setwd(OUTFILE)

# Append information about simplified chromosome names 
  fst_df <- fst_df %>%
    filter(chr %in% chrom_df$chr)
  
  fst_df <- left_join(fst_df, chrom_df, by = "chr")
  nCHR <- length(unique(fst_df$chr))
  
# Calculate the distance along chromosomes in Mb
  fst_df <- fst_df %>%
    mutate(midpos_Mb = midpos/1000000)

# Strip the original file name such that only the population that FOCALPOP is being compared to is retained (for plot labeling)
  # THIS MAY ALSO NEED ALTERING DEPENDING ON YOUR NAMING SCHEME
  final_df <- fst_df %>%
    mutate(temp1 = gsub(".fst.txt", "", comparison)) %>%
    mutate(temp2 = gsub(FOCALPOP, "", temp1)) %>%
    mutate(POP2 = gsub("-", "", temp2))

# Make the POP2 column in the dataframe into a factor with a specific order
  final_df$POP2 <- factor(final_df$POP2, levels = meta_df$pop)
  
# Make the chr column in the dataframe into a factor with a specific order
  final_df$chr_num <- factor(final_df$chr_num, levels = chrom_df$chr_num)

# get rid of negative fst values
  final_df$fst_neg0 <- final_df$fst
  final_df$fst_neg0[final_df$fst_neg0 < 0] <- 0
  head(final_df)
  
#################################################################
# Part 2: Plot the data

# Specify a color palette
  temp_df <- meta_df %>%
    subset(pop %in% COMPARISONS) %>%
    select(mypalette)
  MYPALETTE <- temp_df$mypalette

# Set the ggplot theme
  theme_set(
    theme( 
      legend.position = "none",
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 90, size = 7, vjust = 0.5),
      axis.text.y = element_text(angle = 0, size = 10),
      panel.background = element_rect(fill = "white"), 
      panel.spacing = unit(0,"lines"),
      strip.text.y = element_text(angle = 0) 
    )
  )

#Save a hi-res (god help us) tiff
manhplot <- ggplot() +
  geom_point(data = final_df, aes(x = midpos_Mb, y = fst, color = POP2), 
             alpha = 0.75, size = 0.1) +
  scale_color_manual(values = as.character(MYPALETTE)) +
  facet_grid(POP2 ~ chr_num, scales = "free_x") +
  ylab(expression(italic(F[ST]))) +
  xlab("Chromosome position (Mb)") +
  ggtitle(paste0(FOCALPOP, " vs all")) +
  # set tick mark spacing
  scale_y_continuous(breaks = c(0.0, 0.5, 1)) +
  scale_x_continuous(breaks = c(15,30))
ggsave(paste0(OUTFILE, FOCALPOP,"_", "plot_fst.tiff"), plot = manhplot, width = 30, height = 10, units = "in", dpi=300, compression = "lzw")

# plot by chromosome
for(i in 1:length(unique(final_df$chr_num))){
  plotChrom <- unique(final_df$chr_num)[i]
  manhplot_zoom <- ggplot() + 
    geom_point(data = final_df[final_df$chr_num == plotChrom,], 
               aes(x = as.numeric(midpos_Mb), y = fst_neg0, color = POP2),
               alpha = 0.75, size = .1) + 
    scale_color_manual(values = as.character(MYPALETTE)) +
    facet_grid(POP2~., scales = "free_x") +
    ylab(expression(italic(F[ST]))) +
    xlab("Chromosome position (Mb)") +
    ggtitle(paste(FOCALPOP, "-", plotChrom)) 
  ggsave(paste0(OUTFILE, FOCALPOP,"_", plotChrom, "_zoom_plot_fst.tiff"), plot = manhplot_zoom, width = 10, height = 10, units = "in", dpi = 300, compression = "lzw")
}
