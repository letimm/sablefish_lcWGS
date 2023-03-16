library(tidyverse)
library(ggplot2)

setwd("C:\\Users\\laura.timm\\Desktop\\Anoplopoma_fimbria")
depths <- read.csv("Afim_depths.csv", header = FALSE, sep = '\t')
colnames(depths) <- c("ind", "mean_depth")
ggplot(data = depths, aes(x = reorder(ind, -mean_depth), y = mean_depth)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("Sablefish: mean coverage by individual") +
  xlab("individual") +
  ylab("mean depth") +
  geom_hline(yintercept = 1) +
  theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), axis.text.x = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
