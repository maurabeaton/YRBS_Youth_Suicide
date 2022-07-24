### Data Wrangling of YRBS High School Data for Suicide Planning Analyses

# Load Libraries
library(tidyverse)
library(mice)
library(dplyr)
library(forcats)

# Load YRBS dataset
yrbss_all <- readRDS( file.path( path.expand( "~" ) , "YRBSS" , "2019 main.rds" ) )

# Create dataframe and tibble
yrbss_df <- data.frame(yrbss_all)
yrbss_df <- tibble(yrbss_df)

# Create a subset of data
var <- yrbss_df %>%
  select(year, age, sex, sexid2, 
         grade, race4, race7,
         q26, q27,q28, q29) %>%
  rename(sexid = sexid2,
         race = race4,
         race.ethnicity = race7,
         ideation = q26,
         plan = q27,
         attempt = q28,
         attempt.med = q29)

### Duplicates

# Check for duplicate rows
sum(duplicated(yrbss_df))

### Missingness

# Visualize outcome variables
var %>% select(ideation, plan, 
               attempt, attempt.med) %>%
  arrange(attempt.med) %>%
  vis_miss()

# Make variables explicitly categorical
var <- var %>%
  mutate(year = as.factor(year),
         age = as.factor(age),
         sex = as.factor(sex), 
         sexid = as.factor(sexid),
         grade = as.factor(grade),
         race = as.factor(race),
         race.ethnicity = as.factor(race.ethnicity),
         ideation = as.factor(ideation),
         plan = as.factor(plan),
         attempt = as.factor(attempt), 
         attempt.med = as.factor(attempt.med))

# Run multiple imputation
imputed_var = mice(var, 
                   method = c("polyreg", "polyreg",
                              "logreg", "polyreg",
                              "polyreg", "polyreg",
                              "polyreg", "polyreg",
                              "polyreg", "polyreg",
                              "polyreg"))

# Compare imputed values to data distribution
summary(var$attempt.med)
imputed_var$imp$attempt.med

# Select final imputation to use
var_clean = complete(imputed_var,1)


### Labels

# Add factor labels
fct_sex <- factor(var_clean$sex,
                  labels = c("Female", 
                             "Male"))
fct_sexid <- factor(var_clean$sexid,
                    labels = c("Heterosexual", 
                               "Sexual Minority", 
                               "Unsure"))
fct_race <- factor(var_clean$race, 
                   labels = c("White", 
                              "Black/African American",
                              "Hispanic/Latino", 
                              "Other"))
fct_grade <- factor(var_clean$grade, 
                    labels = c("9th Grade",
                               "10th Grade",
                               "11th Grade", 
                               "12th Grade",
                               "Ungraded/Other"))
fct_ethnicity <- factor(var_clean$race.ethnicity, 
                        labels = c("American Indian/Alaska Native", 
                                   "Asian",
                                   "Black/African American",
                                   "Hispanic/Latino", 
                                   "Native Hawaiian/Other Pacific Islander",
                                   "White",
                                   "Other"))
fct_si <- factor(var_clean$ideation,
                 labels = c("Yes", 
                            "No"))
fct_sp <- factor(var_clean$plan,
                 labels = c("Yes", 
                            "No"))
fct_sa.med <- factor(var_clean$attempt.med, 
                     labels = c("Did not attempt",
                                "Yes",
                                "No"))

# Mutate age so value represents actual age
var_clean <- var_clean %>%
  mutate(age = as.numeric(age)) %>%
  mutate(age = age + 11)

# Collapse attempt factors
fct_attempt <- fct_collapse(var_clean$attempt, 
                          None = "1",
                          Once = "2", 
                          Multiple = c("3","4","5"))

# Combine factors into dataframe
var_fct <- data.frame(id = c(1:217340),
                      fct_sex, fct_sexid, fct_grade,
                      fct_race, fct_ethnicity,
                      fct_si, fct_sp,
                      fct_attempt, fct_sa.med)

# Merge data frames
var_clean <- var_clean %>%
  mutate(id = c(1:217340))
var_final <- merge(var_clean, var_fct, by = "id")

# Select final variables
var_final <- var_final %>%
  select(id, year, 
         age, fct_grade,
         fct_sex, fct_sexid,
         fct_race, fct_ethnicity,
         fct_si, fct_sp, 
         fct_attempt, fct_sa.med) %>%
  rename(grade = fct_grade,
         sex = fct_sex,
         sexid = fct_sexid,
         race = fct_race,
         race.ethnicity = fct_ethnicity,
         ideation = fct_si,
         plan = fct_sp,
         attempt = fct_attempt,
         attempt.med = fct_sa.med)

# Save final dataset
save(var_final, file = "YRBS_Planning")
