# Code used to conduct analyses, generate plots and tables

# Load libraries
library(tidyverse)
library(dplyr)
library(tidyr)
library(forcats)
library(ggplot2)
library(RColorBrewer)
library(crosstable)
library(flextable)
library(ggpubr)

## DEMOGRAPHICS ##

# Plot age and gender
age_plot <- ggplot(yrbss_final, aes(x = age, fill = sex)) + 
  geom_bar(position = "dodge") +
  labs(x = "Age", 
       y = "Count", 
       fill = "Gender") +
  scale_x_continuous(breaks = seq(12, 18, by = 1)) +
  ggtitle("Participant Demographics")

age_plot + scale_fill_manual(values = c(
  "Female"="palevioletred",
  "Male"="skyblue1"))

# Boxplot of suicide ideation by age and gender
ideation_demographics <- ggplot(yrbss_final, aes(x = age, y = ideation, fill = sex)) +
  geom_boxplot() +
  labs(x = "Age", 
       y = NULL, 
       fill = "Gender") +
  scale_x_continuous(breaks = seq(12, 18, by = 1)) +
  ggtitle("Suicide Ideation")

ideation_demographics <- ideation_demographics +
  scale_fill_brewer(palette = "Pastel1")


# Boxplot of suicide attempts by age and gender
attempt_demographics <- ggplot(yrbss_final, aes(x = age, y = attempt, fill = sex)) + 
  geom_boxplot() +
  labs(x = "Age", 
       y = NULL, 
       fill = "Gender") + 
  scale_x_continuous(breaks = seq(12, 18, by = 1)) +
  ggtitle("Suicide Attempts")

attempt_demographics <- attempt_demographics +
  scale_fill_brewer(palette = "Pastel1")

# Combined boxplots
ggarrange(ideation_demographics,
          attempt_demographics,
          common.legend = TRUE, 
          legend = "bottom")

## MAIN ANALYSES ##

# Question 1: Are individuals who’ve made a suicide attempt or suicide 
# attempt requiring medical attention more likely to to have carried 
# a gun in the past 30 days than individuals who only report suicide 
# ideation?

# Counts, percentages and odds ratios of carrying a gun
# Ideation-only group
yrbss_final %>%
  filter(attempt == "None") %>%
  crosstable(ideation, 
             by = gun, 
             effect = TRUE) %>%
  as_flextable()

# Attempt groups
crosstable(yrbss_final, 
           c(attempt, 
             attempt.med), 
           by = gun, 
           effect = TRUE) %>%
  as_flextable()

# Plot showing percent of ideation-only group who carried a gun
Q1_ideation <- yrbss_final %>%
  filter(attempt == "None") %>%
  ggplot(aes(x = ideation, fill = gun)) +
  geom_bar(position = "fill") + 
  labs(x = "Suicide Ideation", 
       y = NULL,
       fill = "Carried a gun in past 30 days?") +
  scale_y_continuous(labels = scales::percent)

Q1_ideation <- Q1_ideation + 
  scale_fill_manual(values = c(
    "Yes" = "midnightblue",
    "No" = "slategray2"))


# Plot showing percent of suicide attempt group who carried a gun
Q1_attempt <- ggplot(yrbss_final, aes(x = attempt, fill = gun)) + 
  geom_bar(position = "fill") + 
  labs(x = "Suicide Attempt", 
       y = NULL,
       fill = "Carried a gun in past 30 days?") +
  scale_y_continuous(labels = scales::percent)

Q1_attempt <- Q1_attempt + 
  scale_fill_manual(values = c(
    "Yes" = "midnightblue",
    "No" = "slategray2"))

# Plot showing percent of participants with suicide attempts requiring 
# medical attention who carried a gun
Q1_attempt.med <- ggplot(yrbss_final, aes(x = attempt.med, fill = fight)) +
  geom_bar(position = "fill") + 
  labs(x = "Attempt requiring medical attention", 
       y = NULL,
       fill = "Carried a gun in past 30 days?") +  scale_y_continuous(labels = scales::percent)

Q1_attempt.med <- Q1_attempt.med + 
  scale_fill_manual(values = c(
    "Yes" = "midnightblue",
    "No" = "slategray2"))

# Combined Q1 plot
Q1 <- ggarrange(Q1_ideation, 
                Q1_attempt, 
                Q1_attempt.med, 
                common.legend = TRUE, 
                legend = "bottom")
