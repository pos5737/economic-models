
library(tidyverse)
library(lubridate)
library(fredr)

# set key to use api (keep private)
source("R/api-keys.R")
# e.g., fredr_set_key("key-here")

# use to find desired series
# RDI, https://www.vox.com/mischiefs-of-faction/2018/2/12/17001984/forecast-good-news-dems
ids <- fredr_series_search_text(search_text = "real disposable")
# I chose series A229RX0Q048SBEA

# get information about chosen series
meta <- fredr_series(series_id = "A229RX0Q048SBEA") %>%
  glimpse()

# preserve original metadata
write_csv(meta, "raw-data/rdi-meta.csv")

# get the series
fred_df_raw <- fredr_series_observations(series_id = "A229RX0Q048SBEA") 

# preserve original data
write_csv(fred_df_raw, "raw-data/rdi-raw.csv")

# tidy the series
rdi_df <- fred_df_raw %>%
  mutate(year = year(date),
         quarter = paste0("Q", quarter(date))) %>%
  select(-date, -series_id) %>%  
  pivot_wider(names_from = quarter, values_from = value) %>%
  mutate_at(vars(starts_with("Q")), list(lag1yr = lag)) %>%
  mutate(percent_change = 100*(Q2 - Q2_lag1yr)/Q2_lag1yr) %>%
  select(year = year, ch_rdi = percent_change) %>%
  glimpse()

# write intermediate dataset to file
write_csv(rdi_df, "intermediate-data/rdi.csv")

