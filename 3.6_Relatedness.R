## Script to plot relatedness from IBD and NGSrelate output##

# Load packages

library("data.table")
library("tidyverse")
library("ggplot2")
library("dplyr")
library("paletteer")

      #####################
      #### Relatedness ####
      #####################

# Set colour palette
col_palette <- c(paletteer_d("ggthemes::Red_Blue_Brown")[12],
                 paletteer_d("ggthemes::Summer")[7],
                 paletteer_d("ggthemes::Green_Orange_Teal")[2],
                 paletteer_d("ggthemes::Winter")[9],
                 paletteer_d("ggthemes::Red_Blue_Brown")[2],
                 paletteer_d("ggthemes::Purple_Pink_Gray")[12])

# Read in data
gen <- fread("data/out/WSD_GLs.genome", header = T)
ngsrel <- fread("data/out/WSD_NGSrelate.res")

summary(gen$PI_HAT)

# Assign relatedness criteria
gen <- gen %>%
  mutate(kinship = (Z1 / 4) + (Z2 / 2)) %>%
  mutate(criteria_2 = case_when(kinship >= 1/2^(5/2) & kinship < 1/2^(3/2) & Z0 < 0.1 ~ "Parent-offspring",
                                kinship >= 1/2^(5/2) & kinship < 1/2^(3/2) & Z0 > 0.1 & Z0 < 0.365 ~ "Full-sibling",
                                kinship >= 1/2^(7/2) + 0.01 & kinship < 1/2^(5/2) + 0.01 & Z0 > 0.365 + 0.01 & Z0 < 1-(1/(2^(3/2))) + 0.01 ~ "Second-degree",
                                kinship >= 1/2^(9/2) + 0.01 & kinship < 1/2^(7/2) + 0.01 & Z0 > 1-(1/2^(3/2)) + 0.01 & Z0 < 1 -(1/2^(5/2)) + 0.01 ~ "Third-degree",
                                kinship < 1/2^(9/2) + 0.01 & Z0 > 1-(1/2^(5/2)) + 0.01 ~ "Unrelated",
                                TRUE ~ "Unknown"))

gen$R1 <- ngsrel$R1 
gen$R0 <- ngsrel$R0
gen$KING <- ngsrel$KING

# Plot PI_HAT distr.
PI_HAT_Plot <- ggplot(gen, aes(x=PI_HAT)) + 
  geom_histogram(col = col_palette[5], alpha = 0.9, fill = col_palette[5], binwidth = 0.01) + 
  scale_y_continuous(trans='log10') +
  xlab("Pairwise relatedness") + ylab("Count") +
  theme_classic() +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14)) +
  ggtitle("A")

# Plot R1 vs. KING
R1vsKING_Plot <- ggplot(filter(gen, criteria_2 != "Unknown"), aes(R1, KING)) +
  geom_point(size = 2.5, alpha = 0.5,
             aes(colour = factor(criteria_2, 
                                 levels = c("Parent-offspring",
                                            "Full-sibling",
                                            "Second-degree",
                                            "Third-degree",
                                            "Unrelated",
                                            "Unknown")))) +
  scale_colour_manual(values = col_palette) +
  theme_classic() +
  theme(legend.title = element_blank(),
        legend.position = c(0.8, 0.2),
        legend.text = element_text(size=13),
        axis.text=element_text(size=12),
        axis.title=element_text(size=14)) +
  guides(colour = guide_legend(override.aes = list(alpha=1),
                               keywidth = 0.2,
                               keyheight = 0.2,
                               default.unit = "inch")) +
  ggtitle("B")

ggsave("figures/Figure4.png",
       PI_HAT_Plot + R1vsKING_Plot,
       width = 27, height = 9)
