
packages_needed <- c("gtools", "reshape2", "ggplot2")

for(i in 1:length(packages_needed)){
	  if(!(packages_needed[i] %in% installed.packages())){install.packages(packages_needed[i],  repos = "http://cran.us.r-project.org")}
  library(packages_needed[i], character.only = TRUE)
}

args=commandArgs(trailingOnly = TRUE)
FOLDERIN <- args[1]
PREFIX <- args[2]

r <- read.table(paste0(FOLDERIN,PREFIX,".ld"), header=FALSE, stringsAsFactors=FALSE)
colnames(r) <- c("snp1", "snp2", "bp_space", "r2", "D", "Dp", "r2_EM")
r_ord <- r[order(r$snp1, r$snp2),]
for(i in 3:ncol(r_ord)){r_ord[,i] <- as.numeric(r_ord[,i])}
for(j in 1:2){r_ord[,j] <- as.character(r_ord[,j])}

plot_heatmap <- ggplot(data = r_ord, aes(snp1, snp2, fill = r2))+
	  		geom_tile()+
	    		scale_fill_gradient2(low = "white", high = "navyblue", mid = "turquoise", 
	                	             midpoint = 0.5, limit = c(0,1), space = "Lab", 
	                        	     name="LD") +
			ggtitle(PREFIX)+
  			theme_minimal()+ 
    			theme(axis.text.x=element_blank(), 
	  		      axis.ticks.x=element_blank(), 
          		      axis.text.y=element_blank(),  
	  		      axis.ticks.y=element_blank())+
  			coord_fixed()+
   			theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
         		      panel.background = element_blank(), axis.line = element_line(colour = "black"),
  	 		      text = element_text(size = 20), legend.key.size = unit(1, 'cm')) 


tiff(paste0(FOLDERIN,PREFIX,"_r2.tiff"), width = 12, height = 12, res = 300, units = "in", compression = "lzw")
plot_heatmap
x <- dev.off()
