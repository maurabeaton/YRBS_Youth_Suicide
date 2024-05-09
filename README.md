# YRBS Youth Suicide Data
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

Once downloaded, the files can be imported into R as RDS files using the code below. The dataset used in this analysis was a compiled dataset that inlcudes YRBS data from all 50 US states and all years the survey was conducted (up until 2019). When downloaded using `lodown` this dataset is saved as saved as "2019 main.rds".

```
# Import compiled YRBS dataset
yrbss_all <- readRDS( file.path( path.expand( "~" ) , "YRBSS" , "2019 main.rds" ) )
yrbss_df <- data.frame(yrbss_all)
```

If you've encountered any issues along the way, additional guidance is available here: <http://asdfree.com/youth-risk-behavior-surveillance-system-yrbss.html>

# Variables 

Variables used in the analysis are:
* age - Age of participants
* sex - Biological sex of participants
* q14 - Carried a gun (in past 30 days)
* q17 - Got in a physical fight (in past 30 days)
* q26 - Suicide ideation (in past 12 months)
* q28 - Number of suicide attempts (in past 12 months)
* q29 - Suicide attempt that required medical attention (in past 12 months)
* q56 - Injected illegal drug (in lifetime)

Documentation on these variables is available here: <https://www.cdc.gov/healthyyouth/data/yrbs/pdf/2019/2019_YRBS_SADC_Documentation.pdf>

Since data for many of these variables was only collected starting in 2018. Data used in this analysis was restricted to the years 2018-2019
