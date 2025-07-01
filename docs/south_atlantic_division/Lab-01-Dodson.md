---
title: "Introduction - South Atlantic Division"
author: "Kenaniah Dodson"
#date: 2025-03-30
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

# Introduction - South Atlantic Division

The U.S. Census Bureau defines the South Atlantic Division as a sub-region of the Southeast United States. This division contains seven states, which is the most states of any division:

-   Delaware
-   District of Columbia
-   Florida
-   Georgia
-   Maryland
-   North Carolina
-   South Carolina
-   Virginia
-   West Virginia

Across these states there is a total population of 65,235,308. This total includes 31,816,666 total males and 33,418,642 total females.

Throughout the South Atlantic Division section of this report, we will track indicators of social vulnerability using data from the U.S. Census Bureau and the Federal Housing Finance Agency. We will measuring these indicators based on the U.S. Centers for Disease Control and Prevention (CDC)'s Social Vulnerability Index, including economic inequalities such as Median Income, Median Home Values, and House Price Index.

The CDC's SVI measures social vulnerability by four main categories:

-   Socioeconomic Status (living below 150% poverty line, unemployment, housing cost burden, no high school diploma, no health Insurance)
-   Household Characteristics (aged 65 & older, aged 17 & younger, civilian with a disability, single-parent households, English language proficiency)
-   Racial & Ethnic Minority Status
-   Housing Type & Transportation (multi-unit structures, mobile homes, crowding, no vehicle, group quarters)

Each of these categories will be used to identify communities that are most vulnerable to disasters and could most benefit from additional support. After identifying the most vulnerable communities in the division, we will examine participation in the New Markets Tax Credit (NMTC) and Low Income Housing Tax Credit (NMTC) programs. Both of these programs are national policies that use tax credits to encourage investors to initiate building projects for community facilities and housing within at-risk census tracts.

With this data, we will evaluate whether the NMTC and NMTC programs have had an impact on reducing social vulnerability between our measured years of 2010 and 2020. It is our hypothesis that census tracts that receive investment from the NMTC and LIHTC programs will experience a decrease in social vulnerability and increase in median incomes and home values that is greater than the general trends in the division.

# library {#library}

``` r
library(here)
library(tidyverse)
library(tidycensus)
library(kableExtra)
```

# Data {#data}

``` r
#Load US Census region data
census_regions <- readxl::read_excel(here::here("data/raw/Census_Data_SVI/census_regions.xlsx"))

# View divisions
census_regions %>% select(Division) %>% distinct()
```

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
```

``` r
import::here( "census_division",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("analysis/project_data_steps_dodson.R"),
             .character_only = TRUE)

census_division
```

```         
## [1] "South Atlantic Division"
```

``` r
# Load API key, assign to TidyCensus Package, remember do not print output
source(here::here("analysis/password.R"))
census_api_key(census_api_key)
```

# Census Variable Data Dictionary {#census-variable-data-dictionary}

``` r
census_variables <- load_variables(2020, "acs5/subject", cache = TRUE)
census_variables %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

::: {style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; "}
| name | label | concept |
|:--------------|:-----------------------------------------|:--------------|
| S0101_C01_001 | Estimate!!Total!!Total population | AGE AND SEX |
| S0101_C01_002 | Estimate!!Total!!Total population!!AGE!!Under 5 years | AGE AND SEX |
| S0101_C01_003 | Estimate!!Total!!Total population!!AGE!!5 to 9 years | AGE AND SEX |
| S0101_C01_004 | Estimate!!Total!!Total population!!AGE!!10 to 14 years | AGE AND SEX |
| S0101_C01_005 | Estimate!!Total!!Total population!!AGE!!15 to 19 years | AGE AND SEX |
| S0101_C01_006 | Estimate!!Total!!Total population!!AGE!!20 to 24 years | AGE AND SEX |
:::

# Division Population {#division-population}

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

::: {style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; "}
| GEOID | NAME | variable | estimate | moe | label | concept | year |
|:--------|:--------|:--------|--------:|--------:|:---------|:--------|:--------|
| 5 | South Atlantic Division | S0101_C01_001 | 65,235,308 | NA | Estimate!!Total!!Total population | AGE AND SEX | 2020 |
| 5 | South Atlantic Division | S0101_C03_001 | 31,816,666 | 4,040 | Estimate!!Male!!Total population | AGE AND SEX | 2020 |
| 5 | South Atlantic Division | S0101_C05_001 | 33,418,642 | 4,043 | Estimate!!Female!!Total population | AGE AND SEX | 2020 |
:::
