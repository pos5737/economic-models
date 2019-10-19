
library(tidyverse)
library(lubridate)
library(fredr)

# set key to use api (keep private)
source("R/api-keys.R")
# e.g., fredr_set_key("key-here")

# use to find desired series
# looking for Gunemployment rate
ids <- fredr_series_search_text(search_text = "Unemployment Rate")
# I chose series 	UNRATE

# get information about chosen series
meta <- fredr_series(series_id = "UNRATE") %>%
  glimpse()

# preserve original metadata
write_csv(meta, "raw-data/unemp-meta.csv")

# get the series
fred_df_raw <- fredr_series_observations(series_id = "UNRATE") 

# preserve original data
write_csv(fred_df_raw, "raw-data/unemp-raw.csv")

# tidy the series
unemp_df <- fred_df_raw %>% 
  mutate(year = year(date),
         month = month(date)) %>%
  filter(month == 6) %>%
  select(year, unemployment = value) %>%
  glimpse()

# write intermediate dataset to file
write_csv(unemp_df, "intermediate-data/unemp.csv")
