# YRBS Youth Suicide
This repository includes analysis code run on CDC Youth Risky Behavior Survey (YRBS) data to explore suicide risk factors among US adolescents

YRBS Data & Documentation for middle school and high school samples is available from https://www.cdc.gov/healthyyouth/data/yrbs/index.htm

The code below outlines how to download the YRBS datasets from R using the `lodown` package:
```
# Install the lodown package
library(devtools)
install_github( "ajdamico/lodown" , dependencies = TRUE )

# Download the YRBS data from the CDC website
library(lodown)
lodown( "yrbss" , output_dir = file.path( path.expand( "~" ) , "YRBSS" ) )
```
The code below outlines how to import the downloaded datafiles into R. The dataset used in this analysis was a compiled dataset that inlcudes YRBS data from all 50 US states and all years the survey was conducted (up until 2019). When downloaded using `lodown` this dataset is saved as saved as "2019 main.rds".

```
# Import compiled YRBS dataset
yrbss_all <- readRDS( file.path( path.expand( "~" ) , "YRBSS" , "2019 main.rds" ) )
yrbss_df <- data.frame(yrbss_all)
```
