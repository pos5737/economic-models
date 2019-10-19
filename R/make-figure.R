
library(tidyverse)
library(broom)
library(ggrepel)

# load dataset
df <- read_csv("data/economic-models.csv") %>%
  glimpse()

fit <- lm(incumbent_margin ~ ch_rdi, data = df)

gg_df <- df %>%
  augment(fit, data = .) %>% 
  mutate(label = case_when(.cooksd > 0.05 ~ incumbent_name,
                           TRUE ~ "")) %>%
  mutate(year_label = str_sub(year, 3, 4)) %>%
  glimpse()

# make plot
ggplot(gg_df, aes(x = ch_rdi, y = incumbent_margin, label = paste0(incumbent_name, " ",  year_label))) + 
  #geom_vline(xintercept = 0, color = "grey80") + 
  geom_hline(yintercept = 0, color = "grey80") + 
  geom_point(size = 2) + 
  geom_rug(length = unit(0.01, "npc")) + 
  geom_text_repel(size = 3) + 
  theme_bw() + 
  labs(x = "% Change in Real Disposable Income",
       y = "Incumbent Margin of Victory",
       title = "Economic Voting in U.S. Presidential Elections")
ggsave("example.png", height = 3, width = 4, scale = 1.4)
