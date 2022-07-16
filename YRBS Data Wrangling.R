# Load Libraries
library(tidyverse)

# Load YRBS dataset
yrbss_all <- readRDS( file.path( path.expand( "~" ) , "YRBSS" , "2019 main.rds" ) )

# Create dataframe and tibble
yrbss_df <- data.frame(yrbss_all)
yrbss_df <- tibble(yrbss_df)

# Create a subset of data
yrbss_var <- yrbss_df %>%
  select(year, age, sex, sexid2, q14, 
         q17, q23, q24, q25, q26, q27,
         q28, q29, q42, q56, q60) %>%
  rename(sexid = sexid2,
         gun = q14,
         fight = q17,
         bullied = q23,
         cyber.bullied = q24,
         hopeless = q25,
         ideation = q26,
         plan = q27,
         attempt = q28,
         attempt.med = q29,
         binge.drinking = q42,
         needle = q56,
         sex.partners = q60)


