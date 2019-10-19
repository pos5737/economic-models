
library(tidyverse)
library(lubridate)
library(fredr)

# set key to use api (keep private)
source("R/api-keys.R")
# e.g., fredr_set_key("key-here")

# use to find desired series
# looking for GDP per caption
ids <- fredr_series_search_text(search_text = "GDP per capita")
# I chose series A939RX0Q048SBEA

# get information about chosen series
meta <- fredr_series(series_id = "A939RX0Q048SBEA") %>%
  glimpse()

# preserve original metadata
write_csv(meta, "raw-data/gdp-meta.csv")

# get the series
fred_df_raw <- fredr_series_observations(series_id = "A939RX0Q048SBEA") 

# preserve original data
write_csv(fred_df_raw, "raw-data/gdp-raw.csv")

# tidy the series
gdp_df <- fred_df_raw %>%
  mutate(year = year(date),
         quarter = paste0("Q", quarter(date))) %>%
  select(-date, -series_id) %>%  
  pivot_wider(names_from = quarter, values_from = value) %>%
  mutate_at(vars(starts_with("Q")), list(lag1yr = lag)) %>%
  mutate(percent_change = 100*(Q2 - Q2_lag1yr)/Q2_lag1yr) %>%
  select(year = year, ch_gdp = percent_change) %>%
  glimpse()

# write intermediate dataset to file
write_csv(gdp_df, "intermediate-data/gdp.csv")