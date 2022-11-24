###################
##### KLFDAPC #####
###################

# Load packages

library("devtools")
library("SNPRelate")
devtools::install_github("xinghuq/KLFDAPC")
library("KLFDAPC")
library("SeqArray")
library("paletteer")
library("ggplot2")

# Set colour palette

col_palette <- c(paletteer_d("ggthemes::Red_Blue_Brown")[12],
                 paletteer_d("ggthemes::Summer")[7],
                 paletteer_d("ggthemes::Green_Orange_Teal")[2],
                 paletteer_d("ggthemes::Winter")[9],
                 paletteer_d("ggthemes::Red_Blue_Brown")[2],
                 paletteer_d("ggthemes::Purple_Pink_Gray")[12])

# Read in popfile and VCR
popsex <- read.table("file_lists/pop_file.info")
pop_file <- popsex$V1

samp.annot <- data.frame(pop_file)

# Convert to GDS
snpgdsVCF2GDS(vcf.fn = "data/out/WSD_GLs.vcf", out.fn = "WSD_GLs_GDS")

# Open GDS file
(genofile <- snpgdsOpen("WSD_GLs_GDS", readonly = FALSE))

# Check if data looks correct
read.gdsn(index.gdsn(genofile, "sample.id"))
read.gdsn(index.gdsn(genofile, "snp.rs.id"))
read.gdsn(index.gdsn(genofile, "genotype"))

# Add sample annotation subdirect. with pop info
add.gdsn(genofile, "sample.annot", samp.annot)
read.gdsn(index.gdsn(genofile, "sample.annot"))
pop_code <- read.gdsn(index.gdsn(genofile, "sample.annot"))

pop_code$pop_file=factor(pop_code$pop_file,levels=c("Faroes", "US/FR", "Iceland", "Ireland", "Scotland"))

# Perform PCA
pcadata <- SNPRelate::snpgdsPCA(genofile, autosome.only = FALSE)

# Close GDS file
snpgdsClose(genofile)

# Generate normalize function
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Normalize PCA
pcanorm=apply(pcadata$eigenvect[,1:20], 2, normalize)

# Generate Gaussian matrix
kmat <- kmatrixGauss(pcanorm,sigma=5)

# Perform KLFDAPC
klfdapc=KLFDA(kmat, pop_code$pop_file, r=3, knn = 1)

# Plot
plot(klfdapc$Z[,1], klfdapc$Z[,2], xlab="RD 1", ylab="RD 2")

KLFDAPC_Plot <- plot(klfdapc$Z[,1], klfdapc$Z[,2], col=col_palette[as.integer(pop_code$pop_file)], pch=19, xlab="RD 1", ylab="RD 2") +
  legend("topright", legend=levels(pop_code$pop_file), pch=19, col=col_palette[1:nlevels(pop_code$pop_file)])

ggsave("figures/FigureS7.png", KLFDAPC_Plot, width = 17, height = 9, units = "cm")
