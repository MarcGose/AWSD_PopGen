##Script to process output from NGSadmix##

# Load packages

library("tidyverse")
library("purrr")
library("forcats")
library("readxl")
library("data.table")
library("patchwork")
library("paletteer")

    ####################
    ##### NGSadmix #####
    ####################

# Set colour palette

col_palette <- c(paletteer_d("ggthemes::Red_Blue_Brown")[12],
                 paletteer_d("ggthemes::Summer")[7],
                 paletteer_d("ggthemes::Green_Orange_Teal")[2],
                 paletteer_d("ggthemes::Winter")[9],
                 paletteer_d("ggthemes::Red_Blue_Brown")[2],
                 paletteer_d("ggthemes::Purple_Pink_Gray")[12])

# Set data path and read in files
data_path <- "data/out/NGSadmix"
files <- dir(data_path, pattern = "*.qopt")

meta <- read.table("file_lists/pop_file2.info")

df <- tibble(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ fread(file.path(data_path, .))))

# Unnest data
df <- unnest(df, cols = c(file_contents)) %>%
  mutate(ID = rep(meta$V2, 60)) %>%
  pivot_longer(cols = c(V1, V2, V3, V4, V5, V6)) %>%
  drop_na()

df <- left_join(df, meta, by = c("ID" = "V2"))

# Split by K
K1 <- filter(df, grepl("K1_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

K2 <- filter(df, grepl("K2_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

K3 <- filter(df, grepl("K3_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

K4 <- filter(df, grepl("K4_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

K5 <- filter(df, grepl("K5_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

K6 <- filter(df, grepl("K6_run1_out.qopt$", filename)) %>%
  mutate(ID = as.factor(ID),
         name = as.factor(name))

# Plot

# https://luisdva.github.io/rstats/model-cluster-plots/

k1_plot <- ggplot(K1, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(V1), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x =  element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none") +
  ylab("K=1")

k1_plot

k2_plot <- ggplot(K2, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Origin), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x =  element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none") +
  ylab("K=2")

k2_plot

k3_plot <- ggplot(K3, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Origin), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x =  element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none") +
  ylab("K=3")

k3_plot

k4_plot <- ggplot(K4, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Origin), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x =  element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none") +
  ylab("K=4")

k4_plot

k5_plot <- ggplot(K5, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Origin), switch = "x", scales = "free", space = "free") +
  theme_minimal() + 
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x =  element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        strip.text.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "none") +
  ylab("K=5")

k5_plot

k6_plot <- ggplot(K6, aes(factor(ID), value, fill = factor(name))) +
  geom_col(color = "gray", size = 0.1) +
  facet_grid(~fct_inorder(Origin), switch = "x", scales = "free", space = "free") +
  theme_minimal() +
  scale_fill_manual(values = col_palette) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_discrete(expand = expansion(add = 1.25)) +
  theme(panel.spacing.x = unit(0.1, "lines"),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        plot.title = element_text(angle = 75, hjust = 1, vjust = -60),
        legend.position = "none") +
  ylab("K=6")

k6_plot

k1_plot + k2_plot + k3_plot + k4_plot + k5_plot + k6_plot + plot_layout(ncol = 1)

ggsave("figures/FigureS4.png",
      k1_plot + k2_plot + k3_plot + k4_plot + k5_plot + k6_plot + plot_layout(ncol = 1),
       width = 7, height = 9)