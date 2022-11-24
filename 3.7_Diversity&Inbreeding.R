## Script to calculate genetic diversity using InbreedR package ##

# Load packages

library("data.table")
library("tidyverse")
library("ggplot2")
library("dplyr")
library("paletteer")
library("inbreedR")
library("vcfR")
library("reshape")

      #########################
      ### Genetic diversity ###
      #########################

# Set colour palette
col_palette <- c(paletteer_d("ggthemes::Red_Blue_Brown")[12],
                 paletteer_d("ggthemes::Summer")[7],
                 paletteer_d("ggthemes::Green_Orange_Teal")[2],
                 paletteer_d("ggthemes::Winter")[9],
                 paletteer_d("ggthemes::Red_Blue_Brown")[2],
                 paletteer_d("ggthemes::Purple_Pink_Gray")[12])

# Read in data
vcf_file <- "data/out/WSD_GLs.vcf"
vcf <- read.vcfR(vcf_file, verbose = FALSE )

# Pop assignments
meta <- read.table("file_lists/pop_file2.info", header = FALSE)

gt <- extract.gt(vcf)
gt <- as.data.frame(t(gt), stringsAsFactors = FALSE)
gt[gt == "."] <- NA
snp_geno <- do.call(cbind, apply(gt, 2, function(x) colsplit(x, "/", c("a","b"))))
WSD_SNPs <- convert_raw(snp_geno)
check_data(WSD_SNPs)
het <- MLH(WSD_SNPs)
barplot(het, ylab = "MLH", xlab = "ID")

df_het <- cbind(het, meta)

mutate(df_het, across(where(is.character), as.factor))

# Write function to get sMLH from .raw PLINK output
get_sMLH_from_plinkraw <- function(file) {
  
  x <- fread(file, colClasses = "character")
  ids <- x$FID
  x <- dplyr::select(x, contains("HET"))
  #row.names(x) <- ids
  NAs <- apply(x, 1, function(x) sum(is.na(x)))
  
  sMLH <- as.data.frame(sMLH(x))
  sMLH$ANIMAL <- ids
  sMLH$NAS <- NAs
  colnames(sMLH) <- c("sMLH", "ANIMAL", "NAs")
  sMLH <- sMLH
  
}

# Summary stats
hetero <- as.data.frame(df_het, as.factor(df_het$Origin))

sum_stats <- df_het %>%
  group_by(Origin) %>%
  get_summary_stats(het, type = "mean_sd")

res.aov <- df_het %>% anova_test(sum_stats$mean ~ Origin)

res.aov

# Pairwise t-test across groups
pwc <- sum_stats %>%
  pairwise_t_test(mean ~ Origin, p.adjust.method = "bonferroni")

pwc

# run sMLH on raw file
raw_file <- "data/out/WSD_GLs.raw"

# get sMLH
sMLH <- get_sMLH_from_plinkraw(raw_file)

df_het2 <- cbind(sMLH, popsex)

mutate(df_het2, across(where(is.character), as.factor))

# Plot sMLH distribution across sample set
sMLH_dist <- ggplot(sMLH, aes(sMLH)) +
  geom_histogram(aes(y=..density..),  position="identity", alpha=0.9, col = col_palette[5], fill = col_palette[5]) +
  geom_density(alpha=0.6, col = col_palette[5], fill = col_palette[5]) +
  labs(y = "Density", x = "sMLH") +
  theme_few() +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14)) +
  scale_fill_manual(values = col_palette[5]) +
  ggtitle("A")

plot(sMLH_dist)

# Plot sMLH proportion per region
sMLH_per_region <- ggplot(df_het2) +
  aes(x = sMLH, y = V1) +
  labs(y = "Origin", x = "sMLH") +
  geom_boxplot(fill = col_palette) +
  geom_point() +
  theme_few()

plot(sMLH_per_region)

ggsave("figures/Figure3.png", sMLH_dist + sMLH_per_region, width = 23, height = 9)

      #########################
      ####### Inbreeding ######
      #########################

# Read in data

fhats <- fread("data/out/WSD_GLs.ibc", header = T) %>%
  mutate_if(is.integer, as.character)

# Join with sMLH
ibcs <- fhats %>%
  left_join(sMLH, by = c("FID" = "ANIMAL"))

ibcs %>%
  select(Fhat1, Fhat2, Fhat3, sMLH) %>%
  pairs()

corr_eqn <- function(x,y, digits = 2) {
  corr_coef <- round(cor(x, y), digits = digits)
  paste("italic(r) == ", corr_coef)
}

# Plot Fhat2 distribution
Fhat2_dist <- ggplot(ibcs, aes(Fhat2)) +
  geom_histogram(aes(y=..density..),  position="identity", alpha=0.9, col = col_palette[5], fill = col_palette[5]) +
  geom_density(alpha=0.6, col = col_palette[5], fill = col_palette[5]) +
  labs(y = "Density", x = "Fhat2") +
  theme_few() +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14)) +
  scale_fill_manual(values = col_palette[5]) +
  ggtitle("A")

Fhat2_dist

# Combine with pop assignments
ibcs_meta <- cbind(ibcs, meta)

mutate(ibcs_meta, across(where(is.character), as.factor))

# Plot Fhat2 proportions per region
Fhat2_per_region <- ggplot(ibcs_meta) +
  aes(x = Fhat2, y = V1) +
  labs(y = "Origin", x = "Fhat2") +
  geom_boxplot(fill = col_palette) +
  geom_point() +
  labs(title = "B") +
  theme_few() +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14))

ggsave("figures/FigureS8.png", Fhat2_dist + Fhat2_per_region, width = 27, height = 9, units = "cm")
