# Code used to evaluate data quality and prepare data for analysis

# Load libraries
library(tidyverse)
library(dplyr)
library(tidyr)
library(visdat)
library(mice)
library(forcats)

# Import data
yrbss_2019 <- readRDS( file.path( path.expand( "~" ) , "YRBSS" , "2019 main.rds" ) )
yrbss_df <- data.frame(yrbss_2019)
yrbss_df <- yrbss_df %>%
  filter(year == 2018 | year == 2019)
glimpse(yrbss_df)

# Check for duplicates
sum(duplicated(yrbss_df))

# Create subset of YRBS data with variables of interest
yrbss_VoI <- yrbss_df %>%
  select(age, sex, q14, q17, 
         q26, q28, q29, q56) %>%
  rename(gun = q14,
         fight = q17,
         ideation = q26,
         attempt = q28,
         attempt.med = q29,
         needle = q56)

# Visualize missing values
yrbss_VoI %>% 
  arrange(attempt.med) %>%
  vis_miss()

# About 15% of my data is missing. To address this we ran a multiple imputation using the `mice` package. 
# mice requires that all variables be explicitly defined as either numerical or categorical (all YRBS data is categorical)

# Classify variables as categorical 
yrbss_VoI_input <- yrbss_VoI %>%
  mutate(age = as.factor(age),
         sex = as.factor(sex),
         ideation = as.factor(ideation),
         attempt = as.factor(attempt), 
         attempt.med = as.factor(attempt.med), 
         gun = as.factor(gun),
         fight = as.factor(fight), 
         needle = as.factor(needle))

# Run multiple imputation
inputed_data = mice(yrbss_VoI_input, 
                    method = c("polyreg", "logreg",
                               "polyreg", "polyreg",
                               "polyreg", "polyreg",
                               "polyreg", "polyreg"))

# Compare imputed values to data distribution
summary(yrbss_VoI_input$attempt.med)
inputed_data$imp$attempt.med

# Select final imputation
yrbss_clean = complete(inputed_data, 1)

# Final check for missing values
sum(is.na(yrbss_clean))

# Create variable labels 
yrbss_clean = expss::apply_labels(yrbss_final,
                                  age = "Age",
                                  sex = "Gender",
                                  gun = "Carried a gun",
                                  fight = "Got in physical fight",
                                  needle = "Injected illegal drugs",
                                  ideation = "Suicide ideation",
                                  attempt = "Suicide attempt",
                                  attempt.med = "Attempt requiring medical attention")

# Collapse factors
yrbss_clean$attempt <- fct_collapse(yrbss_clean$attempt, 
                                    None = "1",
                                    Once = "2",
                                    Multiple = c("3","4","5"))
yrbss_clean$gun <- fct_collapse(yrbss_clean$gun,
                                No = "1",
                                Yes= c("2", "3", "4", "5"))
yrbss_clean$fight <- fct_collapse(yrbss_clean$fight, 
                                  No = "1",
                                  Yes= c("2", "3", "4", "5", "6", "7", "8"))

# Add factor labels
yrbss_clean$sex <- factor(yrbss_clean$sex, 
                          labels = c("Female", "Male"))
yrbss_clean$needle <- factor(yrbss_clean$needle, 
                             labels = c("Never", "Once", "More than once"))
yrbss_clean$ideation <- factor(yrbss_clean$ideation,
                               levels = c("2", "1" ),
                               labels = c("No", "Yes"))
yrbss_clean$attempt.med <- factor(yrbss_clean$attempt.med, 
                                  levels = c("1", "3", "2"),
                                  labels = c("Did not attempt","No", "Yes"))

# Convert to numeric variables
age_numeric <- as.numeric(yrbss_clean$age)
# Mutate age so the number equals  actual values
yrbss_clean <- yrbss_clean %>%
  mutate(age2 = age_numeric + 11)
