---
title: "Lab 01 - Mountain Division"
author: "Michelle Knopp"
date: "2025-03-31"
output: 
  github_document:
    toc: true
    toc_depth: 3
    preserve_yaml: true
  rmdformats::downcute:
    toc_depth: 3
    self_contained: true
    thumbnails: false
    lightbox: true
    gallery: false
    highlight: "tango"
    code_folding: show
always_allow_html: true
knit: (function(inputFile, encoding) {
  rmarkdown::render(inputFile, encoding = encoding,
  output_format = "all") })
---

Lab 01 - Mountain Division
================
Michelle Knopp
2025-03-31

- [Library](#library)
- [Load Data](#load-data)
- [Census Variable Data Dictionary](#census-variable-data-dictionary)
- [Division Population](#division-population)

## Introduction

The US Census Bureau has categorized the 50 states and District of
Columbia into 4 distinct regions. Those regions are further divided into
9 districts. For the purposes of this report, we are focusing on the
Mountain District, which is part of the West Region. There are 8 states
in the Mountain District: Arizona, Colorado, Idaho, New Mexico, Montana,
Utah, Nevada, and Wyoming.

According to the 2020 Census data, the Mountain division has a total 
population of 24,534,951, consisting of 12,282,456 males and 12,252,495 
females.

For this portion of the project, we will be examining the impact of two
federally funded tax programs, the New Markets Tax Program and the Low 
Income Housing Tax Credit program on qualifying neighborhoods. In order 
to evaluate the change in neighborhoods,we will be looking at Social 
Variability Index (SVI) Census variables which are defined by U.S. Centers 
for Disease Control and Prevention (CDC)'s to measure neighborhood 
vulnerability. In addition, we will also be looking at economic outcomes 
variables to include: median home values and median income from Census 
data, and the Federal Housing Finance Agency's house price index.

The purpose of the federally funded New Markets Tax Credits and Low Income 
Housing Tax credits is to provide low-income neighborhoods investment funding 
to improve vulnerable neighborhoods.

The CDC's SVI looks at 4 categories of vulnerability. All variables within
these categories can be pulled from Census Data API. They include:

  -  Socioeconomic Status Variables (below 50% poverty, unemployed, housing
  cost burden, no high school diploma, no health insurance)
  -  Household Characteristics Variables (aged 65 and up, ages 17 and younger,
  civilian w/a disability, single-parent household, english language 
  proficiency)
  -  Racial & Ethnic Minority Variables
  -  Housing Type/Transportation Variables (multi-unit structures, mobile homes,
  crowding, no vehicle, group quarters)
  
We will also be including the following economic variables in our analysis:

  -Median Home Values
  -Median Income
  -House Price Index
  
We will look at these variables in vulnerable neighborhoods who received NMTC 
and LIHTC funding and compare them with similar neighborhoods who did not 
receive funding from these programs. Specifically we will be looking at 2010
and 2020 Census data for these neighborhoods. It is our hypothesis that those
neighborhoods who received NMTC and LIHTC funding will have decreased SVI
vulnerability flags and improved economic outcomes.


# Library

``` r
library(here)
library(tidyverse)
library(stringi)
library(kableExtra)
library(tidycensus)
```

# Data

``` r
#Load US Census region data
census_regions <- readxl::read_excel(here::here("data/raw/Census_Data_SVI/census_regions.xlsx"))

# View divisions
census_regions %>% select(Division) %>% distinct()
```

    ## # A tibble: 9 × 1
    ##   Division                   
    ##   <chr>                      
    ## 1 New England Division       
    ## 2 Middle Atlantic Division   
    ## 3 East North Central Division
    ## 4 West North Central Division
    ## 5 South Atlantic Division    
    ## 6 East South Central Division
    ## 7 West South Central Division
    ## 8 Mountain Division          
    ## 9 Pacific Division

``` r
import::here( "census_division",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("analysis/project_data_steps_knopp.R"),
             .character_only = TRUE)

census_division
```

    ## [1] "Mountain Division"

``` r
# Load API key, assign to TidyCensus Package, remember do not print output
source(here::here("analysis/password.R"))
tidycensus::census_api_key(census_api_key)
```

# Census Variable Data Dictionary

``` r
census_variables <- load_variables(2020, "acs5/subject", cache = TRUE)
census_variables %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

name
</th>

<th style="text-align:left;">

label
</th>

<th style="text-align:left;">

concept
</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

S0101_C01_001
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

<tr>

<td style="text-align:left;">

S0101_C01_002
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population!!AGE!!Under 5 years
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

<tr>

<td style="text-align:left;">

S0101_C01_003
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population!!AGE!!5 to 9 years
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

<tr>

<td style="text-align:left;">

S0101_C01_004
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population!!AGE!!10 to 14 years
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

<tr>

<td style="text-align:left;">

S0101_C01_005
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population!!AGE!!15 to 19 years
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

<tr>

<td style="text-align:left;">

S0101_C01_006
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population!!AGE!!20 to 24 years
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

</tr>

</tbody>

</table>

</div>

# Division Population

``` r
# Query Census API via tidyverse
acs_pull <- get_acs(geography = "division", 
              variables = c("S0101_C01_001", "S0101_C03_001", "S0101_C05_001"), 
              year = 2020) %>% filter(NAME == census_division)
```

``` r
# Join data set with census_variable df
left_join(acs_pull, census_variables, join_by("variable" == "name")) %>% mutate("year" = "2020") %>% kbl(format.args = list(big.mark = ",")) %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

GEOID
</th>

<th style="text-align:left;">

NAME
</th>

<th style="text-align:left;">

variable
</th>

<th style="text-align:right;">

estimate
</th>

<th style="text-align:right;">

moe
</th>

<th style="text-align:left;">

label
</th>

<th style="text-align:left;">

concept
</th>

<th style="text-align:left;">

year
</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:left;">

S0101_C01_001
</td>

<td style="text-align:right;">

24,534,951
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:left;">

Estimate!!Total!!Total population
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

<td style="text-align:left;">

2020
</td>

</tr>

<tr>

<td style="text-align:left;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:left;">

S0101_C03_001
</td>

<td style="text-align:right;">

12,282,456
</td>

<td style="text-align:right;">

1,948
</td>

<td style="text-align:left;">

Estimate!!Male!!Total population
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

<td style="text-align:left;">

2020
</td>

</tr>

<tr>

<td style="text-align:left;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:left;">

S0101_C05_001
</td>

<td style="text-align:right;">

12,252,495
</td>

<td style="text-align:right;">

1,947
</td>

<td style="text-align:left;">

Estimate!!Female!!Total population
</td>

<td style="text-align:left;">

AGE AND SEX
</td>

<td style="text-align:left;">

2020
</td>

</tr>

</tbody>

</table>

</div>
