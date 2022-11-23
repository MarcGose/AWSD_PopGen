##Script to visualise population structure using DAPC and KLFDAPC##

# Load packages

library("adegenet")
library("pegas")
library(vcfR)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(tidyverse)
library(gtools)
library(dartR)
library(paletteer)

    ################
    ##### DAPC #####
    ################

# Set colour palette

col_palette <- c(paletteer_d("ggthemes::Red_Blue_Brown")[12],
                 paletteer_d("ggthemes::Summer")[7],
                 paletteer_d("ggthemes::Green_Orange_Teal")[2],
                 paletteer_d("ggthemes::Winter")[9],
                 paletteer_d("ggthemes::Red_Blue_Brown")[2],
                 paletteer_d("ggthemes::Purple_Pink_Gray")[12])

# Read in VCF and popfile
vcf<- read.vcfR("data/out//WSD_GLs3.vcf")
pops <- read.table("data/out/pop_file2.info")

# Convert to genlight
genotypes <- vcfR2genlight(vcf)
genotypes@pop <- as.factor(pops$V1)

(as.matrix(genotypes))[c(1:5), 1:12]

grp <- find.clusters(genotypes, max.n.clust = 10)
# Choose 5
dapc1 <- dapc(genotypes, genotypes$pop)
# Choose 5

# estimate a-score
dapc2 <- dapc(genotypes, genotypes$pop, n.da = 100, n.pca = 100)

temp <- a.score(dapc2)

temp <- optim.a.score(dapc1)

temp <- as.data.frame(genotypes)%>%
  replace_na()

genotypes2 <- df2genind(temp, ploidy = 2, sep = "\t")

xval <- xvalDapc(genotypes2, grp, n.pca.max = 300, training.set = 0.9, result = "groupMean", center = TRUE, scale = FALSE, n.pca = NULL, n.rep = 30, xval.plot = TRUE)

# Compute PCs
pc1 <- dapc1$ind.coord[,1]
pc2 <- dapc1$ind.coord[,2]
pc3 <- dapc1$ind.coord[,3]
pc4 <- dapc1$ind.coord[,4]

ggplot_dapc <- as.data.frame(cbind(pc1, pc2)) # pc3, pc4))
ggplot_dapc$pop <- pops$V1

# Plot
DAPC_Plot <- ggplot(ggplot_dapc) +
  aes(pc1, pc2, col = pop) +
  geom_point(shape = ifelse(1:nrow(pca_pop) == 83, 17, 19), size = 3) +
  scale_color_manual(values = col_palette) +
  ylab("PC2") +
  xlab("PC1") +
  theme_few()

ggsave("figures/FigureS6", DAPC_Plot, width = 21, height = 10, units = "cm")

ggplot(ggplot_dapc) +
  aes(pc1, pc3, col = pop) + 
  geom_point(shape = ifelse(1:nrow(pca_pop) == 83, 17, 19), size = 3) +
  scale_color_manual(values = col_palette) +
  ylab("PC3") +
  xlab("PC1") +
  theme_few()