annotate_figure(Q1, 
                top = text_grob("Percent of participants who carried a gun, by suicide outcomes", 
                                face = "bold"))


# Question 2: Are individuals who’ve made a suicide attempt or suicide attempt 
# requiring medical attention more likely to have been involved in a physical 
# fight in the past 30 days than individuals who only report suicide ideation?

# Counts, percentages and odds ratios of getting into a physical fight
# Ideation-only group
yrbss_final %>%
  filter(attempt == "None") %>% 
  crosstable(ideation, 
             by = fight, 
             effect = TRUE) %>%
  as_flextable()

# Attempt groups
crosstable(yrbss_final, 
           c(attempt, 
             attempt.med), 
           by = fight, 
           effect = TRUE) %>%
  as_flextable()

# Plot showing percent of ideation-only group who got into a physical fight
Q2_ideation <- yrbss_final %>%
  filter(attempt == "None") %>%
  ggplot(aes(x = ideation, fill = fight)) + 
  geom_bar(position = "fill") + 
  labs(x = "Suicide Ideation", 
       y =  NULL, 
       fill = "Physical fight in past 30 days") +
  scale_y_continuous(labels = scales::percent)

Q2_ideation <- Q2_ideation + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Plot showing percent of attempt group who got into a physical fight
Q2_attempt <- ggplot(yrbss_final, aes(x = attempt, fill = fight)) + 
  geom_bar(position = "fill") + 
  labs(x = "Suicide Attempt", 
       y = NULL, 
       fill = "Physical fight in past 30 days") +
  scale_y_continuous(labels = scales::percent)


Q2_attempt <- Q2_attempt + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Plot showing percent of participants with suicide attempt requiring medical attention
# who got into a physical fight
Q2_attempt.med <- ggplot(yrbss_final, aes(x = attempt.med, fill = fight)) + 
  geom_bar(position = "fill") + 
  labs(x = "Attempt requiring medical attention", 
       y = NULL, 
       fill = "Physical fight in past 30 days") +
  scale_y_continuous(labels = scales::percent)

Q2_attempt.med <- Q2_attempt.med + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Combined plots
Q2 <- ggarrange(Q2_ideation, 
                Q2_attempt, 
                Q2_attempt.med, 
                common.legend = TRUE, 
                legend = "bottom")
annotate_figure(Q2, 
                top = text_grob("Percent of participants who got in a physical fight, by suicide outcome", 
                                face = "bold"))

# Plot showing percent of ideation-only group who got into a physical fight, by gender
Q2_ideation_sex <- ggplot(yrbss_final, 
                          aes(x = ideation, fill = fight)) + 
  geom_bar(position = "fill") + 
  labs(x = NULL, 
       y = NULL,
       fill = "Physical fight in past 30 days?") +
  ggtitle("Suicide Ideation") +
  theme(plot.title = element_text(size = 10)) +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~sex)

Q2_ideation_sex <- Q2_ideation_sex + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Plot showing percent of attempt group who got into a physical fight, by gender
Q2_attempt_sex <- ggplot(yrbss_final, 
                         aes(x = attempt, fill = fight)) + 
  geom_bar(position = "fill") + 
  labs(x = NULL, 
       y = NULL, 
       fill = "Physical fight in past 30 days?") + 
  ggtitle("Suicide Attempts") +
  theme(plot.title = element_text(size = 10)) +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~sex)

Q2_attempt_sex <- Q2_attempt_sex + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Plot showing percent of participants with suicide attempt requiring medical attention
# who got into a physical fight, by gender
Q2_attempt.med_sex <- ggplot(yrbss_final, 
                             aes(x = attempt.med, fill = fight)) +
  geom_bar(position = "fill") + 
  labs(x = NULL, 
       y = NULL, 
       fill = "Physical fight in past 30 days?") + 
  ggtitle("Attempts Requiring Medical Attention") +
  theme(plot.title = element_text(size = 10)) +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~sex)
Q2_attempt.med_sex <- Q2_attempt.med_sex + 
  scale_fill_manual(values = c(
    "Yes" = "red4",
    "No" = "bisque"))

# Combined Q2-Gender plot
Q2_sex <- ggarrange(Q2_ideation_sex, 
                    Q2_attempt_sex, 
                    Q2_attempt.med_sex, 
                    nrow = 3, 
                    ncol = 1,
                    heights = 50,
                    common.legend = TRUE, 
                    legend = "right")
