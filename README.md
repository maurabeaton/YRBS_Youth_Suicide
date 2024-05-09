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
* year - Year data was collected
* age - Age of participants
* sex - Biological sex of participants
* sexid2 - Sexual identity (collapsed variable)
* q14 - Carried a gun
* q17 - Got in a physical fight
* q23 - Bullied at school
* q24 - Cyber bullied
* q25 - Felt sad or hopeless
* q26 - Suicide ideation
* q27 - Suicide plan
* q28 - Number of suicide attempts
* q29 - Suicide attempt that required medical attention
* q42 - Binge Drinking
* q56 - Injected illegal drug
* q60 - Number of sex partners

Documentation on these variables is available here: <https://www.cdc.gov/healthyyouth/data/yrbs/pdf/2019/2019_YRBS_SADC_Documentation.pdf>
