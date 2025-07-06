---
title: Introduction - South Atlantic Division
author: "Minnie Mouse"
#date: "2024-03-09"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

# Introduction

-  CONTENT

# Library

``` r
library(here)
library(tidyverse)
library(tidycensus)
library(kableExtra)
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
             .from = here::here("analysis/project_data_steps_minnie.R"),
             .character_only = TRUE)

census_division
```

    ## [1] "South Atlantic Division"

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

-  DATA TABLE