############################################################################
## Genotype heatmap
############################################################################
### INSTALL PACKAGES & LOAD FUNCTIONS

packages_needed <- c("ggplot2", "scales", "ggpubr", "tidyverse", "data.table", "readxl")

for(i in 1:length(packages_needed)){
  if(!(packages_needed[i] %in% installed.packages())){install.packages(packages_needed[i])}
  library(packages_needed[i], character.only = TRUE)
}

#################################################################################

#################################################################################
# Specify working directory and input files

## ALL OF THESE FIELDS WILL NEED TO CHANGE TO FIT YOUR NEEDS

# Main directory where your data files are stored
DATADIR <- "C:/Users/laura.timm/Desktop/Anoplopoma_fimbria/" 

# Beagle file that you are interested in plotting the genotype matrix for
beagle_file <- read.table(paste0(DATADIR, "chr14_peak/chr14.beagle"), header = TRUE)

# text file of a list of bamfiles that should match the order of your individuals in your beagle file
BAM_LIST <- "Afim_filtered_bamslist.txt" 

# Metadata xlsx file 
SAMPLEMETADATA <- "sablefish_metadata.xlsx"

# Population color and region file where "pop" is the first column and are the names of your 
# different populations, "region" is your geographic region, and "color" are your plotting colors
# for each pop
POPMETADATA <- "chr14_peak/peak-colors.txt"

# Out directory for your figures
FIGOUT <- "C:/Users/laura.timm/Desktop/Anoplopoma_fimbria/chr14_peak/"

# Prefix for naming your figures 
PREFIX <- "Afim_chr14peak"
#################################################################################

#################################################################################
# set up meta data for plotting

# Read in your text file with the bamfile list
bam_df <- read.delim(paste0(DATADIR,BAM_LIST), header = F, col.names = "sample_id")
head(bam_df)
dim(bam_df)

## For loop to pull your sample names from your bamfiles. Here you want to extract the information
## using str_extract that matches your sample names so the regex will need to change to fit your needs.
## My sample names are in the format ABLG#### or ABLG##### so the \\d+ will get all digits after ABLG no 
## matter how many are there (thats the + sign). 
sampleIDS <- NULL
for(i in 1:nrow(bam_df)){
  sampleIDS <-  rbind(sampleIDS, str_extract(bam_df$sample_id[i], "ABLG\\d+")) 
  
}

## Now strip off the ABLG and just grab the sample digits (This chunk of code may or may not 
## be needed depending on your naming convention)
sampleIDs_df <- as.data.frame(sampleIDS)
#sampleNUMs <- NULL
#for(i in 1:nrow(sampleIDs_df)){
#  sampleNUMs <-  rbind(sampleNUMs, str_extract(sampleIDs_df$V1[i], "\\d+"))
#}

## Make this a dataframe to merge
#sampleNUMs_df <- as.data.frame(sampleNUMs)
#sampleNUMs_df$V1 <- as.numeric(sampleNUMs_df$V1)

## Read in your metadata file
metadata <- read_xlsx(paste0(DATADIR,SAMPLEMETADATA), sheet = "sheet1")
seq_samples <- metadata[metadata$final_dataset == "1",]
head(seq_samples)
str(seq_samples)

## Join your metadata to the sample ids that are ordered by your bamfiles
plotData <- left_join(sampleIDs_df, seq_samples, by = c("V1" = "ABLG"))[c("V1", "genetic_sex")]

## add an individual identifier that will match your genotype matrix labels
plotData$Ind <- paste0("Ind", 1:nrow(plotData)) 

# read in population metadata
df_popMetaData <- read.delim(paste0(DATADIR, POPMETADATA), header = TRUE, sep = "\t")
mypalette <- df_popMetaData$color
pop.factor.levels <- df_popMetaData$sex

#################################################################################