annotate_figure(Q2_sex, 
                top = text_grob("Percent of participants who got in a physical fight, by suicide outcome and gender",
                                face = "bold", 
                                size = 12))


# Question 3: Are individuals who’ve made a suicide attempt or suicide attempt 
# requiring medical attention more likely to report having injected illegal drugs 
# than individuals who only report suicide ideation?

# Plot showing percent of ideation-only group who injected illegal drugs
Q3_ideation <- yrbss_final %>%
  filter(attempt == "None") %>%
  ggplot(aes(x = ideation, fill = needle)) + 
  geom_bar(position = "fill") + 
  labs(x = "Suicide Ideation", 
       y = NULL, 
       fill = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent)

Q3_ideation <- Q3_ideation + 
  scale_fill_manual(values = c(
    "Never" = "darkolivegreen3",
    "Once" = "darkorange",
    "More than once" = "tomato3"))

# Plot showing percent of attempt group who injected illegal drugs
Q3_attempt <- ggplot(yrbss_final, aes(x = attempt, fill = needle)) +  
  geom_bar(position = "fill") + 
  labs(x = "Suicide Attempt", 
       y = NULL, 
       fill = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent)

Q3_attempt <- Q3_attempt + 
  scale_fill_manual(values = c(
    "Never" = "darkolivegreen3",
    "Once" = "darkorange",
    "More than once" = "tomato3"))

# Plot showing percentage of participants with suicide attempts requiring 
# medical attention who injected illegal drugs
Q3_attempt.med <- ggplot(yrbss_final, aes(x = attempt.med, fill = needle)) + 
  geom_bar(position = "fill") + 
  labs(x = "Attempt requiring medical attention", 
       y = NULL, 
       fill = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent)

Q3_attempt.med <- Q3_attempt.med + 
  scale_fill_manual(values = c(
    "Never" = "darkolivegreen3",
    "Once" = "darkorange",
    "More than once" = "tomato3"))

#Combined Q3 Plot
Q3 <- ggarrange(Q3_ideation, 
                Q3_attempt, 
                Q3_attempt.med, 
                common.legend = TRUE, 
                legend = "bottom")
annotate_figure(Q3, 
                top = text_grob("Percent of participants who injected illegal drugs, by suicide outcome",
                                face = "bold"))

# Question 4: Is there a cumulative effect when multiple risky behaviors 
# are reported such that a higher proportion of individuals who report 
# injecting illegal drugs, getting into a fight *AND* carrying a gun also 
# report a suicide attempt?

# Counts, percentages and odds ratios between risky behavior variables
crosstable(yrbss_final, c(fight, needle), by = gun, effect = TRUE) %>%
  as_flextable()

# Plot showing relationship between risky behaviors
RB <- ggplot(yrbss_final, aes(x = fight, fill = gun)) + 
  geom_bar(position = "fill") +
  labs(x = "Got in physical fight", 
       y = NULL, 
       fill = "Carried a gun", 
       subtitle = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~ needle)

RB + scale_fill_manual(values = c(
  "Yes" = "midnightblue",
  "No" = "slategray2"))

# Plot showing interaction between risky behaviors in individuals who have not attempted suicide in the past year
Q4_no_attempt <- yrbss_final %>%
  filter(attempt.med == "Did not attempt") %>%
  ggplot(aes(x = fight, fill = gun)) + 
  geom_bar(position = "fill") +
  labs(x = "Got in physical fight", 
       y = NULL, 
       fill = "Carried a gun",
       title = "No attempt in past 12 months",
       subtitle = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~ needle)

Q4_no_attempt <- Q4_no_attempt + 
  scale_fill_manual(values = c(
    "Yes" = "midnightblue",
    "No" = "slategray2"))

# Plot showing interaction between risky behaviors in individuals who have attempted suicide in the past year
Q4_attempt <- yrbss_final %>%
  filter(attempt.med != "Did not attempt") %>%
  ggplot(aes(x = fight, fill = gun)) + 
  geom_bar(position = "fill") +
  labs(x = "Got in physical fight", 
       y = NULL, 
       fill = "Carried a gun",
       title = "Attempt in the past 12 months",
       subtitle = "Injected illegal drugs") +
  scale_y_continuous(labels = scales::percent) +
  facet_grid(~ needle)

Q4_attempt <- Q4_attempt + 
  scale_fill_manual(values = c(
    "Yes" = "midnightblue",
    "No" = "slategray2"))
  

