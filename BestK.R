##Script to pot Ln and Delta K to estame best K##

# Load packages

library("tidyverse")
library("purrr")
library("forcats")
library("readxl")
library("data.table")
library("patchwork")
library("ggplot2")

    ########################
    #### Ln and Delta K ####
    ########################

# Set datapath and load in .log files
data_path <- "data/out/NGSadmix"
files <- dir(data_path, pattern = "*.log")

# write dataframe
df <- tibble(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ readLines(file.path(data_path, .))))
# Generate function
get_best_like <- function(df) {
  like <- df[grep(pattern = "best like=",df)]
  like <- substr(like,regexpr(pattern="=",like)[1]+1,regexpr(pattern="=",like)[1]+14)
}

# Generate dataframe with changed delimiters and group by K
lnl <- df %>%
  mutate(lnl = map(df$file_contents, get_best_like)) %>%
  select(-file_contents) %>%
  unnest(cols = c(lnl)) %>%
  mutate(filename = gsub("WSD_GLs_NGSadmix_", "", filename)) %>%
  mutate(filename = gsub("_out.log", "", filename)) %>%
  separate(filename, c("K", "run"), sep = "_") %>%
  mutate(run = gsub("run", "", run)) %>%
  mutate(run = as.numeric(run)) %>%
  mutate(K = as.factor(K)) %>%
  mutate(lnl = as.numeric(lnl)) %>%
  group_by(K) %>%
  summarise(mean = mean(lnl),
            minlnl = min(lnl),
            maxlnl = max(lnl),
            sd = sd(lnl)) %>%
  mutate(K = as.numeric(gsub("K", "", K)))

# Plot
lnl_plot <- ggplot(lnl, aes(K, mean)) +
  geom_point() +
  geom_pointrange(aes(ymin = minlnl, ymax = maxlnl),
                  size = 0.5) +
  theme_minimal() +
  ylab("Likelihood") +
  scale_y_continuous(labels = scales::scientific) +
  ggtitle("B")

lnl_plot

# Delta K function
deltaK <- lnl %>%
  mutate(LprimeK = c(NA,mean[-1]-mean[-length(mean)]),
         LdblprimeK = c(NA,LprimeK[-c(1,length(mean))]-(LprimeK)[-(1:2)],NA),
         delta = LdblprimeK/sd) 

# Plot
deltak_plot <- ggplot(deltaK, aes(K, delta)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  scale_x_continuous(limits=c(2, 5)) +
  ylab("Delta K") +
  ggtitle("A") +
  scale_y_continuous(labels = scales::scientific)

deltak_plot

ggsave("figures/FigureS2.png", lnl_plot + deltak_plot, width = 21, height = 10, units = "cm")