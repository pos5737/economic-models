
library(tidyverse)

# load googlesheet published to web as csv
# sheet at https://docs.google.com/spreadsheets/d/1Am1cZb9qJXjupfDxVDS0dmhGXb6RgNYONV14NOr8C3E/edit#gid=0
url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vS0RH-GoRJ7EVcPdLSYvUzLXwxyZGhfIvgOwjDdih4yM8mHJ4Fmz_7ADP43EsQHLq8AawXfJd7XgiOs/pub?gid=0&single=true&output=csv"
raw_df <- read_csv(url, skip = 4) %>%
  glimpse()

# write raw data to file
write_csv(raw_df, "raw-data/election-raw.csv")

# clean data
df <- raw_df %>%
  mutate(share_rep = 100*votes_rep/(votes_dem + votes_rep),
         share_dem = 100*votes_dem/(votes_dem + votes_rep)) %>%
  mutate(incumbent_margin = case_when(incumbent_party == "Democrat"   ~ share_dem - share_rep,
                                      incumbent_party == "Republican" ~ share_rep - share_dem),
         winner_name = case_when(votes_dem > votes_rep ~ short_name_dem,
                            votes_rep > votes_dem ~ short_name_rep),
         incumbent_name = case_when(incumbent_party == "Democrat"   ~ short_name_dem,
                                    incumbent_party == "Republican" ~ short_name_rep),
         challenger_name = case_when(incumbent_party == "Democrat"   ~ short_name_rep,
                                     incumbent_party == "Republican" ~ short_name_dem)) %>%
  select(year, incumbent_margin, winner_name, incumbent_party, incumbent_name, challenger_name) %>%
  glimpse()

write_csv(df, "intermediate-data/election.csv")
