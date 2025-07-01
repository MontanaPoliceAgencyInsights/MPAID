---
title: Introduction - [Pacific Division]
author: "Drew Radovich"
#date: "2024-03-09"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

## Introduction

The Pacific Division is defined by the U.S. Census Bureau as a subdivision of the West Region comprising of five states: Alaska, California, Hawaii, Oregon, and Washington. These states have an estimated total population of 53,191,898 (26,489,419 male and 26,702,479 female.)

This project hopes to identify the trends between social vulnerability in census tracts and the amount of tax credit dollars they receive through two popular tax credit programs, the New Market Tax Credit (NMTC) and Low Income Housing Tax Credit (LIHTC). To identify social vulnerability, we will be using the U.S. Centers for Disease Control and Prevention (CDC)'s Social Vulnerability Index. We will also utilize data from the U.S. Census Bureau to identify census tracts and changes from the years 2010 to 2020. Data related to Median Income, Median Home Values, and House Price Indexes will be from the U.S. Census Bureau and Federal Housing Finance Agency to aid in the analysis of economic inequalities across regions.
The CDC's Social Vulnerability Index aims to approximate a communities vulnerability to disaster through the following four categories:
-  Socioeconomic Status (living below the 150% poverty line, unemployment, housing cost burden, no high school diploma, no health insurance)
-  Household Characteristics (aged 65+, aged 17 & younger, civilian with a disability, single-parent households, English language proficiency)
-  Racial & Ethnic Minority Status
-  Housing Type & Transportation (multi-unit structures, mobile homes, crowding, no vehicle, group quarters)

Once we identify particularly vulnerable communities within the division, we can examine patterns of participation in the NMTC and LIHTC programs. These national programs encourage investors to initiate building projects in at-risk communities by offering tax credits. The hope of these incentives is to reduce social vulnerability and increase economic outcomes.

For the Pacific Division, we will evaluate the impact of the NMTC and LIHTC at reducing social vulnerability (measured by flags) and increasing economic outcomes (measure by median incomes, home values, and housing price index) from 2010 to 2020. Our hypothesis is that census tracts whom receive investment from these programs will experience a decrease in social vulnerability over time as well as increases in median incomes and home values greater than the genereal trends of the division.


## Library

``` r
library( here )
library( tidyverse )
library( kableExtra )
library( tidycensus )
```

## Load Data

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
             .from = here::here("analysis/project_data_steps_radovich.R"),
             .character_only = TRUE)

census_division
```

    ## [1] "Pacific Division"

``` r
# Load API key, assign to TidyCensus Package, remember do not print output
source(here::here("password.R"))
tidycensus::census_api_key(census_api_key)
```

## Census Variable Data Dictionary

``` r
# Preview Data
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

## Division Population

``` r
# Query Census API via tidyverse
acs_pull <- get_acs(geography = "division", 
              variables = c("S0101_C01_001", "S0101_C03_001", "S0101_C05_001"), 
              year = 2020) %>% filter(NAME == census_division)
```

``` r
# Join data set with census_variable df
left_join(acs_pull, census_variables, join_by("variable" == "name")) %>% mutate( "year" = "2020") %>% kbl(format.args = list(big.mark = ",")) %>% kable_styling() %>% scroll_box(width = "100%")
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
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:left;">
S0101_C01_001
</td>
<td style="text-align:right;">
53,191,898
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
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:left;">
S0101_C03_001
</td>
<td style="text-align:right;">
26,489,419
</td>
<td style="text-align:right;">
1,875
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
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:left;">
S0101_C05_001
</td>
<td style="text-align:right;">
26,702,479
</td>
<td style="text-align:right;">
1,876
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
