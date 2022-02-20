rm(list = ls())
library(tidyverse)
library(tidyjson)
library(jsonlite)
library(dplyr)

path <- "/Users/atolentino/DViz/Bui/HW_3/number_3"
setwd(path)

url <- "https://static01.nyt.com/newsgraphics/2022/01/29/brady-career/216fe5204c6d41cf312f933f886cc16d35e148e9/player-lookup.json"

player_stats <- read.table(file = "cumulative-stats.tsv", sep = '\t', header = TRUE)
player_lookup <- fromJSON(txt = url)

lookup <- player_lookup %>% spread_all

lookup_df <- lookup %>% 
  as.data.frame() %>% 
  select(player_id, player_name, age_start, year_start, year_end, last_name)

join_df <- left_join(player_stats, lookup_df, by = "player_id") %>% 
  mutate(
    age = age_start + (year - year_start)
  )

df_clean <- join_df %>% 
  select(player_name, year, age, playoff_wins, tds, yards, pb_games, year_start, year_end, last_name) %>% 
  mutate(year_start = as.integer(year_start),
         year_end = as.integer(year_end))

write.csv(df_clean, "cleaned_player_data.csv", row.names = FALSE)

players_2021 <- df_clean %>% 
  filter(year == 2021) %>% 
  select(player_name)

write.csv(players_2021, "players_in_2021.csv", row.names = FALSE)
str(df_clean)
