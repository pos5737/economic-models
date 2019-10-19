
library(tidyverse)

df <- read_csv("intermediate-data/rdi.csv") %>%
  full_join(read_csv("intermediate-data/gdp.csv")) %>%
  full_join(read_csv("intermediate-data/unemp.csv")) %>%
  right_join(read_csv("intermediate-data/election.csv")) %>%
  glimpse()

write_csv(df, "data/economic-models.csv")