plot.matrix <- matrix(ncol = ((ncol(beagle_file)-3)/3), nrow = nrow(beagle_file))
rownames(plot.matrix) <- beagle_file$V1
colnames(plot.matrix) <- paste0("Ind",1:((ncol(beagle_file)-3)/3))
for(i in 1:nrow(beagle_file)){
  for(j in 4:ncol(beagle_file)){
    if(j%%3 == 0){
      
      hom_major <- beagle_file[i,(j-2)]
      het <- beagle_file[i,(j-1)]
      hom_minor <- beagle_file[i,(j)]
      probs <- c(hom_major, het, hom_minor)
    
      if(probs[1] == probs[2] & probs[1] == probs[3]){ ## all equal make WHITE
        plot.matrix[i,((j/3)-1)] <- NA
      }else if(probs[1] == max(probs) & probs[1] == probs[2]){ ## hom major equal to het make between BLUE and YELLOW 1-2
        plot.matrix[i,((j/3)-1)] <- 1 + probs[1]
      }else if(probs[1] == max(probs) & probs[1] == probs[3]){ ## SHOULD NEVER HAPPEN
        plot.matrix[i,((j/3)-1)] <- "NO"
      }else if(probs[2] == max(probs) & probs[2] == probs[3]){## hom minor equal to het make between RED and YELLOW 3-4
        plot.matrix[i,((j/3)-1)] <- 3 + probs[2]
      }else if(max(probs) == probs[1]){ ## hom major BLUE 0-1
        plot.matrix[i,((j/3)-1)] <- abs(probs[1]-1) # absolute value of the probability - 1 means that the bluer it is the higher the probability towards being a hom major 
      }else if(max(probs) == probs[2]){ ## het YELLOW 2-3
        plot.matrix[i,((j/3)-1)] <- 2 + probs[2]
      }else if(max(probs) == probs[3]){ ## hom minor RED 4-5
        plot.matrix[i,((j/3)-1)] <- 4 + probs[3]
      }
    }
  } 
}
## Take matrix and create a datatable for plotting
plot.table <- reshape2::melt(plot.matrix)

## Rename columns 
colnames(plot.table) <- c("locus", "Ind", "value")

## Join your metadata with the new dataframe with genotype scores
plot.table.meta <- left_join(plot.table, plotData, by = "Ind")
plot.table.meta$value <- as.numeric(as.character(plot.table.meta$value))

## Factor your locality column into the order you want them to plot in which is the order of your
## pop.factor.levels
plot.table.meta$genetic_sex <- factor(plot.table.meta$genetic_sex, levels = pop.factor.levels)

#order for plotting
plot.table.meta$Ind <- factor(plot.table.meta$Ind, 
                              levels=unique((plot.table.meta$Ind)[order(plot.table.meta$genetic_sex)]))

## Uncomment and do any subsetting for plotting if you need to
#plot.table.meta_keep <- plot.table.meta[plot.table.meta$keep118 == 1,]

# Plot your genotype heatmap 
geno_heatmap <- ggplot(plot.table.meta,aes(x=locus, y=Ind, fill=value)) + 
  geom_tile() + 
  theme_minimal()+ 
  theme(axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        text = element_text(size = 12), legend.key.size = unit(1, 'cm'))+
  ylab(label ="Individual")+
  scale_fill_gradient2(low = "blue", mid = "yellow", high ="red", 
                       midpoint = 3.0, guide = "colourbar", na.value = "white")

geno_heatmap

## Make the colored bar that is for your population colors 
## add a column called Locality_text that just has Locality as all the values 
## this will serve as your X-axis and your population ID will serve as your y-axis
plot.table.meta <- plot.table.meta %>% 
  mutate(cluster_text = "sex")

# plot a bar that represents population ids for the individuals in rows of the genotype heatmap
pop_heatmap <- ggplot(plot.table.meta, aes(cluster_text,Ind, fill=genetic_sex)) + 
  geom_tile() + 
  theme_minimal()+ 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(),  axis.line = element_blank(), 
        legend.text = element_text(size = 12), legend.key.size = unit(1, 'cm'))+
  theme(axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  xlab(label = ". ") +
  ylab(label = " ") +
  scale_fill_manual(values = mypalette) + 
  theme(legend.position="left") + 
  theme(axis.text.x=element_blank())

tiff(paste0(FIGOUT, PREFIX,".tiff"), width = 15, height = 7, res = 300, units = "in", compression = "lzw")
ggarrange(pop_heatmap, geno_heatmap, widths = c(0.3, 1))
dev.off()
