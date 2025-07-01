---
title: "Lab-05-Dodson"
author: "Kenaniah Dodson"
date: "2025-04-28"
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

Lab-05-Dodson
================
Kenaniah Dodson
2025-04-28

- [Library](#library)
- [Data](#data)
  - [House Price Index Data](#house-price-index-data)
  - [CBSA Crosswalk](#cbsa-crosswalk)
  - [Census Data](#census-data)
- [NMTC Data](#nmtc-data)
- [LIHTC](#lihtc)
- [Log NMTC and LIHTC Variables](#log-nmtc-and-lihtc-variables)
- [Diff-in-Diff Models](#diff-in-diff-models)
  - [NMTC Evaluation](#nmtc-evaluation)
    - [National SVI](#national-svi)
    - [National Median Income](#national-median-income)
    - [National Median Home Value](#national-median-home-value)
    - [National House Price Index](#national-house-price-index)
- [NMTC Divisional](#nmtc-divisional)
  - [Median Income](#median-income)
  - [Home Value](#home-value)
  - [House Price Index](#house-price-index)
- [Homework](#homework)
  - [NMTC Divisional Models](#nmtc-divisional-models)
  - [Visualize NMTC Divisional
    Models](#visualize-nmtc-divisional-models)
- [LIHTC Divisional](#lihtc-divisional)
  - [Median Income](#median-income-1)
  - [Home Value](#home-value-1)
- [House Price Index](#house-price-index-1)
  - [LIHTC Divisional Model](#lihtc-divisional-model)
  - [Visualize NMTC Divisional
    Models](#visualize-nmtc-divisional-models-1)

# Library

``` r
library(here)         # relative filepaths for reproducibility
library(rio)          # read excel file from URL
library(tidyverse)    # data wrangling
library(stringi)      # string data wrangling
library(tidycensus)   # US census data
library(ggplot2)      # data visualization
library(kableExtra)   # table formatting
library(scales)       # palette and number formatting
library(unhcrthemes)  # data visualization themes
library(ggrepel)      # data visualization formatting to avoid overlapping
library(rcompanion)   # data visualization of variable distribution
library(ggpubr)       # data visualization of variable distribution
library(moments)      # measures of skewness and kurtosis
library(tinytable)    # format regression tables
library(modelsummary) # format regression tables
```

``` r
import::here( "fips_census_regions",
              "load_svi_data",
              "merge_svi_data",
              "census_division",
              "slopegraph_plot",
              "census_pull",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("analysis/project_data_steps_dodson.R"),
             .character_only = TRUE)
```

``` r
# Load API key, assign to TidyCensus Package
source(here::here("analysis/password.R"))
census_api_key(census_api_key)
```

# Data

``` r
# Load NMTC AND LIHTC data sets

svi_divisional_nmtc <- readRDS(here::here(paste0("data/wrangling/", str_replace_all(census_division, " ", "_"), "_svi_divisional_nmtc.rds")))

svi_national_nmtc <- readRDS(here::here(paste0("data/wrangling/", str_replace_all(census_division, " ", "_"), "_svi_national_nmtc.rds")))

svi_divisional_lihtc <- readRDS(here::here(paste0("data/wrangling/", str_replace_all(census_division, " ", "_"), "_svi_divisional_lihtc.rds")))

svi_national_lihtc <- readRDS(here::here(paste0("data/wrangling/", str_replace_all(census_division, " ", "_"), "_svi_national_lihtc.rds")))
```

## House Price Index Data

``` r
hpi_df <- read.csv("https://r-class.github.io/paf-515-course-materials/data/raw/HPI/HPI_AT_BDL_tract.csv")

hpi_df_10_20 <- hpi_df %>% 
  mutate(GEOID10 = str_pad(tract, 11, "left", pad=0)) %>% 
  filter(year %in% c(2010, 2020))  %>%
 select(GEOID10, state_abbr, year, hpi) %>%
  pivot_wider(names_from = year, values_from = hpi) %>%
  mutate(housing_price_index10 = `2010`,
         housing_price_index20 = `2020`) %>%
  select(GEOID10, state_abbr, housing_price_index10, housing_price_index20)

# View data
hpi_df_10_20 %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID10
</th>
<th style="text-align:left;">
state_abbr
</th>
<th style="text-align:right;">
housing_price_index10
</th>
<th style="text-align:right;">
housing_price_index20
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
132.35
</td>
<td style="text-align:right;">
152.78
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
123.78
</td>
<td style="text-align:right;">
123.37
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
158.57
</td>
<td style="text-align:right;">
167.01
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
165.11
</td>
<td style="text-align:right;">
179.60
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020501
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
172.55
</td>
<td style="text-align:right;">
180.96
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020502
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:right;">
158.75
</td>
<td style="text-align:right;">
164.25
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Drop state_abbr column for joining
hpi_df_10_20 <- hpi_df_10_20 %>% select(-state_abbr)
```

## CBSA Crosswalk

``` r
msa_csa_crosswalk <- rio::import("https://r-class.github.io/paf-515-course-materials/data/raw/CSA_MSA_Crosswalk/qcew-county-msa-csa-crosswalk.xlsx", which=4)

msa_csa_crosswalk <- msa_csa_crosswalk %>% 
  mutate(county_fips = str_pad(`County Code`, 5, "left", pad=0),
         cbsa = coalesce(`CSA Title`, `MSA Title`),
         cbsa_code = coalesce(`CSA Code`, `MSA Code`),
         county_title = `County Title`)  %>% 
  select(county_fips, county_title, cbsa, cbsa_code)

msa_csa_crosswalk %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
county_fips
</th>
<th style="text-align:left;">
county_title
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:left;">
cbsa_code
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001
</td>
<td style="text-align:left;">
Autauga County, Alabama
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:left;">
CS388
</td>
</tr>
<tr>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01005
</td>
<td style="text-align:left;">
Barbour County, Alabama
</td>
<td style="text-align:left;">
Eufaula, AL-GA MicroSA
</td>
<td style="text-align:left;">
C2164
</td>
</tr>
<tr>
<td style="text-align:left;">
01007
</td>
<td style="text-align:left;">
Bibb County, Alabama
</td>
<td style="text-align:left;">
Birmingham-Hoover-Cullman, AL CSA
</td>
<td style="text-align:left;">
CS142
</td>
</tr>
<tr>
<td style="text-align:left;">
01009
</td>
<td style="text-align:left;">
Blount County, Alabama
</td>
<td style="text-align:left;">
Birmingham-Hoover-Cullman, AL CSA
</td>
<td style="text-align:left;">
CS142
</td>
</tr>
<tr>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
</tbody>
</table>

</div>

## Census Data

``` r
states <- list(svi_national_nmtc$state %>% unique())
states 
```

    ## [[1]]
    ##  [1] "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" "IN"
    ## [16] "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH"
    ## [31] "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT"
    ## [46] "VT" "VA" "WA" "WV" "WI" "WY"

``` r
census_pull10 <- lapply(states, census_pull, yr = 2010)

census_pull10_df <- census_pull10[[1]] %>%  
  # Drop margin of error column
  select(-moe) %>%
  # Add suffix to variable names
  mutate(variable = paste0(variable, "_10")) %>%
  # Pivot data frame
  pivot_wider(
    names_from = variable,
    values_from = c(estimate)
  )

census_pull10_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
Census Tract 201, Autauga County, Alabama
</td>
<td style="text-align:right;">
31769
</td>
<td style="text-align:right;">
120700
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
Census Tract 202, Autauga County, Alabama
</td>
<td style="text-align:right;">
19437
</td>
<td style="text-align:right;">
138500
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
Census Tract 203, Autauga County, Alabama
</td>
<td style="text-align:right;">
24146
</td>
<td style="text-align:right;">
111300
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
Census Tract 204, Autauga County, Alabama
</td>
<td style="text-align:right;">
27735
</td>
<td style="text-align:right;">
126300
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
Census Tract 205, Autauga County, Alabama
</td>
<td style="text-align:right;">
35517
</td>
<td style="text-align:right;">
173000
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
Census Tract 206, Autauga County, Alabama
</td>
<td style="text-align:right;">
24597
</td>
<td style="text-align:right;">
110700
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
Census Tract 207, Autauga County, Alabama
</td>
<td style="text-align:right;">
22114
</td>
<td style="text-align:right;">
93800
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020801
</td>
<td style="text-align:left;">
Census Tract 208.01, Autauga County, Alabama
</td>
<td style="text-align:right;">
30841
</td>
<td style="text-align:right;">
258000
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020802
</td>
<td style="text-align:left;">
Census Tract 208.02, Autauga County, Alabama
</td>
<td style="text-align:right;">
29006
</td>
<td style="text-align:right;">
145100
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020900
</td>
<td style="text-align:left;">
Census Tract 209, Autauga County, Alabama
</td>
<td style="text-align:right;">
24841
</td>
<td style="text-align:right;">
108000
</td>
</tr>
</tbody>
</table>

</div>

``` r
census_pull19 <- lapply(states, census_pull, yr = 2019)

census_pull19_df <- census_pull19[[1]] %>% 
  # Select columns
  select(GEOID, NAME, variable, estimate, moe) %>% 
  # Create individual FIPS columns for state, county, and tract
  mutate(FIPS_st = substr(GEOID, 1, 2),
         FIPS_county = substr(GEOID, 3, 5),
         FIPS_tract = substr(GEOID, 6, 11)) %>%
# Los Angeles, CA Census Tract fixes
                      mutate(FIPS_tract2 = if_else((FIPS_county == "037" & FIPS_st == "06" & FIPS_tract == "137000"), "930401", FIPS_tract )) %>%
# Pima County, AZ Census Tract fixes
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "002704"), "002701", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "002906"), "002903", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "004118"), "410501", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "004121"), "410502", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "004125"), "410503", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "005200"), "470400", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "019" & FIPS_st == "04" & FIPS_tract == "005300"), "470500", FIPS_tract2 )) %>%
# Madison County, NY Census Tract fixes
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030101"), "940101", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030102"), "940102", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030103"), "940103", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030200"), "940200", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030300"), "940300", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030401"), "940401", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030403"), "940403", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030600"), "940600", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "053" & FIPS_st == "36" & FIPS_tract == "030402"), "940700", FIPS_tract2 )) %>%
# Oneida County, NY Census Tract fixes
                      mutate(FIPS_tract2 = if_else((FIPS_county == "065" & FIPS_st == "36" & FIPS_tract == "024800"), "940000", FIPS_tract2 )) %>% 
                      mutate(FIPS_tract2 = if_else((FIPS_county == "065" & FIPS_st == "36" & FIPS_tract == "024700"), "940100", FIPS_tract2 )) %>%
                      mutate(FIPS_tract2 = if_else((FIPS_county == "065" & FIPS_st == "36" & FIPS_tract == "024900"), "940200", FIPS_tract2 )) %>%  
                      # Move columns in data set
                      relocate(c(FIPS_st, FIPS_county, FIPS_tract, FIPS_tract2),.after = GEOID) %>%
                      # Create new GEOID column
                      mutate(GEOID = paste0(FIPS_st, FIPS_county, FIPS_tract2)) %>% 
                      # Drop newly created FIPS columns and margin of error
                      select(-FIPS_st, -FIPS_county, -FIPS_tract, -FIPS_tract2, -moe) %>% 
                      # Add suffix
                      mutate(variable = paste0(variable, "_19")) %>%
                      # Pivot data set
                      pivot_wider(
                        names_from = variable,
                        values_from = c(estimate)
                      ) 

census_pull19_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
Census Tract 201, Autauga County, Alabama
</td>
<td style="text-align:right;">
25970
</td>
<td style="text-align:right;">
136100
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
Census Tract 202, Autauga County, Alabama
</td>
<td style="text-align:right;">
20154
</td>
<td style="text-align:right;">
90500
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
Census Tract 203, Autauga County, Alabama
</td>
<td style="text-align:right;">
27383
</td>
<td style="text-align:right;">
122600
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
Census Tract 204, Autauga County, Alabama
</td>
<td style="text-align:right;">
34620
</td>
<td style="text-align:right;">
152700
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
Census Tract 205, Autauga County, Alabama
</td>
<td style="text-align:right;">
41178
</td>
<td style="text-align:right;">
186900
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
Census Tract 206, Autauga County, Alabama
</td>
<td style="text-align:right;">
21146
</td>
<td style="text-align:right;">
103600
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
Census Tract 207, Autauga County, Alabama
</td>
<td style="text-align:right;">
20934
</td>
<td style="text-align:right;">
82400
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020801
</td>
<td style="text-align:left;">
Census Tract 208.01, Autauga County, Alabama
</td>
<td style="text-align:right;">
31667
</td>
<td style="text-align:right;">
322900
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020802
</td>
<td style="text-align:left;">
Census Tract 208.02, Autauga County, Alabama
</td>
<td style="text-align:right;">
33086
</td>
<td style="text-align:right;">
171500
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020900
</td>
<td style="text-align:left;">
Census Tract 209, Autauga County, Alabama
</td>
<td style="text-align:right;">
32677
</td>
<td style="text-align:right;">
156900
</td>
</tr>
</tbody>
</table>

</div>

``` r
inflation_adj = 1.16

# Join 2010 and 2019 Median Income and Home Value Data
census_pull_df <- left_join(census_pull10_df, census_pull19_df[c("GEOID", "Median_Income_19", "Median_Home_Value_19")], join_by("GEOID" == "GEOID"))

# Create new inflation adjusted columns for 2010 median income and median home value, find changes over time
census_pull_df <- census_pull_df %>% 
                   mutate(Median_Income_10adj = Median_Income_10*inflation_adj,
                          Median_Home_Value_10adj = Median_Home_Value_10*inflation_adj,
                          Median_Income_Change = Median_Income_19 - Median_Income_10adj,
                          Median_Income_Change_pct = (Median_Income_19 - Median_Income_10adj)/Median_Income_10adj,
                          Median_Home_Value_Change = Median_Home_Value_19 - Median_Home_Value_10adj,
                          Median_Home_Value_Change_pct = (Median_Home_Value_19 - Median_Home_Value_10adj)/Median_Home_Value_10adj)

# View data
census_pull_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
<th style="text-align:right;">
Median_Income_10adj
</th>
<th style="text-align:right;">
Median_Home_Value_10adj
</th>
<th style="text-align:right;">
Median_Income_Change
</th>
<th style="text-align:right;">
Median_Income_Change_pct
</th>
<th style="text-align:right;">
Median_Home_Value_Change
</th>
<th style="text-align:right;">
Median_Home_Value_Change_pct
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
Census Tract 201, Autauga County, Alabama
</td>
<td style="text-align:right;">
31769
</td>
<td style="text-align:right;">
120700
</td>
<td style="text-align:right;">
25970
</td>
<td style="text-align:right;">
136100
</td>
<td style="text-align:right;">
36852.04
</td>
<td style="text-align:right;">
140012
</td>
<td style="text-align:right;">
-10882.04
</td>
<td style="text-align:right;">
-0.2952900
</td>
<td style="text-align:right;">
-3912
</td>
<td style="text-align:right;">
-0.0279405
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
Census Tract 202, Autauga County, Alabama
</td>
<td style="text-align:right;">
19437
</td>
<td style="text-align:right;">
138500
</td>
<td style="text-align:right;">
20154
</td>
<td style="text-align:right;">
90500
</td>
<td style="text-align:right;">
22546.92
</td>
<td style="text-align:right;">
160660
</td>
<td style="text-align:right;">
-2392.92
</td>
<td style="text-align:right;">
-0.1061307
</td>
<td style="text-align:right;">
-70160
</td>
<td style="text-align:right;">
-0.4366986
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
Census Tract 203, Autauga County, Alabama
</td>
<td style="text-align:right;">
24146
</td>
<td style="text-align:right;">
111300
</td>
<td style="text-align:right;">
27383
</td>
<td style="text-align:right;">
122600
</td>
<td style="text-align:right;">
28009.36
</td>
<td style="text-align:right;">
129108
</td>
<td style="text-align:right;">
-626.36
</td>
<td style="text-align:right;">
-0.0223625
</td>
<td style="text-align:right;">
-6508
</td>
<td style="text-align:right;">
-0.0504074
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
Census Tract 204, Autauga County, Alabama
</td>
<td style="text-align:right;">
27735
</td>
<td style="text-align:right;">
126300
</td>
<td style="text-align:right;">
34620
</td>
<td style="text-align:right;">
152700
</td>
<td style="text-align:right;">
32172.60
</td>
<td style="text-align:right;">
146508
</td>
<td style="text-align:right;">
2447.40
</td>
<td style="text-align:right;">
0.0760709
</td>
<td style="text-align:right;">
6192
</td>
<td style="text-align:right;">
0.0422639
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
Census Tract 205, Autauga County, Alabama
</td>
<td style="text-align:right;">
35517
</td>
<td style="text-align:right;">
173000
</td>
<td style="text-align:right;">
41178
</td>
<td style="text-align:right;">
186900
</td>
<td style="text-align:right;">
41199.72
</td>
<td style="text-align:right;">
200680
</td>
<td style="text-align:right;">
-21.72
</td>
<td style="text-align:right;">
-0.0005272
</td>
<td style="text-align:right;">
-13780
</td>
<td style="text-align:right;">
-0.0686665
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
Census Tract 206, Autauga County, Alabama
</td>
<td style="text-align:right;">
24597
</td>
<td style="text-align:right;">
110700
</td>
<td style="text-align:right;">
21146
</td>
<td style="text-align:right;">
103600
</td>
<td style="text-align:right;">
28532.52
</td>
<td style="text-align:right;">
128412
</td>
<td style="text-align:right;">
-7386.52
</td>
<td style="text-align:right;">
-0.2588807
</td>
<td style="text-align:right;">
-24812
</td>
<td style="text-align:right;">
-0.1932218
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
Census Tract 207, Autauga County, Alabama
</td>
<td style="text-align:right;">
22114
</td>
<td style="text-align:right;">
93800
</td>
<td style="text-align:right;">
20934
</td>
<td style="text-align:right;">
82400
</td>
<td style="text-align:right;">
25652.24
</td>
<td style="text-align:right;">
108808
</td>
<td style="text-align:right;">
-4718.24
</td>
<td style="text-align:right;">
-0.1839309
</td>
<td style="text-align:right;">
-26408
</td>
<td style="text-align:right;">
-0.2427027
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020801
</td>
<td style="text-align:left;">
Census Tract 208.01, Autauga County, Alabama
</td>
<td style="text-align:right;">
30841
</td>
<td style="text-align:right;">
258000
</td>
<td style="text-align:right;">
31667
</td>
<td style="text-align:right;">
322900
</td>
<td style="text-align:right;">
35775.56
</td>
<td style="text-align:right;">
299280
</td>
<td style="text-align:right;">
-4108.56
</td>
<td style="text-align:right;">
-0.1148426
</td>
<td style="text-align:right;">
23620
</td>
<td style="text-align:right;">
0.0789227
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020802
</td>
<td style="text-align:left;">
Census Tract 208.02, Autauga County, Alabama
</td>
<td style="text-align:right;">
29006
</td>
<td style="text-align:right;">
145100
</td>
<td style="text-align:right;">
33086
</td>
<td style="text-align:right;">
171500
</td>
<td style="text-align:right;">
33646.96
</td>
<td style="text-align:right;">
168316
</td>
<td style="text-align:right;">
-560.96
</td>
<td style="text-align:right;">
-0.0166719
</td>
<td style="text-align:right;">
3184
</td>
<td style="text-align:right;">
0.0189168
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020900
</td>
<td style="text-align:left;">
Census Tract 209, Autauga County, Alabama
</td>
<td style="text-align:right;">
24841
</td>
<td style="text-align:right;">
108000
</td>
<td style="text-align:right;">
32677
</td>
<td style="text-align:right;">
156900
</td>
<td style="text-align:right;">
28815.56
</td>
<td style="text-align:right;">
125280
</td>
<td style="text-align:right;">
3861.44
</td>
<td style="text-align:right;">
0.1340054
</td>
<td style="text-align:right;">
31620
</td>
<td style="text-align:right;">
0.2523946
</td>
</tr>
</tbody>
</table>

</div>

# NMTC Data

``` r
svi_divisional_nmtc_df0 <- left_join(svi_divisional_nmtc, census_pull_df, join_by("GEOID_2010_trt" == "GEOID"))

svi_divisional_nmtc_df1 <- left_join(svi_divisional_nmtc_df0, hpi_df_10_20, join_by("GEOID_2010_trt" == "GEOID10")) %>%
                          unite("county_fips", FIPS_st, FIPS_county, sep = "") 

svi_divisional_nmtc_df <- left_join(svi_divisional_nmtc_df1, msa_csa_crosswalk, join_by("county_fips" == "county_fips"))

svi_divisional_nmtc_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
county_fips
</th>
<th style="text-align:left;">
FIPS_tract
</th>
<th style="text-align:left;">
state
</th>
<th style="text-align:left;">
state_name
</th>
<th style="text-align:left;">
county
</th>
<th style="text-align:right;">
region_number
</th>
<th style="text-align:left;">
region
</th>
<th style="text-align:right;">
division_number
</th>
<th style="text-align:left;">
division
</th>
<th style="text-align:right;">
E_TOTPOP_10
</th>
<th style="text-align:right;">
E_HU_10
</th>
<th style="text-align:right;">
E_HH_10
</th>
<th style="text-align:right;">
E_POV150_10
</th>
<th style="text-align:right;">
ET_POVSTATUS_10
</th>
<th style="text-align:right;">
EP_POV150_10
</th>
<th style="text-align:right;">
EPL_POV150_10
</th>
<th style="text-align:right;">
F_POV150_10
</th>
<th style="text-align:right;">
E_UNEMP_10
</th>
<th style="text-align:right;">
ET_EMPSTATUS_10
</th>
<th style="text-align:right;">
EP_UNEMP_10
</th>
<th style="text-align:right;">
EPL_UNEMP_10
</th>
<th style="text-align:right;">
F_UNEMP_10
</th>
<th style="text-align:right;">
E_HBURD_OWN_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_10
</th>
<th style="text-align:right;">
EP_HBURD_OWN_10
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_10
</th>
<th style="text-align:right;">
F_HBURD_OWN_10
</th>
<th style="text-align:right;">
E_HBURD_RENT_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_10
</th>
<th style="text-align:right;">
EP_HBURD_RENT_10
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_10
</th>
<th style="text-align:right;">
F_HBURD_RENT_10
</th>
<th style="text-align:right;">
E_HBURD_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_10
</th>
<th style="text-align:right;">
EP_HBURD_10
</th>
<th style="text-align:right;">
EPL_HBURD_10
</th>
<th style="text-align:right;">
F_HBURD_10
</th>
<th style="text-align:right;">
E_NOHSDP_10
</th>
<th style="text-align:right;">
ET_EDSTATUS_10
</th>
<th style="text-align:right;">
EP_NOHSDP_10
</th>
<th style="text-align:right;">
EPL_NOHSDP_10
</th>
<th style="text-align:right;">
F_NOHSDP_10
</th>
<th style="text-align:right;">
E_UNINSUR_12
</th>
<th style="text-align:right;">
ET_INSURSTATUS_12
</th>
<th style="text-align:right;">
EP_UNINSUR_12
</th>
<th style="text-align:right;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
F_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
F_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:right;">
EPL_AGE17_10
</th>
<th style="text-align:right;">
F_AGE17_10
</th>
<th style="text-align:right;">
E_DISABL_12
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_12
</th>
<th style="text-align:right;">
EP_DISABL_12
</th>
<th style="text-align:right;">
EPL_DISABL_12
</th>
<th style="text-align:right;">
F_DISABL_12
</th>
<th style="text-align:right;">
E_SNGPNT_10
</th>
<th style="text-align:right;">
ET_FAMILIES_10
</th>
<th style="text-align:right;">
EP_SNGPNT_10
</th>
<th style="text-align:right;">
EPL_SNGPNT_10
</th>
<th style="text-align:right;">
F_SNGPNT_10
</th>
<th style="text-align:right;">
E_LIMENG_10
</th>
<th style="text-align:right;">
ET_POPAGE5UP_10
</th>
<th style="text-align:right;">
EP_LIMENG_10
</th>
<th style="text-align:right;">
EPL_LIMENG_10
</th>
<th style="text-align:right;">
F_LIMENG_10
</th>
<th style="text-align:right;">
E_MINRTY_10
</th>
<th style="text-align:right;">
ET_POPETHRACE_10
</th>
<th style="text-align:right;">
EP_MINRTY_10
</th>
<th style="text-align:right;">
EPL_MINRTY_10
</th>
<th style="text-align:right;">
F_MINRTY_10
</th>
<th style="text-align:right;">
E_STRHU_10
</th>
<th style="text-align:right;">
E_MUNIT_10
</th>
<th style="text-align:right;">
EP_MUNIT_10
</th>
<th style="text-align:right;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
F_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
</th>
<th style="text-align:right;">
F_MOBILE_10
</th>
<th style="text-align:right;">
E_CROWD_10
</th>
<th style="text-align:right;">
ET_OCCUPANTS_10
</th>
<th style="text-align:right;">
EP_CROWD_10
</th>
<th style="text-align:right;">
EPL_CROWD_10
</th>
<th style="text-align:right;">
F_CROWD_10
</th>
<th style="text-align:right;">
E_NOVEH_10
</th>
<th style="text-align:right;">
ET_KNOWNVEH_10
</th>
<th style="text-align:right;">
EP_NOVEH_10
</th>
<th style="text-align:right;">
EPL_NOVEH_10
</th>
<th style="text-align:right;">
F_NOVEH_10
</th>
<th style="text-align:right;">
E_GROUPQ_10
</th>
<th style="text-align:right;">
ET_HHTYPE_10
</th>
<th style="text-align:right;">
EP_GROUPQ_10
</th>
<th style="text-align:right;">
EPL_GROUPQ_10
</th>
<th style="text-align:right;">
F_GROUPQ_10
</th>
<th style="text-align:right;">
SPL_THEME1_10
</th>
<th style="text-align:right;">
RPL_THEME1_10
</th>
<th style="text-align:right;">
F_THEME1_10
</th>
<th style="text-align:right;">
SPL_THEME2_10
</th>
<th style="text-align:right;">
RPL_THEME2_10
</th>
<th style="text-align:right;">
F_THEME2_10
</th>
<th style="text-align:right;">
SPL_THEME3_10
</th>
<th style="text-align:right;">
RPL_THEME3_10
</th>
<th style="text-align:right;">
F_THEME3_10
</th>
<th style="text-align:right;">
SPL_THEME4_10
</th>
<th style="text-align:right;">
RPL_THEME4_10
</th>
<th style="text-align:right;">
F_THEME4_10
</th>
<th style="text-align:right;">
SPL_THEMES_10
</th>
<th style="text-align:right;">
RPL_THEMES_10
</th>
<th style="text-align:right;">
F_TOTAL_10
</th>
<th style="text-align:right;">
E_TOTPOP_20
</th>
<th style="text-align:right;">
E_HU_20
</th>
<th style="text-align:right;">
E_HH_20
</th>
<th style="text-align:right;">
E_POV150_20
</th>
<th style="text-align:right;">
ET_POVSTATUS_20
</th>
<th style="text-align:right;">
EP_POV150_20
</th>
<th style="text-align:right;">
EPL_POV150_20
</th>
<th style="text-align:right;">
F_POV150_20
</th>
<th style="text-align:right;">
E_UNEMP_20
</th>
<th style="text-align:right;">
ET_EMPSTATUS_20
</th>
<th style="text-align:right;">
EP_UNEMP_20
</th>
<th style="text-align:right;">
EPL_UNEMP_20
</th>
<th style="text-align:right;">
F_UNEMP_20
</th>
<th style="text-align:right;">
E_HBURD_OWN_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_20
</th>
<th style="text-align:right;">
EP_HBURD_OWN_20
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_20
</th>
<th style="text-align:right;">
F_HBURD_OWN_20
</th>
<th style="text-align:right;">
E_HBURD_RENT_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_20
</th>
<th style="text-align:right;">
EP_HBURD_RENT_20
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_20
</th>
<th style="text-align:right;">
F_HBURD_RENT_20
</th>
<th style="text-align:right;">
E_HBURD_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_20
</th>
<th style="text-align:right;">
EP_HBURD_20
</th>
<th style="text-align:right;">
EPL_HBURD_20
</th>
<th style="text-align:right;">
F_HBURD_20
</th>
<th style="text-align:right;">
E_NOHSDP_20
</th>
<th style="text-align:right;">
ET_EDSTATUS_20
</th>
<th style="text-align:right;">
EP_NOHSDP_20
</th>
<th style="text-align:right;">
EPL_NOHSDP_20
</th>
<th style="text-align:right;">
F_NOHSDP_20
</th>
<th style="text-align:right;">
E_UNINSUR_20
</th>
<th style="text-align:right;">
ET_INSURSTATUS_20
</th>
<th style="text-align:right;">
EP_UNINSUR_20
</th>
<th style="text-align:right;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
F_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
F_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:right;">
EPL_AGE17_20
</th>
<th style="text-align:right;">
F_AGE17_20
</th>
<th style="text-align:right;">
E_DISABL_20
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_20
</th>
<th style="text-align:right;">
EP_DISABL_20
</th>
<th style="text-align:right;">
EPL_DISABL_20
</th>
<th style="text-align:right;">
F_DISABL_20
</th>
<th style="text-align:right;">
E_SNGPNT_20
</th>
<th style="text-align:right;">
ET_FAMILIES_20
</th>
<th style="text-align:right;">
EP_SNGPNT_20
</th>
<th style="text-align:right;">
EPL_SNGPNT_20
</th>
<th style="text-align:right;">
F_SNGPNT_20
</th>
<th style="text-align:right;">
E_LIMENG_20
</th>
<th style="text-align:right;">
ET_POPAGE5UP_20
</th>
<th style="text-align:right;">
EP_LIMENG_20
</th>
<th style="text-align:right;">
EPL_LIMENG_20
</th>
<th style="text-align:right;">
F_LIMENG_20
</th>
<th style="text-align:right;">
E_MINRTY_20
</th>
<th style="text-align:right;">
ET_POPETHRACE_20
</th>
<th style="text-align:right;">
EP_MINRTY_20
</th>
<th style="text-align:right;">
EPL_MINRTY_20
</th>
<th style="text-align:right;">
F_MINRTY_20
</th>
<th style="text-align:right;">
E_STRHU_20
</th>
<th style="text-align:right;">
E_MUNIT_20
</th>
<th style="text-align:right;">
EP_MUNIT_20
</th>
<th style="text-align:right;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
F_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
</th>
<th style="text-align:right;">
F_MOBILE_20
</th>
<th style="text-align:right;">
E_CROWD_20
</th>
<th style="text-align:right;">
ET_OCCUPANTS_20
</th>
<th style="text-align:right;">
EP_CROWD_20
</th>
<th style="text-align:right;">
EPL_CROWD_20
</th>
<th style="text-align:right;">
F_CROWD_20
</th>
<th style="text-align:right;">
E_NOVEH_20
</th>
<th style="text-align:right;">
ET_KNOWNVEH_20
</th>
<th style="text-align:right;">
EP_NOVEH_20
</th>
<th style="text-align:right;">
EPL_NOVEH_20
</th>
<th style="text-align:right;">
F_NOVEH_20
</th>
<th style="text-align:right;">
E_GROUPQ_20
</th>
<th style="text-align:right;">
ET_HHTYPE_20
</th>
<th style="text-align:right;">
EP_GROUPQ_20
</th>
<th style="text-align:right;">
EPL_GROUPQ_20
</th>
<th style="text-align:right;">
F_GROUPQ_20
</th>
<th style="text-align:right;">
SPL_THEME1_20
</th>
<th style="text-align:right;">
RPL_THEME1_20
</th>
<th style="text-align:right;">
F_THEME1_20
</th>
<th style="text-align:right;">
SPL_THEME2_20
</th>
<th style="text-align:right;">
RPL_THEME2_20
</th>
<th style="text-align:right;">
F_THEME2_20
</th>
<th style="text-align:right;">
SPL_THEME3_20
</th>
<th style="text-align:right;">
RPL_THEME3_20
</th>
<th style="text-align:right;">
F_THEME3_20
</th>
<th style="text-align:right;">
SPL_THEME4_20
</th>
<th style="text-align:right;">
RPL_THEME4_20
</th>
<th style="text-align:right;">
F_THEME4_20
</th>
<th style="text-align:right;">
SPL_THEMES_20
</th>
<th style="text-align:right;">
RPL_THEMES_20
</th>
<th style="text-align:right;">
F_TOTAL_20
</th>
<th style="text-align:left;">
nmtc_eligibility
</th>
<th style="text-align:right;">
pre10_nmtc_project_cnt
</th>
<th style="text-align:right;">
pre10_nmtc_dollars
</th>
<th style="text-align:left;">
pre10_nmtc_dollars_formatted
</th>
<th style="text-align:right;">
post10_nmtc_project_cnt
</th>
<th style="text-align:right;">
post10_nmtc_dollars
</th>
<th style="text-align:left;">
post10_nmtc_dollars_formatted
</th>
<th style="text-align:right;">
nmtc_flag
</th>
<th style="text-align:left;">
NAME
</th>
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
<th style="text-align:right;">
Median_Income_10adj
</th>
<th style="text-align:right;">
Median_Home_Value_10adj
</th>
<th style="text-align:right;">
Median_Income_Change
</th>
<th style="text-align:right;">
Median_Income_Change_pct
</th>
<th style="text-align:right;">
Median_Home_Value_Change
</th>
<th style="text-align:right;">
Median_Home_Value_Change_pct
</th>
<th style="text-align:right;">
housing_price_index10
</th>
<th style="text-align:right;">
housing_price_index20
</th>
<th style="text-align:left;">
county_title
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:left;">
cbsa_code
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
10001040201
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
040201
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
5208
</td>
<td style="text-align:right;">
1953
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
850
</td>
<td style="text-align:right;">
5183
</td>
<td style="text-align:right;">
16.399769
</td>
<td style="text-align:right;">
0.3672
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
2550
</td>
<td style="text-align:right;">
5.764706
</td>
<td style="text-align:right;">
0.3364
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
29.10053
</td>
<td style="text-align:right;">
0.45810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
486
</td>
<td style="text-align:right;">
45.67901
</td>
<td style="text-align:right;">
0.49650
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
33.55445
</td>
<td style="text-align:right;">
0.4431
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
459
</td>
<td style="text-align:right;">
3090
</td>
<td style="text-align:right;">
14.8543689
</td>
<td style="text-align:right;">
0.5386
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
435
</td>
<td style="text-align:right;">
5283
</td>
<td style="text-align:right;">
8.233958
</td>
<td style="text-align:right;">
0.19610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
8.717358
</td>
<td style="text-align:right;">
0.256100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1588
</td>
<td style="text-align:right;">
30.491551
</td>
<td style="text-align:right;">
0.8927
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
537
</td>
<td style="text-align:right;">
3716
</td>
<td style="text-align:right;">
14.451023
</td>
<td style="text-align:right;">
0.4708
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
417
</td>
<td style="text-align:right;">
1343
</td>
<td style="text-align:right;">
31.04989
</td>
<td style="text-align:right;">
0.8599
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
4835
</td>
<td style="text-align:right;">
1.427094
</td>
<td style="text-align:right;">
0.5240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1881
</td>
<td style="text-align:right;">
5208
</td>
<td style="text-align:right;">
36.117511
</td>
<td style="text-align:right;">
0.56890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1953
</td>
<td style="text-align:right;">
87
</td>
<td style="text-align:right;">
4.454685
</td>
<td style="text-align:right;">
0.5392
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
7.578085
</td>
<td style="text-align:right;">
0.6495
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
2.1558872
</td>
<td style="text-align:right;">
0.6471
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
6.688778
</td>
<td style="text-align:right;">
0.6124
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5208
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.88140
</td>
<td style="text-align:right;">
0.3053
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.003500
</td>
<td style="text-align:right;">
0.7667
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.56890
</td>
<td style="text-align:right;">
0.56140
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.8296
</td>
<td style="text-align:right;">
0.6516
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8.283400
</td>
<td style="text-align:right;">
0.5452
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
4770
</td>
<td style="text-align:right;">
1906
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
755
</td>
<td style="text-align:right;">
4692
</td>
<td style="text-align:right;">
16.09122
</td>
<td style="text-align:right;">
0.3758
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
2500
</td>
<td style="text-align:right;">
3.680000
</td>
<td style="text-align:right;">
0.3633
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
1184
</td>
<td style="text-align:right;">
16.638513
</td>
<td style="text-align:right;">
0.280400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
235
</td>
<td style="text-align:right;">
548
</td>
<td style="text-align:right;">
42.88321
</td>
<td style="text-align:right;">
0.46090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
432
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
24.94226
</td>
<td style="text-align:right;">
0.36220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
3100
</td>
<td style="text-align:right;">
8.096774
</td>
<td style="text-align:right;">
0.4085
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
4770
</td>
<td style="text-align:right;">
4.779874
</td>
<td style="text-align:right;">
0.21160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
11.509434
</td>
<td style="text-align:right;">
0.23290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1352
</td>
<td style="text-align:right;">
28.343816
</td>
<td style="text-align:right;">
0.88650
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
3418.125
</td>
<td style="text-align:right;">
14.335346
</td>
<td style="text-align:right;">
0.4309
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
1263.2064
</td>
<td style="text-align:right;">
25.965669
</td>
<td style="text-align:right;">
0.8111
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4526
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09987
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1875
</td>
<td style="text-align:right;">
4769.908
</td>
<td style="text-align:right;">
39.30893
</td>
<td style="text-align:right;">
0.5372
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1906
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
3.7775446
</td>
<td style="text-align:right;">
0.4876
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
6.7156348
</td>
<td style="text-align:right;">
0.6610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
0.5773672
</td>
<td style="text-align:right;">
0.3165
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
1731.7111
</td>
<td style="text-align:right;">
1.847883
</td>
<td style="text-align:right;">
0.2303
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4770
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2111
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.72140
</td>
<td style="text-align:right;">
0.2531
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.46127
</td>
<td style="text-align:right;">
0.45940
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.5372
</td>
<td style="text-align:right;">
0.5306
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.9065
</td>
<td style="text-align:right;">
0.2183
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6.62637
</td>
<td style="text-align:right;">
0.2829
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 402.01, Kent County, Delaware
</td>
<td style="text-align:right;">
29025
</td>
<td style="text-align:right;">
209100
</td>
<td style="text-align:right;">
32593
</td>
<td style="text-align:right;">
191200
</td>
<td style="text-align:right;">
33669.00
</td>
<td style="text-align:right;">
242556
</td>
<td style="text-align:right;">
-1076.00
</td>
<td style="text-align:right;">
-0.0319582
</td>
<td style="text-align:right;">
-51356
</td>
<td style="text-align:right;">
-0.2117284
</td>
<td style="text-align:right;">
172.23
</td>
<td style="text-align:right;">
224.88
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001040502
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
040502
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
2087
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
192
</td>
<td style="text-align:right;">
2087
</td>
<td style="text-align:right;">
9.199808
</td>
<td style="text-align:right;">
0.1738
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
722
</td>
<td style="text-align:right;">
4.847645
</td>
<td style="text-align:right;">
0.2495
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
281
</td>
<td style="text-align:right;">
700
</td>
<td style="text-align:right;">
40.14286
</td>
<td style="text-align:right;">
0.78190
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
28.95928
</td>
<td style="text-align:right;">
0.17110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
345
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
37.45928
</td>
<td style="text-align:right;">
0.5710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
1546
</td>
<td style="text-align:right;">
18.3699871
</td>
<td style="text-align:right;">
0.6484
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
119
</td>
<td style="text-align:right;">
2121
</td>
<td style="text-align:right;">
5.610561
</td>
<td style="text-align:right;">
0.10710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
518
</td>
<td style="text-align:right;">
24.820316
</td>
<td style="text-align:right;">
0.906800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
480
</td>
<td style="text-align:right;">
22.999521
</td>
<td style="text-align:right;">
0.4910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
1527
</td>
<td style="text-align:right;">
21.480026
</td>
<td style="text-align:right;">
0.7959
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
680
</td>
<td style="text-align:right;">
25.44118
</td>
<td style="text-align:right;">
0.7769
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
1998
</td>
<td style="text-align:right;">
5.005005
</td>
<td style="text-align:right;">
0.7960
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
2087
</td>
<td style="text-align:right;">
26.832774
</td>
<td style="text-align:right;">
0.45240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1428
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
29.641694
</td>
<td style="text-align:right;">
0.8785
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
921
</td>
<td style="text-align:right;">
3.257329
</td>
<td style="text-align:right;">
0.3600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2087
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.74980
</td>
<td style="text-align:right;">
0.2670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.766600
</td>
<td style="text-align:right;">
0.9666
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.45240
</td>
<td style="text-align:right;">
0.44640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.9115
</td>
<td style="text-align:right;">
0.2071
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.880300
</td>
<td style="text-align:right;">
0.4785
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2555
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
565
</td>
<td style="text-align:right;">
2555
</td>
<td style="text-align:right;">
22.11350
</td>
<td style="text-align:right;">
0.5385
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
1154
</td>
<td style="text-align:right;">
11.698440
</td>
<td style="text-align:right;">
0.9175
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
691
</td>
<td style="text-align:right;">
20.839363
</td>
<td style="text-align:right;">
0.486500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
262
</td>
<td style="text-align:right;">
64.12214
</td>
<td style="text-align:right;">
0.88940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
953
</td>
<td style="text-align:right;">
32.73872
</td>
<td style="text-align:right;">
0.62590
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
192
</td>
<td style="text-align:right;">
1782
</td>
<td style="text-align:right;">
10.774411
</td>
<td style="text-align:right;">
0.5377
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
198
</td>
<td style="text-align:right;">
2519
</td>
<td style="text-align:right;">
7.860262
</td>
<td style="text-align:right;">
0.40160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
519
</td>
<td style="text-align:right;">
20.313112
</td>
<td style="text-align:right;">
0.68510
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
664
</td>
<td style="text-align:right;">
25.988258
</td>
<td style="text-align:right;">
0.79390
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
1854.295
</td>
<td style="text-align:right;">
18.389741
</td>
<td style="text-align:right;">
0.6427
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
195
</td>
<td style="text-align:right;">
614.6519
</td>
<td style="text-align:right;">
31.725274
</td>
<td style="text-align:right;">
0.8870
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
2351
</td>
<td style="text-align:right;">
3.1901319
</td>
<td style="text-align:right;">
0.72360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1215
</td>
<td style="text-align:right;">
2555.353
</td>
<td style="text-align:right;">
47.54725
</td>
<td style="text-align:right;">
0.6272
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
5.9223301
</td>
<td style="text-align:right;">
0.5514
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
170
</td>
<td style="text-align:right;">
16.5048544
</td>
<td style="text-align:right;">
0.7844
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
6.0796646
</td>
<td style="text-align:right;">
0.8947
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
953.5886
</td>
<td style="text-align:right;">
8.703963
</td>
<td style="text-align:right;">
0.7220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2555
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2111
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.02120
</td>
<td style="text-align:right;">
0.6565
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.73230
</td>
<td style="text-align:right;">
0.96800
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6272
</td>
<td style="text-align:right;">
0.6195
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.1636
</td>
<td style="text-align:right;">
0.7893
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.54430
</td>
<td style="text-align:right;">
0.8433
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 405.02, Kent County, Delaware
</td>
<td style="text-align:right;">
31789
</td>
<td style="text-align:right;">
168400
</td>
<td style="text-align:right;">
31074
</td>
<td style="text-align:right;">
157700
</td>
<td style="text-align:right;">
36875.24
</td>
<td style="text-align:right;">
195344
</td>
<td style="text-align:right;">
-5801.24
</td>
<td style="text-align:right;">
-0.1573207
</td>
<td style="text-align:right;">
-37644
</td>
<td style="text-align:right;">
-0.1927062
</td>
<td style="text-align:right;">
143.93
</td>
<td style="text-align:right;">
162.18
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001040900
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
040900
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
2363
</td>
<td style="text-align:right;">
1205
</td>
<td style="text-align:right;">
1007
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
30.212522
</td>
<td style="text-align:right;">
0.7006
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
1089
</td>
<td style="text-align:right;">
15.702479
</td>
<td style="text-align:right;">
0.9032
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
27.07182
</td>
<td style="text-align:right;">
0.37770
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
258
</td>
<td style="text-align:right;">
645
</td>
<td style="text-align:right;">
40.00000
</td>
<td style="text-align:right;">
0.36590
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
356
</td>
<td style="text-align:right;">
1007
</td>
<td style="text-align:right;">
35.35253
</td>
<td style="text-align:right;">
0.5041
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
248
</td>
<td style="text-align:right;">
1416
</td>
<td style="text-align:right;">
17.5141243
</td>
<td style="text-align:right;">
0.6235
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
2479
</td>
<td style="text-align:right;">
4.759984
</td>
<td style="text-align:right;">
0.08169
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
509
</td>
<td style="text-align:right;">
21.540415
</td>
<td style="text-align:right;">
0.863300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
7.109606
</td>
<td style="text-align:right;">
0.0386
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
428
</td>
<td style="text-align:right;">
1427
</td>
<td style="text-align:right;">
29.992992
</td>
<td style="text-align:right;">
0.9611
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
387
</td>
<td style="text-align:right;">
11.36951
</td>
<td style="text-align:right;">
0.3400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
2349
</td>
<td style="text-align:right;">
2.128565
</td>
<td style="text-align:right;">
0.6157
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
2363
</td>
<td style="text-align:right;">
30.765975
</td>
<td style="text-align:right;">
0.50480
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1205
</td>
<td style="text-align:right;">
378
</td>
<td style="text-align:right;">
31.369295
</td>
<td style="text-align:right;">
0.8688
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1007
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
256
</td>
<td style="text-align:right;">
1007
</td>
<td style="text-align:right;">
25.422046
</td>
<td style="text-align:right;">
0.9457
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
622
</td>
<td style="text-align:right;">
2363
</td>
<td style="text-align:right;">
26.3224714
</td>
<td style="text-align:right;">
0.9741
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.81309
</td>
<td style="text-align:right;">
0.5851
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.818700
</td>
<td style="text-align:right;">
0.6717
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.50480
</td>
<td style="text-align:right;">
0.49810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.1183
</td>
<td style="text-align:right;">
0.7840
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.254890
</td>
<td style="text-align:right;">
0.6833
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
2373
</td>
<td style="text-align:right;">
1114
</td>
<td style="text-align:right;">
1028
</td>
<td style="text-align:right;">
574
</td>
<td style="text-align:right;">
1679
</td>
<td style="text-align:right;">
34.18702
</td>
<td style="text-align:right;">
0.7904
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
1034
</td>
<td style="text-align:right;">
1.837524
</td>
<td style="text-align:right;">
0.1211
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
8.306709
</td>
<td style="text-align:right;">
0.029920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
335
</td>
<td style="text-align:right;">
715
</td>
<td style="text-align:right;">
46.85315
</td>
<td style="text-align:right;">
0.55400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
361
</td>
<td style="text-align:right;">
1028
</td>
<td style="text-align:right;">
35.11673
</td>
<td style="text-align:right;">
0.69080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
1292
</td>
<td style="text-align:right;">
17.337461
</td>
<td style="text-align:right;">
0.7807
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
2250
</td>
<td style="text-align:right;">
3.466667
</td>
<td style="text-align:right;">
0.13250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
501
</td>
<td style="text-align:right;">
21.112516
</td>
<td style="text-align:right;">
0.71690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
208
</td>
<td style="text-align:right;">
8.765276
</td>
<td style="text-align:right;">
0.05851
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1505.000
</td>
<td style="text-align:right;">
25.980066
</td>
<td style="text-align:right;">
0.9018
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
220.0000
</td>
<td style="text-align:right;">
13.181818
</td>
<td style="text-align:right;">
0.4476
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
2268
</td>
<td style="text-align:right;">
0.3086420
</td>
<td style="text-align:right;">
0.28740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
974
</td>
<td style="text-align:right;">
2373.000
</td>
<td style="text-align:right;">
41.04509
</td>
<td style="text-align:right;">
0.5571
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1114
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
42.7289048
</td>
<td style="text-align:right;">
0.9104
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
1028
</td>
<td style="text-align:right;">
0.4863813
</td>
<td style="text-align:right;">
0.2927
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
248
</td>
<td style="text-align:right;">
1028.0000
</td>
<td style="text-align:right;">
24.124514
</td>
<td style="text-align:right;">
0.9466
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
678
</td>
<td style="text-align:right;">
2373
</td>
<td style="text-align:right;">
28.5714286
</td>
<td style="text-align:right;">
0.9778
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.51550
</td>
<td style="text-align:right;">
0.4976
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.41221
</td>
<td style="text-align:right;">
0.42860
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5571
</td>
<td style="text-align:right;">
0.5503
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.3075
</td>
<td style="text-align:right;">
0.8411
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
8.79231
</td>
<td style="text-align:right;">
0.6264
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 409, Kent County, Delaware
</td>
<td style="text-align:right;">
13641
</td>
<td style="text-align:right;">
218000
</td>
<td style="text-align:right;">
13618
</td>
<td style="text-align:right;">
240500
</td>
<td style="text-align:right;">
15823.56
</td>
<td style="text-align:right;">
252880
</td>
<td style="text-align:right;">
-2205.56
</td>
<td style="text-align:right;">
-0.1393846
</td>
<td style="text-align:right;">
-12380
</td>
<td style="text-align:right;">
-0.0489560
</td>
<td style="text-align:right;">
199.51
</td>
<td style="text-align:right;">
191.02
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041000
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041000
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
5577
</td>
<td style="text-align:right;">
2570
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
1291
</td>
<td style="text-align:right;">
5577
</td>
<td style="text-align:right;">
23.148646
</td>
<td style="text-align:right;">
0.5435
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
2702
</td>
<td style="text-align:right;">
5.329386
</td>
<td style="text-align:right;">
0.2938
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
1312
</td>
<td style="text-align:right;">
35.67073
</td>
<td style="text-align:right;">
0.67500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
1057
</td>
<td style="text-align:right;">
12.77200
</td>
<td style="text-align:right;">
0.04274
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
603
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
25.45378
</td>
<td style="text-align:right;">
0.1769
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
3504
</td>
<td style="text-align:right;">
21.6609589
</td>
<td style="text-align:right;">
0.7311
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
655
</td>
<td style="text-align:right;">
5999
</td>
<td style="text-align:right;">
10.918486
</td>
<td style="text-align:right;">
0.29800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
594
</td>
<td style="text-align:right;">
10.650888
</td>
<td style="text-align:right;">
0.371200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1487
</td>
<td style="text-align:right;">
26.663080
</td>
<td style="text-align:right;">
0.7247
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
683
</td>
<td style="text-align:right;">
4587
</td>
<td style="text-align:right;">
14.889906
</td>
<td style="text-align:right;">
0.4947
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
1466
</td>
<td style="text-align:right;">
24.82947
</td>
<td style="text-align:right;">
0.7646
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
5105
</td>
<td style="text-align:right;">
3.682664
</td>
<td style="text-align:right;">
0.7342
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3384
</td>
<td style="text-align:right;">
5577
</td>
<td style="text-align:right;">
60.677784
</td>
<td style="text-align:right;">
0.77850
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2570
</td>
<td style="text-align:right;">
479
</td>
<td style="text-align:right;">
18.638132
</td>
<td style="text-align:right;">
0.7741
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
22.062257
</td>
<td style="text-align:right;">
0.8159
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
3.8412832
</td>
<td style="text-align:right;">
0.8132
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
9.328831
</td>
<td style="text-align:right;">
0.7266
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
5577
</td>
<td style="text-align:right;">
0.1613771
</td>
<td style="text-align:right;">
0.7632
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.04330
</td>
<td style="text-align:right;">
0.3511
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.089400
</td>
<td style="text-align:right;">
0.8041
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.77850
</td>
<td style="text-align:right;">
0.76820
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.8930
</td>
<td style="text-align:right;">
0.9705
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
9.804200
</td>
<td style="text-align:right;">
0.7522
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
6719
</td>
<td style="text-align:right;">
3107
</td>
<td style="text-align:right;">
2804
</td>
<td style="text-align:right;">
2006
</td>
<td style="text-align:right;">
6656
</td>
<td style="text-align:right;">
30.13822
</td>
<td style="text-align:right;">
0.7207
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
436
</td>
<td style="text-align:right;">
3058
</td>
<td style="text-align:right;">
14.257685
</td>
<td style="text-align:right;">
0.9556
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
299
</td>
<td style="text-align:right;">
1387
</td>
<td style="text-align:right;">
21.557318
</td>
<td style="text-align:right;">
0.521400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
1417
</td>
<td style="text-align:right;">
41.14326
</td>
<td style="text-align:right;">
0.42160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
882
</td>
<td style="text-align:right;">
2804
</td>
<td style="text-align:right;">
31.45506
</td>
<td style="text-align:right;">
0.58610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
953
</td>
<td style="text-align:right;">
4915
</td>
<td style="text-align:right;">
19.389624
</td>
<td style="text-align:right;">
0.8333
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
509
</td>
<td style="text-align:right;">
6603
</td>
<td style="text-align:right;">
7.708617
</td>
<td style="text-align:right;">
0.39290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
18.172347
</td>
<td style="text-align:right;">
0.58640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1389
</td>
<td style="text-align:right;">
20.672719
</td>
<td style="text-align:right;">
0.47220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1393
</td>
<td style="text-align:right;">
5214.000
</td>
<td style="text-align:right;">
26.716532
</td>
<td style="text-align:right;">
0.9150
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
661
</td>
<td style="text-align:right;">
1752.0000
</td>
<td style="text-align:right;">
37.728310
</td>
<td style="text-align:right;">
0.9336
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
340
</td>
<td style="text-align:right;">
6411
</td>
<td style="text-align:right;">
5.3033848
</td>
<td style="text-align:right;">
0.82180
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4068
</td>
<td style="text-align:right;">
6719.048
</td>
<td style="text-align:right;">
60.54429
</td>
<td style="text-align:right;">
0.7409
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3107
</td>
<td style="text-align:right;">
469
</td>
<td style="text-align:right;">
15.0949469
</td>
<td style="text-align:right;">
0.7136
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
586
</td>
<td style="text-align:right;">
18.8606373
</td>
<td style="text-align:right;">
0.8099
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
2804
</td>
<td style="text-align:right;">
1.9258203
</td>
<td style="text-align:right;">
0.5840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
253
</td>
<td style="text-align:right;">
2804.0000
</td>
<td style="text-align:right;">
9.022825
</td>
<td style="text-align:right;">
0.7342
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
6719
</td>
<td style="text-align:right;">
1.0418217
</td>
<td style="text-align:right;">
0.7345
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.48860
</td>
<td style="text-align:right;">
0.7870
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.72900
</td>
<td style="text-align:right;">
0.96760
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.7409
</td>
<td style="text-align:right;">
0.7319
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.5762
</td>
<td style="text-align:right;">
0.9178
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
11.53470
</td>
<td style="text-align:right;">
0.9313
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 410, Kent County, Delaware
</td>
<td style="text-align:right;">
32000
</td>
<td style="text-align:right;">
147800
</td>
<td style="text-align:right;">
30625
</td>
<td style="text-align:right;">
135400
</td>
<td style="text-align:right;">
37120.00
</td>
<td style="text-align:right;">
171448
</td>
<td style="text-align:right;">
-6495.00
</td>
<td style="text-align:right;">
-0.1749731
</td>
<td style="text-align:right;">
-36048
</td>
<td style="text-align:right;">
-0.2102562
</td>
<td style="text-align:right;">
168.61
</td>
<td style="text-align:right;">
200.50
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041100
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041100
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
2957
</td>
<td style="text-align:right;">
800
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
499
</td>
<td style="text-align:right;">
2555
</td>
<td style="text-align:right;">
19.530333
</td>
<td style="text-align:right;">
0.4511
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
845
</td>
<td style="text-align:right;">
5.207101
</td>
<td style="text-align:right;">
0.2813
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.00257
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
395
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
54.10959
</td>
<td style="text-align:right;">
0.69280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
395
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
53.52304
</td>
<td style="text-align:right;">
0.9155
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1118
</td>
<td style="text-align:right;">
0.9838998
</td>
<td style="text-align:right;">
0.0213
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
2559
</td>
<td style="text-align:right;">
2.540055
</td>
<td style="text-align:right;">
0.02694
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.003549
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1198
</td>
<td style="text-align:right;">
40.514035
</td>
<td style="text-align:right;">
0.9944
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
1192
</td>
<td style="text-align:right;">
9.815436
</td>
<td style="text-align:right;">
0.2221
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
133
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
19.19192
</td>
<td style="text-align:right;">
0.6322
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
2551
</td>
<td style="text-align:right;">
1.646413
</td>
<td style="text-align:right;">
0.5567
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
720
</td>
<td style="text-align:right;">
2957
</td>
<td style="text-align:right;">
24.349002
</td>
<td style="text-align:right;">
0.41770
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1428
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
1.355014
</td>
<td style="text-align:right;">
0.1640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
402
</td>
<td style="text-align:right;">
2957
</td>
<td style="text-align:right;">
13.5948597
</td>
<td style="text-align:right;">
0.9492
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.69614
</td>
<td style="text-align:right;">
0.2527
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.408949
</td>
<td style="text-align:right;">
0.4377
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.41770
</td>
<td style="text-align:right;">
0.41220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.5857
</td>
<td style="text-align:right;">
0.1097
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.108489
</td>
<td style="text-align:right;">
0.2207
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3881
</td>
<td style="text-align:right;">
1350
</td>
<td style="text-align:right;">
1322
</td>
<td style="text-align:right;">
1031
</td>
<td style="text-align:right;">
3618
</td>
<td style="text-align:right;">
28.49641
</td>
<td style="text-align:right;">
0.6874
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
877
</td>
<td style="text-align:right;">
6.613455
</td>
<td style="text-align:right;">
0.6891
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.002567
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
758
</td>
<td style="text-align:right;">
1319
</td>
<td style="text-align:right;">
57.46778
</td>
<td style="text-align:right;">
0.78900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
758
</td>
<td style="text-align:right;">
1322
</td>
<td style="text-align:right;">
57.33737
</td>
<td style="text-align:right;">
0.97720
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
1801
</td>
<td style="text-align:right;">
2.276513
</td>
<td style="text-align:right;">
0.0857
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
2762
</td>
<td style="text-align:right;">
1.194786
</td>
<td style="text-align:right;">
0.02847
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
1.649059
</td>
<td style="text-align:right;">
0.01027
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1291
</td>
<td style="text-align:right;">
33.264623
</td>
<td style="text-align:right;">
0.97230
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
1470.497
</td>
<td style="text-align:right;">
8.772546
</td>
<td style="text-align:right;">
0.1457
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
1156.7160
</td>
<td style="text-align:right;">
9.769036
</td>
<td style="text-align:right;">
0.3067
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3373
</td>
<td style="text-align:right;">
0.1185888
</td>
<td style="text-align:right;">
0.22310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1672
</td>
<td style="text-align:right;">
3881.437
</td>
<td style="text-align:right;">
43.07683
</td>
<td style="text-align:right;">
0.5797
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1350
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0.6666667
</td>
<td style="text-align:right;">
0.3180
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.7407407
</td>
<td style="text-align:right;">
0.4343
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1322
</td>
<td style="text-align:right;">
0.0756430
</td>
<td style="text-align:right;">
0.2359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
1321.8616
</td>
<td style="text-align:right;">
1.361716
</td>
<td style="text-align:right;">
0.1744
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
3881
</td>
<td style="text-align:right;">
6.7766040
</td>
<td style="text-align:right;">
0.9251
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.46787
</td>
<td style="text-align:right;">
0.4818
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.65807
</td>
<td style="text-align:right;">
0.08121
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5797
</td>
<td style="text-align:right;">
0.5726
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.0877
</td>
<td style="text-align:right;">
0.2866
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.79334
</td>
<td style="text-align:right;">
0.3059
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 411, Kent County, Delaware
</td>
<td style="text-align:right;">
23029
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
27357
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
26713.64
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
643.36
</td>
<td style="text-align:right;">
0.0240836
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041200
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041200
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
4723
</td>
<td style="text-align:right;">
1880
</td>
<td style="text-align:right;">
1742
</td>
<td style="text-align:right;">
778
</td>
<td style="text-align:right;">
4710
</td>
<td style="text-align:right;">
16.518047
</td>
<td style="text-align:right;">
0.3700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
2264
</td>
<td style="text-align:right;">
8.524735
</td>
<td style="text-align:right;">
0.5848
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
1168
</td>
<td style="text-align:right;">
41.18151
</td>
<td style="text-align:right;">
0.80360
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
257
</td>
<td style="text-align:right;">
574
</td>
<td style="text-align:right;">
44.77352
</td>
<td style="text-align:right;">
0.47360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
1742
</td>
<td style="text-align:right;">
42.36510
</td>
<td style="text-align:right;">
0.7087
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
3071
</td>
<td style="text-align:right;">
18.6584175
</td>
<td style="text-align:right;">
0.6563
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
471
</td>
<td style="text-align:right;">
3937
</td>
<td style="text-align:right;">
11.963424
</td>
<td style="text-align:right;">
0.34310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
600
</td>
<td style="text-align:right;">
12.703790
</td>
<td style="text-align:right;">
0.504200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1257
</td>
<td style="text-align:right;">
26.614440
</td>
<td style="text-align:right;">
0.7223
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
3036
</td>
<td style="text-align:right;">
19.202899
</td>
<td style="text-align:right;">
0.7085
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
240
</td>
<td style="text-align:right;">
1183
</td>
<td style="text-align:right;">
20.28740
</td>
<td style="text-align:right;">
0.6645
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
4378
</td>
<td style="text-align:right;">
4.339881
</td>
<td style="text-align:right;">
0.7670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2933
</td>
<td style="text-align:right;">
4723
</td>
<td style="text-align:right;">
62.100360
</td>
<td style="text-align:right;">
0.78710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1880
</td>
<td style="text-align:right;">
327
</td>
<td style="text-align:right;">
17.393617
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
18.776596
</td>
<td style="text-align:right;">
0.7841
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
1742
</td>
<td style="text-align:right;">
2.3536165
</td>
<td style="text-align:right;">
0.6746
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
1742
</td>
<td style="text-align:right;">
5.281286
</td>
<td style="text-align:right;">
0.5288
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4723
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.66290
</td>
<td style="text-align:right;">
0.5376
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.366500
</td>
<td style="text-align:right;">
0.8969
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.78710
</td>
<td style="text-align:right;">
0.77670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.1295
</td>
<td style="text-align:right;">
0.7889
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.946000
</td>
<td style="text-align:right;">
0.7681
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4135
</td>
<td style="text-align:right;">
1851
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
870
</td>
<td style="text-align:right;">
4076
</td>
<td style="text-align:right;">
21.34446
</td>
<td style="text-align:right;">
0.5206
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
180
</td>
<td style="text-align:right;">
1879
</td>
<td style="text-align:right;">
9.579564
</td>
<td style="text-align:right;">
0.8567
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
1230
</td>
<td style="text-align:right;">
31.219512
</td>
<td style="text-align:right;">
0.844800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
482
</td>
<td style="text-align:right;">
46.88797
</td>
<td style="text-align:right;">
0.55500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
610
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
35.63084
</td>
<td style="text-align:right;">
0.70270
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
286
</td>
<td style="text-align:right;">
2785
</td>
<td style="text-align:right;">
10.269300
</td>
<td style="text-align:right;">
0.5146
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
4124
</td>
<td style="text-align:right;">
4.946654
</td>
<td style="text-align:right;">
0.22200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
755
</td>
<td style="text-align:right;">
18.258767
</td>
<td style="text-align:right;">
0.59080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
25.804111
</td>
<td style="text-align:right;">
0.78410
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
3057.653
</td>
<td style="text-align:right;">
18.674456
</td>
<td style="text-align:right;">
0.6593
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
375
</td>
<td style="text-align:right;">
1138.2043
</td>
<td style="text-align:right;">
32.946633
</td>
<td style="text-align:right;">
0.8989
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
3953
</td>
<td style="text-align:right;">
0.6577283
</td>
<td style="text-align:right;">
0.38940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2299
</td>
<td style="text-align:right;">
4134.641
</td>
<td style="text-align:right;">
55.60337
</td>
<td style="text-align:right;">
0.6982
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1851
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
9.4543490
</td>
<td style="text-align:right;">
0.6291
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
438
</td>
<td style="text-align:right;">
23.6628849
</td>
<td style="text-align:right;">
0.8514
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
0.2920561
</td>
<td style="text-align:right;">
0.2552
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
1712.2269
</td>
<td style="text-align:right;">
8.351697
</td>
<td style="text-align:right;">
0.7088
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
4135
</td>
<td style="text-align:right;">
0.4836759
</td>
<td style="text-align:right;">
0.6479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.81660
</td>
<td style="text-align:right;">
0.5950
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.32250
</td>
<td style="text-align:right;">
0.89620
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6982
</td>
<td style="text-align:right;">
0.6897
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.0924
</td>
<td style="text-align:right;">
0.7625
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.92970
</td>
<td style="text-align:right;">
0.7729
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 412, Kent County, Delaware
</td>
<td style="text-align:right;">
23257
</td>
<td style="text-align:right;">
177100
</td>
<td style="text-align:right;">
26589
</td>
<td style="text-align:right;">
261500
</td>
<td style="text-align:right;">
26978.12
</td>
<td style="text-align:right;">
205436
</td>
<td style="text-align:right;">
-389.12
</td>
<td style="text-align:right;">
-0.0144235
</td>
<td style="text-align:right;">
56064
</td>
<td style="text-align:right;">
0.2729025
</td>
<td style="text-align:right;">
165.96
</td>
<td style="text-align:right;">
190.13
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041300
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041300
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
1912
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
596
</td>
<td style="text-align:right;">
1880
</td>
<td style="text-align:right;">
31.702128
</td>
<td style="text-align:right;">
0.7303
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
790
</td>
<td style="text-align:right;">
12.784810
</td>
<td style="text-align:right;">
0.8216
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
361
</td>
<td style="text-align:right;">
34.34903
</td>
<td style="text-align:right;">
0.63440
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
32.81553
</td>
<td style="text-align:right;">
0.22600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
33.44749
</td>
<td style="text-align:right;">
0.4394
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
1123
</td>
<td style="text-align:right;">
6.7675868
</td>
<td style="text-align:right;">
0.2300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
1975
</td>
<td style="text-align:right;">
8.708861
</td>
<td style="text-align:right;">
0.21160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
11.610879
</td>
<td style="text-align:right;">
0.432500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
451
</td>
<td style="text-align:right;">
23.587866
</td>
<td style="text-align:right;">
0.5306
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
1415
</td>
<td style="text-align:right;">
18.586572
</td>
<td style="text-align:right;">
0.6820
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
189
</td>
<td style="text-align:right;">
504
</td>
<td style="text-align:right;">
37.50000
</td>
<td style="text-align:right;">
0.9172
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1739
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1022
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
780
</td>
<td style="text-align:right;">
1912
</td>
<td style="text-align:right;">
40.794979
</td>
<td style="text-align:right;">
0.61730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
10.777882
</td>
<td style="text-align:right;">
0.6734
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
2.061856
</td>
<td style="text-align:right;">
0.5184
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
15.867580
</td>
<td style="text-align:right;">
0.8735
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1912
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.43290
</td>
<td style="text-align:right;">
0.4667
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.664500
</td>
<td style="text-align:right;">
0.5849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.61730
</td>
<td style="text-align:right;">
0.60910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.5955
</td>
<td style="text-align:right;">
0.5310
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.310200
</td>
<td style="text-align:right;">
0.5491
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2056
</td>
<td style="text-align:right;">
1010
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
839
</td>
<td style="text-align:right;">
2047
</td>
<td style="text-align:right;">
40.98681
</td>
<td style="text-align:right;">
0.8824
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
1049
</td>
<td style="text-align:right;">
10.009533
</td>
<td style="text-align:right;">
0.8718
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
319
</td>
<td style="text-align:right;">
26.332288
</td>
<td style="text-align:right;">
0.715100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
282
</td>
<td style="text-align:right;">
564
</td>
<td style="text-align:right;">
50.00000
</td>
<td style="text-align:right;">
0.62780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
41.44960
</td>
<td style="text-align:right;">
0.82570
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
1267
</td>
<td style="text-align:right;">
7.813733
</td>
<td style="text-align:right;">
0.3940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
2048
</td>
<td style="text-align:right;">
4.003906
</td>
<td style="text-align:right;">
0.16480
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
16.585603
</td>
<td style="text-align:right;">
0.50570
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
574
</td>
<td style="text-align:right;">
27.918288
</td>
<td style="text-align:right;">
0.87170
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
322
</td>
<td style="text-align:right;">
1474.000
</td>
<td style="text-align:right;">
21.845319
</td>
<td style="text-align:right;">
0.7931
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
540.0000
</td>
<td style="text-align:right;">
41.111111
</td>
<td style="text-align:right;">
0.9533
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
1918
</td>
<td style="text-align:right;">
1.9290928
</td>
<td style="text-align:right;">
0.61360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1101
</td>
<td style="text-align:right;">
2056.000
</td>
<td style="text-align:right;">
53.55058
</td>
<td style="text-align:right;">
0.6819
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1010
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
10.8910891
</td>
<td style="text-align:right;">
0.6527
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
1.5855040
</td>
<td style="text-align:right;">
0.5304
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
883.0000
</td>
<td style="text-align:right;">
12.004530
</td>
<td style="text-align:right;">
0.8210
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
2056
</td>
<td style="text-align:right;">
0.4377432
</td>
<td style="text-align:right;">
0.6354
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.13870
</td>
<td style="text-align:right;">
0.6919
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.73740
</td>
<td style="text-align:right;">
0.96820
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.6819
</td>
<td style="text-align:right;">
0.6736
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.8195
</td>
<td style="text-align:right;">
0.6344
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
10.37750
</td>
<td style="text-align:right;">
0.8249
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 413, Kent County, Delaware
</td>
<td style="text-align:right;">
26161
</td>
<td style="text-align:right;">
170700
</td>
<td style="text-align:right;">
23750
</td>
<td style="text-align:right;">
162800
</td>
<td style="text-align:right;">
30346.76
</td>
<td style="text-align:right;">
198012
</td>
<td style="text-align:right;">
-6596.76
</td>
<td style="text-align:right;">
-0.2173794
</td>
<td style="text-align:right;">
-35212
</td>
<td style="text-align:right;">
-0.1778276
</td>
<td style="text-align:right;">
125.53
</td>
<td style="text-align:right;">
144.48
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041400
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041400
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
3520
</td>
<td style="text-align:right;">
1746
</td>
<td style="text-align:right;">
1453
</td>
<td style="text-align:right;">
1040
</td>
<td style="text-align:right;">
3141
</td>
<td style="text-align:right;">
33.110474
</td>
<td style="text-align:right;">
0.7548
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
1256
</td>
<td style="text-align:right;">
9.394905
</td>
<td style="text-align:right;">
0.6456
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
467
</td>
<td style="text-align:right;">
20.12848
</td>
<td style="text-align:right;">
0.14600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
648
</td>
<td style="text-align:right;">
986
</td>
<td style="text-align:right;">
65.72008
</td>
<td style="text-align:right;">
0.88750
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
1453
</td>
<td style="text-align:right;">
51.06676
</td>
<td style="text-align:right;">
0.8854
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
326
</td>
<td style="text-align:right;">
2060
</td>
<td style="text-align:right;">
15.8252427
</td>
<td style="text-align:right;">
0.5697
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
3008
</td>
<td style="text-align:right;">
4.488032
</td>
<td style="text-align:right;">
0.07466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
475
</td>
<td style="text-align:right;">
13.494318
</td>
<td style="text-align:right;">
0.555300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
917
</td>
<td style="text-align:right;">
26.051136
</td>
<td style="text-align:right;">
0.6887
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
572
</td>
<td style="text-align:right;">
2200
</td>
<td style="text-align:right;">
26.000000
</td>
<td style="text-align:right;">
0.9122
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
238
</td>
<td style="text-align:right;">
654
</td>
<td style="text-align:right;">
36.39144
</td>
<td style="text-align:right;">
0.9103
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
3062
</td>
<td style="text-align:right;">
1.763553
</td>
<td style="text-align:right;">
0.5730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2306
</td>
<td style="text-align:right;">
3520
</td>
<td style="text-align:right;">
65.511364
</td>
<td style="text-align:right;">
0.80580
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1746
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
32.073310
</td>
<td style="text-align:right;">
0.8720
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1453
</td>
<td style="text-align:right;">
0.4129387
</td>
<td style="text-align:right;">
0.3280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1453
</td>
<td style="text-align:right;">
20.165176
</td>
<td style="text-align:right;">
0.9164
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
287
</td>
<td style="text-align:right;">
3520
</td>
<td style="text-align:right;">
8.1534091
</td>
<td style="text-align:right;">
0.9253
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.93016
</td>
<td style="text-align:right;">
0.6234
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.639500
</td>
<td style="text-align:right;">
0.9508
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.80580
</td>
<td style="text-align:right;">
0.79520
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.2226
</td>
<td style="text-align:right;">
0.8240
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.598060
</td>
<td style="text-align:right;">
0.8394
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
3390
</td>
<td style="text-align:right;">
1833
</td>
<td style="text-align:right;">
1617
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
3251
</td>
<td style="text-align:right;">
31.03660
</td>
<td style="text-align:right;">
0.7389
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
1853
</td>
<td style="text-align:right;">
7.285483
</td>
<td style="text-align:right;">
0.7386
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
592
</td>
<td style="text-align:right;">
34.628378
</td>
<td style="text-align:right;">
0.899300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
1025
</td>
<td style="text-align:right;">
70.92683
</td>
<td style="text-align:right;">
0.95250
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
932
</td>
<td style="text-align:right;">
1617
</td>
<td style="text-align:right;">
57.63760
</td>
<td style="text-align:right;">
0.97780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
255
</td>
<td style="text-align:right;">
2253
</td>
<td style="text-align:right;">
11.318242
</td>
<td style="text-align:right;">
0.5621
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
3194
</td>
<td style="text-align:right;">
11.897308
</td>
<td style="text-align:right;">
0.64010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
336
</td>
<td style="text-align:right;">
9.911504
</td>
<td style="text-align:right;">
0.16120
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
665
</td>
<td style="text-align:right;">
19.616519
</td>
<td style="text-align:right;">
0.40580
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
525
</td>
<td style="text-align:right;">
2529.000
</td>
<td style="text-align:right;">
20.759193
</td>
<td style="text-align:right;">
0.7511
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
622.0000
</td>
<td style="text-align:right;">
39.067524
</td>
<td style="text-align:right;">
0.9428
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
3246
</td>
<td style="text-align:right;">
0.9242144
</td>
<td style="text-align:right;">
0.45190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2363
</td>
<td style="text-align:right;">
3390.000
</td>
<td style="text-align:right;">
69.70501
</td>
<td style="text-align:right;">
0.8011
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1833
</td>
<td style="text-align:right;">
637
</td>
<td style="text-align:right;">
34.7517730
</td>
<td style="text-align:right;">
0.8775
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
1617
</td>
<td style="text-align:right;">
2.5355597
</td>
<td style="text-align:right;">
0.6635
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
358
</td>
<td style="text-align:right;">
1617.0000
</td>
<td style="text-align:right;">
22.139765
</td>
<td style="text-align:right;">
0.9372
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
3390
</td>
<td style="text-align:right;">
5.0442478
</td>
<td style="text-align:right;">
0.9052
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.65750
</td>
<td style="text-align:right;">
0.8282
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.71280
</td>
<td style="text-align:right;">
0.61900
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8011
</td>
<td style="text-align:right;">
0.7913
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.5634
</td>
<td style="text-align:right;">
0.9151
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.73480
</td>
<td style="text-align:right;">
0.8623
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 414, Kent County, Delaware
</td>
<td style="text-align:right;">
22105
</td>
<td style="text-align:right;">
195200
</td>
<td style="text-align:right;">
25352
</td>
<td style="text-align:right;">
190000
</td>
<td style="text-align:right;">
25641.80
</td>
<td style="text-align:right;">
226432
</td>
<td style="text-align:right;">
-289.80
</td>
<td style="text-align:right;">
-0.0113019
</td>
<td style="text-align:right;">
-36432
</td>
<td style="text-align:right;">
-0.1608960
</td>
<td style="text-align:right;">
174.43
</td>
<td style="text-align:right;">
222.67
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001041500
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
041500
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
4098
</td>
<td style="text-align:right;">
1661
</td>
<td style="text-align:right;">
1469
</td>
<td style="text-align:right;">
756
</td>
<td style="text-align:right;">
4098
</td>
<td style="text-align:right;">
18.448023
</td>
<td style="text-align:right;">
0.4222
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
141
</td>
<td style="text-align:right;">
2212
</td>
<td style="text-align:right;">
6.374322
</td>
<td style="text-align:right;">
0.3968
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
1109
</td>
<td style="text-align:right;">
28.22362
</td>
<td style="text-align:right;">
0.42170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
360
</td>
<td style="text-align:right;">
56.66667
</td>
<td style="text-align:right;">
0.74570
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
517
</td>
<td style="text-align:right;">
1469
</td>
<td style="text-align:right;">
35.19401
</td>
<td style="text-align:right;">
0.4992
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
2750
</td>
<td style="text-align:right;">
10.7272727
</td>
<td style="text-align:right;">
0.3855
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
3946
</td>
<td style="text-align:right;">
6.158135
</td>
<td style="text-align:right;">
0.12390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
626
</td>
<td style="text-align:right;">
15.275744
</td>
<td style="text-align:right;">
0.659400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
24.353343
</td>
<td style="text-align:right;">
0.5834
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
3015
</td>
<td style="text-align:right;">
18.076285
</td>
<td style="text-align:right;">
0.6599
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
217
</td>
<td style="text-align:right;">
1085
</td>
<td style="text-align:right;">
20.00000
</td>
<td style="text-align:right;">
0.6563
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
3952
</td>
<td style="text-align:right;">
2.859312
</td>
<td style="text-align:right;">
0.6795
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1972
</td>
<td style="text-align:right;">
4098
</td>
<td style="text-align:right;">
48.121035
</td>
<td style="text-align:right;">
0.68770
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1661
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
12.582781
</td>
<td style="text-align:right;">
0.6992
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.602047
</td>
<td style="text-align:right;">
0.4063
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1469
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
1469
</td>
<td style="text-align:right;">
3.539823
</td>
<td style="text-align:right;">
0.3853
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4098
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.82760
</td>
<td style="text-align:right;">
0.2906
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.238500
</td>
<td style="text-align:right;">
0.8589
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.68770
</td>
<td style="text-align:right;">
0.67860
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.0210
</td>
<td style="text-align:right;">
0.2527
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7.774800
</td>
<td style="text-align:right;">
0.4611
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4506
</td>
<td style="text-align:right;">
1536
</td>
<td style="text-align:right;">
1516
</td>
<td style="text-align:right;">
1520
</td>
<td style="text-align:right;">
4501
</td>
<td style="text-align:right;">
33.77027
</td>
<td style="text-align:right;">
0.7838
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
145
</td>
<td style="text-align:right;">
2238
</td>
<td style="text-align:right;">
6.478999
</td>
<td style="text-align:right;">
0.6780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
189
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
24.835742
</td>
<td style="text-align:right;">
0.660400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
375
</td>
<td style="text-align:right;">
755
</td>
<td style="text-align:right;">
49.66887
</td>
<td style="text-align:right;">
0.61980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
564
</td>
<td style="text-align:right;">
1516
</td>
<td style="text-align:right;">
37.20317
</td>
<td style="text-align:right;">
0.74010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
2917
</td>
<td style="text-align:right;">
6.616387
</td>
<td style="text-align:right;">
0.3313
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
529
</td>
<td style="text-align:right;">
4479
</td>
<td style="text-align:right;">
11.810672
</td>
<td style="text-align:right;">
0.63540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
574
</td>
<td style="text-align:right;">
12.738571
</td>
<td style="text-align:right;">
0.29900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1176
</td>
<td style="text-align:right;">
26.098535
</td>
<td style="text-align:right;">
0.79920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
647
</td>
<td style="text-align:right;">
3301.887
</td>
<td style="text-align:right;">
19.594854
</td>
<td style="text-align:right;">
0.7040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
339
</td>
<td style="text-align:right;">
1022.2089
</td>
<td style="text-align:right;">
33.163474
</td>
<td style="text-align:right;">
0.9011
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
4156
</td>
<td style="text-align:right;">
1.4918191
</td>
<td style="text-align:right;">
0.55350
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2106
</td>
<td style="text-align:right;">
4506.129
</td>
<td style="text-align:right;">
46.73634
</td>
<td style="text-align:right;">
0.6179
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1536
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
18.8802083
</td>
<td style="text-align:right;">
0.7598
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
1516
</td>
<td style="text-align:right;">
4.5514512
</td>
<td style="text-align:right;">
0.8288
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
1516.4830
</td>
<td style="text-align:right;">
9.693482
</td>
<td style="text-align:right;">
0.7574
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
4506
</td>
<td style="text-align:right;">
0.5770084
</td>
<td style="text-align:right;">
0.6682
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.16860
</td>
<td style="text-align:right;">
0.7007
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.25680
</td>
<td style="text-align:right;">
0.87570
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6179
</td>
<td style="text-align:right;">
0.6104
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.1942
</td>
<td style="text-align:right;">
0.8024
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.23750
</td>
<td style="text-align:right;">
0.8094
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 415, Kent County, Delaware
</td>
<td style="text-align:right;">
24801
</td>
<td style="text-align:right;">
177400
</td>
<td style="text-align:right;">
27014
</td>
<td style="text-align:right;">
171300
</td>
<td style="text-align:right;">
28769.16
</td>
<td style="text-align:right;">
205784
</td>
<td style="text-align:right;">
-1755.16
</td>
<td style="text-align:right;">
-0.0610084
</td>
<td style="text-align:right;">
-34484
</td>
<td style="text-align:right;">
-0.1675738
</td>
<td style="text-align:right;">
216.49
</td>
<td style="text-align:right;">
246.21
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
<tr>
<td style="text-align:left;">
10001042000
</td>
<td style="text-align:left;">
10001
</td>
<td style="text-align:left;">
042000
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
Kent County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
3037
</td>
<td style="text-align:right;">
1200
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
3037
</td>
<td style="text-align:right;">
18.669740
</td>
<td style="text-align:right;">
0.4287
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
178
</td>
<td style="text-align:right;">
1552
</td>
<td style="text-align:right;">
11.469072
</td>
<td style="text-align:right;">
0.7632
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
928
</td>
<td style="text-align:right;">
41.81034
</td>
<td style="text-align:right;">
0.81540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
44.55959
</td>
<td style="text-align:right;">
0.46980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
474
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
42.28368
</td>
<td style="text-align:right;">
0.7069
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
508
</td>
<td style="text-align:right;">
2110
</td>
<td style="text-align:right;">
24.0758294
</td>
<td style="text-align:right;">
0.7927
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
3029
</td>
<td style="text-align:right;">
15.252559
</td>
<td style="text-align:right;">
0.49000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
413
</td>
<td style="text-align:right;">
13.598946
</td>
<td style="text-align:right;">
0.562000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
613
</td>
<td style="text-align:right;">
20.184393
</td>
<td style="text-align:right;">
0.3207
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
489
</td>
<td style="text-align:right;">
2427
</td>
<td style="text-align:right;">
20.148331
</td>
<td style="text-align:right;">
0.7477
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
845
</td>
<td style="text-align:right;">
13.84615
</td>
<td style="text-align:right;">
0.4393
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
2868
</td>
<td style="text-align:right;">
1.115760
</td>
<td style="text-align:right;">
0.4677
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
3037
</td>
<td style="text-align:right;">
4.511031
</td>
<td style="text-align:right;">
0.07128
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1428
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
30.166667
</td>
<td style="text-align:right;">
0.8820
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
3.300624
</td>
<td style="text-align:right;">
0.3644
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3037
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.18150
</td>
<td style="text-align:right;">
0.7026
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.537400
</td>
<td style="text-align:right;">
0.5126
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.07128
</td>
<td style="text-align:right;">
0.07033
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.9194
</td>
<td style="text-align:right;">
0.2102
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.709580
</td>
<td style="text-align:right;">
0.4513
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3460
</td>
<td style="text-align:right;">
1291
</td>
<td style="text-align:right;">
1144
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
3460
</td>
<td style="text-align:right;">
16.04046
</td>
<td style="text-align:right;">
0.3745
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
1787
</td>
<td style="text-align:right;">
7.162843
</td>
<td style="text-align:right;">
0.7294
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
1052
</td>
<td style="text-align:right;">
16.634981
</td>
<td style="text-align:right;">
0.280300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
20.65217
</td>
<td style="text-align:right;">
0.08512
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
194
</td>
<td style="text-align:right;">
1144
</td>
<td style="text-align:right;">
16.95804
</td>
<td style="text-align:right;">
0.09936
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
2398
</td>
<td style="text-align:right;">
29.649708
</td>
<td style="text-align:right;">
0.9637
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
3440
</td>
<td style="text-align:right;">
20.668605
</td>
<td style="text-align:right;">
0.91280
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
455
</td>
<td style="text-align:right;">
13.150289
</td>
<td style="text-align:right;">
0.32050
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
792
</td>
<td style="text-align:right;">
22.890173
</td>
<td style="text-align:right;">
0.61620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
470
</td>
<td style="text-align:right;">
2648.000
</td>
<td style="text-align:right;">
17.749245
</td>
<td style="text-align:right;">
0.6107
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
872.0000
</td>
<td style="text-align:right;">
6.077982
</td>
<td style="text-align:right;">
0.1545
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
3260
</td>
<td style="text-align:right;">
1.1656442
</td>
<td style="text-align:right;">
0.50140
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
590
</td>
<td style="text-align:right;">
3460.000
</td>
<td style="text-align:right;">
17.05202
</td>
<td style="text-align:right;">
0.2337
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1291
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
22.8505035
</td>
<td style="text-align:right;">
0.8450
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1144
</td>
<td style="text-align:right;">
0.7867133
</td>
<td style="text-align:right;">
0.3721
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
1144.0000
</td>
<td style="text-align:right;">
17.132867
</td>
<td style="text-align:right;">
0.8985
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
3460
</td>
<td style="text-align:right;">
0.7803468
</td>
<td style="text-align:right;">
0.7044
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.07976
</td>
<td style="text-align:right;">
0.6746
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.20330
</td>
<td style="text-align:right;">
0.30100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.2337
</td>
<td style="text-align:right;">
0.2308
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.9460
</td>
<td style="text-align:right;">
0.6984
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.46276
</td>
<td style="text-align:right;">
0.5716
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 420, Kent County, Delaware
</td>
<td style="text-align:right;">
25586
</td>
<td style="text-align:right;">
173900
</td>
<td style="text-align:right;">
32641
</td>
<td style="text-align:right;">
194500
</td>
<td style="text-align:right;">
29679.76
</td>
<td style="text-align:right;">
201724
</td>
<td style="text-align:right;">
2961.24
</td>
<td style="text-align:right;">
0.0997730
</td>
<td style="text-align:right;">
-7224
</td>
<td style="text-align:right;">
-0.0358113
</td>
<td style="text-align:right;">
147.99
</td>
<td style="text-align:right;">
173.96
</td>
<td style="text-align:left;">
Kent County, Delaware
</td>
<td style="text-align:left;">
Dover, DE MSA
</td>
<td style="text-align:left;">
C2010
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_national_nmtc_df0 <- left_join(svi_national_nmtc, census_pull_df, join_by("GEOID_2010_trt" == "GEOID"))

svi_national_nmtc_df1 <- left_join(svi_national_nmtc_df0, hpi_df_10_20, join_by("GEOID_2010_trt" == "GEOID10")) %>%
                          unite("county_fips", FIPS_st, FIPS_county, sep = "") 

svi_national_nmtc_df <- left_join(svi_national_nmtc_df1, msa_csa_crosswalk, join_by("county_fips" == "county_fips"))

svi_national_nmtc_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
county_fips
</th>
<th style="text-align:left;">
FIPS_tract
</th>
<th style="text-align:left;">
state
</th>
<th style="text-align:left;">
state_name
</th>
<th style="text-align:left;">
county
</th>
<th style="text-align:right;">
region_number
</th>
<th style="text-align:left;">
region
</th>
<th style="text-align:right;">
division_number
</th>
<th style="text-align:left;">
division
</th>
<th style="text-align:right;">
E_TOTPOP_10
</th>
<th style="text-align:right;">
E_HU_10
</th>
<th style="text-align:right;">
E_HH_10
</th>
<th style="text-align:right;">
E_POV150_10
</th>
<th style="text-align:right;">
ET_POVSTATUS_10
</th>
<th style="text-align:right;">
EP_POV150_10
</th>
<th style="text-align:right;">
EPL_POV150_10
</th>
<th style="text-align:right;">
F_POV150_10
</th>
<th style="text-align:right;">
E_UNEMP_10
</th>
<th style="text-align:right;">
ET_EMPSTATUS_10
</th>
<th style="text-align:right;">
EP_UNEMP_10
</th>
<th style="text-align:right;">
EPL_UNEMP_10
</th>
<th style="text-align:right;">
F_UNEMP_10
</th>
<th style="text-align:right;">
E_HBURD_OWN_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_10
</th>
<th style="text-align:right;">
EP_HBURD_OWN_10
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_10
</th>
<th style="text-align:right;">
F_HBURD_OWN_10
</th>
<th style="text-align:right;">
E_HBURD_RENT_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_10
</th>
<th style="text-align:right;">
EP_HBURD_RENT_10
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_10
</th>
<th style="text-align:right;">
F_HBURD_RENT_10
</th>
<th style="text-align:right;">
E_HBURD_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_10
</th>
<th style="text-align:right;">
EP_HBURD_10
</th>
<th style="text-align:right;">
EPL_HBURD_10
</th>
<th style="text-align:right;">
F_HBURD_10
</th>
<th style="text-align:right;">
E_NOHSDP_10
</th>
<th style="text-align:right;">
ET_EDSTATUS_10
</th>
<th style="text-align:right;">
EP_NOHSDP_10
</th>
<th style="text-align:right;">
EPL_NOHSDP_10
</th>
<th style="text-align:right;">
F_NOHSDP_10
</th>
<th style="text-align:right;">
E_UNINSUR_12
</th>
<th style="text-align:right;">
ET_INSURSTATUS_12
</th>
<th style="text-align:right;">
EP_UNINSUR_12
</th>
<th style="text-align:right;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
F_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
F_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:right;">
EPL_AGE17_10
</th>
<th style="text-align:right;">
F_AGE17_10
</th>
<th style="text-align:right;">
E_DISABL_12
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_12
</th>
<th style="text-align:right;">
EP_DISABL_12
</th>
<th style="text-align:right;">
EPL_DISABL_12
</th>
<th style="text-align:right;">
F_DISABL_12
</th>
<th style="text-align:right;">
E_SNGPNT_10
</th>
<th style="text-align:right;">
ET_FAMILIES_10
</th>
<th style="text-align:right;">
EP_SNGPNT_10
</th>
<th style="text-align:right;">
EPL_SNGPNT_10
</th>
<th style="text-align:right;">
F_SNGPNT_10
</th>
<th style="text-align:right;">
E_LIMENG_10
</th>
<th style="text-align:right;">
ET_POPAGE5UP_10
</th>
<th style="text-align:right;">
EP_LIMENG_10
</th>
<th style="text-align:right;">
EPL_LIMENG_10
</th>
<th style="text-align:right;">
F_LIMENG_10
</th>
<th style="text-align:right;">
E_MINRTY_10
</th>
<th style="text-align:right;">
ET_POPETHRACE_10
</th>
<th style="text-align:right;">
EP_MINRTY_10
</th>
<th style="text-align:right;">
EPL_MINRTY_10
</th>
<th style="text-align:right;">
F_MINRTY_10
</th>
<th style="text-align:right;">
E_STRHU_10
</th>
<th style="text-align:right;">
E_MUNIT_10
</th>
<th style="text-align:right;">
EP_MUNIT_10
</th>
<th style="text-align:right;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
F_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
</th>
<th style="text-align:right;">
F_MOBILE_10
</th>
<th style="text-align:right;">
E_CROWD_10
</th>
<th style="text-align:right;">
ET_OCCUPANTS_10
</th>
<th style="text-align:right;">
EP_CROWD_10
</th>
<th style="text-align:right;">
EPL_CROWD_10
</th>
<th style="text-align:right;">
F_CROWD_10
</th>
<th style="text-align:right;">
E_NOVEH_10
</th>
<th style="text-align:right;">
ET_KNOWNVEH_10
</th>
<th style="text-align:right;">
EP_NOVEH_10
</th>
<th style="text-align:right;">
EPL_NOVEH_10
</th>
<th style="text-align:right;">
F_NOVEH_10
</th>
<th style="text-align:right;">
E_GROUPQ_10
</th>
<th style="text-align:right;">
ET_HHTYPE_10
</th>
<th style="text-align:right;">
EP_GROUPQ_10
</th>
<th style="text-align:right;">
EPL_GROUPQ_10
</th>
<th style="text-align:right;">
F_GROUPQ_10
</th>
<th style="text-align:right;">
SPL_THEME1_10
</th>
<th style="text-align:right;">
RPL_THEME1_10
</th>
<th style="text-align:right;">
F_THEME1_10
</th>
<th style="text-align:right;">
SPL_THEME2_10
</th>
<th style="text-align:right;">
RPL_THEME2_10
</th>
<th style="text-align:right;">
F_THEME2_10
</th>
<th style="text-align:right;">
SPL_THEME3_10
</th>
<th style="text-align:right;">
RPL_THEME3_10
</th>
<th style="text-align:right;">
F_THEME3_10
</th>
<th style="text-align:right;">
SPL_THEME4_10
</th>
<th style="text-align:right;">
RPL_THEME4_10
</th>
<th style="text-align:right;">
F_THEME4_10
</th>
<th style="text-align:right;">
SPL_THEMES_10
</th>
<th style="text-align:right;">
RPL_THEMES_10
</th>
<th style="text-align:right;">
F_TOTAL_10
</th>
<th style="text-align:right;">
E_TOTPOP_20
</th>
<th style="text-align:right;">
E_HU_20
</th>
<th style="text-align:right;">
E_HH_20
</th>
<th style="text-align:right;">
E_POV150_20
</th>
<th style="text-align:right;">
ET_POVSTATUS_20
</th>
<th style="text-align:right;">
EP_POV150_20
</th>
<th style="text-align:right;">
EPL_POV150_20
</th>
<th style="text-align:right;">
F_POV150_20
</th>
<th style="text-align:right;">
E_UNEMP_20
</th>
<th style="text-align:right;">
ET_EMPSTATUS_20
</th>
<th style="text-align:right;">
EP_UNEMP_20
</th>
<th style="text-align:right;">
EPL_UNEMP_20
</th>
<th style="text-align:right;">
F_UNEMP_20
</th>
<th style="text-align:right;">
E_HBURD_OWN_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_20
</th>
<th style="text-align:right;">
EP_HBURD_OWN_20
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_20
</th>
<th style="text-align:right;">
F_HBURD_OWN_20
</th>
<th style="text-align:right;">
E_HBURD_RENT_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_20
</th>
<th style="text-align:right;">
EP_HBURD_RENT_20
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_20
</th>
<th style="text-align:right;">
F_HBURD_RENT_20
</th>
<th style="text-align:right;">
E_HBURD_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_20
</th>
<th style="text-align:right;">
EP_HBURD_20
</th>
<th style="text-align:right;">
EPL_HBURD_20
</th>
<th style="text-align:right;">
F_HBURD_20
</th>
<th style="text-align:right;">
E_NOHSDP_20
</th>
<th style="text-align:right;">
ET_EDSTATUS_20
</th>
<th style="text-align:right;">
EP_NOHSDP_20
</th>
<th style="text-align:right;">
EPL_NOHSDP_20
</th>
<th style="text-align:right;">
F_NOHSDP_20
</th>
<th style="text-align:right;">
E_UNINSUR_20
</th>
<th style="text-align:right;">
ET_INSURSTATUS_20
</th>
<th style="text-align:right;">
EP_UNINSUR_20
</th>
<th style="text-align:right;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
F_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
F_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:right;">
EPL_AGE17_20
</th>
<th style="text-align:right;">
F_AGE17_20
</th>
<th style="text-align:right;">
E_DISABL_20
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_20
</th>
<th style="text-align:right;">
EP_DISABL_20
</th>
<th style="text-align:right;">
EPL_DISABL_20
</th>
<th style="text-align:right;">
F_DISABL_20
</th>
<th style="text-align:right;">
E_SNGPNT_20
</th>
<th style="text-align:right;">
ET_FAMILIES_20
</th>
<th style="text-align:right;">
EP_SNGPNT_20
</th>
<th style="text-align:right;">
EPL_SNGPNT_20
</th>
<th style="text-align:right;">
F_SNGPNT_20
</th>
<th style="text-align:right;">
E_LIMENG_20
</th>
<th style="text-align:right;">
ET_POPAGE5UP_20
</th>
<th style="text-align:right;">
EP_LIMENG_20
</th>
<th style="text-align:right;">
EPL_LIMENG_20
</th>
<th style="text-align:right;">
F_LIMENG_20
</th>
<th style="text-align:right;">
E_MINRTY_20
</th>
<th style="text-align:right;">
ET_POPETHRACE_20
</th>
<th style="text-align:right;">
EP_MINRTY_20
</th>
<th style="text-align:right;">
EPL_MINRTY_20
</th>
<th style="text-align:right;">
F_MINRTY_20
</th>
<th style="text-align:right;">
E_STRHU_20
</th>
<th style="text-align:right;">
E_MUNIT_20
</th>
<th style="text-align:right;">
EP_MUNIT_20
</th>
<th style="text-align:right;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
F_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
</th>
<th style="text-align:right;">
F_MOBILE_20
</th>
<th style="text-align:right;">
E_CROWD_20
</th>
<th style="text-align:right;">
ET_OCCUPANTS_20
</th>
<th style="text-align:right;">
EP_CROWD_20
</th>
<th style="text-align:right;">
EPL_CROWD_20
</th>
<th style="text-align:right;">
F_CROWD_20
</th>
<th style="text-align:right;">
E_NOVEH_20
</th>
<th style="text-align:right;">
ET_KNOWNVEH_20
</th>
<th style="text-align:right;">
EP_NOVEH_20
</th>
<th style="text-align:right;">
EPL_NOVEH_20
</th>
<th style="text-align:right;">
F_NOVEH_20
</th>
<th style="text-align:right;">
E_GROUPQ_20
</th>
<th style="text-align:right;">
ET_HHTYPE_20
</th>
<th style="text-align:right;">
EP_GROUPQ_20
</th>
<th style="text-align:right;">
EPL_GROUPQ_20
</th>
<th style="text-align:right;">
F_GROUPQ_20
</th>
<th style="text-align:right;">
SPL_THEME1_20
</th>
<th style="text-align:right;">
RPL_THEME1_20
</th>
<th style="text-align:right;">
F_THEME1_20
</th>
<th style="text-align:right;">
SPL_THEME2_20
</th>
<th style="text-align:right;">
RPL_THEME2_20
</th>
<th style="text-align:right;">
F_THEME2_20
</th>
<th style="text-align:right;">
SPL_THEME3_20
</th>
<th style="text-align:right;">
RPL_THEME3_20
</th>
<th style="text-align:right;">
F_THEME3_20
</th>
<th style="text-align:right;">
SPL_THEME4_20
</th>
<th style="text-align:right;">
RPL_THEME4_20
</th>
<th style="text-align:right;">
F_THEME4_20
</th>
<th style="text-align:right;">
SPL_THEMES_20
</th>
<th style="text-align:right;">
RPL_THEMES_20
</th>
<th style="text-align:right;">
F_TOTAL_20
</th>
<th style="text-align:left;">
nmtc_eligibility
</th>
<th style="text-align:right;">
pre10_nmtc_project_cnt
</th>
<th style="text-align:right;">
pre10_nmtc_dollars
</th>
<th style="text-align:left;">
pre10_nmtc_dollars_formatted
</th>
<th style="text-align:right;">
post10_nmtc_project_cnt
</th>
<th style="text-align:right;">
post10_nmtc_dollars
</th>
<th style="text-align:left;">
post10_nmtc_dollars_formatted
</th>
<th style="text-align:right;">
nmtc_flag
</th>
<th style="text-align:left;">
NAME
</th>
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
<th style="text-align:right;">
Median_Income_10adj
</th>
<th style="text-align:right;">
Median_Home_Value_10adj
</th>
<th style="text-align:right;">
Median_Income_Change
</th>
<th style="text-align:right;">
Median_Income_Change_pct
</th>
<th style="text-align:right;">
Median_Home_Value_Change
</th>
<th style="text-align:right;">
Median_Home_Value_Change_pct
</th>
<th style="text-align:right;">
housing_price_index10
</th>
<th style="text-align:right;">
housing_price_index20
</th>
<th style="text-align:left;">
county_title
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:left;">
cbsa_code
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
01001
</td>
<td style="text-align:left;">
020200
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Autauga County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
816
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
495
</td>
<td style="text-align:right;">
1992
</td>
<td style="text-align:right;">
24.84940
</td>
<td style="text-align:right;">
0.5954
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
834
</td>
<td style="text-align:right;">
8.153477
</td>
<td style="text-align:right;">
0.57540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
11.16173
</td>
<td style="text-align:right;">
0.02067
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
36.08247
</td>
<td style="text-align:right;">
0.30190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
154
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
21.09589
</td>
<td style="text-align:right;">
0.09312
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
339
</td>
<td style="text-align:right;">
1265
</td>
<td style="text-align:right;">
26.798419
</td>
<td style="text-align:right;">
0.8392
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
15.55666
</td>
<td style="text-align:right;">
0.6000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
10.09901
</td>
<td style="text-align:right;">
0.3419
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
29.55446
</td>
<td style="text-align:right;">
0.8192
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
1515
</td>
<td style="text-align:right;">
23.69637
</td>
<td style="text-align:right;">
0.8791
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
132
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
28.947368
</td>
<td style="text-align:right;">
0.8351
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
1890
</td>
<td style="text-align:right;">
0.7936508
</td>
<td style="text-align:right;">
0.40130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1243
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
61.534653
</td>
<td style="text-align:right;">
0.77810
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
816
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
4.1666667
</td>
<td style="text-align:right;">
0.6664
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
1.780822
</td>
<td style="text-align:right;">
0.5406
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
15.7534247
</td>
<td style="text-align:right;">
0.83820
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.70312
</td>
<td style="text-align:right;">
0.5665
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.27660
</td>
<td style="text-align:right;">
0.8614
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.77810
</td>
<td style="text-align:right;">
0.7709
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.53160
</td>
<td style="text-align:right;">
0.5047
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.28942
</td>
<td style="text-align:right;">
0.6832
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
720
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
1511
</td>
<td style="text-align:right;">
25.413633
</td>
<td style="text-align:right;">
0.6427
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
4.044630
</td>
<td style="text-align:right;">
0.41320
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
392
</td>
<td style="text-align:right;">
8.418367
</td>
<td style="text-align:right;">
0.03542
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
181
</td>
<td style="text-align:right;">
64.08840
</td>
<td style="text-align:right;">
0.9086
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
26.00349
</td>
<td style="text-align:right;">
0.40410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
1313
</td>
<td style="text-align:right;">
10.586443
</td>
<td style="text-align:right;">
0.5601
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
1533
</td>
<td style="text-align:right;">
5.936073
</td>
<td style="text-align:right;">
0.4343
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
16.163916
</td>
<td style="text-align:right;">
0.5169
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
325
</td>
<td style="text-align:right;">
18.49744
</td>
<td style="text-align:right;">
0.28510
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
164
</td>
<td style="text-align:right;">
1208.000
</td>
<td style="text-align:right;">
13.576159
</td>
<td style="text-align:right;">
0.4127
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
359.0000
</td>
<td style="text-align:right;">
11.6991643
</td>
<td style="text-align:right;">
0.39980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1651
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1116
</td>
<td style="text-align:right;">
1757.000
</td>
<td style="text-align:right;">
63.5173591
</td>
<td style="text-align:right;">
0.759100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
720
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.4166667
</td>
<td style="text-align:right;">
0.2470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0.6944444
</td>
<td style="text-align:right;">
0.5106
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
1.5706806
</td>
<td style="text-align:right;">
0.46880
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
573.000
</td>
<td style="text-align:right;">
9.947644
</td>
<td style="text-align:right;">
0.7317
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
12.0660216
</td>
<td style="text-align:right;">
0.9549
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.45440
</td>
<td style="text-align:right;">
0.4888
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.70929
</td>
<td style="text-align:right;">
0.10250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.759100
</td>
<td style="text-align:right;">
0.752700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.91300
</td>
<td style="text-align:right;">
0.6862
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.835790
</td>
<td style="text-align:right;">
0.4802
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 202, Autauga County, Alabama
</td>
<td style="text-align:right;">
19437
</td>
<td style="text-align:right;">
138500
</td>
<td style="text-align:right;">
20154
</td>
<td style="text-align:right;">
90500
</td>
<td style="text-align:right;">
22546.92
</td>
<td style="text-align:right;">
160660
</td>
<td style="text-align:right;">
-2392.92
</td>
<td style="text-align:right;">
-0.1061307
</td>
<td style="text-align:right;">
-70160
</td>
<td style="text-align:right;">
-0.4366986
</td>
<td style="text-align:right;">
123.78
</td>
<td style="text-align:right;">
123.37
</td>
<td style="text-align:left;">
Autauga County, Alabama
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:left;">
CS388
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
01001
</td>
<td style="text-align:left;">
020700
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Autauga County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
2664
</td>
<td style="text-align:right;">
1254
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
2664
</td>
<td style="text-align:right;">
26.65165
</td>
<td style="text-align:right;">
0.6328
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
1310
</td>
<td style="text-align:right;">
2.213741
</td>
<td style="text-align:right;">
0.05255
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
18.87324
</td>
<td style="text-align:right;">
0.13890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
429
</td>
<td style="text-align:right;">
43.58974
</td>
<td style="text-align:right;">
0.47090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
28.18262
</td>
<td style="text-align:right;">
0.28130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
396
</td>
<td style="text-align:right;">
1852
</td>
<td style="text-align:right;">
21.382289
</td>
<td style="text-align:right;">
0.7478
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
345
</td>
<td style="text-align:right;">
2878
</td>
<td style="text-align:right;">
11.98749
</td>
<td style="text-align:right;">
0.4459
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
389
</td>
<td style="text-align:right;">
14.60210
</td>
<td style="text-align:right;">
0.6417
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
599
</td>
<td style="text-align:right;">
22.48499
</td>
<td style="text-align:right;">
0.4007
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
2168
</td>
<td style="text-align:right;">
23.52399
</td>
<td style="text-align:right;">
0.8752
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
712
</td>
<td style="text-align:right;">
32.022472
</td>
<td style="text-align:right;">
0.8712
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2480
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
2664
</td>
<td style="text-align:right;">
26.051051
</td>
<td style="text-align:right;">
0.51380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1254
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.6379585
</td>
<td style="text-align:right;">
0.2931
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
460
</td>
<td style="text-align:right;">
36.6826156
</td>
<td style="text-align:right;">
0.9714
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1238
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
10.9745391
</td>
<td style="text-align:right;">
0.74770
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2664
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.16035
</td>
<td style="text-align:right;">
0.4069
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.88178
</td>
<td style="text-align:right;">
0.6997
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.51380
</td>
<td style="text-align:right;">
0.5090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.50000
</td>
<td style="text-align:right;">
0.4882
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.05593
</td>
<td style="text-align:right;">
0.5185
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3562
</td>
<td style="text-align:right;">
1313
</td>
<td style="text-align:right;">
1248
</td>
<td style="text-align:right;">
1370
</td>
<td style="text-align:right;">
3528
</td>
<td style="text-align:right;">
38.832200
</td>
<td style="text-align:right;">
0.8512
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
1562
</td>
<td style="text-align:right;">
8.194622
</td>
<td style="text-align:right;">
0.79350
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
844
</td>
<td style="text-align:right;">
19.905213
</td>
<td style="text-align:right;">
0.44510
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
404
</td>
<td style="text-align:right;">
58.66337
</td>
<td style="text-align:right;">
0.8359
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
405
</td>
<td style="text-align:right;">
1248
</td>
<td style="text-align:right;">
32.45192
</td>
<td style="text-align:right;">
0.60420
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
396
</td>
<td style="text-align:right;">
2211
</td>
<td style="text-align:right;">
17.910448
</td>
<td style="text-align:right;">
0.7857
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
3547
</td>
<td style="text-align:right;">
12.517620
</td>
<td style="text-align:right;">
0.7758
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
9.966311
</td>
<td style="text-align:right;">
0.1800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
26.78271
</td>
<td style="text-align:right;">
0.79230
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
629
</td>
<td style="text-align:right;">
2593.000
</td>
<td style="text-align:right;">
24.257617
</td>
<td style="text-align:right;">
0.8730
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
797.0000
</td>
<td style="text-align:right;">
21.4554580
</td>
<td style="text-align:right;">
0.71860
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3211
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
3562.000
</td>
<td style="text-align:right;">
28.3267827
</td>
<td style="text-align:right;">
0.466800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1313
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1.0662605
</td>
<td style="text-align:right;">
0.3165
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
443
</td>
<td style="text-align:right;">
33.7395278
</td>
<td style="text-align:right;">
0.9663
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
1248
</td>
<td style="text-align:right;">
5.8493590
</td>
<td style="text-align:right;">
0.82110
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1248.000
</td>
<td style="text-align:right;">
1.362180
</td>
<td style="text-align:right;">
0.1554
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
112
</td>
<td style="text-align:right;">
3562
</td>
<td style="text-align:right;">
3.1443010
</td>
<td style="text-align:right;">
0.8514
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.81040
</td>
<td style="text-align:right;">
0.8569
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.65869
</td>
<td style="text-align:right;">
0.58470
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.466800
</td>
<td style="text-align:right;">
0.462900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.11070
</td>
<td style="text-align:right;">
0.7714
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.046590
</td>
<td style="text-align:right;">
0.7851
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 207, Autauga County, Alabama
</td>
<td style="text-align:right;">
22114
</td>
<td style="text-align:right;">
93800
</td>
<td style="text-align:right;">
20934
</td>
<td style="text-align:right;">
82400
</td>
<td style="text-align:right;">
25652.24
</td>
<td style="text-align:right;">
108808
</td>
<td style="text-align:right;">
-4718.24
</td>
<td style="text-align:right;">
-0.1839309
</td>
<td style="text-align:right;">
-26408
</td>
<td style="text-align:right;">
-0.2427027
</td>
<td style="text-align:right;">
95.94
</td>
<td style="text-align:right;">
108.47
</td>
<td style="text-align:left;">
Autauga County, Alabama
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:left;">
CS388
</td>
</tr>
<tr>
<td style="text-align:left;">
01001021100
</td>
<td style="text-align:left;">
01001
</td>
<td style="text-align:left;">
021100
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Autauga County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3298
</td>
<td style="text-align:right;">
1502
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
860
</td>
<td style="text-align:right;">
3298
</td>
<td style="text-align:right;">
26.07641
</td>
<td style="text-align:right;">
0.6211
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
1605
</td>
<td style="text-align:right;">
18.504673
</td>
<td style="text-align:right;">
0.94340
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
1016
</td>
<td style="text-align:right;">
24.60630
</td>
<td style="text-align:right;">
0.32070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
307
</td>
<td style="text-align:right;">
24.10423
</td>
<td style="text-align:right;">
0.11920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
24.48980
</td>
<td style="text-align:right;">
0.17380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
2231
</td>
<td style="text-align:right;">
31.824294
</td>
<td style="text-align:right;">
0.8976
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
654
</td>
<td style="text-align:right;">
3565
</td>
<td style="text-align:right;">
18.34502
</td>
<td style="text-align:right;">
0.7018
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
411
</td>
<td style="text-align:right;">
12.46210
</td>
<td style="text-align:right;">
0.5001
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
22.37720
</td>
<td style="text-align:right;">
0.3934
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
936
</td>
<td style="text-align:right;">
2861
</td>
<td style="text-align:right;">
32.71583
</td>
<td style="text-align:right;">
0.9807
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
16.727273
</td>
<td style="text-align:right;">
0.5715
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
3155
</td>
<td style="text-align:right;">
0.2852615
</td>
<td style="text-align:right;">
0.25010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
3298
</td>
<td style="text-align:right;">
60.006064
</td>
<td style="text-align:right;">
0.77030
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1502
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.9320905
</td>
<td style="text-align:right;">
0.3234
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
659
</td>
<td style="text-align:right;">
43.8748336
</td>
<td style="text-align:right;">
0.9849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
3.325775
</td>
<td style="text-align:right;">
0.7062
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
10.3552532
</td>
<td style="text-align:right;">
0.73130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3298
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.33770
</td>
<td style="text-align:right;">
0.7351
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.69580
</td>
<td style="text-align:right;">
0.6028
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.77030
</td>
<td style="text-align:right;">
0.7631
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.10980
</td>
<td style="text-align:right;">
0.7827
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.91360
</td>
<td style="text-align:right;">
0.7557
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3499
</td>
<td style="text-align:right;">
1825
</td>
<td style="text-align:right;">
1462
</td>
<td style="text-align:right;">
1760
</td>
<td style="text-align:right;">
3499
</td>
<td style="text-align:right;">
50.300086
</td>
<td style="text-align:right;">
0.9396
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
966
</td>
<td style="text-align:right;">
4.347826
</td>
<td style="text-align:right;">
0.45390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
1274
</td>
<td style="text-align:right;">
33.437991
</td>
<td style="text-align:right;">
0.85200
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
27.65957
</td>
<td style="text-align:right;">
0.1824
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
478
</td>
<td style="text-align:right;">
1462
</td>
<td style="text-align:right;">
32.69494
</td>
<td style="text-align:right;">
0.61110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
422
</td>
<td style="text-align:right;">
2488
</td>
<td style="text-align:right;">
16.961415
</td>
<td style="text-align:right;">
0.7638
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
497
</td>
<td style="text-align:right;">
3499
</td>
<td style="text-align:right;">
14.204058
</td>
<td style="text-align:right;">
0.8246
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
853
</td>
<td style="text-align:right;">
24.378394
</td>
<td style="text-align:right;">
0.8688
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
808
</td>
<td style="text-align:right;">
23.09231
</td>
<td style="text-align:right;">
0.58290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
908
</td>
<td style="text-align:right;">
2691.100
</td>
<td style="text-align:right;">
33.740844
</td>
<td style="text-align:right;">
0.9808
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
179
</td>
<td style="text-align:right;">
811.6985
</td>
<td style="text-align:right;">
22.0525243
</td>
<td style="text-align:right;">
0.73230
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
3248
</td>
<td style="text-align:right;">
0.2463054
</td>
<td style="text-align:right;">
0.26220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1986
</td>
<td style="text-align:right;">
3498.713
</td>
<td style="text-align:right;">
56.7637257
</td>
<td style="text-align:right;">
0.717500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1825
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
1.5890411
</td>
<td style="text-align:right;">
0.3551
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
576
</td>
<td style="text-align:right;">
31.5616438
</td>
<td style="text-align:right;">
0.9594
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
1462
</td>
<td style="text-align:right;">
6.0191518
</td>
<td style="text-align:right;">
0.82690
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1461.993
</td>
<td style="text-align:right;">
10.123166
</td>
<td style="text-align:right;">
0.7364
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
3499
</td>
<td style="text-align:right;">
1.0860246
</td>
<td style="text-align:right;">
0.7013
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.59300
</td>
<td style="text-align:right;">
0.8073
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.42700
</td>
<td style="text-align:right;">
0.91560
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.717500
</td>
<td style="text-align:right;">
0.711400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.57910
</td>
<td style="text-align:right;">
0.9216
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.316600
</td>
<td style="text-align:right;">
0.9150
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 211, Autauga County, Alabama
</td>
<td style="text-align:right;">
17997
</td>
<td style="text-align:right;">
74000
</td>
<td style="text-align:right;">
20620
</td>
<td style="text-align:right;">
88600
</td>
<td style="text-align:right;">
20876.52
</td>
<td style="text-align:right;">
85840
</td>
<td style="text-align:right;">
-256.52
</td>
<td style="text-align:right;">
-0.0122875
</td>
<td style="text-align:right;">
2760
</td>
<td style="text-align:right;">
0.0321528
</td>
<td style="text-align:right;">
134.13
</td>
<td style="text-align:right;">
145.41
</td>
<td style="text-align:left;">
Autauga County, Alabama
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:left;">
CS388
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010200
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
010200
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
2612
</td>
<td style="text-align:right;">
1220
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
338
</td>
<td style="text-align:right;">
2605
</td>
<td style="text-align:right;">
12.97505
</td>
<td style="text-align:right;">
0.2907
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
1193
</td>
<td style="text-align:right;">
3.688181
</td>
<td style="text-align:right;">
0.14720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
928
</td>
<td style="text-align:right;">
18.53448
</td>
<td style="text-align:right;">
0.13090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
146
</td>
<td style="text-align:right;">
21.23288
</td>
<td style="text-align:right;">
0.09299
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
203
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
18.90130
</td>
<td style="text-align:right;">
0.05657
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
455
</td>
<td style="text-align:right;">
1872
</td>
<td style="text-align:right;">
24.305556
</td>
<td style="text-align:right;">
0.8016
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
2730
</td>
<td style="text-align:right;">
16.70330
</td>
<td style="text-align:right;">
0.6445
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
401
</td>
<td style="text-align:right;">
15.35222
</td>
<td style="text-align:right;">
0.6847
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
21.55436
</td>
<td style="text-align:right;">
0.3406
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
410
</td>
<td style="text-align:right;">
2038
</td>
<td style="text-align:right;">
20.11776
</td>
<td style="text-align:right;">
0.7755
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
779
</td>
<td style="text-align:right;">
8.215661
</td>
<td style="text-align:right;">
0.2181
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2510
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
2612
</td>
<td style="text-align:right;">
12.595712
</td>
<td style="text-align:right;">
0.31130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1220
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
3.1147541
</td>
<td style="text-align:right;">
0.4648
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
31.5573770
</td>
<td style="text-align:right;">
0.9545
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
1.862197
</td>
<td style="text-align:right;">
0.5509
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
4.0037244
</td>
<td style="text-align:right;">
0.40880
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2612
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.94057
</td>
<td style="text-align:right;">
0.3398
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.11188
</td>
<td style="text-align:right;">
0.2802
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.31130
</td>
<td style="text-align:right;">
0.3084
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.74300
</td>
<td style="text-align:right;">
0.6129
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.10675
</td>
<td style="text-align:right;">
0.3771
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2928
</td>
<td style="text-align:right;">
1312
</td>
<td style="text-align:right;">
1176
</td>
<td style="text-align:right;">
884
</td>
<td style="text-align:right;">
2928
</td>
<td style="text-align:right;">
30.191257
</td>
<td style="text-align:right;">
0.7334
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
1459
</td>
<td style="text-align:right;">
1.987663
</td>
<td style="text-align:right;">
0.13560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
830
</td>
<td style="text-align:right;">
8.554217
</td>
<td style="text-align:right;">
0.03726
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
38.72832
</td>
<td style="text-align:right;">
0.3964
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
1176
</td>
<td style="text-align:right;">
17.43197
</td>
<td style="text-align:right;">
0.12010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
294
</td>
<td style="text-align:right;">
2052
</td>
<td style="text-align:right;">
14.327485
</td>
<td style="text-align:right;">
0.6940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
2925
</td>
<td style="text-align:right;">
7.487179
</td>
<td style="text-align:right;">
0.5423
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
556
</td>
<td style="text-align:right;">
18.989071
</td>
<td style="text-align:right;">
0.6705
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
699
</td>
<td style="text-align:right;">
23.87295
</td>
<td style="text-align:right;">
0.63390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
489
</td>
<td style="text-align:right;">
2226.455
</td>
<td style="text-align:right;">
21.963167
</td>
<td style="text-align:right;">
0.8122
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
191
</td>
<td style="text-align:right;">
783.8820
</td>
<td style="text-align:right;">
24.3659136
</td>
<td style="text-align:right;">
0.77990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2710
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
398
</td>
<td style="text-align:right;">
2927.519
</td>
<td style="text-align:right;">
13.5951280
</td>
<td style="text-align:right;">
0.251100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1312
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
0.9908537
</td>
<td style="text-align:right;">
0.3111
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
30.4878049
</td>
<td style="text-align:right;">
0.9557
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1176
</td>
<td style="text-align:right;">
0.5102041
</td>
<td style="text-align:right;">
0.25900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
1176.202
</td>
<td style="text-align:right;">
6.886570
</td>
<td style="text-align:right;">
0.6115
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
2928
</td>
<td style="text-align:right;">
0.2390710
</td>
<td style="text-align:right;">
0.4961
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.22540
</td>
<td style="text-align:right;">
0.4183
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.99129
</td>
<td style="text-align:right;">
0.76340
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.251100
</td>
<td style="text-align:right;">
0.249000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.63340
</td>
<td style="text-align:right;">
0.5496
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.101190
</td>
<td style="text-align:right;">
0.5207
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
408000
</td>
<td style="text-align:left;">
\$408,000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Census Tract 102, Baldwin County, Alabama
</td>
<td style="text-align:right;">
23862
</td>
<td style="text-align:right;">
103200
</td>
<td style="text-align:right;">
26085
</td>
<td style="text-align:right;">
136900
</td>
<td style="text-align:right;">
27679.92
</td>
<td style="text-align:right;">
119712
</td>
<td style="text-align:right;">
-1594.92
</td>
<td style="text-align:right;">
-0.0576201
</td>
<td style="text-align:right;">
17188
</td>
<td style="text-align:right;">
0.1435779
</td>
<td style="text-align:right;">
128.38
</td>
<td style="text-align:right;">
166.27
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010500
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
010500
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
4230
</td>
<td style="text-align:right;">
1779
</td>
<td style="text-align:right;">
1425
</td>
<td style="text-align:right;">
498
</td>
<td style="text-align:right;">
3443
</td>
<td style="text-align:right;">
14.46413
</td>
<td style="text-align:right;">
0.3337
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
1625
</td>
<td style="text-align:right;">
10.215385
</td>
<td style="text-align:right;">
0.71790
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
1069
</td>
<td style="text-align:right;">
14.12535
</td>
<td style="text-align:right;">
0.04638
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
356
</td>
<td style="text-align:right;">
55.05618
</td>
<td style="text-align:right;">
0.73830
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
347
</td>
<td style="text-align:right;">
1425
</td>
<td style="text-align:right;">
24.35088
</td>
<td style="text-align:right;">
0.17010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
707
</td>
<td style="text-align:right;">
2945
</td>
<td style="text-align:right;">
24.006791
</td>
<td style="text-align:right;">
0.7967
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
4001
</td>
<td style="text-align:right;">
13.19670
</td>
<td style="text-align:right;">
0.5005
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
619
</td>
<td style="text-align:right;">
14.63357
</td>
<td style="text-align:right;">
0.6436
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
790
</td>
<td style="text-align:right;">
18.67612
</td>
<td style="text-align:right;">
0.1937
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
536
</td>
<td style="text-align:right;">
3096
</td>
<td style="text-align:right;">
17.31266
</td>
<td style="text-align:right;">
0.6572
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
165
</td>
<td style="text-align:right;">
920
</td>
<td style="text-align:right;">
17.934783
</td>
<td style="text-align:right;">
0.6102
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
4021
</td>
<td style="text-align:right;">
0.4973887
</td>
<td style="text-align:right;">
0.32320
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
754
</td>
<td style="text-align:right;">
4230
</td>
<td style="text-align:right;">
17.825059
</td>
<td style="text-align:right;">
0.40230
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1779
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
5.4525014
</td>
<td style="text-align:right;">
0.5525
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.4496908
</td>
<td style="text-align:right;">
0.4600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
1425
</td>
<td style="text-align:right;">
4.421053
</td>
<td style="text-align:right;">
0.7762
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
1425
</td>
<td style="text-align:right;">
6.3157895
</td>
<td style="text-align:right;">
0.56910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
787
</td>
<td style="text-align:right;">
4230
</td>
<td style="text-align:right;">
18.6052
</td>
<td style="text-align:right;">
0.9649
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.51890
</td>
<td style="text-align:right;">
0.5121
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.42790
</td>
<td style="text-align:right;">
0.4539
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.40230
</td>
<td style="text-align:right;">
0.3986
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.32270
</td>
<td style="text-align:right;">
0.8628
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.67180
</td>
<td style="text-align:right;">
0.6054
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
5877
</td>
<td style="text-align:right;">
1975
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
820
</td>
<td style="text-align:right;">
5244
</td>
<td style="text-align:right;">
15.636918
</td>
<td style="text-align:right;">
0.3902
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
2583
</td>
<td style="text-align:right;">
3.484321
</td>
<td style="text-align:right;">
0.33610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
159
</td>
<td style="text-align:right;">
1345
</td>
<td style="text-align:right;">
11.821561
</td>
<td style="text-align:right;">
0.10530
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
491
</td>
<td style="text-align:right;">
28.30957
</td>
<td style="text-align:right;">
0.1924
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
16.23094
</td>
<td style="text-align:right;">
0.09053
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
4248
</td>
<td style="text-align:right;">
13.418079
</td>
<td style="text-align:right;">
0.6669
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
5247
</td>
<td style="text-align:right;">
6.727654
</td>
<td style="text-align:right;">
0.4924
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1109
</td>
<td style="text-align:right;">
18.870172
</td>
<td style="text-align:right;">
0.6645
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1144
</td>
<td style="text-align:right;">
19.46571
</td>
<td style="text-align:right;">
0.34110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
4102.545
</td>
<td style="text-align:right;">
17.476956
</td>
<td style="text-align:right;">
0.6332
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
1286.1180
</td>
<td style="text-align:right;">
8.0085961
</td>
<td style="text-align:right;">
0.23410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5639
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
868
</td>
<td style="text-align:right;">
5877.481
</td>
<td style="text-align:right;">
14.7682323
</td>
<td style="text-align:right;">
0.270900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1975
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1.3164557
</td>
<td style="text-align:right;">
0.3359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
2.2784810
</td>
<td style="text-align:right;">
0.6271
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
0.4901961
</td>
<td style="text-align:right;">
0.25400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
1835.798
</td>
<td style="text-align:right;">
6.318779
</td>
<td style="text-align:right;">
0.5811
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
633
</td>
<td style="text-align:right;">
5877
</td>
<td style="text-align:right;">
10.7708014
</td>
<td style="text-align:right;">
0.9507
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.97613
</td>
<td style="text-align:right;">
0.3410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.96769
</td>
<td style="text-align:right;">
0.19610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.270900
</td>
<td style="text-align:right;">
0.268600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.74880
</td>
<td style="text-align:right;">
0.6077
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.963520
</td>
<td style="text-align:right;">
0.3406
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 105, Baldwin County, Alabama
</td>
<td style="text-align:right;">
21585
</td>
<td style="text-align:right;">
121100
</td>
<td style="text-align:right;">
28301
</td>
<td style="text-align:right;">
148500
</td>
<td style="text-align:right;">
25038.60
</td>
<td style="text-align:right;">
140476
</td>
<td style="text-align:right;">
3262.40
</td>
<td style="text-align:right;">
0.1302948
</td>
<td style="text-align:right;">
8024
</td>
<td style="text-align:right;">
0.0571201
</td>
<td style="text-align:right;">
191.57
</td>
<td style="text-align:right;">
213.49
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010600
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
010600
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3724
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
1147
</td>
<td style="text-align:right;">
1973
</td>
<td style="text-align:right;">
3724
</td>
<td style="text-align:right;">
52.98067
</td>
<td style="text-align:right;">
0.9342
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
142
</td>
<td style="text-align:right;">
1439
</td>
<td style="text-align:right;">
9.867964
</td>
<td style="text-align:right;">
0.69680
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
235
</td>
<td style="text-align:right;">
688
</td>
<td style="text-align:right;">
34.15698
</td>
<td style="text-align:right;">
0.62950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
459
</td>
<td style="text-align:right;">
40.74074
</td>
<td style="text-align:right;">
0.40290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
422
</td>
<td style="text-align:right;">
1147
</td>
<td style="text-align:right;">
36.79163
</td>
<td style="text-align:right;">
0.55150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
497
</td>
<td style="text-align:right;">
1876
</td>
<td style="text-align:right;">
26.492537
</td>
<td style="text-align:right;">
0.8354
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
511
</td>
<td style="text-align:right;">
3661
</td>
<td style="text-align:right;">
13.95794
</td>
<td style="text-align:right;">
0.5334
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
6.60580
</td>
<td style="text-align:right;">
0.1481
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1256
</td>
<td style="text-align:right;">
33.72718
</td>
<td style="text-align:right;">
0.9305
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
496
</td>
<td style="text-align:right;">
2522
</td>
<td style="text-align:right;">
19.66693
</td>
<td style="text-align:right;">
0.7587
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
838
</td>
<td style="text-align:right;">
32.696897
</td>
<td style="text-align:right;">
0.8779
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
3479
</td>
<td style="text-align:right;">
0.9198045
</td>
<td style="text-align:right;">
0.42810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2606
</td>
<td style="text-align:right;">
3724
</td>
<td style="text-align:right;">
69.978518
</td>
<td style="text-align:right;">
0.81840
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
1.4583333
</td>
<td style="text-align:right;">
0.3683
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
22.2916667
</td>
<td style="text-align:right;">
0.9036
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
1147
</td>
<td style="text-align:right;">
8.456844
</td>
<td style="text-align:right;">
0.8956
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
1147
</td>
<td style="text-align:right;">
14.5597210
</td>
<td style="text-align:right;">
0.82090
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3724
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.55130
</td>
<td style="text-align:right;">
0.7859
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.14330
</td>
<td style="text-align:right;">
0.8145
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.81840
</td>
<td style="text-align:right;">
0.8108
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.35240
</td>
<td style="text-align:right;">
0.8725
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.86540
</td>
<td style="text-align:right;">
0.8550
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
4115
</td>
<td style="text-align:right;">
1534
</td>
<td style="text-align:right;">
1268
</td>
<td style="text-align:right;">
1676
</td>
<td style="text-align:right;">
3997
</td>
<td style="text-align:right;">
41.931449
</td>
<td style="text-align:right;">
0.8814
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
294
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
16.252073
</td>
<td style="text-align:right;">
0.96740
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
814
</td>
<td style="text-align:right;">
41.891892
</td>
<td style="text-align:right;">
0.94320
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
44.93392
</td>
<td style="text-align:right;">
0.5438
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
1268
</td>
<td style="text-align:right;">
42.98107
</td>
<td style="text-align:right;">
0.83620
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
624
</td>
<td style="text-align:right;">
2425
</td>
<td style="text-align:right;">
25.731959
</td>
<td style="text-align:right;">
0.9002
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
994
</td>
<td style="text-align:right;">
4115
</td>
<td style="text-align:right;">
24.155529
</td>
<td style="text-align:right;">
0.9602
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
642
</td>
<td style="text-align:right;">
15.601458
</td>
<td style="text-align:right;">
0.4841
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1126
</td>
<td style="text-align:right;">
27.36331
</td>
<td style="text-align:right;">
0.81750
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
568
</td>
<td style="text-align:right;">
2989.000
</td>
<td style="text-align:right;">
19.003011
</td>
<td style="text-align:right;">
0.7045
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
715.0000
</td>
<td style="text-align:right;">
29.6503497
</td>
<td style="text-align:right;">
0.85920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
3825
</td>
<td style="text-align:right;">
1.4640523
</td>
<td style="text-align:right;">
0.53120
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2715
</td>
<td style="text-align:right;">
4115.000
</td>
<td style="text-align:right;">
65.9781288
</td>
<td style="text-align:right;">
0.773200
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1534
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
529
</td>
<td style="text-align:right;">
34.4850065
</td>
<td style="text-align:right;">
0.9685
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1268
</td>
<td style="text-align:right;">
7.9652997
</td>
<td style="text-align:right;">
0.87950
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
1268.000
</td>
<td style="text-align:right;">
7.018927
</td>
<td style="text-align:right;">
0.6184
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
4115
</td>
<td style="text-align:right;">
0.4131227
</td>
<td style="text-align:right;">
0.5707
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.54540
</td>
<td style="text-align:right;">
0.9754
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.39650
</td>
<td style="text-align:right;">
0.90810
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.773200
</td>
<td style="text-align:right;">
0.766700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.14500
</td>
<td style="text-align:right;">
0.7858
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.860100
</td>
<td style="text-align:right;">
0.9520
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8000000
</td>
<td style="text-align:left;">
\$8,000,000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Census Tract 106, Baldwin County, Alabama
</td>
<td style="text-align:right;">
17788
</td>
<td style="text-align:right;">
81600
</td>
<td style="text-align:right;">
16453
</td>
<td style="text-align:right;">
104700
</td>
<td style="text-align:right;">
20634.08
</td>
<td style="text-align:right;">
94656
</td>
<td style="text-align:right;">
-4181.08
</td>
<td style="text-align:right;">
-0.2026298
</td>
<td style="text-align:right;">
10044
</td>
<td style="text-align:right;">
0.1061105
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003011000
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
011000
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3758
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
1576
</td>
<td style="text-align:right;">
1053
</td>
<td style="text-align:right;">
3758
</td>
<td style="text-align:right;">
28.02022
</td>
<td style="text-align:right;">
0.6597
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
3.866432
</td>
<td style="text-align:right;">
0.16250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1297
</td>
<td style="text-align:right;">
22.59059
</td>
<td style="text-align:right;">
0.25080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
279
</td>
<td style="text-align:right;">
29.74910
</td>
<td style="text-align:right;">
0.19030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
376
</td>
<td style="text-align:right;">
1576
</td>
<td style="text-align:right;">
23.85787
</td>
<td style="text-align:right;">
0.15710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
744
</td>
<td style="text-align:right;">
2723
</td>
<td style="text-align:right;">
27.322806
</td>
<td style="text-align:right;">
0.8465
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
996
</td>
<td style="text-align:right;">
4137
</td>
<td style="text-align:right;">
24.07542
</td>
<td style="text-align:right;">
0.8462
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
713
</td>
<td style="text-align:right;">
18.97286
</td>
<td style="text-align:right;">
0.8429
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
804
</td>
<td style="text-align:right;">
21.39436
</td>
<td style="text-align:right;">
0.3306
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
763
</td>
<td style="text-align:right;">
3295
</td>
<td style="text-align:right;">
23.15630
</td>
<td style="text-align:right;">
0.8670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
1145
</td>
<td style="text-align:right;">
13.537118
</td>
<td style="text-align:right;">
0.4538
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
3475
</td>
<td style="text-align:right;">
1.4388489
</td>
<td style="text-align:right;">
0.51460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
516
</td>
<td style="text-align:right;">
3758
</td>
<td style="text-align:right;">
13.730708
</td>
<td style="text-align:right;">
0.33300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
606
</td>
<td style="text-align:right;">
30.1192843
</td>
<td style="text-align:right;">
0.9484
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1576
</td>
<td style="text-align:right;">
2.664975
</td>
<td style="text-align:right;">
0.6476
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
1576
</td>
<td style="text-align:right;">
6.0913706
</td>
<td style="text-align:right;">
0.55620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3758
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.67200
</td>
<td style="text-align:right;">
0.5579
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.00890
</td>
<td style="text-align:right;">
0.7581
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.33300
</td>
<td style="text-align:right;">
0.3299
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.63860
</td>
<td style="text-align:right;">
0.5614
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.65250
</td>
<td style="text-align:right;">
0.6030
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
4921
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
1539
</td>
<td style="text-align:right;">
4908
</td>
<td style="text-align:right;">
31.356968
</td>
<td style="text-align:right;">
0.7523
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
2105
</td>
<td style="text-align:right;">
7.125891
</td>
<td style="text-align:right;">
0.72850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
214
</td>
<td style="text-align:right;">
1471
</td>
<td style="text-align:right;">
14.547927
</td>
<td style="text-align:right;">
0.20260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
261
</td>
<td style="text-align:right;">
22.60536
</td>
<td style="text-align:right;">
0.1167
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
15.76212
</td>
<td style="text-align:right;">
0.07981
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
936
</td>
<td style="text-align:right;">
3332
</td>
<td style="text-align:right;">
28.091237
</td>
<td style="text-align:right;">
0.9206
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
861
</td>
<td style="text-align:right;">
4921
</td>
<td style="text-align:right;">
17.496444
</td>
<td style="text-align:right;">
0.8930
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1039
</td>
<td style="text-align:right;">
21.113595
</td>
<td style="text-align:right;">
0.7653
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1183
</td>
<td style="text-align:right;">
24.03983
</td>
<td style="text-align:right;">
0.64410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
585
</td>
<td style="text-align:right;">
3738.000
</td>
<td style="text-align:right;">
15.650080
</td>
<td style="text-align:right;">
0.5371
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
1151.0000
</td>
<td style="text-align:right;">
7.0373588
</td>
<td style="text-align:right;">
0.19000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
4546
</td>
<td style="text-align:right;">
2.2217334
</td>
<td style="text-align:right;">
0.61440
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1244
</td>
<td style="text-align:right;">
4921.000
</td>
<td style="text-align:right;">
25.2794148
</td>
<td style="text-align:right;">
0.427800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
527
</td>
<td style="text-align:right;">
26.6296109
</td>
<td style="text-align:right;">
0.9393
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
1732
</td>
<td style="text-align:right;">
4.7921478
</td>
<td style="text-align:right;">
0.77460
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
1732.000
</td>
<td style="text-align:right;">
8.718245
</td>
<td style="text-align:right;">
0.6904
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
4921
</td>
<td style="text-align:right;">
0.4064215
</td>
<td style="text-align:right;">
0.5688
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.37421
</td>
<td style="text-align:right;">
0.7528
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.75090
</td>
<td style="text-align:right;">
0.63780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.427800
</td>
<td style="text-align:right;">
0.424200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.08100
</td>
<td style="text-align:right;">
0.7597
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.633910
</td>
<td style="text-align:right;">
0.7366
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 110, Baldwin County, Alabama
</td>
<td style="text-align:right;">
19340
</td>
<td style="text-align:right;">
126400
</td>
<td style="text-align:right;">
23679
</td>
<td style="text-align:right;">
158700
</td>
<td style="text-align:right;">
22434.40
</td>
<td style="text-align:right;">
146624
</td>
<td style="text-align:right;">
1244.60
</td>
<td style="text-align:right;">
0.0554773
</td>
<td style="text-align:right;">
12076
</td>
<td style="text-align:right;">
0.0823603
</td>
<td style="text-align:right;">
129.69
</td>
<td style="text-align:right;">
188.85
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003011406
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
011406
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3317
</td>
<td style="text-align:right;">
6418
</td>
<td style="text-align:right;">
1307
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
3317
</td>
<td style="text-align:right;">
17.57612
</td>
<td style="text-align:right;">
0.4181
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
1789
</td>
<td style="text-align:right;">
3.912800
</td>
<td style="text-align:right;">
0.16690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
685
</td>
<td style="text-align:right;">
32.26277
</td>
<td style="text-align:right;">
0.57540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
622
</td>
<td style="text-align:right;">
45.65916
</td>
<td style="text-align:right;">
0.52130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
505
</td>
<td style="text-align:right;">
1307
</td>
<td style="text-align:right;">
38.63810
</td>
<td style="text-align:right;">
0.60430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
2255
</td>
<td style="text-align:right;">
7.450111
</td>
<td style="text-align:right;">
0.2800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
919
</td>
<td style="text-align:right;">
3677
</td>
<td style="text-align:right;">
24.99320
</td>
<td style="text-align:right;">
0.8623
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
13.62677
</td>
<td style="text-align:right;">
0.5791
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
673
</td>
<td style="text-align:right;">
20.28942
</td>
<td style="text-align:right;">
0.2668
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
2769
</td>
<td style="text-align:right;">
13.21777
</td>
<td style="text-align:right;">
0.4276
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
887
</td>
<td style="text-align:right;">
10.822999
</td>
<td style="text-align:right;">
0.3359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
180
</td>
<td style="text-align:right;">
3066
</td>
<td style="text-align:right;">
5.8708415
</td>
<td style="text-align:right;">
0.77920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
3317
</td>
<td style="text-align:right;">
14.259873
</td>
<td style="text-align:right;">
0.34330
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6418
</td>
<td style="text-align:right;">
3976
</td>
<td style="text-align:right;">
61.9507635
</td>
<td style="text-align:right;">
0.9655
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
5.9831723
</td>
<td style="text-align:right;">
0.7063
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1307
</td>
<td style="text-align:right;">
1.300689
</td>
<td style="text-align:right;">
0.4632
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1307
</td>
<td style="text-align:right;">
0.7651109
</td>
<td style="text-align:right;">
0.08684
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3317
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.33160
</td>
<td style="text-align:right;">
0.4577
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.38860
</td>
<td style="text-align:right;">
0.4323
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.34330
</td>
<td style="text-align:right;">
0.3401
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.58584
</td>
<td style="text-align:right;">
0.5335
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.64934
</td>
<td style="text-align:right;">
0.4576
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3226
</td>
<td style="text-align:right;">
7850
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
3215
</td>
<td style="text-align:right;">
7.091757
</td>
<td style="text-align:right;">
0.1241
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
2055
</td>
<td style="text-align:right;">
3.503650
</td>
<td style="text-align:right;">
0.33910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
302
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
26.514486
</td>
<td style="text-align:right;">
0.69300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
658
</td>
<td style="text-align:right;">
34.95441
</td>
<td style="text-align:right;">
0.3131
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
532
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
29.60490
</td>
<td style="text-align:right;">
0.52020
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
2726
</td>
<td style="text-align:right;">
4.695525
</td>
<td style="text-align:right;">
0.2384
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
530
</td>
<td style="text-align:right;">
3226
</td>
<td style="text-align:right;">
16.429014
</td>
<td style="text-align:right;">
0.8749
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
790
</td>
<td style="text-align:right;">
24.488531
</td>
<td style="text-align:right;">
0.8715
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
10.60136
</td>
<td style="text-align:right;">
0.05624
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
2884.000
</td>
<td style="text-align:right;">
9.708738
</td>
<td style="text-align:right;">
0.1832
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
792.0000
</td>
<td style="text-align:right;">
7.3232323
</td>
<td style="text-align:right;">
0.20270
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
3107
</td>
<td style="text-align:right;">
0.4827808
</td>
<td style="text-align:right;">
0.34070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
3226.000
</td>
<td style="text-align:right;">
0.4649721
</td>
<td style="text-align:right;">
0.002512
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7850
</td>
<td style="text-align:right;">
5394
</td>
<td style="text-align:right;">
68.7133758
</td>
<td style="text-align:right;">
0.9706
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
3.4904459
</td>
<td style="text-align:right;">
0.6697
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
1.2799110
</td>
<td style="text-align:right;">
0.41980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1797.000
</td>
<td style="text-align:right;">
1.446856
</td>
<td style="text-align:right;">
0.1647
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3226
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.09670
</td>
<td style="text-align:right;">
0.3785
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.65434
</td>
<td style="text-align:right;">
0.08785
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.002512
</td>
<td style="text-align:right;">
0.002491
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.40790
</td>
<td style="text-align:right;">
0.4381
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.161452
</td>
<td style="text-align:right;">
0.2215
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 114.06, Baldwin County, Alabama
</td>
<td style="text-align:right;">
29838
</td>
<td style="text-align:right;">
252000
</td>
<td style="text-align:right;">
32201
</td>
<td style="text-align:right;">
224200
</td>
<td style="text-align:right;">
34612.08
</td>
<td style="text-align:right;">
292320
</td>
<td style="text-align:right;">
-2411.08
</td>
<td style="text-align:right;">
-0.0696601
</td>
<td style="text-align:right;">
-68120
</td>
<td style="text-align:right;">
-0.2330323
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003011407
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
011407
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
5187
</td>
<td style="text-align:right;">
6687
</td>
<td style="text-align:right;">
2066
</td>
<td style="text-align:right;">
1404
</td>
<td style="text-align:right;">
5172
</td>
<td style="text-align:right;">
27.14617
</td>
<td style="text-align:right;">
0.6423
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
1935
</td>
<td style="text-align:right;">
8.888889
</td>
<td style="text-align:right;">
0.63280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
482
</td>
<td style="text-align:right;">
1433
</td>
<td style="text-align:right;">
33.63573
</td>
<td style="text-align:right;">
0.61530
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
367
</td>
<td style="text-align:right;">
633
</td>
<td style="text-align:right;">
57.97788
</td>
<td style="text-align:right;">
0.79510
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
849
</td>
<td style="text-align:right;">
2066
</td>
<td style="text-align:right;">
41.09390
</td>
<td style="text-align:right;">
0.67110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
278
</td>
<td style="text-align:right;">
3618
</td>
<td style="text-align:right;">
7.683803
</td>
<td style="text-align:right;">
0.2906
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
4945
</td>
<td style="text-align:right;">
20.76845
</td>
<td style="text-align:right;">
0.7735
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1398
</td>
<td style="text-align:right;">
26.95200
</td>
<td style="text-align:right;">
0.9629
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1263
</td>
<td style="text-align:right;">
24.34933
</td>
<td style="text-align:right;">
0.5302
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
596
</td>
<td style="text-align:right;">
3792
</td>
<td style="text-align:right;">
15.71730
</td>
<td style="text-align:right;">
0.5759
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
1633
</td>
<td style="text-align:right;">
9.675444
</td>
<td style="text-align:right;">
0.2833
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
4867
</td>
<td style="text-align:right;">
0.5958496
</td>
<td style="text-align:right;">
0.35240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
170
</td>
<td style="text-align:right;">
5187
</td>
<td style="text-align:right;">
3.277424
</td>
<td style="text-align:right;">
0.07984
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6687
</td>
<td style="text-align:right;">
2772
</td>
<td style="text-align:right;">
41.4535666
</td>
<td style="text-align:right;">
0.9251
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
2.9460147
</td>
<td style="text-align:right;">
0.6326
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
2066
</td>
<td style="text-align:right;">
4.356244
</td>
<td style="text-align:right;">
0.7729
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2066
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02586
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5187
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.01030
</td>
<td style="text-align:right;">
0.6516
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.70470
</td>
<td style="text-align:right;">
0.6077
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.07984
</td>
<td style="text-align:right;">
0.0791
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.72046
</td>
<td style="text-align:right;">
0.6014
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.51530
</td>
<td style="text-align:right;">
0.5852
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
5608
</td>
<td style="text-align:right;">
7576
</td>
<td style="text-align:right;">
2543
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
5602
</td>
<td style="text-align:right;">
18.886112
</td>
<td style="text-align:right;">
0.4835
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
2631
</td>
<td style="text-align:right;">
1.216268
</td>
<td style="text-align:right;">
0.05882
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
581
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
29.358262
</td>
<td style="text-align:right;">
0.77080
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
309
</td>
<td style="text-align:right;">
564
</td>
<td style="text-align:right;">
54.78723
</td>
<td style="text-align:right;">
0.7671
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
890
</td>
<td style="text-align:right;">
2543
</td>
<td style="text-align:right;">
34.99803
</td>
<td style="text-align:right;">
0.67250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
4433
</td>
<td style="text-align:right;">
5.188360
</td>
<td style="text-align:right;">
0.2698
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
776
</td>
<td style="text-align:right;">
5602
</td>
<td style="text-align:right;">
13.852196
</td>
<td style="text-align:right;">
0.8156
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1527
</td>
<td style="text-align:right;">
27.228959
</td>
<td style="text-align:right;">
0.9205
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
10.11056
</td>
<td style="text-align:right;">
0.05099
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
615
</td>
<td style="text-align:right;">
5035.000
</td>
<td style="text-align:right;">
12.214498
</td>
<td style="text-align:right;">
0.3295
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1746.0000
</td>
<td style="text-align:right;">
0.9163803
</td>
<td style="text-align:right;">
0.01566
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5573
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
441
</td>
<td style="text-align:right;">
5608.000
</td>
<td style="text-align:right;">
7.8637660
</td>
<td style="text-align:right;">
0.140300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7576
</td>
<td style="text-align:right;">
3055
</td>
<td style="text-align:right;">
40.3247096
</td>
<td style="text-align:right;">
0.9148
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
0.9503696
</td>
<td style="text-align:right;">
0.5383
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2543
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
2543.000
</td>
<td style="text-align:right;">
4.915454
</td>
<td style="text-align:right;">
0.4934
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
5608
</td>
<td style="text-align:right;">
0.1069900
</td>
<td style="text-align:right;">
0.4054
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.30022
</td>
<td style="text-align:right;">
0.4418
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.41144
</td>
<td style="text-align:right;">
0.04295
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.140300
</td>
<td style="text-align:right;">
0.139100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.44986
</td>
<td style="text-align:right;">
0.4589
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.301820
</td>
<td style="text-align:right;">
0.2416
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Census Tract 114.07, Baldwin County, Alabama
</td>
<td style="text-align:right;">
22317
</td>
<td style="text-align:right;">
292600
</td>
<td style="text-align:right;">
28418
</td>
<td style="text-align:right;">
241100
</td>
<td style="text-align:right;">
25887.72
</td>
<td style="text-align:right;">
339416
</td>
<td style="text-align:right;">
2530.28
</td>
<td style="text-align:right;">
0.0977406
</td>
<td style="text-align:right;">
-98316
</td>
<td style="text-align:right;">
-0.2896622
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
<tr>
<td style="text-align:left;">
01003011502
</td>
<td style="text-align:left;">
01003
</td>
<td style="text-align:left;">
011502
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Baldwin County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
9234
</td>
<td style="text-align:right;">
4606
</td>
<td style="text-align:right;">
3702
</td>
<td style="text-align:right;">
3160
</td>
<td style="text-align:right;">
9213
</td>
<td style="text-align:right;">
34.29936
</td>
<td style="text-align:right;">
0.7632
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
282
</td>
<td style="text-align:right;">
4002
</td>
<td style="text-align:right;">
7.046477
</td>
<td style="text-align:right;">
0.47570
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
2158
</td>
<td style="text-align:right;">
24.37442
</td>
<td style="text-align:right;">
0.31260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
582
</td>
<td style="text-align:right;">
1544
</td>
<td style="text-align:right;">
37.69430
</td>
<td style="text-align:right;">
0.33410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1108
</td>
<td style="text-align:right;">
3702
</td>
<td style="text-align:right;">
29.92977
</td>
<td style="text-align:right;">
0.33740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
997
</td>
<td style="text-align:right;">
6176
</td>
<td style="text-align:right;">
16.143135
</td>
<td style="text-align:right;">
0.6201
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2074
</td>
<td style="text-align:right;">
10111
</td>
<td style="text-align:right;">
20.51231
</td>
<td style="text-align:right;">
0.7670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1450
</td>
<td style="text-align:right;">
15.70284
</td>
<td style="text-align:right;">
0.7043
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2491
</td>
<td style="text-align:right;">
26.97639
</td>
<td style="text-align:right;">
0.6984
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1542
</td>
<td style="text-align:right;">
7577
</td>
<td style="text-align:right;">
20.35106
</td>
<td style="text-align:right;">
0.7842
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
684
</td>
<td style="text-align:right;">
2718
</td>
<td style="text-align:right;">
25.165563
</td>
<td style="text-align:right;">
0.7767
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
532
</td>
<td style="text-align:right;">
8697
</td>
<td style="text-align:right;">
6.1170519
</td>
<td style="text-align:right;">
0.78590
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3275
</td>
<td style="text-align:right;">
9234
</td>
<td style="text-align:right;">
35.466753
</td>
<td style="text-align:right;">
0.60970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4606
</td>
<td style="text-align:right;">
214
</td>
<td style="text-align:right;">
4.6461138
</td>
<td style="text-align:right;">
0.5268
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
828
</td>
<td style="text-align:right;">
17.9765523
</td>
<td style="text-align:right;">
0.8689
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3702
</td>
<td style="text-align:right;">
2.404106
</td>
<td style="text-align:right;">
0.6192
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
3702
</td>
<td style="text-align:right;">
7.9146407
</td>
<td style="text-align:right;">
0.64700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9234
</td>
<td style="text-align:right;">
0.0000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.96340
</td>
<td style="text-align:right;">
0.6387
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.74950
</td>
<td style="text-align:right;">
0.9623
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.60970
</td>
<td style="text-align:right;">
0.6040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.02590
</td>
<td style="text-align:right;">
0.7475
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
10.34850
</td>
<td style="text-align:right;">
0.8024
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
14165
</td>
<td style="text-align:right;">
6867
</td>
<td style="text-align:right;">
6002
</td>
<td style="text-align:right;">
2853
</td>
<td style="text-align:right;">
14165
</td>
<td style="text-align:right;">
20.141193
</td>
<td style="text-align:right;">
0.5175
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
7047
</td>
<td style="text-align:right;">
4.441606
</td>
<td style="text-align:right;">
0.46620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1181
</td>
<td style="text-align:right;">
4164
</td>
<td style="text-align:right;">
28.362152
</td>
<td style="text-align:right;">
0.74500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
887
</td>
<td style="text-align:right;">
1838
</td>
<td style="text-align:right;">
48.25898
</td>
<td style="text-align:right;">
0.6211
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2068
</td>
<td style="text-align:right;">
6002
</td>
<td style="text-align:right;">
34.45518
</td>
<td style="text-align:right;">
0.65900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1667
</td>
<td style="text-align:right;">
10750
</td>
<td style="text-align:right;">
15.506977
</td>
<td style="text-align:right;">
0.7286
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2527
</td>
<td style="text-align:right;">
14165
</td>
<td style="text-align:right;">
17.839746
</td>
<td style="text-align:right;">
0.8980
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3082
</td>
<td style="text-align:right;">
21.757854
</td>
<td style="text-align:right;">
0.7907
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2506
</td>
<td style="text-align:right;">
17.69149
</td>
<td style="text-align:right;">
0.24240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3004
</td>
<td style="text-align:right;">
11659.000
</td>
<td style="text-align:right;">
25.765503
</td>
<td style="text-align:right;">
0.9038
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
407
</td>
<td style="text-align:right;">
3482.0000
</td>
<td style="text-align:right;">
11.6886847
</td>
<td style="text-align:right;">
0.39940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
13519
</td>
<td style="text-align:right;">
2.6925068
</td>
<td style="text-align:right;">
0.65290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2755
</td>
<td style="text-align:right;">
14165.000
</td>
<td style="text-align:right;">
19.4493470
</td>
<td style="text-align:right;">
0.346300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6867
</td>
<td style="text-align:right;">
441
</td>
<td style="text-align:right;">
6.4220183
</td>
<td style="text-align:right;">
0.5555
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
7.6598223
</td>
<td style="text-align:right;">
0.7585
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
6002
</td>
<td style="text-align:right;">
1.5494835
</td>
<td style="text-align:right;">
0.46540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
184
</td>
<td style="text-align:right;">
6002.000
</td>
<td style="text-align:right;">
3.065645
</td>
<td style="text-align:right;">
0.3373
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14165
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.26930
</td>
<td style="text-align:right;">
0.7261
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.98920
</td>
<td style="text-align:right;">
0.76250
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.346300
</td>
<td style="text-align:right;">
0.343400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.29980
</td>
<td style="text-align:right;">
0.3856
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.904600
</td>
<td style="text-align:right;">
0.6398
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
\$0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8860000
</td>
<td style="text-align:left;">
\$8,860,000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Census Tract 115.02, Baldwin County, Alabama
</td>
<td style="text-align:right;">
20411
</td>
<td style="text-align:right;">
162700
</td>
<td style="text-align:right;">
22820
</td>
<td style="text-align:right;">
180400
</td>
<td style="text-align:right;">
23676.76
</td>
<td style="text-align:right;">
188732
</td>
<td style="text-align:right;">
-856.76
</td>
<td style="text-align:right;">
-0.0361857
</td>
<td style="text-align:right;">
-8332
</td>
<td style="text-align:right;">
-0.0441473
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Baldwin County, Alabama
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:left;">
CS380
</td>
</tr>
</tbody>
</table>

</div>

# LIHTC

``` r
svi_divisional_lihtc_df0 <- left_join(svi_divisional_lihtc, census_pull_df, join_by("GEOID_2010_trt" == "GEOID"))

svi_divisional_lihtc_df1 <- left_join(svi_divisional_lihtc_df0, hpi_df_10_20, join_by("GEOID_2010_trt" == "GEOID10")) %>%
                          unite("county_fips", FIPS_st, FIPS_county, sep = "") 

svi_divisional_lihtc_df <- left_join(svi_divisional_lihtc_df1, msa_csa_crosswalk, join_by("county_fips" == "county_fips"))

svi_divisional_lihtc_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
county_fips
</th>
<th style="text-align:left;">
FIPS_tract
</th>
<th style="text-align:left;">
state
</th>
<th style="text-align:left;">
state_name
</th>
<th style="text-align:left;">
county
</th>
<th style="text-align:right;">
region_number
</th>
<th style="text-align:left;">
region
</th>
<th style="text-align:right;">
division_number
</th>
<th style="text-align:left;">
division
</th>
<th style="text-align:right;">
E_TOTPOP_10
</th>
<th style="text-align:right;">
E_HU_10
</th>
<th style="text-align:right;">
E_HH_10
</th>
<th style="text-align:right;">
E_POV150_10
</th>
<th style="text-align:right;">
ET_POVSTATUS_10
</th>
<th style="text-align:right;">
EP_POV150_10
</th>
<th style="text-align:right;">
EPL_POV150_10
</th>
<th style="text-align:right;">
F_POV150_10
</th>
<th style="text-align:right;">
E_UNEMP_10
</th>
<th style="text-align:right;">
ET_EMPSTATUS_10
</th>
<th style="text-align:right;">
EP_UNEMP_10
</th>
<th style="text-align:right;">
EPL_UNEMP_10
</th>
<th style="text-align:right;">
F_UNEMP_10
</th>
<th style="text-align:right;">
E_HBURD_OWN_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_10
</th>
<th style="text-align:right;">
EP_HBURD_OWN_10
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_10
</th>
<th style="text-align:right;">
F_HBURD_OWN_10
</th>
<th style="text-align:right;">
E_HBURD_RENT_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_10
</th>
<th style="text-align:right;">
EP_HBURD_RENT_10
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_10
</th>
<th style="text-align:right;">
F_HBURD_RENT_10
</th>
<th style="text-align:right;">
E_HBURD_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_10
</th>
<th style="text-align:right;">
EP_HBURD_10
</th>
<th style="text-align:right;">
EPL_HBURD_10
</th>
<th style="text-align:right;">
F_HBURD_10
</th>
<th style="text-align:right;">
E_NOHSDP_10
</th>
<th style="text-align:right;">
ET_EDSTATUS_10
</th>
<th style="text-align:right;">
EP_NOHSDP_10
</th>
<th style="text-align:right;">
EPL_NOHSDP_10
</th>
<th style="text-align:right;">
F_NOHSDP_10
</th>
<th style="text-align:right;">
E_UNINSUR_12
</th>
<th style="text-align:right;">
ET_INSURSTATUS_12
</th>
<th style="text-align:right;">
EP_UNINSUR_12
</th>
<th style="text-align:right;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
F_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
F_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:right;">
EPL_AGE17_10
</th>
<th style="text-align:right;">
F_AGE17_10
</th>
<th style="text-align:right;">
E_DISABL_12
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_12
</th>
<th style="text-align:right;">
EP_DISABL_12
</th>
<th style="text-align:right;">
EPL_DISABL_12
</th>
<th style="text-align:right;">
F_DISABL_12
</th>
<th style="text-align:right;">
E_SNGPNT_10
</th>
<th style="text-align:right;">
ET_FAMILIES_10
</th>
<th style="text-align:right;">
EP_SNGPNT_10
</th>
<th style="text-align:right;">
EPL_SNGPNT_10
</th>
<th style="text-align:right;">
F_SNGPNT_10
</th>
<th style="text-align:right;">
E_LIMENG_10
</th>
<th style="text-align:right;">
ET_POPAGE5UP_10
</th>
<th style="text-align:right;">
EP_LIMENG_10
</th>
<th style="text-align:right;">
EPL_LIMENG_10
</th>
<th style="text-align:right;">
F_LIMENG_10
</th>
<th style="text-align:right;">
E_MINRTY_10
</th>
<th style="text-align:right;">
ET_POPETHRACE_10
</th>
<th style="text-align:right;">
EP_MINRTY_10
</th>
<th style="text-align:right;">
EPL_MINRTY_10
</th>
<th style="text-align:right;">
F_MINRTY_10
</th>
<th style="text-align:right;">
E_STRHU_10
</th>
<th style="text-align:right;">
E_MUNIT_10
</th>
<th style="text-align:right;">
EP_MUNIT_10
</th>
<th style="text-align:right;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
F_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
</th>
<th style="text-align:right;">
F_MOBILE_10
</th>
<th style="text-align:right;">
E_CROWD_10
</th>
<th style="text-align:right;">
ET_OCCUPANTS_10
</th>
<th style="text-align:right;">
EP_CROWD_10
</th>
<th style="text-align:right;">
EPL_CROWD_10
</th>
<th style="text-align:right;">
F_CROWD_10
</th>
<th style="text-align:right;">
E_NOVEH_10
</th>
<th style="text-align:right;">
ET_KNOWNVEH_10
</th>
<th style="text-align:right;">
EP_NOVEH_10
</th>
<th style="text-align:right;">
EPL_NOVEH_10
</th>
<th style="text-align:right;">
F_NOVEH_10
</th>
<th style="text-align:right;">
E_GROUPQ_10
</th>
<th style="text-align:right;">
ET_HHTYPE_10
</th>
<th style="text-align:right;">
EP_GROUPQ_10
</th>
<th style="text-align:right;">
EPL_GROUPQ_10
</th>
<th style="text-align:right;">
F_GROUPQ_10
</th>
<th style="text-align:right;">
SPL_THEME1_10
</th>
<th style="text-align:right;">
RPL_THEME1_10
</th>
<th style="text-align:right;">
F_THEME1_10
</th>
<th style="text-align:right;">
SPL_THEME2_10
</th>
<th style="text-align:right;">
RPL_THEME2_10
</th>
<th style="text-align:right;">
F_THEME2_10
</th>
<th style="text-align:right;">
SPL_THEME3_10
</th>
<th style="text-align:right;">
RPL_THEME3_10
</th>
<th style="text-align:right;">
F_THEME3_10
</th>
<th style="text-align:right;">
SPL_THEME4_10
</th>
<th style="text-align:right;">
RPL_THEME4_10
</th>
<th style="text-align:right;">
F_THEME4_10
</th>
<th style="text-align:right;">
SPL_THEMES_10
</th>
<th style="text-align:right;">
RPL_THEMES_10
</th>
<th style="text-align:right;">
F_TOTAL_10
</th>
<th style="text-align:right;">
E_TOTPOP_20
</th>
<th style="text-align:right;">
E_HU_20
</th>
<th style="text-align:right;">
E_HH_20
</th>
<th style="text-align:right;">
E_POV150_20
</th>
<th style="text-align:right;">
ET_POVSTATUS_20
</th>
<th style="text-align:right;">
EP_POV150_20
</th>
<th style="text-align:right;">
EPL_POV150_20
</th>
<th style="text-align:right;">
F_POV150_20
</th>
<th style="text-align:right;">
E_UNEMP_20
</th>
<th style="text-align:right;">
ET_EMPSTATUS_20
</th>
<th style="text-align:right;">
EP_UNEMP_20
</th>
<th style="text-align:right;">
EPL_UNEMP_20
</th>
<th style="text-align:right;">
F_UNEMP_20
</th>
<th style="text-align:right;">
E_HBURD_OWN_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_20
</th>
<th style="text-align:right;">
EP_HBURD_OWN_20
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_20
</th>
<th style="text-align:right;">
F_HBURD_OWN_20
</th>
<th style="text-align:right;">
E_HBURD_RENT_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_20
</th>
<th style="text-align:right;">
EP_HBURD_RENT_20
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_20
</th>
<th style="text-align:right;">
F_HBURD_RENT_20
</th>
<th style="text-align:right;">
E_HBURD_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_20
</th>
<th style="text-align:right;">
EP_HBURD_20
</th>
<th style="text-align:right;">
EPL_HBURD_20
</th>
<th style="text-align:right;">
F_HBURD_20
</th>
<th style="text-align:right;">
E_NOHSDP_20
</th>
<th style="text-align:right;">
ET_EDSTATUS_20
</th>
<th style="text-align:right;">
EP_NOHSDP_20
</th>
<th style="text-align:right;">
EPL_NOHSDP_20
</th>
<th style="text-align:right;">
F_NOHSDP_20
</th>
<th style="text-align:right;">
E_UNINSUR_20
</th>
<th style="text-align:right;">
ET_INSURSTATUS_20
</th>
<th style="text-align:right;">
EP_UNINSUR_20
</th>
<th style="text-align:right;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
F_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
F_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:right;">
EPL_AGE17_20
</th>
<th style="text-align:right;">
F_AGE17_20
</th>
<th style="text-align:right;">
E_DISABL_20
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_20
</th>
<th style="text-align:right;">
EP_DISABL_20
</th>
<th style="text-align:right;">
EPL_DISABL_20
</th>
<th style="text-align:right;">
F_DISABL_20
</th>
<th style="text-align:right;">
E_SNGPNT_20
</th>
<th style="text-align:right;">
ET_FAMILIES_20
</th>
<th style="text-align:right;">
EP_SNGPNT_20
</th>
<th style="text-align:right;">
EPL_SNGPNT_20
</th>
<th style="text-align:right;">
F_SNGPNT_20
</th>
<th style="text-align:right;">
E_LIMENG_20
</th>
<th style="text-align:right;">
ET_POPAGE5UP_20
</th>
<th style="text-align:right;">
EP_LIMENG_20
</th>
<th style="text-align:right;">
EPL_LIMENG_20
</th>
<th style="text-align:right;">
F_LIMENG_20
</th>
<th style="text-align:right;">
E_MINRTY_20
</th>
<th style="text-align:right;">
ET_POPETHRACE_20
</th>
<th style="text-align:right;">
EP_MINRTY_20
</th>
<th style="text-align:right;">
EPL_MINRTY_20
</th>
<th style="text-align:right;">
F_MINRTY_20
</th>
<th style="text-align:right;">
E_STRHU_20
</th>
<th style="text-align:right;">
E_MUNIT_20
</th>
<th style="text-align:right;">
EP_MUNIT_20
</th>
<th style="text-align:right;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
F_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
</th>
<th style="text-align:right;">
F_MOBILE_20
</th>
<th style="text-align:right;">
E_CROWD_20
</th>
<th style="text-align:right;">
ET_OCCUPANTS_20
</th>
<th style="text-align:right;">
EP_CROWD_20
</th>
<th style="text-align:right;">
EPL_CROWD_20
</th>
<th style="text-align:right;">
F_CROWD_20
</th>
<th style="text-align:right;">
E_NOVEH_20
</th>
<th style="text-align:right;">
ET_KNOWNVEH_20
</th>
<th style="text-align:right;">
EP_NOVEH_20
</th>
<th style="text-align:right;">
EPL_NOVEH_20
</th>
<th style="text-align:right;">
F_NOVEH_20
</th>
<th style="text-align:right;">
E_GROUPQ_20
</th>
<th style="text-align:right;">
ET_HHTYPE_20
</th>
<th style="text-align:right;">
EP_GROUPQ_20
</th>
<th style="text-align:right;">
EPL_GROUPQ_20
</th>
<th style="text-align:right;">
F_GROUPQ_20
</th>
<th style="text-align:right;">
SPL_THEME1_20
</th>
<th style="text-align:right;">
RPL_THEME1_20
</th>
<th style="text-align:right;">
F_THEME1_20
</th>
<th style="text-align:right;">
SPL_THEME2_20
</th>
<th style="text-align:right;">
RPL_THEME2_20
</th>
<th style="text-align:right;">
F_THEME2_20
</th>
<th style="text-align:right;">
SPL_THEME3_20
</th>
<th style="text-align:right;">
RPL_THEME3_20
</th>
<th style="text-align:right;">
F_THEME3_20
</th>
<th style="text-align:right;">
SPL_THEME4_20
</th>
<th style="text-align:right;">
RPL_THEME4_20
</th>
<th style="text-align:right;">
F_THEME4_20
</th>
<th style="text-align:right;">
SPL_THEMES_20
</th>
<th style="text-align:right;">
RPL_THEMES_20
</th>
<th style="text-align:right;">
F_TOTAL_20
</th>
<th style="text-align:right;">
pre10_lihtc_project_cnt
</th>
<th style="text-align:right;">
pre10_lihtc_project_dollars
</th>
<th style="text-align:right;">
post10_lihtc_project_cnt
</th>
<th style="text-align:right;">
post10_lihtc_project_dollars
</th>
<th style="text-align:right;">
lihtc_flag
</th>
<th style="text-align:left;">
lihtc_eligibility
</th>
<th style="text-align:left;">
NAME
</th>
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
<th style="text-align:right;">
Median_Income_10adj
</th>
<th style="text-align:right;">
Median_Home_Value_10adj
</th>
<th style="text-align:right;">
Median_Income_Change
</th>
<th style="text-align:right;">
Median_Income_Change_pct
</th>
<th style="text-align:right;">
Median_Home_Value_Change
</th>
<th style="text-align:right;">
Median_Home_Value_Change_pct
</th>
<th style="text-align:right;">
housing_price_index10
</th>
<th style="text-align:right;">
housing_price_index20
</th>
<th style="text-align:left;">
county_title
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:left;">
cbsa_code
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
10003002200
</td>
<td style="text-align:left;">
10003
</td>
<td style="text-align:left;">
002200
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
New Castle County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
3765
</td>
<td style="text-align:right;">
1162
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
2101
</td>
<td style="text-align:right;">
3738
</td>
<td style="text-align:right;">
56.20653
</td>
<td style="text-align:right;">
0.9604
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
191
</td>
<td style="text-align:right;">
1458
</td>
<td style="text-align:right;">
13.1001372
</td>
<td style="text-align:right;">
0.83340
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
194
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
58.96657
</td>
<td style="text-align:right;">
0.97690
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
628
</td>
<td style="text-align:right;">
60.03185
</td>
<td style="text-align:right;">
0.8081
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
59.66562
</td>
<td style="text-align:right;">
0.9664
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
779
</td>
<td style="text-align:right;">
1798
</td>
<td style="text-align:right;">
43.325918
</td>
<td style="text-align:right;">
0.9854
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
493
</td>
<td style="text-align:right;">
3339
</td>
<td style="text-align:right;">
14.764900
</td>
<td style="text-align:right;">
0.46710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
225
</td>
<td style="text-align:right;">
5.976096
</td>
<td style="text-align:right;">
0.11800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1429
</td>
<td style="text-align:right;">
37.9548473
</td>
<td style="text-align:right;">
0.989700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
417
</td>
<td style="text-align:right;">
1970
</td>
<td style="text-align:right;">
21.167513
</td>
<td style="text-align:right;">
0.784400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
314
</td>
<td style="text-align:right;">
714
</td>
<td style="text-align:right;">
43.97759
</td>
<td style="text-align:right;">
0.95280
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
500
</td>
<td style="text-align:right;">
3388
</td>
<td style="text-align:right;">
14.7579693
</td>
<td style="text-align:right;">
0.9426
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3668
</td>
<td style="text-align:right;">
3765
</td>
<td style="text-align:right;">
97.423639
</td>
<td style="text-align:right;">
0.9678
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1162
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
1.979346
</td>
<td style="text-align:right;">
0.4385
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
14.0020899
</td>
<td style="text-align:right;">
0.9922
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
308
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
32.18391
</td>
<td style="text-align:right;">
0.9657
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3765
</td>
<td style="text-align:right;">
0.185923
</td>
<td style="text-align:right;">
0.7635
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.21270
</td>
<td style="text-align:right;">
0.9244
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.787500
</td>
<td style="text-align:right;">
0.968900
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.9678
</td>
<td style="text-align:right;">
0.9550
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3408
</td>
<td style="text-align:right;">
0.8640
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
12.308800
</td>
<td style="text-align:right;">
0.9629
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
2815
</td>
<td style="text-align:right;">
994
</td>
<td style="text-align:right;">
737
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
2784
</td>
<td style="text-align:right;">
51.36494
</td>
<td style="text-align:right;">
0.9554
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
1114
</td>
<td style="text-align:right;">
9.515260
</td>
<td style="text-align:right;">
0.8545
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
340
</td>
<td style="text-align:right;">
42.05882
</td>
<td style="text-align:right;">
0.9621
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
397
</td>
<td style="text-align:right;">
39.04282
</td>
<td style="text-align:right;">
0.3733
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
737
</td>
<td style="text-align:right;">
40.43419
</td>
<td style="text-align:right;">
0.8083
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
606
</td>
<td style="text-align:right;">
1745
</td>
<td style="text-align:right;">
34.727794
</td>
<td style="text-align:right;">
0.9837
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
402
</td>
<td style="text-align:right;">
2815
</td>
<td style="text-align:right;">
14.280639
</td>
<td style="text-align:right;">
0.7435
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
17.868561
</td>
<td style="text-align:right;">
0.57060
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
846
</td>
<td style="text-align:right;">
30.053286
</td>
<td style="text-align:right;">
0.92830
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
491
</td>
<td style="text-align:right;">
1969.000
</td>
<td style="text-align:right;">
24.936516
</td>
<td style="text-align:right;">
0.88050
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
565.0000
</td>
<td style="text-align:right;">
26.72566
</td>
<td style="text-align:right;">
0.825600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
2625
</td>
<td style="text-align:right;">
21.3333333
</td>
<td style="text-align:right;">
0.9754
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2646
</td>
<td style="text-align:right;">
2815.000
</td>
<td style="text-align:right;">
93.99645
</td>
<td style="text-align:right;">
0.9462
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
994
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1.10664
</td>
<td style="text-align:right;">
0.3592
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
737
</td>
<td style="text-align:right;">
0.8141113
</td>
<td style="text-align:right;">
0.3774
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
108
</td>
<td style="text-align:right;">
737.000
</td>
<td style="text-align:right;">
14.65400
</td>
<td style="text-align:right;">
0.8690
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
2815
</td>
<td style="text-align:right;">
1.1012433
</td>
<td style="text-align:right;">
0.7405
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.3454
</td>
<td style="text-align:right;">
0.9499
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4.180400
</td>
<td style="text-align:right;">
0.984000
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.9462
</td>
<td style="text-align:right;">
0.9347
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.5261
</td>
<td style="text-align:right;">
0.4921
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
11.998100
</td>
<td style="text-align:right;">
0.9568
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 22, New Castle County, Delaware
</td>
<td style="text-align:right;">
14641
</td>
<td style="text-align:right;">
95400
</td>
<td style="text-align:right;">
23472
</td>
<td style="text-align:right;">
79600
</td>
<td style="text-align:right;">
16983.56
</td>
<td style="text-align:right;">
110664
</td>
<td style="text-align:right;">
6488.44
</td>
<td style="text-align:right;">
0.3820424
</td>
<td style="text-align:right;">
-31064
</td>
<td style="text-align:right;">
-0.2807056
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
New Castle County, Delaware
</td>
<td style="text-align:left;">
Philadelphia-Camden-Vineland, PA-NJ-DE-MD CSA
</td>
<td style="text-align:left;">
CS428
</td>
</tr>
<tr>
<td style="text-align:left;">
10003014501
</td>
<td style="text-align:left;">
10003
</td>
<td style="text-align:left;">
014501
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
New Castle County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
939
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
1386
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
70.89514
</td>
<td style="text-align:right;">
0.9895
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
1122
</td>
<td style="text-align:right;">
4.2780749
</td>
<td style="text-align:right;">
0.19780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.00257
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
541
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
75.45328
</td>
<td style="text-align:right;">
0.9611
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
541
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
69.62677
</td>
<td style="text-align:right;">
0.9944
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
618
</td>
<td style="text-align:right;">
23.786408
</td>
<td style="text-align:right;">
0.7845
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
2056
</td>
<td style="text-align:right;">
2.529183
</td>
<td style="text-align:right;">
0.02664
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
6.700767
</td>
<td style="text-align:right;">
0.15180
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0.3069054
</td>
<td style="text-align:right;">
0.005545
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
2056
</td>
<td style="text-align:right;">
8.560311
</td>
<td style="text-align:right;">
0.161200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.01071
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
0.4092072
</td>
<td style="text-align:right;">
0.2950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
184
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
9.411765
</td>
<td style="text-align:right;">
0.1643
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
939
</td>
<td style="text-align:right;">
370
</td>
<td style="text-align:right;">
39.403621
</td>
<td style="text-align:right;">
0.9074
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1488
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
146
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
18.79022
</td>
<td style="text-align:right;">
0.9044
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.99284
</td>
<td style="text-align:right;">
0.6440
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.624255
</td>
<td style="text-align:right;">
0.003867
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1643
</td>
<td style="text-align:right;">
0.1621
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.5229
</td>
<td style="text-align:right;">
0.4936
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
6.304295
</td>
<td style="text-align:right;">
0.2474
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2126
</td>
<td style="text-align:right;">
1068
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
1531
</td>
<td style="text-align:right;">
2126
</td>
<td style="text-align:right;">
72.01317
</td>
<td style="text-align:right;">
0.9948
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
136
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
12.746017
</td>
<td style="text-align:right;">
0.9370
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
89.47368
</td>
<td style="text-align:right;">
0.9990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
638
</td>
<td style="text-align:right;">
937
</td>
<td style="text-align:right;">
68.08965
</td>
<td style="text-align:right;">
0.9311
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
655
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
68.51464
</td>
<td style="text-align:right;">
0.9967
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
615
</td>
<td style="text-align:right;">
5.853658
</td>
<td style="text-align:right;">
0.2880
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
2126
</td>
<td style="text-align:right;">
8.231421
</td>
<td style="text-align:right;">
0.4254
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
174
</td>
<td style="text-align:right;">
8.184384
</td>
<td style="text-align:right;">
0.10240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
140
</td>
<td style="text-align:right;">
6.585136
</td>
<td style="text-align:right;">
0.03945
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
1986.000
</td>
<td style="text-align:right;">
6.092649
</td>
<td style="text-align:right;">
0.05007
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
102.0000
</td>
<td style="text-align:right;">
36.27451
</td>
<td style="text-align:right;">
0.923300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
2074
</td>
<td style="text-align:right;">
2.4108004
</td>
<td style="text-align:right;">
0.6655
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
2126.000
</td>
<td style="text-align:right;">
37.44120
</td>
<td style="text-align:right;">
0.5142
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1068
</td>
<td style="text-align:right;">
676
</td>
<td style="text-align:right;">
63.29588
</td>
<td style="text-align:right;">
0.9619
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
9.9372385
</td>
<td style="text-align:right;">
0.9670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
322
</td>
<td style="text-align:right;">
956.000
</td>
<td style="text-align:right;">
33.68201
</td>
<td style="text-align:right;">
0.9751
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2126
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2111
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.6419
</td>
<td style="text-align:right;">
0.8250
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1.780720
</td>
<td style="text-align:right;">
0.113400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5142
</td>
<td style="text-align:right;">
0.5080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.2951
</td>
<td style="text-align:right;">
0.8374
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.231920
</td>
<td style="text-align:right;">
0.6857
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 145.01, New Castle County, Delaware
</td>
<td style="text-align:right;">
9067
</td>
<td style="text-align:right;">
325000
</td>
<td style="text-align:right;">
7380
</td>
<td style="text-align:right;">
233800
</td>
<td style="text-align:right;">
10517.72
</td>
<td style="text-align:right;">
377000
</td>
<td style="text-align:right;">
-3137.72
</td>
<td style="text-align:right;">
-0.2983270
</td>
<td style="text-align:right;">
-143200
</td>
<td style="text-align:right;">
-0.3798408
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
New Castle County, Delaware
</td>
<td style="text-align:left;">
Philadelphia-Camden-Vineland, PA-NJ-DE-MD CSA
</td>
<td style="text-align:left;">
CS428
</td>
</tr>
<tr>
<td style="text-align:left;">
10003014502
</td>
<td style="text-align:left;">
10003
</td>
<td style="text-align:left;">
014502
</td>
<td style="text-align:left;">
DE
</td>
<td style="text-align:left;">
Delaware
</td>
<td style="text-align:left;">
New Castle County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
5783
</td>
<td style="text-align:right;">
1441
</td>
<td style="text-align:right;">
1105
</td>
<td style="text-align:right;">
2275
</td>
<td style="text-align:right;">
2996
</td>
<td style="text-align:right;">
75.93458
</td>
<td style="text-align:right;">
0.9934
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
132
</td>
<td style="text-align:right;">
2389
</td>
<td style="text-align:right;">
5.5253244
</td>
<td style="text-align:right;">
0.31400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
229
</td>
<td style="text-align:right;">
21.83406
</td>
<td style="text-align:right;">
0.19290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
652
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
74.42922
</td>
<td style="text-align:right;">
0.9567
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
702
</td>
<td style="text-align:right;">
1105
</td>
<td style="text-align:right;">
63.52941
</td>
<td style="text-align:right;">
0.9830
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
587
</td>
<td style="text-align:right;">
5.621806
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
180
</td>
<td style="text-align:right;">
6088
</td>
<td style="text-align:right;">
2.956636
</td>
<td style="text-align:right;">
0.03618
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
2.040463
</td>
<td style="text-align:right;">
0.02041
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
4.0290507
</td>
<td style="text-align:right;">
0.020260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
3410
</td>
<td style="text-align:right;">
4.428153
</td>
<td style="text-align:right;">
0.029160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
57.78894
</td>
<td style="text-align:right;">
0.98670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
5711
</td>
<td style="text-align:right;">
0.6828927
</td>
<td style="text-align:right;">
0.3758
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
491
</td>
<td style="text-align:right;">
5783
</td>
<td style="text-align:right;">
8.490403
</td>
<td style="text-align:right;">
0.1472
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1441
</td>
<td style="text-align:right;">
472
</td>
<td style="text-align:right;">
32.755031
</td>
<td style="text-align:right;">
0.8757
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
1105
</td>
<td style="text-align:right;">
4.7058824
</td>
<td style="text-align:right;">
0.8627
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
1105
</td>
<td style="text-align:right;">
21.90045
</td>
<td style="text-align:right;">
0.9274
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2787
</td>
<td style="text-align:right;">
5783
</td>
<td style="text-align:right;">
48.192979
</td>
<td style="text-align:right;">
0.9885
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.50968
</td>
<td style="text-align:right;">
0.4907
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
1.432330
</td>
<td style="text-align:right;">
0.040710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.1472
</td>
<td style="text-align:right;">
0.1453
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.8352
</td>
<td style="text-align:right;">
0.9660
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
7.924410
</td>
<td style="text-align:right;">
0.4875
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
6752
</td>
<td style="text-align:right;">
1338
</td>
<td style="text-align:right;">
1064
</td>
<td style="text-align:right;">
2027
</td>
<td style="text-align:right;">
2989
</td>
<td style="text-align:right;">
67.81532
</td>
<td style="text-align:right;">
0.9920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
2685
</td>
<td style="text-align:right;">
13.147114
</td>
<td style="text-align:right;">
0.9437
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
160
</td>
<td style="text-align:right;">
28.12500
</td>
<td style="text-align:right;">
0.7682
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
620
</td>
<td style="text-align:right;">
904
</td>
<td style="text-align:right;">
68.58407
</td>
<td style="text-align:right;">
0.9350
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
665
</td>
<td style="text-align:right;">
1064
</td>
<td style="text-align:right;">
62.50000
</td>
<td style="text-align:right;">
0.9903
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
1141
</td>
<td style="text-align:right;">
4.557406
</td>
<td style="text-align:right;">
0.2116
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
305
</td>
<td style="text-align:right;">
6727
</td>
<td style="text-align:right;">
4.533968
</td>
<td style="text-align:right;">
0.1964
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
201
</td>
<td style="text-align:right;">
2.976896
</td>
<td style="text-align:right;">
0.01566
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
1.525474
</td>
<td style="text-align:right;">
0.01056
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
182
</td>
<td style="text-align:right;">
2931.000
</td>
<td style="text-align:right;">
6.209485
</td>
<td style="text-align:right;">
0.05207
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
196.0000
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.008258
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
6752
</td>
<td style="text-align:right;">
0.4887441
</td>
<td style="text-align:right;">
0.3436
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1244
</td>
<td style="text-align:right;">
6752.000
</td>
<td style="text-align:right;">
18.42417
</td>
<td style="text-align:right;">
0.2554
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1338
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
28.84903
</td>
<td style="text-align:right;">
0.8433
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1064
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1168
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
1064.000
</td>
<td style="text-align:right;">
10.99624
</td>
<td style="text-align:right;">
0.7959
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3772
</td>
<td style="text-align:right;">
6752
</td>
<td style="text-align:right;">
55.8649289
</td>
<td style="text-align:right;">
0.9908
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3340
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.430148
</td>
<td style="text-align:right;">
0.002408
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.2554
</td>
<td style="text-align:right;">
0.2523
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.9268
</td>
<td style="text-align:right;">
0.6874
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
6.946348
</td>
<td style="text-align:right;">
0.3282
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 145.02, New Castle County, Delaware
</td>
<td style="text-align:right;">
3939
</td>
<td style="text-align:right;">
248000
</td>
<td style="text-align:right;">
3920
</td>
<td style="text-align:right;">
256700
</td>
<td style="text-align:right;">
4569.24
</td>
<td style="text-align:right;">
287680
</td>
<td style="text-align:right;">
-649.24
</td>
<td style="text-align:right;">
-0.1420893
</td>
<td style="text-align:right;">
-30980
</td>
<td style="text-align:right;">
-0.1076891
</td>
<td style="text-align:right;">
273.23
</td>
<td style="text-align:right;">
354.36
</td>
<td style="text-align:left;">
New Castle County, Delaware
</td>
<td style="text-align:left;">
Philadelphia-Camden-Vineland, PA-NJ-DE-MD CSA
</td>
<td style="text-align:left;">
CS428
</td>
</tr>
<tr>
<td style="text-align:left;">
11001001803
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
001803
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
2965
</td>
<td style="text-align:right;">
1716
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
712
</td>
<td style="text-align:right;">
2965
</td>
<td style="text-align:right;">
24.01349
</td>
<td style="text-align:right;">
0.5660
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
249
</td>
<td style="text-align:right;">
1742
</td>
<td style="text-align:right;">
14.2939150
</td>
<td style="text-align:right;">
0.86780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
24.14773
</td>
<td style="text-align:right;">
0.27170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
654
</td>
<td style="text-align:right;">
1233
</td>
<td style="text-align:right;">
53.04136
</td>
<td style="text-align:right;">
0.6691
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
739
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
46.62461
</td>
<td style="text-align:right;">
0.8084
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
530
</td>
<td style="text-align:right;">
2290
</td>
<td style="text-align:right;">
23.144105
</td>
<td style="text-align:right;">
0.7689
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
621
</td>
<td style="text-align:right;">
3307
</td>
<td style="text-align:right;">
18.778349
</td>
<td style="text-align:right;">
0.64490
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
14.907251
</td>
<td style="text-align:right;">
0.64050
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
433
</td>
<td style="text-align:right;">
14.6037099
</td>
<td style="text-align:right;">
0.130700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
397
</td>
<td style="text-align:right;">
2619
</td>
<td style="text-align:right;">
15.158457
</td>
<td style="text-align:right;">
0.509500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
666
</td>
<td style="text-align:right;">
19.21922
</td>
<td style="text-align:right;">
0.63310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
2875
</td>
<td style="text-align:right;">
11.2347826
</td>
<td style="text-align:right;">
0.9153
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2807
</td>
<td style="text-align:right;">
2965
</td>
<td style="text-align:right;">
94.671164
</td>
<td style="text-align:right;">
0.9471
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1716
</td>
<td style="text-align:right;">
1178
</td>
<td style="text-align:right;">
68.648019
</td>
<td style="text-align:right;">
0.9715
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
5.8044164
</td>
<td style="text-align:right;">
0.9056
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
605
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
38.17035
</td>
<td style="text-align:right;">
0.9779
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2965
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.65600
</td>
<td style="text-align:right;">
0.8220
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.829100
</td>
<td style="text-align:right;">
0.677100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.9471
</td>
<td style="text-align:right;">
0.9346
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.4173
</td>
<td style="text-align:right;">
0.8900
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.849500
</td>
<td style="text-align:right;">
0.8633
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
4161
</td>
<td style="text-align:right;">
1765
</td>
<td style="text-align:right;">
1623
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
4161
</td>
<td style="text-align:right;">
25.64287
</td>
<td style="text-align:right;">
0.6257
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
2245
</td>
<td style="text-align:right;">
7.394209
</td>
<td style="text-align:right;">
0.7467
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
216
</td>
<td style="text-align:right;">
27.77778
</td>
<td style="text-align:right;">
0.7579
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
1407
</td>
<td style="text-align:right;">
48.47193
</td>
<td style="text-align:right;">
0.5905
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
1623
</td>
<td style="text-align:right;">
45.71781
</td>
<td style="text-align:right;">
0.8878
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
624
</td>
<td style="text-align:right;">
2995
</td>
<td style="text-align:right;">
20.834725
</td>
<td style="text-align:right;">
0.8628
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
4161
</td>
<td style="text-align:right;">
13.530401
</td>
<td style="text-align:right;">
0.7154
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
9.613074
</td>
<td style="text-align:right;">
0.14970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
918
</td>
<td style="text-align:right;">
22.062004
</td>
<td style="text-align:right;">
0.56160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
3243.000
</td>
<td style="text-align:right;">
22.109158
</td>
<td style="text-align:right;">
0.80240
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
730.0000
</td>
<td style="text-align:right;">
27.39726
</td>
<td style="text-align:right;">
0.836500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
533
</td>
<td style="text-align:right;">
3914
</td>
<td style="text-align:right;">
13.6177823
</td>
<td style="text-align:right;">
0.9433
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3689
</td>
<td style="text-align:right;">
4161.000
</td>
<td style="text-align:right;">
88.65657
</td>
<td style="text-align:right;">
0.9109
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1765
</td>
<td style="text-align:right;">
1317
</td>
<td style="text-align:right;">
74.61756
</td>
<td style="text-align:right;">
0.9757
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
1623
</td>
<td style="text-align:right;">
12.2612446
</td>
<td style="text-align:right;">
0.9830
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
690
</td>
<td style="text-align:right;">
1623.000
</td>
<td style="text-align:right;">
42.51386
</td>
<td style="text-align:right;">
0.9878
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
4161
</td>
<td style="text-align:right;">
0.1201634
</td>
<td style="text-align:right;">
0.4852
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.8384
</td>
<td style="text-align:right;">
0.8685
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.293500
</td>
<td style="text-align:right;">
0.887500
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9109
</td>
<td style="text-align:right;">
0.8998
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6117
</td>
<td style="text-align:right;">
0.9260
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.654500
</td>
<td style="text-align:right;">
0.9370
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 18.03, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
26314
</td>
<td style="text-align:right;">
451600
</td>
<td style="text-align:right;">
27862
</td>
<td style="text-align:right;">
572400
</td>
<td style="text-align:right;">
30524.24
</td>
<td style="text-align:right;">
523856
</td>
<td style="text-align:right;">
-2662.24
</td>
<td style="text-align:right;">
-0.0872172
</td>
<td style="text-align:right;">
48544
</td>
<td style="text-align:right;">
0.0926667
</td>
<td style="text-align:right;">
243.08
</td>
<td style="text-align:right;">
337.39
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002001
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002001
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
2668
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
345
</td>
<td style="text-align:right;">
2668
</td>
<td style="text-align:right;">
12.93103
</td>
<td style="text-align:right;">
0.2723
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1550
</td>
<td style="text-align:right;">
0.8387097
</td>
<td style="text-align:right;">
0.02102
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
406
</td>
<td style="text-align:right;">
19.21182
</td>
<td style="text-align:right;">
0.12550
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
398
</td>
<td style="text-align:right;">
598
</td>
<td style="text-align:right;">
66.55518
</td>
<td style="text-align:right;">
0.8962
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
47.41036
</td>
<td style="text-align:right;">
0.8256
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
327
</td>
<td style="text-align:right;">
2055
</td>
<td style="text-align:right;">
15.912409
</td>
<td style="text-align:right;">
0.5720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
2427
</td>
<td style="text-align:right;">
9.023486
</td>
<td style="text-align:right;">
0.22340
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
308
</td>
<td style="text-align:right;">
11.544228
</td>
<td style="text-align:right;">
0.42830
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
457
</td>
<td style="text-align:right;">
17.1289355
</td>
<td style="text-align:right;">
0.196800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
299
</td>
<td style="text-align:right;">
1964
</td>
<td style="text-align:right;">
15.224033
</td>
<td style="text-align:right;">
0.511800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
606
</td>
<td style="text-align:right;">
36.46865
</td>
<td style="text-align:right;">
0.91070
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
2521
</td>
<td style="text-align:right;">
5.0376835
</td>
<td style="text-align:right;">
0.7970
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2082
</td>
<td style="text-align:right;">
2668
</td>
<td style="text-align:right;">
78.035982
</td>
<td style="text-align:right;">
0.8691
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
471
</td>
<td style="text-align:right;">
42.974453
</td>
<td style="text-align:right;">
0.9187
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
0.2988048
</td>
<td style="text-align:right;">
0.3128
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
34.06374
</td>
<td style="text-align:right;">
0.9705
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
2668
</td>
<td style="text-align:right;">
6.859070
</td>
<td style="text-align:right;">
0.9133
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.91432
</td>
<td style="text-align:right;">
0.3153
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.844600
</td>
<td style="text-align:right;">
0.685900
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8691
</td>
<td style="text-align:right;">
0.8576
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.2962
</td>
<td style="text-align:right;">
0.8507
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
8.924220
</td>
<td style="text-align:right;">
0.6368
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3578
</td>
<td style="text-align:right;">
1241
</td>
<td style="text-align:right;">
1181
</td>
<td style="text-align:right;">
1230
</td>
<td style="text-align:right;">
3571
</td>
<td style="text-align:right;">
34.44413
</td>
<td style="text-align:right;">
0.7939
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
1925
</td>
<td style="text-align:right;">
4.571429
</td>
<td style="text-align:right;">
0.4798
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
340
</td>
<td style="text-align:right;">
28.23529
</td>
<td style="text-align:right;">
0.7710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
534
</td>
<td style="text-align:right;">
841
</td>
<td style="text-align:right;">
63.49584
</td>
<td style="text-align:right;">
0.8822
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
630
</td>
<td style="text-align:right;">
1181
</td>
<td style="text-align:right;">
53.34462
</td>
<td style="text-align:right;">
0.9577
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
828
</td>
<td style="text-align:right;">
2392
</td>
<td style="text-align:right;">
34.615385
</td>
<td style="text-align:right;">
0.9832
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
3572
</td>
<td style="text-align:right;">
3.835386
</td>
<td style="text-align:right;">
0.1527
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
15.930687
</td>
<td style="text-align:right;">
0.47320
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
988
</td>
<td style="text-align:right;">
27.613192
</td>
<td style="text-align:right;">
0.86160
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
358
</td>
<td style="text-align:right;">
2588.000
</td>
<td style="text-align:right;">
13.833076
</td>
<td style="text-align:right;">
0.40220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
855.0000
</td>
<td style="text-align:right;">
21.98830
</td>
<td style="text-align:right;">
0.727700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
698
</td>
<td style="text-align:right;">
3258
</td>
<td style="text-align:right;">
21.4241866
</td>
<td style="text-align:right;">
0.9755
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3296
</td>
<td style="text-align:right;">
3578.000
</td>
<td style="text-align:right;">
92.11850
</td>
<td style="text-align:right;">
0.9329
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1241
</td>
<td style="text-align:right;">
838
</td>
<td style="text-align:right;">
67.52619
</td>
<td style="text-align:right;">
0.9678
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
216
</td>
<td style="text-align:right;">
1181
</td>
<td style="text-align:right;">
18.2895851
</td>
<td style="text-align:right;">
0.9962
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
1181.000
</td>
<td style="text-align:right;">
41.49026
</td>
<td style="text-align:right;">
0.9866
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
3578
</td>
<td style="text-align:right;">
2.6830632
</td>
<td style="text-align:right;">
0.8444
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3673
</td>
<td style="text-align:right;">
0.7557
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.440200
</td>
<td style="text-align:right;">
0.924000
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9329
</td>
<td style="text-align:right;">
0.9215
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.9750
</td>
<td style="text-align:right;">
0.9729
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
11.715400
</td>
<td style="text-align:right;">
0.9405
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 20.01, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
30587
</td>
<td style="text-align:right;">
654900
</td>
<td style="text-align:right;">
31601
</td>
<td style="text-align:right;">
840900
</td>
<td style="text-align:right;">
35480.92
</td>
<td style="text-align:right;">
759684
</td>
<td style="text-align:right;">
-3879.92
</td>
<td style="text-align:right;">
-0.1093523
</td>
<td style="text-align:right;">
81216
</td>
<td style="text-align:right;">
0.1069076
</td>
<td style="text-align:right;">
261.91
</td>
<td style="text-align:right;">
372.73
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002101
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002101
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
4735
</td>
<td style="text-align:right;">
2173
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
1273
</td>
<td style="text-align:right;">
4735
</td>
<td style="text-align:right;">
26.88490
</td>
<td style="text-align:right;">
0.6333
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
2545
</td>
<td style="text-align:right;">
14.9312377
</td>
<td style="text-align:right;">
0.88620
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
413
</td>
<td style="text-align:right;">
910
</td>
<td style="text-align:right;">
45.38462
</td>
<td style="text-align:right;">
0.87540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
887
</td>
<td style="text-align:right;">
59.52649
</td>
<td style="text-align:right;">
0.7988
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
941
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
52.36505
</td>
<td style="text-align:right;">
0.9021
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
974
</td>
<td style="text-align:right;">
3332
</td>
<td style="text-align:right;">
29.231693
</td>
<td style="text-align:right;">
0.8912
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1104
</td>
<td style="text-align:right;">
5530
</td>
<td style="text-align:right;">
19.963834
</td>
<td style="text-align:right;">
0.68980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
511
</td>
<td style="text-align:right;">
10.791975
</td>
<td style="text-align:right;">
0.37930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
962
</td>
<td style="text-align:right;">
20.3167899
</td>
<td style="text-align:right;">
0.326700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
4252
</td>
<td style="text-align:right;">
11.124177
</td>
<td style="text-align:right;">
0.294000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
318
</td>
<td style="text-align:right;">
997
</td>
<td style="text-align:right;">
31.89569
</td>
<td style="text-align:right;">
0.86880
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
523
</td>
<td style="text-align:right;">
4484
</td>
<td style="text-align:right;">
11.6636931
</td>
<td style="text-align:right;">
0.9194
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4604
</td>
<td style="text-align:right;">
4735
</td>
<td style="text-align:right;">
97.233368
</td>
<td style="text-align:right;">
0.9664
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2173
</td>
<td style="text-align:right;">
861
</td>
<td style="text-align:right;">
39.622642
</td>
<td style="text-align:right;">
0.9084
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
3.3388982
</td>
<td style="text-align:right;">
0.7732
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
427
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
23.76183
</td>
<td style="text-align:right;">
0.9390
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
4735
</td>
<td style="text-align:right;">
2.449842
</td>
<td style="text-align:right;">
0.8331
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.00260
</td>
<td style="text-align:right;">
0.8910
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.788200
</td>
<td style="text-align:right;">
0.656100
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9664
</td>
<td style="text-align:right;">
0.9536
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6346
</td>
<td style="text-align:right;">
0.9380
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
11.391800
</td>
<td style="text-align:right;">
0.9101
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
5693
</td>
<td style="text-align:right;">
2360
</td>
<td style="text-align:right;">
2143
</td>
<td style="text-align:right;">
1011
</td>
<td style="text-align:right;">
5693
</td>
<td style="text-align:right;">
17.75865
</td>
<td style="text-align:right;">
0.4264
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
3360
</td>
<td style="text-align:right;">
2.440476
</td>
<td style="text-align:right;">
0.1930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
390
</td>
<td style="text-align:right;">
1070
</td>
<td style="text-align:right;">
36.44860
</td>
<td style="text-align:right;">
0.9206
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
344
</td>
<td style="text-align:right;">
1073
</td>
<td style="text-align:right;">
32.05965
</td>
<td style="text-align:right;">
0.2338
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
734
</td>
<td style="text-align:right;">
2143
</td>
<td style="text-align:right;">
34.25105
</td>
<td style="text-align:right;">
0.6685
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
518
</td>
<td style="text-align:right;">
3999
</td>
<td style="text-align:right;">
12.953238
</td>
<td style="text-align:right;">
0.6323
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
320
</td>
<td style="text-align:right;">
5693
</td>
<td style="text-align:right;">
5.620938
</td>
<td style="text-align:right;">
0.2628
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
684
</td>
<td style="text-align:right;">
12.014755
</td>
<td style="text-align:right;">
0.25940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
25.294221
</td>
<td style="text-align:right;">
0.75820
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
387
</td>
<td style="text-align:right;">
4253.000
</td>
<td style="text-align:right;">
9.099459
</td>
<td style="text-align:right;">
0.15780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
438
</td>
<td style="text-align:right;">
1260.0000
</td>
<td style="text-align:right;">
34.76190
</td>
<td style="text-align:right;">
0.914000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
281
</td>
<td style="text-align:right;">
5250
</td>
<td style="text-align:right;">
5.3523810
</td>
<td style="text-align:right;">
0.8235
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5097
</td>
<td style="text-align:right;">
5693.000
</td>
<td style="text-align:right;">
89.53100
</td>
<td style="text-align:right;">
0.9159
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2360
</td>
<td style="text-align:right;">
1021
</td>
<td style="text-align:right;">
43.26271
</td>
<td style="text-align:right;">
0.9125
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
2143
</td>
<td style="text-align:right;">
3.2664489
</td>
<td style="text-align:right;">
0.7350
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
2143.000
</td>
<td style="text-align:right;">
22.86514
</td>
<td style="text-align:right;">
0.9409
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
5693
</td>
<td style="text-align:right;">
0.2107852
</td>
<td style="text-align:right;">
0.5502
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.1830
</td>
<td style="text-align:right;">
0.3950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.912900
</td>
<td style="text-align:right;">
0.728400
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9159
</td>
<td style="text-align:right;">
0.9047
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3186
</td>
<td style="text-align:right;">
0.8452
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.330400
</td>
<td style="text-align:right;">
0.6994
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
301689
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 21.01, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
25269
</td>
<td style="text-align:right;">
347700
</td>
<td style="text-align:right;">
37281
</td>
<td style="text-align:right;">
535600
</td>
<td style="text-align:right;">
29312.04
</td>
<td style="text-align:right;">
403332
</td>
<td style="text-align:right;">
7968.96
</td>
<td style="text-align:right;">
0.2718664
</td>
<td style="text-align:right;">
132268
</td>
<td style="text-align:right;">
0.3279383
</td>
<td style="text-align:right;">
306.75
</td>
<td style="text-align:right;">
608.13
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002102
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002102
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
4331
</td>
<td style="text-align:right;">
2300
</td>
<td style="text-align:right;">
1959
</td>
<td style="text-align:right;">
844
</td>
<td style="text-align:right;">
4314
</td>
<td style="text-align:right;">
19.56421
</td>
<td style="text-align:right;">
0.4524
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
2296
</td>
<td style="text-align:right;">
10.0174216
</td>
<td style="text-align:right;">
0.68400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
529
</td>
<td style="text-align:right;">
1073
</td>
<td style="text-align:right;">
49.30103
</td>
<td style="text-align:right;">
0.92220
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
427
</td>
<td style="text-align:right;">
886
</td>
<td style="text-align:right;">
48.19413
</td>
<td style="text-align:right;">
0.5547
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
1959
</td>
<td style="text-align:right;">
48.80041
</td>
<td style="text-align:right;">
0.8496
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
590
</td>
<td style="text-align:right;">
3048
</td>
<td style="text-align:right;">
19.356955
</td>
<td style="text-align:right;">
0.6744
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
505
</td>
<td style="text-align:right;">
4796
</td>
<td style="text-align:right;">
10.529608
</td>
<td style="text-align:right;">
0.28220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
795
</td>
<td style="text-align:right;">
18.356038
</td>
<td style="text-align:right;">
0.78820
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
781
</td>
<td style="text-align:right;">
18.0327869
</td>
<td style="text-align:right;">
0.227700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
533
</td>
<td style="text-align:right;">
3865
</td>
<td style="text-align:right;">
13.790427
</td>
<td style="text-align:right;">
0.435100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
253
</td>
<td style="text-align:right;">
879
</td>
<td style="text-align:right;">
28.78271
</td>
<td style="text-align:right;">
0.82940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
3966
</td>
<td style="text-align:right;">
5.6480081
</td>
<td style="text-align:right;">
0.8164
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4191
</td>
<td style="text-align:right;">
4331
</td>
<td style="text-align:right;">
96.767490
</td>
<td style="text-align:right;">
0.9624
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2300
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
16.869565
</td>
<td style="text-align:right;">
0.7553
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
1959
</td>
<td style="text-align:right;">
3.8284839
</td>
<td style="text-align:right;">
0.8124
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
492
</td>
<td style="text-align:right;">
1959
</td>
<td style="text-align:right;">
25.11485
</td>
<td style="text-align:right;">
0.9448
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4331
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.94260
</td>
<td style="text-align:right;">
0.6280
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.096800
</td>
<td style="text-align:right;">
0.806900
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9624
</td>
<td style="text-align:right;">
0.9497
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.0748
</td>
<td style="text-align:right;">
0.7667
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.076600
</td>
<td style="text-align:right;">
0.7841
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
5607
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
2132
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
5446
</td>
<td style="text-align:right;">
15.14873
</td>
<td style="text-align:right;">
0.3486
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
3245
</td>
<td style="text-align:right;">
6.440678
</td>
<td style="text-align:right;">
0.6748
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
278
</td>
<td style="text-align:right;">
1266
</td>
<td style="text-align:right;">
21.95893
</td>
<td style="text-align:right;">
0.5388
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
866
</td>
<td style="text-align:right;">
27.59815
</td>
<td style="text-align:right;">
0.1650
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
517
</td>
<td style="text-align:right;">
2132
</td>
<td style="text-align:right;">
24.24953
</td>
<td style="text-align:right;">
0.3348
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
4263
</td>
<td style="text-align:right;">
14.238799
</td>
<td style="text-align:right;">
0.6782
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
305
</td>
<td style="text-align:right;">
5598
</td>
<td style="text-align:right;">
5.448374
</td>
<td style="text-align:right;">
0.2520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
819
</td>
<td style="text-align:right;">
14.606742
</td>
<td style="text-align:right;">
0.40290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1108
</td>
<td style="text-align:right;">
19.761013
</td>
<td style="text-align:right;">
0.41430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
568
</td>
<td style="text-align:right;">
4496.000
</td>
<td style="text-align:right;">
12.633452
</td>
<td style="text-align:right;">
0.33400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
1306.0000
</td>
<td style="text-align:right;">
10.03063
</td>
<td style="text-align:right;">
0.318400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
396
</td>
<td style="text-align:right;">
5261
</td>
<td style="text-align:right;">
7.5270861
</td>
<td style="text-align:right;">
0.8749
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4997
</td>
<td style="text-align:right;">
5607.000
</td>
<td style="text-align:right;">
89.12074
</td>
<td style="text-align:right;">
0.9136
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2369
</td>
<td style="text-align:right;">
523
</td>
<td style="text-align:right;">
22.07683
</td>
<td style="text-align:right;">
0.7910
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
2132
</td>
<td style="text-align:right;">
4.6435272
</td>
<td style="text-align:right;">
0.8330
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
2132.000
</td>
<td style="text-align:right;">
20.59099
</td>
<td style="text-align:right;">
0.9275
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
5607
</td>
<td style="text-align:right;">
0.4458712
</td>
<td style="text-align:right;">
0.6371
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.2884
</td>
<td style="text-align:right;">
0.4249
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.344500
</td>
<td style="text-align:right;">
0.383400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.9136
</td>
<td style="text-align:right;">
0.9025
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3686
</td>
<td style="text-align:right;">
0.8631
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
8.915100
</td>
<td style="text-align:right;">
0.6434
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 21.02, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
30821
</td>
<td style="text-align:right;">
384700
</td>
<td style="text-align:right;">
43067
</td>
<td style="text-align:right;">
533900
</td>
<td style="text-align:right;">
35752.36
</td>
<td style="text-align:right;">
446252
</td>
<td style="text-align:right;">
7314.64
</td>
<td style="text-align:right;">
0.2045918
</td>
<td style="text-align:right;">
87648
</td>
<td style="text-align:right;">
0.1964092
</td>
<td style="text-align:right;">
258.28
</td>
<td style="text-align:right;">
488.79
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002400
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002400
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
3771
</td>
<td style="text-align:right;">
1371
</td>
<td style="text-align:right;">
1326
</td>
<td style="text-align:right;">
735
</td>
<td style="text-align:right;">
3771
</td>
<td style="text-align:right;">
19.49085
</td>
<td style="text-align:right;">
0.4500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
2184
</td>
<td style="text-align:right;">
16.0714286
</td>
<td style="text-align:right;">
0.91120
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
911
</td>
<td style="text-align:right;">
23.16136
</td>
<td style="text-align:right;">
0.23540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
51.08434
</td>
<td style="text-align:right;">
0.6239
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
423
</td>
<td style="text-align:right;">
1326
</td>
<td style="text-align:right;">
31.90045
</td>
<td style="text-align:right;">
0.3851
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
2913
</td>
<td style="text-align:right;">
18.777892
</td>
<td style="text-align:right;">
0.6600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
3652
</td>
<td style="text-align:right;">
12.102957
</td>
<td style="text-align:right;">
0.34850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
644
</td>
<td style="text-align:right;">
17.077698
</td>
<td style="text-align:right;">
0.74380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
15.8313445
</td>
<td style="text-align:right;">
0.157300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
412
</td>
<td style="text-align:right;">
2993
</td>
<td style="text-align:right;">
13.765453
</td>
<td style="text-align:right;">
0.433500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
750
</td>
<td style="text-align:right;">
17.46667
</td>
<td style="text-align:right;">
0.57510
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
3658
</td>
<td style="text-align:right;">
2.5150355
</td>
<td style="text-align:right;">
0.6532
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3316
</td>
<td style="text-align:right;">
3771
</td>
<td style="text-align:right;">
87.934235
</td>
<td style="text-align:right;">
0.9116
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1371
</td>
<td style="text-align:right;">
232
</td>
<td style="text-align:right;">
16.921955
</td>
<td style="text-align:right;">
0.7557
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
1326
</td>
<td style="text-align:right;">
3.0165913
</td>
<td style="text-align:right;">
0.7456
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
458
</td>
<td style="text-align:right;">
1326
</td>
<td style="text-align:right;">
34.53997
</td>
<td style="text-align:right;">
0.9721
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3771
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.75480
</td>
<td style="text-align:right;">
0.5675
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.562900
</td>
<td style="text-align:right;">
0.528200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.9116
</td>
<td style="text-align:right;">
0.8996
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.0357
</td>
<td style="text-align:right;">
0.7509
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.265000
</td>
<td style="text-align:right;">
0.6847
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4059
</td>
<td style="text-align:right;">
1435
</td>
<td style="text-align:right;">
1356
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
4015
</td>
<td style="text-align:right;">
13.67372
</td>
<td style="text-align:right;">
0.3051
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
2778
</td>
<td style="text-align:right;">
3.779698
</td>
<td style="text-align:right;">
0.3758
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
159
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
18.15068
</td>
<td style="text-align:right;">
0.3556
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
31.60083
</td>
<td style="text-align:right;">
0.2269
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
311
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
22.91820
</td>
<td style="text-align:right;">
0.2843
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
775
</td>
<td style="text-align:right;">
3420
</td>
<td style="text-align:right;">
22.660819
</td>
<td style="text-align:right;">
0.8954
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
337
</td>
<td style="text-align:right;">
4003
</td>
<td style="text-align:right;">
8.418686
</td>
<td style="text-align:right;">
0.4368
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
486
</td>
<td style="text-align:right;">
11.973392
</td>
<td style="text-align:right;">
0.25750
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
448
</td>
<td style="text-align:right;">
11.037201
</td>
<td style="text-align:right;">
0.08946
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
357
</td>
<td style="text-align:right;">
3565.455
</td>
<td style="text-align:right;">
10.012749
</td>
<td style="text-align:right;">
0.19900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
685.6722
</td>
<td style="text-align:right;">
14.73007
</td>
<td style="text-align:right;">
0.508900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
660
</td>
<td style="text-align:right;">
3925
</td>
<td style="text-align:right;">
16.8152866
</td>
<td style="text-align:right;">
0.9608
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2687
</td>
<td style="text-align:right;">
4059.093
</td>
<td style="text-align:right;">
66.19705
</td>
<td style="text-align:right;">
0.7815
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1435
</td>
<td style="text-align:right;">
376
</td>
<td style="text-align:right;">
26.20209
</td>
<td style="text-align:right;">
0.8256
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
104
</td>
<td style="text-align:right;">
1356
</td>
<td style="text-align:right;">
7.6696165
</td>
<td style="text-align:right;">
0.9358
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
1356.438
</td>
<td style="text-align:right;">
24.18097
</td>
<td style="text-align:right;">
0.9469
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
4059
</td>
<td style="text-align:right;">
1.7738359
</td>
<td style="text-align:right;">
0.7960
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.2974
</td>
<td style="text-align:right;">
0.4283
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.015660
</td>
<td style="text-align:right;">
0.204600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7815
</td>
<td style="text-align:right;">
0.7720
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6843
</td>
<td style="text-align:right;">
0.9401
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
8.778860
</td>
<td style="text-align:right;">
0.6239
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 24, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
31431
</td>
<td style="text-align:right;">
410000
</td>
<td style="text-align:right;">
46985
</td>
<td style="text-align:right;">
623600
</td>
<td style="text-align:right;">
36459.96
</td>
<td style="text-align:right;">
475600
</td>
<td style="text-align:right;">
10525.04
</td>
<td style="text-align:right;">
0.2886739
</td>
<td style="text-align:right;">
148000
</td>
<td style="text-align:right;">
0.3111859
</td>
<td style="text-align:right;">
320.66
</td>
<td style="text-align:right;">
611.78
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002701
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002701
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
5414
</td>
<td style="text-align:right;">
2927
</td>
<td style="text-align:right;">
2716
</td>
<td style="text-align:right;">
974
</td>
<td style="text-align:right;">
5224
</td>
<td style="text-align:right;">
18.64472
</td>
<td style="text-align:right;">
0.4281
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
4012
</td>
<td style="text-align:right;">
3.7637089
</td>
<td style="text-align:right;">
0.15460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
638
</td>
<td style="text-align:right;">
34.63950
</td>
<td style="text-align:right;">
0.64400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
973
</td>
<td style="text-align:right;">
2078
</td>
<td style="text-align:right;">
46.82387
</td>
<td style="text-align:right;">
0.5234
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1194
</td>
<td style="text-align:right;">
2716
</td>
<td style="text-align:right;">
43.96171
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
579
</td>
<td style="text-align:right;">
3999
</td>
<td style="text-align:right;">
14.478620
</td>
<td style="text-align:right;">
0.5249
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
546
</td>
<td style="text-align:right;">
4681
</td>
<td style="text-align:right;">
11.664174
</td>
<td style="text-align:right;">
0.33000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
378
</td>
<td style="text-align:right;">
6.981899
</td>
<td style="text-align:right;">
0.16380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
586
</td>
<td style="text-align:right;">
10.8237902
</td>
<td style="text-align:right;">
0.070390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
4153
</td>
<td style="text-align:right;">
2.456056
</td>
<td style="text-align:right;">
0.007624
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
229
</td>
<td style="text-align:right;">
827
</td>
<td style="text-align:right;">
27.69045
</td>
<td style="text-align:right;">
0.81270
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
198
</td>
<td style="text-align:right;">
5197
</td>
<td style="text-align:right;">
3.8098903
</td>
<td style="text-align:right;">
0.7406
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2851
</td>
<td style="text-align:right;">
5414
</td>
<td style="text-align:right;">
52.659771
</td>
<td style="text-align:right;">
0.7261
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2927
</td>
<td style="text-align:right;">
2081
</td>
<td style="text-align:right;">
71.096686
</td>
<td style="text-align:right;">
0.9751
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
2716
</td>
<td style="text-align:right;">
6.1487482
</td>
<td style="text-align:right;">
0.9168
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1275
</td>
<td style="text-align:right;">
2716
</td>
<td style="text-align:right;">
46.94404
</td>
<td style="text-align:right;">
0.9890
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
5414
</td>
<td style="text-align:right;">
3.509420
</td>
<td style="text-align:right;">
0.8632
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.18410
</td>
<td style="text-align:right;">
0.3915
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.795114
</td>
<td style="text-align:right;">
0.123700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7261
</td>
<td style="text-align:right;">
0.7165
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.9250
</td>
<td style="text-align:right;">
0.9729
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
8.630314
</td>
<td style="text-align:right;">
0.5962
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
6651
</td>
<td style="text-align:right;">
2920
</td>
<td style="text-align:right;">
2747
</td>
<td style="text-align:right;">
733
</td>
<td style="text-align:right;">
6508
</td>
<td style="text-align:right;">
11.26306
</td>
<td style="text-align:right;">
0.2337
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
4736
</td>
<td style="text-align:right;">
2.132601
</td>
<td style="text-align:right;">
0.1533
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
122
</td>
<td style="text-align:right;">
779
</td>
<td style="text-align:right;">
15.66110
</td>
<td style="text-align:right;">
0.2359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
900
</td>
<td style="text-align:right;">
1968
</td>
<td style="text-align:right;">
45.73171
</td>
<td style="text-align:right;">
0.5282
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1022
</td>
<td style="text-align:right;">
2747
</td>
<td style="text-align:right;">
37.20422
</td>
<td style="text-align:right;">
0.7403
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
612
</td>
<td style="text-align:right;">
4924
</td>
<td style="text-align:right;">
12.428920
</td>
<td style="text-align:right;">
0.6126
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
6508
</td>
<td style="text-align:right;">
5.669945
</td>
<td style="text-align:right;">
0.2662
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
5.788603
</td>
<td style="text-align:right;">
0.04676
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1117
</td>
<td style="text-align:right;">
16.794467
</td>
<td style="text-align:right;">
0.25460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
389
</td>
<td style="text-align:right;">
5391.000
</td>
<td style="text-align:right;">
7.215730
</td>
<td style="text-align:right;">
0.08129
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
234
</td>
<td style="text-align:right;">
895.0000
</td>
<td style="text-align:right;">
26.14525
</td>
<td style="text-align:right;">
0.815400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
6138
</td>
<td style="text-align:right;">
1.7758227
</td>
<td style="text-align:right;">
0.5949
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3988
</td>
<td style="text-align:right;">
6651.000
</td>
<td style="text-align:right;">
59.96091
</td>
<td style="text-align:right;">
0.7366
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2920
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
67.87671
</td>
<td style="text-align:right;">
0.9685
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
247
</td>
<td style="text-align:right;">
2747
</td>
<td style="text-align:right;">
8.9916272
</td>
<td style="text-align:right;">
0.9563
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1315
</td>
<td style="text-align:right;">
2747.000
</td>
<td style="text-align:right;">
47.87040
</td>
<td style="text-align:right;">
0.9925
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
6651
</td>
<td style="text-align:right;">
2.1500526
</td>
<td style="text-align:right;">
0.8197
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.0061
</td>
<td style="text-align:right;">
0.3411
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.792950
</td>
<td style="text-align:right;">
0.117000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7366
</td>
<td style="text-align:right;">
0.7276
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.9170
</td>
<td style="text-align:right;">
0.9684
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
8.452650
</td>
<td style="text-align:right;">
0.5694
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 27.01, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
33454
</td>
<td style="text-align:right;">
563600
</td>
<td style="text-align:right;">
52608
</td>
<td style="text-align:right;">
713500
</td>
<td style="text-align:right;">
38806.64
</td>
<td style="text-align:right;">
653776
</td>
<td style="text-align:right;">
13801.36
</td>
<td style="text-align:right;">
0.3556443
</td>
<td style="text-align:right;">
59724
</td>
<td style="text-align:right;">
0.0913524
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
<tr>
<td style="text-align:left;">
11001002900
</td>
<td style="text-align:left;">
11001
</td>
<td style="text-align:left;">
002900
</td>
<td style="text-align:left;">
DC
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:left;">
District of Columbia
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
South Atlantic Division
</td>
<td style="text-align:right;">
3885
</td>
<td style="text-align:right;">
1767
</td>
<td style="text-align:right;">
1384
</td>
<td style="text-align:right;">
1193
</td>
<td style="text-align:right;">
3885
</td>
<td style="text-align:right;">
30.70785
</td>
<td style="text-align:right;">
0.7107
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
281
</td>
<td style="text-align:right;">
2376
</td>
<td style="text-align:right;">
11.8265993
</td>
<td style="text-align:right;">
0.78030
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
260
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:right;">
44.98270
</td>
<td style="text-align:right;">
0.86970
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
806
</td>
<td style="text-align:right;">
40.07444
</td>
<td style="text-align:right;">
0.3674
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
1384
</td>
<td style="text-align:right;">
42.12428
</td>
<td style="text-align:right;">
0.7027
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
838
</td>
<td style="text-align:right;">
2803
</td>
<td style="text-align:right;">
29.896539
</td>
<td style="text-align:right;">
0.9003
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
424
</td>
<td style="text-align:right;">
4641
</td>
<td style="text-align:right;">
9.135962
</td>
<td style="text-align:right;">
0.22670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
213
</td>
<td style="text-align:right;">
5.482626
</td>
<td style="text-align:right;">
0.09811
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
744
</td>
<td style="text-align:right;">
19.1505792
</td>
<td style="text-align:right;">
0.270000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
325
</td>
<td style="text-align:right;">
3732
</td>
<td style="text-align:right;">
8.708467
</td>
<td style="text-align:right;">
0.168500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
619
</td>
<td style="text-align:right;">
31.17932
</td>
<td style="text-align:right;">
0.86080
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
229
</td>
<td style="text-align:right;">
3681
</td>
<td style="text-align:right;">
6.2211356
</td>
<td style="text-align:right;">
0.8321
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3004
</td>
<td style="text-align:right;">
3885
</td>
<td style="text-align:right;">
77.323037
</td>
<td style="text-align:right;">
0.8656
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1767
</td>
<td style="text-align:right;">
586
</td>
<td style="text-align:right;">
33.163554
</td>
<td style="text-align:right;">
0.8781
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
162
</td>
<td style="text-align:right;">
1384
</td>
<td style="text-align:right;">
11.7052023
</td>
<td style="text-align:right;">
0.9841
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
517
</td>
<td style="text-align:right;">
1384
</td>
<td style="text-align:right;">
37.35549
</td>
<td style="text-align:right;">
0.9768
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3885
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3814
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.32070
</td>
<td style="text-align:right;">
0.7423
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.229510
</td>
<td style="text-align:right;">
0.333000
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8656
</td>
<td style="text-align:right;">
0.8542
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.4013
</td>
<td style="text-align:right;">
0.8852
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.817110
</td>
<td style="text-align:right;">
0.7534
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
4450
</td>
<td style="text-align:right;">
1697
</td>
<td style="text-align:right;">
1486
</td>
<td style="text-align:right;">
529
</td>
<td style="text-align:right;">
4416
</td>
<td style="text-align:right;">
11.97917
</td>
<td style="text-align:right;">
0.2571
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
3378
</td>
<td style="text-align:right;">
1.687389
</td>
<td style="text-align:right;">
0.1054
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
877
</td>
<td style="text-align:right;">
17.33181
</td>
<td style="text-align:right;">
0.3135
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
609
</td>
<td style="text-align:right;">
30.87028
</td>
<td style="text-align:right;">
0.2143
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
340
</td>
<td style="text-align:right;">
1486
</td>
<td style="text-align:right;">
22.88022
</td>
<td style="text-align:right;">
0.2828
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
405
</td>
<td style="text-align:right;">
3531
</td>
<td style="text-align:right;">
11.469839
</td>
<td style="text-align:right;">
0.5689
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
4441
</td>
<td style="text-align:right;">
5.922090
</td>
<td style="text-align:right;">
0.2820
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
245
</td>
<td style="text-align:right;">
5.505618
</td>
<td style="text-align:right;">
0.04174
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
16.089888
</td>
<td style="text-align:right;">
0.22520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
271
</td>
<td style="text-align:right;">
3734.000
</td>
<td style="text-align:right;">
7.257633
</td>
<td style="text-align:right;">
0.08277
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
177
</td>
<td style="text-align:right;">
747.0000
</td>
<td style="text-align:right;">
23.69478
</td>
<td style="text-align:right;">
0.765800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
4197
</td>
<td style="text-align:right;">
7.8389326
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2470
</td>
<td style="text-align:right;">
4450.000
</td>
<td style="text-align:right;">
55.50562
</td>
<td style="text-align:right;">
0.6970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1697
</td>
<td style="text-align:right;">
509
</td>
<td style="text-align:right;">
29.99411
</td>
<td style="text-align:right;">
0.8494
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.18
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
1486
</td>
<td style="text-align:right;">
4.1049798
</td>
<td style="text-align:right;">
0.7992
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
1486.000
</td>
<td style="text-align:right;">
31.83042
</td>
<td style="text-align:right;">
0.9709
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
4450
</td>
<td style="text-align:right;">
0.3595506
</td>
<td style="text-align:right;">
0.6142
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.4962
</td>
<td style="text-align:right;">
0.1947
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.995810
</td>
<td style="text-align:right;">
0.196000
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6970
</td>
<td style="text-align:right;">
0.6885
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.4137
</td>
<td style="text-align:right;">
0.8771
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
7.602710
</td>
<td style="text-align:right;">
0.4367
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 29, District of Columbia, District of Columbia
</td>
<td style="text-align:right;">
29779
</td>
<td style="text-align:right;">
506200
</td>
<td style="text-align:right;">
57209
</td>
<td style="text-align:right;">
678700
</td>
<td style="text-align:right;">
34543.64
</td>
<td style="text-align:right;">
587192
</td>
<td style="text-align:right;">
22665.36
</td>
<td style="text-align:right;">
0.6561370
</td>
<td style="text-align:right;">
91508
</td>
<td style="text-align:right;">
0.1558400
</td>
<td style="text-align:right;">
372.28
</td>
<td style="text-align:right;">
614.06
</td>
<td style="text-align:left;">
District of Columbia, District of Columbia
</td>
<td style="text-align:left;">
Washington-Baltimore-Northern Virginia, DC-MD-VA-WV CSA
</td>
<td style="text-align:left;">
CS548
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_national_lihtc_df0 <- left_join(svi_national_lihtc, census_pull_df, join_by("GEOID_2010_trt" == "GEOID"))

svi_national_lihtc_df1 <- left_join(svi_national_lihtc_df0, hpi_df_10_20, join_by("GEOID_2010_trt" == "GEOID10")) %>%
                          unite("county_fips", FIPS_st, FIPS_county, sep = "") 

svi_national_lihtc_df <- left_join(svi_national_lihtc_df1, msa_csa_crosswalk, join_by("county_fips" == "county_fips"))

svi_national_lihtc_df %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
county_fips
</th>
<th style="text-align:left;">
FIPS_tract
</th>
<th style="text-align:left;">
state
</th>
<th style="text-align:left;">
state_name
</th>
<th style="text-align:left;">
county
</th>
<th style="text-align:right;">
region_number
</th>
<th style="text-align:left;">
region
</th>
<th style="text-align:right;">
division_number
</th>
<th style="text-align:left;">
division
</th>
<th style="text-align:right;">
E_TOTPOP_10
</th>
<th style="text-align:right;">
E_HU_10
</th>
<th style="text-align:right;">
E_HH_10
</th>
<th style="text-align:right;">
E_POV150_10
</th>
<th style="text-align:right;">
ET_POVSTATUS_10
</th>
<th style="text-align:right;">
EP_POV150_10
</th>
<th style="text-align:right;">
EPL_POV150_10
</th>
<th style="text-align:right;">
F_POV150_10
</th>
<th style="text-align:right;">
E_UNEMP_10
</th>
<th style="text-align:right;">
ET_EMPSTATUS_10
</th>
<th style="text-align:right;">
EP_UNEMP_10
</th>
<th style="text-align:right;">
EPL_UNEMP_10
</th>
<th style="text-align:right;">
F_UNEMP_10
</th>
<th style="text-align:right;">
E_HBURD_OWN_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_10
</th>
<th style="text-align:right;">
EP_HBURD_OWN_10
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_10
</th>
<th style="text-align:right;">
F_HBURD_OWN_10
</th>
<th style="text-align:right;">
E_HBURD_RENT_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_10
</th>
<th style="text-align:right;">
EP_HBURD_RENT_10
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_10
</th>
<th style="text-align:right;">
F_HBURD_RENT_10
</th>
<th style="text-align:right;">
E_HBURD_10
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_10
</th>
<th style="text-align:right;">
EP_HBURD_10
</th>
<th style="text-align:right;">
EPL_HBURD_10
</th>
<th style="text-align:right;">
F_HBURD_10
</th>
<th style="text-align:right;">
E_NOHSDP_10
</th>
<th style="text-align:right;">
ET_EDSTATUS_10
</th>
<th style="text-align:right;">
EP_NOHSDP_10
</th>
<th style="text-align:right;">
EPL_NOHSDP_10
</th>
<th style="text-align:right;">
F_NOHSDP_10
</th>
<th style="text-align:right;">
E_UNINSUR_12
</th>
<th style="text-align:right;">
ET_INSURSTATUS_12
</th>
<th style="text-align:right;">
EP_UNINSUR_12
</th>
<th style="text-align:right;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
F_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
F_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:right;">
EPL_AGE17_10
</th>
<th style="text-align:right;">
F_AGE17_10
</th>
<th style="text-align:right;">
E_DISABL_12
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_12
</th>
<th style="text-align:right;">
EP_DISABL_12
</th>
<th style="text-align:right;">
EPL_DISABL_12
</th>
<th style="text-align:right;">
F_DISABL_12
</th>
<th style="text-align:right;">
E_SNGPNT_10
</th>
<th style="text-align:right;">
ET_FAMILIES_10
</th>
<th style="text-align:right;">
EP_SNGPNT_10
</th>
<th style="text-align:right;">
EPL_SNGPNT_10
</th>
<th style="text-align:right;">
F_SNGPNT_10
</th>
<th style="text-align:right;">
E_LIMENG_10
</th>
<th style="text-align:right;">
ET_POPAGE5UP_10
</th>
<th style="text-align:right;">
EP_LIMENG_10
</th>
<th style="text-align:right;">
EPL_LIMENG_10
</th>
<th style="text-align:right;">
F_LIMENG_10
</th>
<th style="text-align:right;">
E_MINRTY_10
</th>
<th style="text-align:right;">
ET_POPETHRACE_10
</th>
<th style="text-align:right;">
EP_MINRTY_10
</th>
<th style="text-align:right;">
EPL_MINRTY_10
</th>
<th style="text-align:right;">
F_MINRTY_10
</th>
<th style="text-align:right;">
E_STRHU_10
</th>
<th style="text-align:right;">
E_MUNIT_10
</th>
<th style="text-align:right;">
EP_MUNIT_10
</th>
<th style="text-align:right;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
F_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
</th>
<th style="text-align:right;">
F_MOBILE_10
</th>
<th style="text-align:right;">
E_CROWD_10
</th>
<th style="text-align:right;">
ET_OCCUPANTS_10
</th>
<th style="text-align:right;">
EP_CROWD_10
</th>
<th style="text-align:right;">
EPL_CROWD_10
</th>
<th style="text-align:right;">
F_CROWD_10
</th>
<th style="text-align:right;">
E_NOVEH_10
</th>
<th style="text-align:right;">
ET_KNOWNVEH_10
</th>
<th style="text-align:right;">
EP_NOVEH_10
</th>
<th style="text-align:right;">
EPL_NOVEH_10
</th>
<th style="text-align:right;">
F_NOVEH_10
</th>
<th style="text-align:right;">
E_GROUPQ_10
</th>
<th style="text-align:right;">
ET_HHTYPE_10
</th>
<th style="text-align:right;">
EP_GROUPQ_10
</th>
<th style="text-align:right;">
EPL_GROUPQ_10
</th>
<th style="text-align:right;">
F_GROUPQ_10
</th>
<th style="text-align:right;">
SPL_THEME1_10
</th>
<th style="text-align:right;">
RPL_THEME1_10
</th>
<th style="text-align:right;">
F_THEME1_10
</th>
<th style="text-align:right;">
SPL_THEME2_10
</th>
<th style="text-align:right;">
RPL_THEME2_10
</th>
<th style="text-align:right;">
F_THEME2_10
</th>
<th style="text-align:right;">
SPL_THEME3_10
</th>
<th style="text-align:right;">
RPL_THEME3_10
</th>
<th style="text-align:right;">
F_THEME3_10
</th>
<th style="text-align:right;">
SPL_THEME4_10
</th>
<th style="text-align:right;">
RPL_THEME4_10
</th>
<th style="text-align:right;">
F_THEME4_10
</th>
<th style="text-align:right;">
SPL_THEMES_10
</th>
<th style="text-align:right;">
RPL_THEMES_10
</th>
<th style="text-align:right;">
F_TOTAL_10
</th>
<th style="text-align:right;">
E_TOTPOP_20
</th>
<th style="text-align:right;">
E_HU_20
</th>
<th style="text-align:right;">
E_HH_20
</th>
<th style="text-align:right;">
E_POV150_20
</th>
<th style="text-align:right;">
ET_POVSTATUS_20
</th>
<th style="text-align:right;">
EP_POV150_20
</th>
<th style="text-align:right;">
EPL_POV150_20
</th>
<th style="text-align:right;">
F_POV150_20
</th>
<th style="text-align:right;">
E_UNEMP_20
</th>
<th style="text-align:right;">
ET_EMPSTATUS_20
</th>
<th style="text-align:right;">
EP_UNEMP_20
</th>
<th style="text-align:right;">
EPL_UNEMP_20
</th>
<th style="text-align:right;">
F_UNEMP_20
</th>
<th style="text-align:right;">
E_HBURD_OWN_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_OWN_20
</th>
<th style="text-align:right;">
EP_HBURD_OWN_20
</th>
<th style="text-align:right;">
EPL_HBURD_OWN_20
</th>
<th style="text-align:right;">
F_HBURD_OWN_20
</th>
<th style="text-align:right;">
E_HBURD_RENT_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_RENT_20
</th>
<th style="text-align:right;">
EP_HBURD_RENT_20
</th>
<th style="text-align:right;">
EPL_HBURD_RENT_20
</th>
<th style="text-align:right;">
F_HBURD_RENT_20
</th>
<th style="text-align:right;">
E_HBURD_20
</th>
<th style="text-align:right;">
ET_HOUSINGCOST_20
</th>
<th style="text-align:right;">
EP_HBURD_20
</th>
<th style="text-align:right;">
EPL_HBURD_20
</th>
<th style="text-align:right;">
F_HBURD_20
</th>
<th style="text-align:right;">
E_NOHSDP_20
</th>
<th style="text-align:right;">
ET_EDSTATUS_20
</th>
<th style="text-align:right;">
EP_NOHSDP_20
</th>
<th style="text-align:right;">
EPL_NOHSDP_20
</th>
<th style="text-align:right;">
F_NOHSDP_20
</th>
<th style="text-align:right;">
E_UNINSUR_20
</th>
<th style="text-align:right;">
ET_INSURSTATUS_20
</th>
<th style="text-align:right;">
EP_UNINSUR_20
</th>
<th style="text-align:right;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
F_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
F_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:right;">
EPL_AGE17_20
</th>
<th style="text-align:right;">
F_AGE17_20
</th>
<th style="text-align:right;">
E_DISABL_20
</th>
<th style="text-align:right;">
ET_DISABLSTATUS_20
</th>
<th style="text-align:right;">
EP_DISABL_20
</th>
<th style="text-align:right;">
EPL_DISABL_20
</th>
<th style="text-align:right;">
F_DISABL_20
</th>
<th style="text-align:right;">
E_SNGPNT_20
</th>
<th style="text-align:right;">
ET_FAMILIES_20
</th>
<th style="text-align:right;">
EP_SNGPNT_20
</th>
<th style="text-align:right;">
EPL_SNGPNT_20
</th>
<th style="text-align:right;">
F_SNGPNT_20
</th>
<th style="text-align:right;">
E_LIMENG_20
</th>
<th style="text-align:right;">
ET_POPAGE5UP_20
</th>
<th style="text-align:right;">
EP_LIMENG_20
</th>
<th style="text-align:right;">
EPL_LIMENG_20
</th>
<th style="text-align:right;">
F_LIMENG_20
</th>
<th style="text-align:right;">
E_MINRTY_20
</th>
<th style="text-align:right;">
ET_POPETHRACE_20
</th>
<th style="text-align:right;">
EP_MINRTY_20
</th>
<th style="text-align:right;">
EPL_MINRTY_20
</th>
<th style="text-align:right;">
F_MINRTY_20
</th>
<th style="text-align:right;">
E_STRHU_20
</th>
<th style="text-align:right;">
E_MUNIT_20
</th>
<th style="text-align:right;">
EP_MUNIT_20
</th>
<th style="text-align:right;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
F_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
</th>
<th style="text-align:right;">
F_MOBILE_20
</th>
<th style="text-align:right;">
E_CROWD_20
</th>
<th style="text-align:right;">
ET_OCCUPANTS_20
</th>
<th style="text-align:right;">
EP_CROWD_20
</th>
<th style="text-align:right;">
EPL_CROWD_20
</th>
<th style="text-align:right;">
F_CROWD_20
</th>
<th style="text-align:right;">
E_NOVEH_20
</th>
<th style="text-align:right;">
ET_KNOWNVEH_20
</th>
<th style="text-align:right;">
EP_NOVEH_20
</th>
<th style="text-align:right;">
EPL_NOVEH_20
</th>
<th style="text-align:right;">
F_NOVEH_20
</th>
<th style="text-align:right;">
E_GROUPQ_20
</th>
<th style="text-align:right;">
ET_HHTYPE_20
</th>
<th style="text-align:right;">
EP_GROUPQ_20
</th>
<th style="text-align:right;">
EPL_GROUPQ_20
</th>
<th style="text-align:right;">
F_GROUPQ_20
</th>
<th style="text-align:right;">
SPL_THEME1_20
</th>
<th style="text-align:right;">
RPL_THEME1_20
</th>
<th style="text-align:right;">
F_THEME1_20
</th>
<th style="text-align:right;">
SPL_THEME2_20
</th>
<th style="text-align:right;">
RPL_THEME2_20
</th>
<th style="text-align:right;">
F_THEME2_20
</th>
<th style="text-align:right;">
SPL_THEME3_20
</th>
<th style="text-align:right;">
RPL_THEME3_20
</th>
<th style="text-align:right;">
F_THEME3_20
</th>
<th style="text-align:right;">
SPL_THEME4_20
</th>
<th style="text-align:right;">
RPL_THEME4_20
</th>
<th style="text-align:right;">
F_THEME4_20
</th>
<th style="text-align:right;">
SPL_THEMES_20
</th>
<th style="text-align:right;">
RPL_THEMES_20
</th>
<th style="text-align:right;">
F_TOTAL_20
</th>
<th style="text-align:right;">
pre10_lihtc_project_cnt
</th>
<th style="text-align:right;">
pre10_lihtc_project_dollars
</th>
<th style="text-align:right;">
post10_lihtc_project_cnt
</th>
<th style="text-align:right;">
post10_lihtc_project_dollars
</th>
<th style="text-align:right;">
lihtc_flag
</th>
<th style="text-align:left;">
lihtc_eligibility
</th>
<th style="text-align:left;">
NAME
</th>
<th style="text-align:right;">
Median_Income_10
</th>
<th style="text-align:right;">
Median_Home_Value_10
</th>
<th style="text-align:right;">
Median_Income_19
</th>
<th style="text-align:right;">
Median_Home_Value_19
</th>
<th style="text-align:right;">
Median_Income_10adj
</th>
<th style="text-align:right;">
Median_Home_Value_10adj
</th>
<th style="text-align:right;">
Median_Income_Change
</th>
<th style="text-align:right;">
Median_Income_Change_pct
</th>
<th style="text-align:right;">
Median_Home_Value_Change
</th>
<th style="text-align:right;">
Median_Home_Value_Change_pct
</th>
<th style="text-align:right;">
housing_price_index10
</th>
<th style="text-align:right;">
housing_price_index20
</th>
<th style="text-align:left;">
county_title
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:left;">
cbsa_code
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01005950700
</td>
<td style="text-align:left;">
01005
</td>
<td style="text-align:left;">
950700
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Barbour County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
1753
</td>
<td style="text-align:right;">
687
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
615
</td>
<td style="text-align:right;">
1628
</td>
<td style="text-align:right;">
37.77641
</td>
<td style="text-align:right;">
0.8088
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
667
</td>
<td style="text-align:right;">
2.548726
</td>
<td style="text-align:right;">
0.06941
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
376
</td>
<td style="text-align:right;">
10.90426
</td>
<td style="text-align:right;">
0.01945
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
33.15508
</td>
<td style="text-align:right;">
0.24640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
18.29485
</td>
<td style="text-align:right;">
0.04875
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
21.85430
</td>
<td style="text-align:right;">
0.7570
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
201
</td>
<td style="text-align:right;">
1527
</td>
<td style="text-align:right;">
13.163065
</td>
<td style="text-align:right;">
0.4991
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
368
</td>
<td style="text-align:right;">
20.992584
</td>
<td style="text-align:right;">
0.89510
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
26.354820
</td>
<td style="text-align:right;">
0.66130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
1085
</td>
<td style="text-align:right;">
19.44700
</td>
<td style="text-align:right;">
0.7505
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
107
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
26.81704
</td>
<td style="text-align:right;">
0.8048
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1628
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
861
</td>
<td style="text-align:right;">
1753
</td>
<td style="text-align:right;">
49.11580
</td>
<td style="text-align:right;">
0.7101
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
687
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
2.4745269
</td>
<td style="text-align:right;">
0.4324
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
5.5312955
</td>
<td style="text-align:right;">
0.6970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
0.5328597
</td>
<td style="text-align:right;">
0.3037
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
3.374778
</td>
<td style="text-align:right;">
0.3529
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
1753
</td>
<td style="text-align:right;">
13.29150
</td>
<td style="text-align:right;">
0.9517
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.18306
</td>
<td style="text-align:right;">
0.4137
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.20468
</td>
<td style="text-align:right;">
0.8377
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.7101
</td>
<td style="text-align:right;">
0.7035
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.7377
</td>
<td style="text-align:right;">
0.6100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.83554
</td>
<td style="text-align:right;">
0.6264
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1527
</td>
<td style="text-align:right;">
691
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
565
</td>
<td style="text-align:right;">
1365
</td>
<td style="text-align:right;">
41.39194
</td>
<td style="text-align:right;">
0.8765
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
572
</td>
<td style="text-align:right;">
6.468532
</td>
<td style="text-align:right;">
0.6776
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
376
</td>
<td style="text-align:right;">
18.617021
</td>
<td style="text-align:right;">
0.38590
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
42.009132
</td>
<td style="text-align:right;">
0.47360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
162
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
27.22689
</td>
<td style="text-align:right;">
0.44540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
1114
</td>
<td style="text-align:right;">
25.13465
</td>
<td style="text-align:right;">
0.8942
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
1378
</td>
<td style="text-align:right;">
7.619739
</td>
<td style="text-align:right;">
0.5505
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
25.081860
</td>
<td style="text-align:right;">
0.88450
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
337
</td>
<td style="text-align:right;">
22.069417
</td>
<td style="text-align:right;">
0.51380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
1041.0000
</td>
<td style="text-align:right;">
22.76657
</td>
<td style="text-align:right;">
0.8360
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
413.0000
</td>
<td style="text-align:right;">
34.86683
</td>
<td style="text-align:right;">
0.9114
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1466
</td>
<td style="text-align:right;">
0.7503411
</td>
<td style="text-align:right;">
0.40700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
1527.0000
</td>
<td style="text-align:right;">
46.56189
</td>
<td style="text-align:right;">
0.6441
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
691
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1.8813314
</td>
<td style="text-align:right;">
0.3740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
5.3545586
</td>
<td style="text-align:right;">
0.7152
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
595.0000
</td>
<td style="text-align:right;">
19.327731
</td>
<td style="text-align:right;">
0.8859
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
1527
</td>
<td style="text-align:right;">
9.7576948
</td>
<td style="text-align:right;">
0.9470
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.44420
</td>
<td style="text-align:right;">
0.7707
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.55270
</td>
<td style="text-align:right;">
0.9403
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.6441
</td>
<td style="text-align:right;">
0.6387
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.02006
</td>
<td style="text-align:right;">
0.7337
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.66106
</td>
<td style="text-align:right;">
0.8537
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 9507, Barbour County, Alabama
</td>
<td style="text-align:right;">
15257
</td>
<td style="text-align:right;">
133700
</td>
<td style="text-align:right;">
17244
</td>
<td style="text-align:right;">
137500
</td>
<td style="text-align:right;">
17698.12
</td>
<td style="text-align:right;">
155092
</td>
<td style="text-align:right;">
-454.12
</td>
<td style="text-align:right;">
-0.0256592
</td>
<td style="text-align:right;">
-17592
</td>
<td style="text-align:right;">
-0.1134294
</td>
<td style="text-align:right;">
131.05
</td>
<td style="text-align:right;">
135.61
</td>
<td style="text-align:left;">
Barbour County, Alabama
</td>
<td style="text-align:left;">
Eufaula, AL-GA MicroSA
</td>
<td style="text-align:left;">
C2164
</td>
</tr>
<tr>
<td style="text-align:left;">
01011952100
</td>
<td style="text-align:left;">
01011
</td>
<td style="text-align:left;">
952100
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Bullock County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
1652
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
564
</td>
<td style="text-align:right;">
1652
</td>
<td style="text-align:right;">
34.14044
</td>
<td style="text-align:right;">
0.7613
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
816
</td>
<td style="text-align:right;">
5.637255
</td>
<td style="text-align:right;">
0.33630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
458
</td>
<td style="text-align:right;">
20.96070
</td>
<td style="text-align:right;">
0.19930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
64.58333
</td>
<td style="text-align:right;">
0.89170
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
28.51986
</td>
<td style="text-align:right;">
0.29220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
271
</td>
<td style="text-align:right;">
1076
</td>
<td style="text-align:right;">
25.18587
</td>
<td style="text-align:right;">
0.8163
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
1663
</td>
<td style="text-align:right;">
9.320505
</td>
<td style="text-align:right;">
0.3183
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
12.046005
</td>
<td style="text-align:right;">
0.47180
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
420
</td>
<td style="text-align:right;">
25.423729
</td>
<td style="text-align:right;">
0.60240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
327
</td>
<td style="text-align:right;">
1279
</td>
<td style="text-align:right;">
25.56685
</td>
<td style="text-align:right;">
0.9151
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
375
</td>
<td style="text-align:right;">
36.53333
</td>
<td style="text-align:right;">
0.9108
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1590
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1428
</td>
<td style="text-align:right;">
1652
</td>
<td style="text-align:right;">
86.44068
</td>
<td style="text-align:right;">
0.8939
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
48.2412060
</td>
<td style="text-align:right;">
0.9897
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
3.4296029
</td>
<td style="text-align:right;">
0.7145
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
8.122744
</td>
<td style="text-align:right;">
0.6556
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1652
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.52440
</td>
<td style="text-align:right;">
0.5138
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.99308
</td>
<td style="text-align:right;">
0.7515
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8939
</td>
<td style="text-align:right;">
0.8856
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.8462
</td>
<td style="text-align:right;">
0.6637
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.25758
</td>
<td style="text-align:right;">
0.6790
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1382
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
1382
</td>
<td style="text-align:right;">
53.69030
</td>
<td style="text-align:right;">
0.9560
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
511
</td>
<td style="text-align:right;">
7.827789
</td>
<td style="text-align:right;">
0.7730
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
402
</td>
<td style="text-align:right;">
27.363184
</td>
<td style="text-align:right;">
0.71780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
30.612245
</td>
<td style="text-align:right;">
0.23070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
28.23315
</td>
<td style="text-align:right;">
0.47730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
181
</td>
<td style="text-align:right;">
905
</td>
<td style="text-align:right;">
20.00000
</td>
<td style="text-align:right;">
0.8253
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
232
</td>
<td style="text-align:right;">
1382
</td>
<td style="text-align:right;">
16.787265
</td>
<td style="text-align:right;">
0.8813
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
164
</td>
<td style="text-align:right;">
11.866860
</td>
<td style="text-align:right;">
0.27170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
18.089725
</td>
<td style="text-align:right;">
0.26290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
258
</td>
<td style="text-align:right;">
1132.0000
</td>
<td style="text-align:right;">
22.79152
</td>
<td style="text-align:right;">
0.8368
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
279.0000
</td>
<td style="text-align:right;">
35.48387
</td>
<td style="text-align:right;">
0.9162
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1275
</td>
<td style="text-align:right;">
2.5882353
</td>
<td style="text-align:right;">
0.64520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1347
</td>
<td style="text-align:right;">
1382.0000
</td>
<td style="text-align:right;">
97.46744
</td>
<td style="text-align:right;">
0.9681
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
375
</td>
<td style="text-align:right;">
50.1336898
</td>
<td style="text-align:right;">
0.9922
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
549.0000
</td>
<td style="text-align:right;">
6.739526
</td>
<td style="text-align:right;">
0.6039
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1382
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.91290
</td>
<td style="text-align:right;">
0.8785
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.93280
</td>
<td style="text-align:right;">
0.7342
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9681
</td>
<td style="text-align:right;">
0.9599
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.98506
</td>
<td style="text-align:right;">
0.2471
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.79886
</td>
<td style="text-align:right;">
0.7570
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 9521, Bullock County, Alabama
</td>
<td style="text-align:right;">
19754
</td>
<td style="text-align:right;">
58200
</td>
<td style="text-align:right;">
18598
</td>
<td style="text-align:right;">
66900
</td>
<td style="text-align:right;">
22914.64
</td>
<td style="text-align:right;">
67512
</td>
<td style="text-align:right;">
-4316.64
</td>
<td style="text-align:right;">
-0.1883791
</td>
<td style="text-align:right;">
-612
</td>
<td style="text-align:right;">
-0.0090651
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01015000300
</td>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
000300
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Calhoun County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3074
</td>
<td style="text-align:right;">
1635
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1904
</td>
<td style="text-align:right;">
3067
</td>
<td style="text-align:right;">
62.08021
</td>
<td style="text-align:right;">
0.9710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
21.512482
</td>
<td style="text-align:right;">
0.96630
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
180
</td>
<td style="text-align:right;">
513
</td>
<td style="text-align:right;">
35.08772
</td>
<td style="text-align:right;">
0.65450
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
46.87882
</td>
<td style="text-align:right;">
0.55040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
563
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
42.33083
</td>
<td style="text-align:right;">
0.70280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
720
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
33.85049
</td>
<td style="text-align:right;">
0.9148
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
628
</td>
<td style="text-align:right;">
2835
</td>
<td style="text-align:right;">
22.151675
</td>
<td style="text-align:right;">
0.8076
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
12.361744
</td>
<td style="text-align:right;">
0.49340
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
713
</td>
<td style="text-align:right;">
23.194535
</td>
<td style="text-align:right;">
0.45030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
647
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
30.64898
</td>
<td style="text-align:right;">
0.9708
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
773
</td>
<td style="text-align:right;">
38.55110
</td>
<td style="text-align:right;">
0.9247
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2878
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2623
</td>
<td style="text-align:right;">
3074
</td>
<td style="text-align:right;">
85.32856
</td>
<td style="text-align:right;">
0.8883
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1635
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
9.0519878
</td>
<td style="text-align:right;">
0.6465
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0.3669725
</td>
<td style="text-align:right;">
0.4502
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
5.1127820
</td>
<td style="text-align:right;">
0.8082
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
303
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
22.781955
</td>
<td style="text-align:right;">
0.9029
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3074
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.36250
</td>
<td style="text-align:right;">
0.9430
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.93218
</td>
<td style="text-align:right;">
0.7233
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8883
</td>
<td style="text-align:right;">
0.8800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.1718
</td>
<td style="text-align:right;">
0.8070
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.35478
</td>
<td style="text-align:right;">
0.9009
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
2390
</td>
<td style="text-align:right;">
1702
</td>
<td style="text-align:right;">
1282
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
2390
</td>
<td style="text-align:right;">
53.84937
</td>
<td style="text-align:right;">
0.9566
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
1066
</td>
<td style="text-align:right;">
9.568480
</td>
<td style="text-align:right;">
0.8541
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
609
</td>
<td style="text-align:right;">
25.944171
</td>
<td style="text-align:right;">
0.67520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
286
</td>
<td style="text-align:right;">
673
</td>
<td style="text-align:right;">
42.496285
</td>
<td style="text-align:right;">
0.48560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
1282
</td>
<td style="text-align:right;">
34.63339
</td>
<td style="text-align:right;">
0.66340
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
467
</td>
<td style="text-align:right;">
1685
</td>
<td style="text-align:right;">
27.71513
</td>
<td style="text-align:right;">
0.9180
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
2379
</td>
<td style="text-align:right;">
15.510719
</td>
<td style="text-align:right;">
0.8562
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
14.309623
</td>
<td style="text-align:right;">
0.40850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
548
</td>
<td style="text-align:right;">
22.928870
</td>
<td style="text-align:right;">
0.57100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
647
</td>
<td style="text-align:right;">
1831.0000
</td>
<td style="text-align:right;">
35.33588
</td>
<td style="text-align:right;">
0.9862
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
576.0000
</td>
<td style="text-align:right;">
35.06944
</td>
<td style="text-align:right;">
0.9130
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
2134
</td>
<td style="text-align:right;">
0.7497657
</td>
<td style="text-align:right;">
0.40690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1896
</td>
<td style="text-align:right;">
2390.0000
</td>
<td style="text-align:right;">
79.33054
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1702
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
5.6404230
</td>
<td style="text-align:right;">
0.5329
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1282
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1282.0000
</td>
<td style="text-align:right;">
14.508580
</td>
<td style="text-align:right;">
0.8308
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
2390
</td>
<td style="text-align:right;">
1.7991632
</td>
<td style="text-align:right;">
0.7727
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.24830
</td>
<td style="text-align:right;">
0.9395
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.28560
</td>
<td style="text-align:right;">
0.8773
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
0.8379
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.45296
</td>
<td style="text-align:right;">
0.4602
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.83196
</td>
<td style="text-align:right;">
0.8718
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 3, Calhoun County, Alabama
</td>
<td style="text-align:right;">
12211
</td>
<td style="text-align:right;">
41700
</td>
<td style="text-align:right;">
18299
</td>
<td style="text-align:right;">
51300
</td>
<td style="text-align:right;">
14164.76
</td>
<td style="text-align:right;">
48372
</td>
<td style="text-align:right;">
4134.24
</td>
<td style="text-align:right;">
0.2918680
</td>
<td style="text-align:right;">
2928
</td>
<td style="text-align:right;">
0.0605309
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
<tr>
<td style="text-align:left;">
01015000500
</td>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
000500
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Calhoun County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
1175
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
1042
</td>
<td style="text-align:right;">
1619
</td>
<td style="text-align:right;">
64.36072
</td>
<td style="text-align:right;">
0.9767
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
472
</td>
<td style="text-align:right;">
26.271186
</td>
<td style="text-align:right;">
0.98460
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
136
</td>
<td style="text-align:right;">
461
</td>
<td style="text-align:right;">
29.50108
</td>
<td style="text-align:right;">
0.48970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
163
</td>
<td style="text-align:right;">
282
</td>
<td style="text-align:right;">
57.80142
</td>
<td style="text-align:right;">
0.79190
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
299
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
40.24226
</td>
<td style="text-align:right;">
0.64910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
340
</td>
<td style="text-align:right;">
1270
</td>
<td style="text-align:right;">
26.77165
</td>
<td style="text-align:right;">
0.8389
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
460
</td>
<td style="text-align:right;">
1794
</td>
<td style="text-align:right;">
25.641026
</td>
<td style="text-align:right;">
0.8722
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
271
</td>
<td style="text-align:right;">
15.655690
</td>
<td style="text-align:right;">
0.70190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
368
</td>
<td style="text-align:right;">
21.259388
</td>
<td style="text-align:right;">
0.32190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
1449
</td>
<td style="text-align:right;">
34.98965
</td>
<td style="text-align:right;">
0.9885
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
38.86010
</td>
<td style="text-align:right;">
0.9269
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1677
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1559
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
90.06355
</td>
<td style="text-align:right;">
0.9123
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1175
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
4.2553191
</td>
<td style="text-align:right;">
0.5128
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.3404255
</td>
<td style="text-align:right;">
0.4480
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1238
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
122
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
16.419919
</td>
<td style="text-align:right;">
0.8473
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.32150
</td>
<td style="text-align:right;">
0.9362
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.03218
</td>
<td style="text-align:right;">
0.7679
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9123
</td>
<td style="text-align:right;">
0.9038
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.2959
</td>
<td style="text-align:right;">
0.3818
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
10.56188
</td>
<td style="text-align:right;">
0.8244
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
907
</td>
<td style="text-align:right;">
488
</td>
<td style="text-align:right;">
586
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
62.34043
</td>
<td style="text-align:right;">
0.9815
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
19.865320
</td>
<td style="text-align:right;">
0.9833
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
30.303030
</td>
<td style="text-align:right;">
0.79220
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
36.708861
</td>
<td style="text-align:right;">
0.34970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
488
</td>
<td style="text-align:right;">
32.37705
</td>
<td style="text-align:right;">
0.60200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
795
</td>
<td style="text-align:right;">
25.03145
</td>
<td style="text-align:right;">
0.8930
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
12.553192
</td>
<td style="text-align:right;">
0.7770
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
26.170213
</td>
<td style="text-align:right;">
0.90530
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
12.553192
</td>
<td style="text-align:right;">
0.08233
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
822.5089
</td>
<td style="text-align:right;">
46.56484
</td>
<td style="text-align:right;">
0.9984
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
197.8892
</td>
<td style="text-align:right;">
15.16000
</td>
<td style="text-align:right;">
0.5363
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
889
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
898
</td>
<td style="text-align:right;">
940.3866
</td>
<td style="text-align:right;">
95.49264
</td>
<td style="text-align:right;">
0.9489
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
907
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.2205072
</td>
<td style="text-align:right;">
0.4456
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
488
</td>
<td style="text-align:right;">
0.4098361
</td>
<td style="text-align:right;">
0.23670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
146
</td>
<td style="text-align:right;">
487.6463
</td>
<td style="text-align:right;">
29.939736
</td>
<td style="text-align:right;">
0.9404
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.23680
</td>
<td style="text-align:right;">
0.9379
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.61712
</td>
<td style="text-align:right;">
0.5593
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9489
</td>
<td style="text-align:right;">
0.9409
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.91370
</td>
<td style="text-align:right;">
0.2196
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.71652
</td>
<td style="text-align:right;">
0.7468
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 5, Calhoun County, Alabama
</td>
<td style="text-align:right;">
11742
</td>
<td style="text-align:right;">
38800
</td>
<td style="text-align:right;">
13571
</td>
<td style="text-align:right;">
38800
</td>
<td style="text-align:right;">
13620.72
</td>
<td style="text-align:right;">
45008
</td>
<td style="text-align:right;">
-49.72
</td>
<td style="text-align:right;">
-0.0036503
</td>
<td style="text-align:right;">
-6208
</td>
<td style="text-align:right;">
-0.1379310
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
<tr>
<td style="text-align:left;">
01015000600
</td>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
000600
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Calhoun County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
2571
</td>
<td style="text-align:right;">
992
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
1394
</td>
<td style="text-align:right;">
2133
</td>
<td style="text-align:right;">
65.35396
</td>
<td style="text-align:right;">
0.9789
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
905
</td>
<td style="text-align:right;">
29.060773
</td>
<td style="text-align:right;">
0.98990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
39.54248
</td>
<td style="text-align:right;">
0.75940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
42.65306
</td>
<td style="text-align:right;">
0.44810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
41.45729
</td>
<td style="text-align:right;">
0.68030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
641
</td>
<td style="text-align:right;">
1556
</td>
<td style="text-align:right;">
41.19537
</td>
<td style="text-align:right;">
0.9554
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
416
</td>
<td style="text-align:right;">
1760
</td>
<td style="text-align:right;">
23.636364
</td>
<td style="text-align:right;">
0.8383
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
220
</td>
<td style="text-align:right;">
8.556982
</td>
<td style="text-align:right;">
0.24910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
22.714897
</td>
<td style="text-align:right;">
0.41610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
539
</td>
<td style="text-align:right;">
1353
</td>
<td style="text-align:right;">
39.83740
</td>
<td style="text-align:right;">
0.9955
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
466
</td>
<td style="text-align:right;">
52.14592
</td>
<td style="text-align:right;">
0.9783
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
2366
</td>
<td style="text-align:right;">
1.2679628
</td>
<td style="text-align:right;">
0.48990
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1944
</td>
<td style="text-align:right;">
2571
</td>
<td style="text-align:right;">
75.61260
</td>
<td style="text-align:right;">
0.8440
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
992
</td>
<td style="text-align:right;">
164
</td>
<td style="text-align:right;">
16.5322581
</td>
<td style="text-align:right;">
0.7673
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.8064516
</td>
<td style="text-align:right;">
0.5110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
5.7788945
</td>
<td style="text-align:right;">
0.8329
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
184
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
23.115578
</td>
<td style="text-align:right;">
0.9049
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
614
</td>
<td style="text-align:right;">
2571
</td>
<td style="text-align:right;">
23.88176
</td>
<td style="text-align:right;">
0.9734
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.44280
</td>
<td style="text-align:right;">
0.9548
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.12890
</td>
<td style="text-align:right;">
0.8088
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8440
</td>
<td style="text-align:right;">
0.8362
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.9895
</td>
<td style="text-align:right;">
0.9792
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
12.40520
</td>
<td style="text-align:right;">
0.9696
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
964
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
1621
</td>
<td style="text-align:right;">
51.63479
</td>
<td style="text-align:right;">
0.9467
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
157
</td>
<td style="text-align:right;">
652
</td>
<td style="text-align:right;">
24.079755
</td>
<td style="text-align:right;">
0.9922
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
6.043956
</td>
<td style="text-align:right;">
0.01547
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
36.338028
</td>
<td style="text-align:right;">
0.34200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
21.00139
</td>
<td style="text-align:right;">
0.23030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
363
</td>
<td style="text-align:right;">
1387
</td>
<td style="text-align:right;">
26.17159
</td>
<td style="text-align:right;">
0.9048
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
1613
</td>
<td style="text-align:right;">
21.760694
</td>
<td style="text-align:right;">
0.9435
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
249
</td>
<td style="text-align:right;">
12.769231
</td>
<td style="text-align:right;">
0.32090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
356
</td>
<td style="text-align:right;">
18.256410
</td>
<td style="text-align:right;">
0.27140
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
332
</td>
<td style="text-align:right;">
1259.7041
</td>
<td style="text-align:right;">
26.35540
</td>
<td style="text-align:right;">
0.9135
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
136
</td>
<td style="text-align:right;">
435.6156
</td>
<td style="text-align:right;">
31.22018
</td>
<td style="text-align:right;">
0.8775
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1891
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1463
</td>
<td style="text-align:right;">
1949.9821
</td>
<td style="text-align:right;">
75.02633
</td>
<td style="text-align:right;">
0.8219
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
964
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1.4522822
</td>
<td style="text-align:right;">
0.3459
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.8298755
</td>
<td style="text-align:right;">
0.5269
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
2.6425591
</td>
<td style="text-align:right;">
0.61120
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
719.0542
</td>
<td style="text-align:right;">
27.397100
</td>
<td style="text-align:right;">
0.9316
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
16.8717949
</td>
<td style="text-align:right;">
0.9655
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.01750
</td>
<td style="text-align:right;">
0.9001
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.47809
</td>
<td style="text-align:right;">
0.4764
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8219
</td>
<td style="text-align:right;">
0.8149
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.38110
</td>
<td style="text-align:right;">
0.8712
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.69859
</td>
<td style="text-align:right;">
0.8583
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 6, Calhoun County, Alabama
</td>
<td style="text-align:right;">
10958
</td>
<td style="text-align:right;">
48000
</td>
<td style="text-align:right;">
14036
</td>
<td style="text-align:right;">
43300
</td>
<td style="text-align:right;">
12711.28
</td>
<td style="text-align:right;">
55680
</td>
<td style="text-align:right;">
1324.72
</td>
<td style="text-align:right;">
0.1042161
</td>
<td style="text-align:right;">
-12380
</td>
<td style="text-align:right;">
-0.2223420
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
<tr>
<td style="text-align:left;">
01015002101
</td>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
002101
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Calhoun County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3872
</td>
<td style="text-align:right;">
1454
</td>
<td style="text-align:right;">
1207
</td>
<td style="text-align:right;">
1729
</td>
<td style="text-align:right;">
2356
</td>
<td style="text-align:right;">
73.38710
</td>
<td style="text-align:right;">
0.9916
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
489
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
24.207921
</td>
<td style="text-align:right;">
0.97860
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
11.90476
</td>
<td style="text-align:right;">
0.02541
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
718
</td>
<td style="text-align:right;">
1039
</td>
<td style="text-align:right;">
69.10491
</td>
<td style="text-align:right;">
0.93320
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
1207
</td>
<td style="text-align:right;">
61.14333
</td>
<td style="text-align:right;">
0.96900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
725
</td>
<td style="text-align:right;">
15.58621
</td>
<td style="text-align:right;">
0.6035
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
664
</td>
<td style="text-align:right;">
3943
</td>
<td style="text-align:right;">
16.839970
</td>
<td style="text-align:right;">
0.6495
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
4.313016
</td>
<td style="text-align:right;">
0.05978
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
238
</td>
<td style="text-align:right;">
6.146694
</td>
<td style="text-align:right;">
0.02255
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
2359
</td>
<td style="text-align:right;">
11.19118
</td>
<td style="text-align:right;">
0.3027
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
35.74144
</td>
<td style="text-align:right;">
0.9050
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
3769
</td>
<td style="text-align:right;">
1.2204829
</td>
<td style="text-align:right;">
0.48250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1601
</td>
<td style="text-align:right;">
3872
</td>
<td style="text-align:right;">
41.34814
</td>
<td style="text-align:right;">
0.6572
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1454
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
52.3383769
</td>
<td style="text-align:right;">
0.9504
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
4.4704264
</td>
<td style="text-align:right;">
0.6738
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
1207
</td>
<td style="text-align:right;">
0.4142502
</td>
<td style="text-align:right;">
0.2791
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
1207
</td>
<td style="text-align:right;">
9.362055
</td>
<td style="text-align:right;">
0.7004
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1516
</td>
<td style="text-align:right;">
3872
</td>
<td style="text-align:right;">
39.15289
</td>
<td style="text-align:right;">
0.9860
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.19220
</td>
<td style="text-align:right;">
0.9133
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1.77253
</td>
<td style="text-align:right;">
0.1304
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.6572
</td>
<td style="text-align:right;">
0.6511
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.5897
</td>
<td style="text-align:right;">
0.9337
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.21163
</td>
<td style="text-align:right;">
0.7885
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
3238
</td>
<td style="text-align:right;">
1459
</td>
<td style="text-align:right;">
1014
</td>
<td style="text-align:right;">
1082
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
58.93246
</td>
<td style="text-align:right;">
0.9735
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
17.890235
</td>
<td style="text-align:right;">
0.9767
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
20.000000
</td>
<td style="text-align:right;">
0.44920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
859
</td>
<td style="text-align:right;">
59.953434
</td>
<td style="text-align:right;">
0.85540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
546
</td>
<td style="text-align:right;">
1014
</td>
<td style="text-align:right;">
53.84615
</td>
<td style="text-align:right;">
0.95350
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
14.62882
</td>
<td style="text-align:right;">
0.7033
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
3238
</td>
<td style="text-align:right;">
7.751699
</td>
<td style="text-align:right;">
0.5588
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
5.157505
</td>
<td style="text-align:right;">
0.03597
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
5.219271
</td>
<td style="text-align:right;">
0.02111
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
1667.0000
</td>
<td style="text-align:right;">
19.37612
</td>
<td style="text-align:right;">
0.7205
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
277.0000
</td>
<td style="text-align:right;">
33.93502
</td>
<td style="text-align:right;">
0.9040
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3164
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1045
</td>
<td style="text-align:right;">
3238.0000
</td>
<td style="text-align:right;">
32.27301
</td>
<td style="text-align:right;">
0.5125
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1459
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
41.6038382
</td>
<td style="text-align:right;">
0.9185
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
4.4551062
</td>
<td style="text-align:right;">
0.6949
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1014
</td>
<td style="text-align:right;">
2.3668639
</td>
<td style="text-align:right;">
0.57900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
1014.0000
</td>
<td style="text-align:right;">
8.382643
</td>
<td style="text-align:right;">
0.6775
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1402
</td>
<td style="text-align:right;">
3238
</td>
<td style="text-align:right;">
43.2983323
</td>
<td style="text-align:right;">
0.9876
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.16580
</td>
<td style="text-align:right;">
0.9263
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1.77637
</td>
<td style="text-align:right;">
0.1225
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5125
</td>
<td style="text-align:right;">
0.5082
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.85750
</td>
<td style="text-align:right;">
0.9661
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.31217
</td>
<td style="text-align:right;">
0.8160
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 21.01, Calhoun County, Alabama
</td>
<td style="text-align:right;">
4968
</td>
<td style="text-align:right;">
92000
</td>
<td style="text-align:right;">
9312
</td>
<td style="text-align:right;">
153500
</td>
<td style="text-align:right;">
5762.88
</td>
<td style="text-align:right;">
106720
</td>
<td style="text-align:right;">
3549.12
</td>
<td style="text-align:right;">
0.6158587
</td>
<td style="text-align:right;">
46780
</td>
<td style="text-align:right;">
0.4383433
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
<tr>
<td style="text-align:left;">
01015002300
</td>
<td style="text-align:left;">
01015
</td>
<td style="text-align:left;">
002300
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Calhoun County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3882
</td>
<td style="text-align:right;">
1861
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
1366
</td>
<td style="text-align:right;">
3882
</td>
<td style="text-align:right;">
35.18805
</td>
<td style="text-align:right;">
0.7753
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1539
</td>
<td style="text-align:right;">
12.085770
</td>
<td style="text-align:right;">
0.80740
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
1109
</td>
<td style="text-align:right;">
25.60866
</td>
<td style="text-align:right;">
0.35530
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
499
</td>
<td style="text-align:right;">
40.48096
</td>
<td style="text-align:right;">
0.39670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
486
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
30.22388
</td>
<td style="text-align:right;">
0.34700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
2610
</td>
<td style="text-align:right;">
27.85441
</td>
<td style="text-align:right;">
0.8534
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
3706
</td>
<td style="text-align:right;">
14.759849
</td>
<td style="text-align:right;">
0.5669
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
18.444101
</td>
<td style="text-align:right;">
0.82530
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
904
</td>
<td style="text-align:right;">
23.286966
</td>
<td style="text-align:right;">
0.45720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
2919
</td>
<td style="text-align:right;">
24.63172
</td>
<td style="text-align:right;">
0.8986
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
1191
</td>
<td style="text-align:right;">
17.38035
</td>
<td style="text-align:right;">
0.5923
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3720
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
3882
</td>
<td style="text-align:right;">
12.62236
</td>
<td style="text-align:right;">
0.3118
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1861
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
2.0419130
</td>
<td style="text-align:right;">
0.4070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
10.6931757
</td>
<td style="text-align:right;">
0.7836
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
3.2338308
</td>
<td style="text-align:right;">
0.6986
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
10.323383
</td>
<td style="text-align:right;">
0.7304
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3882
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.35000
</td>
<td style="text-align:right;">
0.7384
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.86638
</td>
<td style="text-align:right;">
0.6919
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.3118
</td>
<td style="text-align:right;">
0.3089
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.9836
</td>
<td style="text-align:right;">
0.7289
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.51178
</td>
<td style="text-align:right;">
0.7100
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
3265
</td>
<td style="text-align:right;">
1774
</td>
<td style="text-align:right;">
1329
</td>
<td style="text-align:right;">
1103
</td>
<td style="text-align:right;">
3265
</td>
<td style="text-align:right;">
33.78254
</td>
<td style="text-align:right;">
0.7880
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
122
</td>
<td style="text-align:right;">
1422
</td>
<td style="text-align:right;">
8.579465
</td>
<td style="text-align:right;">
0.8131
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
844
</td>
<td style="text-align:right;">
11.966825
</td>
<td style="text-align:right;">
0.10960
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
485
</td>
<td style="text-align:right;">
25.979381
</td>
<td style="text-align:right;">
0.15930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
227
</td>
<td style="text-align:right;">
1329
</td>
<td style="text-align:right;">
17.08051
</td>
<td style="text-align:right;">
0.11070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
2122
</td>
<td style="text-align:right;">
12.58247
</td>
<td style="text-align:right;">
0.6388
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
3265
</td>
<td style="text-align:right;">
10.045942
</td>
<td style="text-align:right;">
0.6808
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
13.476263
</td>
<td style="text-align:right;">
0.36070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
843
</td>
<td style="text-align:right;">
25.819296
</td>
<td style="text-align:right;">
0.74470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
530
</td>
<td style="text-align:right;">
2422.0000
</td>
<td style="text-align:right;">
21.88274
</td>
<td style="text-align:right;">
0.8097
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
254
</td>
<td style="text-align:right;">
861.0000
</td>
<td style="text-align:right;">
29.50058
</td>
<td style="text-align:right;">
0.8574
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3026
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
811
</td>
<td style="text-align:right;">
3265.0000
</td>
<td style="text-align:right;">
24.83920
</td>
<td style="text-align:right;">
0.4221
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1774
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0.3945885
</td>
<td style="text-align:right;">
0.2444
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
338
</td>
<td style="text-align:right;">
19.0529876
</td>
<td style="text-align:right;">
0.8924
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
1329
</td>
<td style="text-align:right;">
1.4296464
</td>
<td style="text-align:right;">
0.44520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
120
</td>
<td style="text-align:right;">
1329.0000
</td>
<td style="text-align:right;">
9.029345
</td>
<td style="text-align:right;">
0.7016
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3265
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.03140
</td>
<td style="text-align:right;">
0.6608
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.86729
</td>
<td style="text-align:right;">
0.7016
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.4221
</td>
<td style="text-align:right;">
0.4185
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.46670
</td>
<td style="text-align:right;">
0.4669
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.78749
</td>
<td style="text-align:right;">
0.6230
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 23, Calhoun County, Alabama
</td>
<td style="text-align:right;">
15086
</td>
<td style="text-align:right;">
77500
</td>
<td style="text-align:right;">
21540
</td>
<td style="text-align:right;">
78500
</td>
<td style="text-align:right;">
17499.76
</td>
<td style="text-align:right;">
89900
</td>
<td style="text-align:right;">
4040.24
</td>
<td style="text-align:right;">
0.2308740
</td>
<td style="text-align:right;">
-11400
</td>
<td style="text-align:right;">
-0.1268076
</td>
<td style="text-align:right;">
120.54
</td>
<td style="text-align:right;">
131.82
</td>
<td style="text-align:left;">
Calhoun County, Alabama
</td>
<td style="text-align:left;">
Anniston-Oxford, AL MSA
</td>
<td style="text-align:left;">
C1150
</td>
</tr>
<tr>
<td style="text-align:left;">
01023956700
</td>
<td style="text-align:left;">
01023
</td>
<td style="text-align:left;">
956700
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Choctaw County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
3011
</td>
<td style="text-align:right;">
1772
</td>
<td style="text-align:right;">
1179
</td>
<td style="text-align:right;">
1715
</td>
<td style="text-align:right;">
3011
</td>
<td style="text-align:right;">
56.95782
</td>
<td style="text-align:right;">
0.9531
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
266
</td>
<td style="text-align:right;">
890
</td>
<td style="text-align:right;">
29.887640
</td>
<td style="text-align:right;">
0.99100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
1035
</td>
<td style="text-align:right;">
25.79710
</td>
<td style="text-align:right;">
0.36240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
54.86111
</td>
<td style="text-align:right;">
0.73440
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
1179
</td>
<td style="text-align:right;">
29.34690
</td>
<td style="text-align:right;">
0.31850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
2053
</td>
<td style="text-align:right;">
35.94739
</td>
<td style="text-align:right;">
0.9287
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
543
</td>
<td style="text-align:right;">
2904
</td>
<td style="text-align:right;">
18.698347
</td>
<td style="text-align:right;">
0.7133
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
569
</td>
<td style="text-align:right;">
18.897376
</td>
<td style="text-align:right;">
0.84040
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
648
</td>
<td style="text-align:right;">
21.521089
</td>
<td style="text-align:right;">
0.33840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
813
</td>
<td style="text-align:right;">
2273
</td>
<td style="text-align:right;">
35.76771
</td>
<td style="text-align:right;">
0.9901
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
32.68482
</td>
<td style="text-align:right;">
0.8778
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2880
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2455
</td>
<td style="text-align:right;">
3011
</td>
<td style="text-align:right;">
81.53437
</td>
<td style="text-align:right;">
0.8712
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1772
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
2.1444695
</td>
<td style="text-align:right;">
0.4136
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
485
</td>
<td style="text-align:right;">
27.3702032
</td>
<td style="text-align:right;">
0.9349
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1179
</td>
<td style="text-align:right;">
6.1068702
</td>
<td style="text-align:right;">
0.8435
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
1179
</td>
<td style="text-align:right;">
9.245123
</td>
<td style="text-align:right;">
0.6964
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3011
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.90460
</td>
<td style="text-align:right;">
0.8597
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.13968
</td>
<td style="text-align:right;">
0.8131
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.8712
</td>
<td style="text-align:right;">
0.8631
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.2524
</td>
<td style="text-align:right;">
0.8387
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.16788
</td>
<td style="text-align:right;">
0.8840
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
3335
</td>
<td style="text-align:right;">
1912
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
1135
</td>
<td style="text-align:right;">
3313
</td>
<td style="text-align:right;">
34.25898
</td>
<td style="text-align:right;">
0.7948
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
1147
</td>
<td style="text-align:right;">
16.390584
</td>
<td style="text-align:right;">
0.9686
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
20.037807
</td>
<td style="text-align:right;">
0.45090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
8.881579
</td>
<td style="text-align:right;">
0.02679
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
17.54772
</td>
<td style="text-align:right;">
0.12350
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
466
</td>
<td style="text-align:right;">
2537
</td>
<td style="text-align:right;">
18.36815
</td>
<td style="text-align:right;">
0.7948
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
495
</td>
<td style="text-align:right;">
3335
</td>
<td style="text-align:right;">
14.842579
</td>
<td style="text-align:right;">
0.8413
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
791
</td>
<td style="text-align:right;">
23.718141
</td>
<td style="text-align:right;">
0.85250
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
613
</td>
<td style="text-align:right;">
18.380810
</td>
<td style="text-align:right;">
0.27840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
884
</td>
<td style="text-align:right;">
2714.0000
</td>
<td style="text-align:right;">
32.57185
</td>
<td style="text-align:right;">
0.9752
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
918.0000
</td>
<td style="text-align:right;">
25.05447
</td>
<td style="text-align:right;">
0.7925
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
3103
</td>
<td style="text-align:right;">
0.8056719
</td>
<td style="text-align:right;">
0.41920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2637
</td>
<td style="text-align:right;">
3335.0000
</td>
<td style="text-align:right;">
79.07046
</td>
<td style="text-align:right;">
0.8436
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1912
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
758
</td>
<td style="text-align:right;">
39.6443515
</td>
<td style="text-align:right;">
0.9799
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
1.1747430
</td>
<td style="text-align:right;">
0.40060
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
1362.0000
</td>
<td style="text-align:right;">
5.506608
</td>
<td style="text-align:right;">
0.5316
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
3335
</td>
<td style="text-align:right;">
0.2398801
</td>
<td style="text-align:right;">
0.4965
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.52300
</td>
<td style="text-align:right;">
0.7901
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.31780
</td>
<td style="text-align:right;">
0.8870
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.8436
</td>
<td style="text-align:right;">
0.8365
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.51650
</td>
<td style="text-align:right;">
0.4924
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
10.20090
</td>
<td style="text-align:right;">
0.8033
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 9567, Choctaw County, Alabama
</td>
<td style="text-align:right;">
12737
</td>
<td style="text-align:right;">
60900
</td>
<td style="text-align:right;">
16852
</td>
<td style="text-align:right;">
63400
</td>
<td style="text-align:right;">
14774.92
</td>
<td style="text-align:right;">
70644
</td>
<td style="text-align:right;">
2077.08
</td>
<td style="text-align:right;">
0.1405815
</td>
<td style="text-align:right;">
-7244
</td>
<td style="text-align:right;">
-0.1025423
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01023957000
</td>
<td style="text-align:left;">
01023
</td>
<td style="text-align:left;">
957000
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Choctaw County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
2567
</td>
<td style="text-align:right;">
1187
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
767
</td>
<td style="text-align:right;">
2567
</td>
<td style="text-align:right;">
29.87924
</td>
<td style="text-align:right;">
0.6933
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
145
</td>
<td style="text-align:right;">
1060
</td>
<td style="text-align:right;">
13.679245
</td>
<td style="text-align:right;">
0.86050
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
14.04729
</td>
<td style="text-align:right;">
0.04540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
21.82741
</td>
<td style="text-align:right;">
0.09791
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
15.72052
</td>
<td style="text-align:right;">
0.02333
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
1704
</td>
<td style="text-align:right;">
20.83333
</td>
<td style="text-align:right;">
0.7366
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
289
</td>
<td style="text-align:right;">
2296
</td>
<td style="text-align:right;">
12.587108
</td>
<td style="text-align:right;">
0.4736
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
12.621737
</td>
<td style="text-align:right;">
0.51120
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
688
</td>
<td style="text-align:right;">
26.801714
</td>
<td style="text-align:right;">
0.68810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
572
</td>
<td style="text-align:right;">
1746
</td>
<td style="text-align:right;">
32.76060
</td>
<td style="text-align:right;">
0.9809
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
636
</td>
<td style="text-align:right;">
19.02516
</td>
<td style="text-align:right;">
0.6414
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2283
</td>
<td style="text-align:right;">
0.2190101
</td>
<td style="text-align:right;">
0.22520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1314
</td>
<td style="text-align:right;">
2567
</td>
<td style="text-align:right;">
51.18816
</td>
<td style="text-align:right;">
0.7225
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1187
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
335
</td>
<td style="text-align:right;">
28.2224094
</td>
<td style="text-align:right;">
0.9394
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
1.4192140
</td>
<td style="text-align:right;">
0.4834
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
7.641921
</td>
<td style="text-align:right;">
0.6353
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2567
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.78733
</td>
<td style="text-align:right;">
0.5903
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.04680
</td>
<td style="text-align:right;">
0.7745
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7225
</td>
<td style="text-align:right;">
0.7158
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.5445
</td>
<td style="text-align:right;">
0.5114
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.10113
</td>
<td style="text-align:right;">
0.6601
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2077
</td>
<td style="text-align:right;">
1158
</td>
<td style="text-align:right;">
866
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
2072
</td>
<td style="text-align:right;">
36.63127
</td>
<td style="text-align:right;">
0.8256
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
780
</td>
<td style="text-align:right;">
7.820513
</td>
<td style="text-align:right;">
0.7726
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
735
</td>
<td style="text-align:right;">
14.421769
</td>
<td style="text-align:right;">
0.19760
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
8.396947
</td>
<td style="text-align:right;">
0.02525
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
866
</td>
<td style="text-align:right;">
13.51039
</td>
<td style="text-align:right;">
0.04053
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
23.97541
</td>
<td style="text-align:right;">
0.8815
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
2077
</td>
<td style="text-align:right;">
9.870005
</td>
<td style="text-align:right;">
0.6729
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
402
</td>
<td style="text-align:right;">
19.354839
</td>
<td style="text-align:right;">
0.68820
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
496
</td>
<td style="text-align:right;">
23.880597
</td>
<td style="text-align:right;">
0.63430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
466
</td>
<td style="text-align:right;">
1576.0000
</td>
<td style="text-align:right;">
29.56853
</td>
<td style="text-align:right;">
0.9544
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
154
</td>
<td style="text-align:right;">
612.0000
</td>
<td style="text-align:right;">
25.16340
</td>
<td style="text-align:right;">
0.7942
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2002
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1018
</td>
<td style="text-align:right;">
2077.0000
</td>
<td style="text-align:right;">
49.01300
</td>
<td style="text-align:right;">
0.6638
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1158
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
37.9101900
</td>
<td style="text-align:right;">
0.9766
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
866
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
866.0000
</td>
<td style="text-align:right;">
4.849884
</td>
<td style="text-align:right;">
0.4884
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2077
</td>
<td style="text-align:right;">
0.2407318
</td>
<td style="text-align:right;">
0.4971
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.19313
</td>
<td style="text-align:right;">
0.7061
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.16589
</td>
<td style="text-align:right;">
0.8369
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6638
</td>
<td style="text-align:right;">
0.6582
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.16796
</td>
<td style="text-align:right;">
0.3247
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9.19078
</td>
<td style="text-align:right;">
0.6792
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 9570, Choctaw County, Alabama
</td>
<td style="text-align:right;">
16224
</td>
<td style="text-align:right;">
51600
</td>
<td style="text-align:right;">
21740
</td>
<td style="text-align:right;">
74000
</td>
<td style="text-align:right;">
18819.84
</td>
<td style="text-align:right;">
59856
</td>
<td style="text-align:right;">
2920.16
</td>
<td style="text-align:right;">
0.1551639
</td>
<td style="text-align:right;">
14144
</td>
<td style="text-align:right;">
0.2363005
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01031010500
</td>
<td style="text-align:left;">
01031
</td>
<td style="text-align:left;">
010500
</td>
<td style="text-align:left;">
AL
</td>
<td style="text-align:left;">
Alabama
</td>
<td style="text-align:left;">
Coffee County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
East South Central Division
</td>
<td style="text-align:right;">
4529
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
1649
</td>
<td style="text-align:right;">
4022
</td>
<td style="text-align:right;">
40.99950
</td>
<td style="text-align:right;">
0.8432
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
1424
</td>
<td style="text-align:right;">
8.005618
</td>
<td style="text-align:right;">
0.56260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
309
</td>
<td style="text-align:right;">
1057
</td>
<td style="text-align:right;">
29.23368
</td>
<td style="text-align:right;">
0.48130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
41.35091
</td>
<td style="text-align:right;">
0.41690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
33.65385
</td>
<td style="text-align:right;">
0.45740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1269
</td>
<td style="text-align:right;">
3370
</td>
<td style="text-align:right;">
37.65579
</td>
<td style="text-align:right;">
0.9387
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
516
</td>
<td style="text-align:right;">
4279
</td>
<td style="text-align:right;">
12.058892
</td>
<td style="text-align:right;">
0.4492
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
832
</td>
<td style="text-align:right;">
18.370501
</td>
<td style="text-align:right;">
0.82310
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
894
</td>
<td style="text-align:right;">
19.739457
</td>
<td style="text-align:right;">
0.23950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1023
</td>
<td style="text-align:right;">
3404
</td>
<td style="text-align:right;">
30.05288
</td>
<td style="text-align:right;">
0.9666
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
303
</td>
<td style="text-align:right;">
1112
</td>
<td style="text-align:right;">
27.24820
</td>
<td style="text-align:right;">
0.8108
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
4270
</td>
<td style="text-align:right;">
1.0070258
</td>
<td style="text-align:right;">
0.44510
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1761
</td>
<td style="text-align:right;">
4529
</td>
<td style="text-align:right;">
38.88276
</td>
<td style="text-align:right;">
0.6383
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0.3076923
</td>
<td style="text-align:right;">
0.2576
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
14.1538462
</td>
<td style="text-align:right;">
0.8279
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
0.4807692
</td>
<td style="text-align:right;">
0.2925
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
7.512019
</td>
<td style="text-align:right;">
0.6289
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
4529
</td>
<td style="text-align:right;">
11.19452
</td>
<td style="text-align:right;">
0.9441
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.25110
</td>
<td style="text-align:right;">
0.7138
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.28510
</td>
<td style="text-align:right;">
0.8639
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.6383
</td>
<td style="text-align:right;">
0.6324
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.9510
</td>
<td style="text-align:right;">
0.7136
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.12550
</td>
<td style="text-align:right;">
0.7794
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
2118
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
1329
</td>
<td style="text-align:right;">
4470
</td>
<td style="text-align:right;">
29.73154
</td>
<td style="text-align:right;">
0.7256
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
1903
</td>
<td style="text-align:right;">
7.724645
</td>
<td style="text-align:right;">
0.7670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
1256
</td>
<td style="text-align:right;">
16.640127
</td>
<td style="text-align:right;">
0.29310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
208
</td>
<td style="text-align:right;">
475
</td>
<td style="text-align:right;">
43.789474
</td>
<td style="text-align:right;">
0.51620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
417
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
24.09012
</td>
<td style="text-align:right;">
0.33700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
953
</td>
<td style="text-align:right;">
3728
</td>
<td style="text-align:right;">
25.56330
</td>
<td style="text-align:right;">
0.8985
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
668
</td>
<td style="text-align:right;">
4485
</td>
<td style="text-align:right;">
14.894091
</td>
<td style="text-align:right;">
0.8425
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1053
</td>
<td style="text-align:right;">
21.869159
</td>
<td style="text-align:right;">
0.79500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
766
</td>
<td style="text-align:right;">
15.908619
</td>
<td style="text-align:right;">
0.16760
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1010
</td>
<td style="text-align:right;">
3719.0000
</td>
<td style="text-align:right;">
27.15784
</td>
<td style="text-align:right;">
0.9262
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
1133.0000
</td>
<td style="text-align:right;">
21.44748
</td>
<td style="text-align:right;">
0.7184
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4577
</td>
<td style="text-align:right;">
0.0218484
</td>
<td style="text-align:right;">
0.19150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1643
</td>
<td style="text-align:right;">
4815.0000
</td>
<td style="text-align:right;">
34.12253
</td>
<td style="text-align:right;">
0.5321
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2118
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1079
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
475
</td>
<td style="text-align:right;">
22.4268178
</td>
<td style="text-align:right;">
0.9157
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
2.1374928
</td>
<td style="text-align:right;">
0.55080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
1731.0000
</td>
<td style="text-align:right;">
8.318891
</td>
<td style="text-align:right;">
0.6750
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
6.8535826
</td>
<td style="text-align:right;">
0.9282
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.57060
</td>
<td style="text-align:right;">
0.8018
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.79870
</td>
<td style="text-align:right;">
0.6649
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.5321
</td>
<td style="text-align:right;">
0.5276
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.17760
</td>
<td style="text-align:right;">
0.7990
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.07900
</td>
<td style="text-align:right;">
0.7892
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 105, Coffee County, Alabama
</td>
<td style="text-align:right;">
14641
</td>
<td style="text-align:right;">
88000
</td>
<td style="text-align:right;">
21367
</td>
<td style="text-align:right;">
78100
</td>
<td style="text-align:right;">
16983.56
</td>
<td style="text-align:right;">
102080
</td>
<td style="text-align:right;">
4383.44
</td>
<td style="text-align:right;">
0.2580990
</td>
<td style="text-align:right;">
-23980
</td>
<td style="text-align:right;">
-0.2349138
</td>
<td style="text-align:right;">
128.88
</td>
<td style="text-align:right;">
137.26
</td>
<td style="text-align:left;">
Coffee County, Alabama
</td>
<td style="text-align:left;">
Dothan-Enterprise-Ozark, AL CSA
</td>
<td style="text-align:left;">
CS222
</td>
</tr>
</tbody>
</table>

</div>

# Log NMTC and LIHTC Variables

``` r
svi_national_nmtc_df$Median_Income_10adj_log <- log(svi_national_nmtc_df$Median_Income_10adj)
svi_national_nmtc_df$Median_Income_19_log <- log(svi_national_nmtc_df$Median_Income_19)

svi_national_nmtc_df$Median_Home_Value_10adj_log = log(svi_national_nmtc_df$Median_Home_Value_10adj)
svi_national_nmtc_df$Median_Home_Value_19_log = log(svi_national_nmtc_df$Median_Home_Value_19)

svi_national_nmtc_df$housing_price_index10_log = log(svi_national_nmtc_df$housing_price_index10)
svi_national_nmtc_df$housing_price_index20_log = log(svi_national_nmtc_df$housing_price_index20)

svi_divisional_nmtc_df$Median_Income_10adj_log <- log(svi_divisional_nmtc_df$Median_Income_10adj)
svi_divisional_nmtc_df$Median_Income_19_log <- log(svi_divisional_nmtc_df$Median_Income_19)

svi_divisional_nmtc_df$Median_Home_Value_10adj_log = log(svi_divisional_nmtc_df$Median_Home_Value_10adj)
svi_divisional_nmtc_df$Median_Home_Value_19_log = log(svi_divisional_nmtc_df$Median_Home_Value_19)

svi_divisional_nmtc_df$housing_price_index10_log = log(svi_divisional_nmtc_df$housing_price_index10)
svi_divisional_nmtc_df$housing_price_index20_log = log(svi_divisional_nmtc_df$housing_price_index20)

svi_national_lihtc_df$Median_Income_10adj_log <- log(svi_national_lihtc_df$Median_Income_10adj)
svi_national_lihtc_df$Median_Income_19_log <- log(svi_national_lihtc_df$Median_Income_19)

svi_national_lihtc_df$Median_Home_Value_10adj_log = log(svi_national_lihtc_df$Median_Home_Value_10adj)
svi_national_lihtc_df$Median_Home_Value_19_log = log(svi_national_lihtc_df$Median_Home_Value_19)

svi_national_lihtc_df$housing_price_index10_log = log(svi_national_lihtc_df$housing_price_index10)
svi_national_lihtc_df$housing_price_index20_log = log(svi_national_lihtc_df$housing_price_index20)

svi_divisional_lihtc_df$Median_Income_10adj_log <- log(svi_divisional_lihtc_df$Median_Income_10adj)
svi_divisional_lihtc_df$Median_Income_19_log <- log(svi_divisional_lihtc_df$Median_Income_19)

svi_divisional_lihtc_df$Median_Home_Value_10adj_log = log(svi_divisional_lihtc_df$Median_Home_Value_10adj)
svi_divisional_lihtc_df$Median_Home_Value_19_log = log(svi_divisional_lihtc_df$Median_Home_Value_19)

svi_divisional_lihtc_df$housing_price_index10_log = log(svi_divisional_lihtc_df$housing_price_index10)
svi_divisional_lihtc_df$housing_price_index20_log = log(svi_divisional_lihtc_df$housing_price_index20)
```

# Diff-in-Diff Models

## NMTC Evaluation

### National SVI

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010
nmtc_did10_usa_svi <- svi_national_nmtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_10, F_THEME2_10, F_THEME3_10, F_THEME4_10, F_TOTAL_10, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_10",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_10",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_10",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_10",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_10") 

nrow(nmtc_did10_usa_svi)
```

    ## [1] 29068

``` r
nmtc_did10_usa_svi %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_SES
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_HHCHAR
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_REM
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_HOUSETRANSPT
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_OVERALL
</th>
<th style="text-align:right;">
treat
</th>
<th style="text-align:right;">
post
</th>
<th style="text-align:right;">
year
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
<tr>
<td style="text-align:left;">
01001021100
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010200
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010500
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010600
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2010
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Create 2020 df, create post variable and set to 1, create year variable and set to 2020
nmtc_did20_usa_svi <- svi_national_nmtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_20, F_THEME2_20, F_THEME3_20, F_THEME4_20, F_TOTAL_20, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "nmtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_20",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_20",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_20",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_20",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_20"
         )


nrow(nmtc_did20_usa_svi)
```

    ## [1] 29068

``` r
nmtc_did20_usa_svi %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
</th>
<th style="text-align:left;">
cbsa
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_SES
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_HHCHAR
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_REM
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_HOUSETRANSPT
</th>
<th style="text-align:right;">
SVI_FLAG_COUNT_OVERALL
</th>
<th style="text-align:right;">
treat
</th>
<th style="text-align:right;">
post
</th>
<th style="text-align:right;">
year
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020200
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020700
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
<tr>
<td style="text-align:left;">
01001021100
</td>
<td style="text-align:left;">
Montgomery-Alexander City, AL CSA
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010200
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010500
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
<tr>
<td style="text-align:left;">
01003010600
</td>
<td style="text-align:left;">
Mobile-Daphne-Fairhope, AL CSA
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2020
</td>
</tr>
</tbody>
</table>

</div>

``` r
nmtc_diff_in_diff_usa_svi <- bind_rows(nmtc_did10_usa_svi, nmtc_did20_usa_svi)

nmtc_diff_in_diff_usa_svi <- nmtc_diff_in_diff_usa_svi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_usa_svi)
```

    ## [1] 58136

### National Median Income

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010, remove any tracts that don't have data for 2010 and 2019
nmtc_did10_usa_inc <- svi_national_nmtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_10adj_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_INCOME" = "Median_Income_10adj_log") 


nrow(nmtc_did10_usa_inc)
```

    ## [1] 29055

``` r
# Create 2019 df, create post variable and set to 1, create year variable and set to 2019, remove any tracts that don't have data for 2010 and 2019
nmtc_did19_usa_inc <- svi_national_nmtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_19_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_INCOME" = "Median_Income_19_log") 


nrow(nmtc_did19_usa_inc)
```

    ## [1] 29055

``` r
nmtc_diff_in_diff_usa_inc <- bind_rows(nmtc_did10_usa_inc, nmtc_did19_usa_inc)

nmtc_diff_in_diff_usa_inc <- nmtc_diff_in_diff_usa_inc %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_usa_inc)
```

    ## [1] 58110

### National Median Home Value

``` r
nmtc_did10_usa_mhv <- svi_national_nmtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_10adj_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_10adj_log") 


nrow(nmtc_did10_usa_mhv)
```

    ## [1] 28199

``` r
nmtc_did19_usa_mhv <- svi_national_nmtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_19_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_19_log") 


nrow(nmtc_did19_usa_mhv)
```

    ## [1] 28199

``` r
nmtc_diff_in_diff_usa_mhv <- bind_rows(nmtc_did10_usa_mhv, nmtc_did19_usa_mhv)

nmtc_diff_in_diff_usa_mhv <- nmtc_diff_in_diff_usa_mhv %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_usa_mhv)
```

    ## [1] 56398

### National House Price Index

``` r
nmtc_did10_usa_hpi <- svi_national_nmtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index10_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index10_log") 


nrow(nmtc_did10_usa_hpi)
```

    ## [1] 13611

``` r
nmtc_did20_usa_hpi <- svi_national_nmtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index20_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "nmtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index20_log") 


nrow(nmtc_did20_usa_hpi)
```

    ## [1] 13611

``` r
nmtc_diff_in_diff_usa_hpi <- bind_rows(nmtc_did10_usa_hpi, nmtc_did20_usa_hpi)

nmtc_diff_in_diff_usa_hpi <- nmtc_diff_in_diff_usa_hpi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_usa_hpi)
```

    ## [1] 27222

# NMTC Divisional

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010
nmtc_did10_div_svi <- svi_divisional_nmtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_10, F_THEME2_10, F_THEME3_10, F_THEME4_10, F_TOTAL_10, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_10",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_10",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_10",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_10",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_10") 

nrow(nmtc_did10_div_svi)
```

    ## [1] 5889

``` r
# Create 2020 df, create post variable and set to 1, create year variable and set to 2020
nmtc_did20_div_svi <- svi_divisional_nmtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_20, F_THEME2_20, F_THEME3_20, F_THEME4_20, F_TOTAL_20, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "nmtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_20",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_20",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_20",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_20",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_20"
  )


nrow(nmtc_did20_div_svi)
```

    ## [1] 5889

``` r
nmtc_diff_in_diff_div_svi <- bind_rows(nmtc_did10_div_svi, nmtc_did20_div_svi)

nmtc_diff_in_diff_div_svi <- nmtc_diff_in_diff_div_svi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_svi)
```

    ## [1] 11778

## Median Income

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010, remove any tracts that don't have data for 2010 and 2019
nmtc_did10_div_inc <- svi_divisional_nmtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_10adj_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_INCOME" = "Median_Income_10adj_log") 


nrow(nmtc_did10_div_inc)
```

    ## [1] 5885

``` r
# Create 2019 df, create post variable and set to 1, create year variable and set to 2019, remove any tracts that don't have data for 2010 and 2019
nmtc_did19_div_inc <- svi_divisional_nmtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_19_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_INCOME" = "Median_Income_19_log") 


nrow(nmtc_did19_div_inc)
```

    ## [1] 5885

``` r
nmtc_diff_in_diff_div_inc <- bind_rows(nmtc_did10_div_inc, nmtc_did19_div_inc)

nmtc_diff_in_diff_div_inc <- nmtc_diff_in_diff_div_inc %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_inc)
```

    ## [1] 11770

## Home Value

``` r
nmtc_did10_div_mhv <- svi_divisional_nmtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_10adj_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_10adj_log") 


nrow(nmtc_did10_div_mhv)
```

    ## [1] 5768

``` r
nmtc_did19_div_mhv <- svi_divisional_nmtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_19_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "nmtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_19_log") 


nrow(nmtc_did19_div_mhv)
```

    ## [1] 5768

``` r
nmtc_diff_in_diff_div_mhv <- bind_rows(nmtc_did10_div_mhv, nmtc_did19_div_mhv)

nmtc_diff_in_diff_div_mhv <- nmtc_diff_in_diff_div_mhv %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_mhv)
```

    ## [1] 11536

## House Price Index

``` r
nmtc_did10_div_hpi <- svi_divisional_nmtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index10_log, nmtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "nmtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index10_log") 


nrow(nmtc_did10_div_hpi)
```

    ## [1] 2761

``` r
nmtc_did20_div_hpi <- svi_divisional_nmtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index20_log, nmtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "nmtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index20_log") 


nrow(nmtc_did20_div_hpi)
```

    ## [1] 2761

``` r
nmtc_diff_in_diff_div_hpi <- bind_rows(nmtc_did10_div_hpi, nmtc_did20_div_hpi)

nmtc_diff_in_diff_div_hpi <- nmtc_diff_in_diff_div_hpi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_hpi)
```

    ## [1] 5522

# Homework

#### For this evaluation, we employ a difference-in-differences (diff-in-diff) model to estimate the impact of federal tax credit programs on socioeconomic outcomes. The diff-in-diff approach allows us to compare changes over time between areas that received interventions and those that did not. We will be comparing groups from both Low-Income Housing Tax Credits (LIHTC) and New Markets Tax Credits (NMTC).

#### Our dependent variables capture key measures of tract well-being:

#### \* Social Vulnerability Index

#### \* Median Household Income

#### \* Median Home Value

#### \* House Price Index

#### These variables provide a comprehensive view of both economic and social changes in the communities studied. The independent variables focus on the presence and intensity of LIHTC and NMTC allocations, representing targeted federal investments intended to stimulate housing affordability and economic development in underserved areas.

## NMTC Divisional Models

``` r
# SVI & Economic Models

m1_nmtc_div <- lm( SVI_FLAG_COUNT_SES ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_svi )

m2_nmtc_div <- lm( SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_svi )

m3_nmtc_div <- lm( SVI_FLAG_COUNT_REM ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_svi )

m4_nmtc_div <- lm( SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_svi )

m5_nmtc_div <- lm( SVI_FLAG_COUNT_OVERALL  ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_svi)

m6_nmtc_div <- lm( MEDIAN_INCOME ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_inc )

m7_nmtc_div <- lm( MEDIAN_HOME_VALUE ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_mhv )

m8_nmtc_div <- lm( HOUSE_PRICE_INDEX ~ treat + post + treat*post + cbsa, data=nmtc_diff_in_diff_div_hpi )

# Add all models to a list
models <- list(
  
  "SES" = m1_nmtc_div,
  "HHChar"  = m2_nmtc_div,
  "REM" = m3_nmtc_div,
  "HOUSETRANSPT" = m4_nmtc_div,
  "OVERALL" = m5_nmtc_div,
  "Median Income (USD, logged)" = m6_nmtc_div,
  "Median Home Value (USD, logged)" = m7_nmtc_div,
  "House Price Index (logged)" = m8_nmtc_div
)


# Display model results
modelsummary(models,  fmt = 2, stars = c('*' = .05, '**' = .01, '***' = .001), coef_omit = "cbsa", gof_omit = "IC|Log",
             notes = list('All models include metro-level fixed effects by core-based statistical area (cbsa).'),
             title = paste0("Differences-in-Differences Linear Regression Analysis of NMTC in ", census_division)) %>%
  group_tt(j = list("Social Vulnerability" = 2:6, "Economic Outcomes" = 7:9))
```

<table style="width:96%;">
<caption>Differences-in-Differences Linear Regression Analysis of NMTC
in South Atlantic Division</caption>
<colgroup>
<col style="width: 8%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 8%" />
<col style="width: 5%" />
<col style="width: 17%" />
<col style="width: 20%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th></th>
<th colspan="5">Social Vulnerability</th>
<th colspan="3">Economic Outcomes</th>
</tr>
<tr class="odd">
<th></th>
<th>SES</th>
<th>HHChar</th>
<th>REM</th>
<th>HOUSETRANSPT</th>
<th>OVERALL</th>
<th>Median Income (USD, logged)</th>
<th>Median Home Value (USD, logged)</th>
<th>House Price Index (logged)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>(Intercept)</td>
<td>3.08***</td>
<td>1.76***</td>
<td>0.64***</td>
<td>1.44***</td>
<td>6.92***</td>
<td>9.87***</td>
<td>11.43***</td>
<td>4.80***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.18)</td>
<td>(0.13)</td>
<td>(0.06)</td>
<td>(0.13)</td>
<td>(0.36)</td>
<td>(0.04)</td>
<td>(0.05)</td>
<td>(0.08)</td>
</tr>
<tr class="odd">
<td>treat</td>
<td>0.91***</td>
<td>0.26***</td>
<td>0.18***</td>
<td>0.44***</td>
<td>1.78***</td>
<td>-0.21***</td>
<td>-0.09***</td>
<td>-0.08**</td>
</tr>
<tr class="even">
<td></td>
<td>(0.08)</td>
<td>(0.06)</td>
<td>(0.03)</td>
<td>(0.06)</td>
<td>(0.17)</td>
<td>(0.02)</td>
<td>(0.02)</td>
<td>(0.03)</td>
</tr>
<tr class="odd">
<td>post</td>
<td>0.01</td>
<td>-0.04</td>
<td>-0.00</td>
<td>0.01</td>
<td>-0.02</td>
<td>-0.00</td>
<td>-0.14***</td>
<td>0.33***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.03)</td>
<td>(0.02)</td>
<td>(0.01)</td>
<td>(0.02)</td>
<td>(0.06)</td>
<td>(0.01)</td>
<td>(0.01)</td>
<td>(0.01)</td>
</tr>
<tr class="odd">
<td>treat × post</td>
<td>-0.15</td>
<td>-0.13</td>
<td>-0.02</td>
<td>0.00</td>
<td>-0.29</td>
<td>0.06*</td>
<td>0.02</td>
<td>0.05</td>
</tr>
<tr class="even">
<td></td>
<td>(0.12)</td>
<td>(0.08)</td>
<td>(0.04)</td>
<td>(0.09)</td>
<td>(0.23)</td>
<td>(0.03)</td>
<td>(0.03)</td>
<td>(0.04)</td>
</tr>
<tr class="odd">
<td>Num.Obs.</td>
<td>10490</td>
<td>10490</td>
<td>10490</td>
<td>10490</td>
<td>10490</td>
<td>10482</td>
<td>10248</td>
<td>5086</td>
</tr>
<tr class="even">
<td>R2</td>
<td>0.168</td>
<td>0.098</td>
<td>0.247</td>
<td>0.081</td>
<td>0.177</td>
<td>0.201</td>
<td>0.424</td>
<td>0.371</td>
</tr>
<tr class="odd">
<td>R2 Adj.</td>
<td>0.158</td>
<td>0.087</td>
<td>0.237</td>
<td>0.069</td>
<td>0.166</td>
<td>0.191</td>
<td>0.416</td>
<td>0.356</td>
</tr>
<tr class="even">
<td>RMSE</td>
<td>1.39</td>
<td>0.96</td>
<td>0.43</td>
<td>1.00</td>
<td>2.73</td>
<td>0.29</td>
<td>0.39</td>
<td>0.31</td>
</tr>
<tr class="odd">
<td colspan="9"><ul>
<li>p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tbody><tfoot>
<tr class="odd">
<td colspan="9">All models include metro-level fixed effects by
core-based statistical area (cbsa).</td>
</tr>
</tfoot>
&#10;</table>

Differences-in-Differences Linear Regression Analysis of NMTC in South
Atlantic Division

#### In the above graph, we can use the different combined results to understand how the NMTC program affected, or did not affect, Social Economic Status (SES). We can see this through:

#### \* The starting amount of flags for the column (Intercept)

#### \* The effect of the program to the column (Intercept + Treat)

#### \* The change after the initial period, regaurdless of whether or not in the program (Intercept + Post)

#### \* The change after the initial period for those in the program (Intercept + Treat x Post)

#### In the South Atlantic Division for those in the NMTC program, we can see that there was a slight decrease in the amount of flags. However, the changes were not statistically significant. For this reason, we are unable to determine whether or not the program was successful in affecting SES.

#### Due to our results, it is possible that a different model, or including omitted variables, would lead to better results.

## Visualize NMTC Divisional Models

#### Since we did not have any significant significance, we do not need to visualize our outcomes.

# LIHTC Divisional

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010
lihtc_did10_div_svi <- svi_divisional_lihtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_10, F_THEME2_10, F_THEME3_10, F_THEME4_10, F_TOTAL_10, lihtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "lihtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_10",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_10",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_10",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_10",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_10") 

nrow(lihtc_did10_div_svi)
```

    ## [1] 538

``` r
# Create 2020 df, create post variable and set to 1, create year variable and set to 2020
lihtc_did20_div_svi <- svi_divisional_lihtc_df %>% 
  select(GEOID_2010_trt, cbsa, F_THEME1_20, F_THEME2_20, F_THEME3_20, F_THEME4_20, F_TOTAL_20, lihtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "lihtc_flag",
         "SVI_FLAG_COUNT_SES" = "F_THEME1_20",
         "SVI_FLAG_COUNT_HHCHAR" = "F_THEME2_20",
         "SVI_FLAG_COUNT_REM" = "F_THEME3_20",
         "SVI_FLAG_COUNT_HOUSETRANSPT" = "F_THEME4_20",
         "SVI_FLAG_COUNT_OVERALL" = "F_TOTAL_20"
  )


nrow(lihtc_did20_div_svi)
```

    ## [1] 538

``` r
lihtc_diff_in_diff_div_svi <- bind_rows(lihtc_did10_div_svi, lihtc_did20_div_svi)

lihtc_diff_in_diff_div_svi <- lihtc_diff_in_diff_div_svi %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_svi)
```

    ## [1] 1076

## Median Income

``` r
# Create 2010 df, create post variable and set to 0, create year variable and set to 2010, remove any tracts that don't have data for 2010 and 2019
lihtc_did10_div_inc <- svi_divisional_lihtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_10adj_log, lihtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "lihtc_flag",
         "MEDIAN_INCOME" = "Median_Income_10adj_log") 


nrow(lihtc_did10_div_inc)
```

    ## [1] 537

``` r
# Create 2019 df, create post variable and set to 1, create year variable and set to 2019, remove any tracts that don't have data for 2010 and 2019
lihtc_did19_div_inc <- svi_divisional_lihtc_df %>% 
  filter(!is.na(Median_Income_10adj_log)) %>% filter(!is.na(Median_Income_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Income_19_log, lihtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "lihtc_flag",
         "MEDIAN_INCOME" = "Median_Income_19_log") 


nrow(lihtc_did19_div_inc)
```

    ## [1] 537

``` r
lihtc_diff_in_diff_div_inc <- bind_rows(lihtc_did10_div_inc, lihtc_did19_div_inc)

lihtc_diff_in_diff_div_inc <- lihtc_diff_in_diff_div_inc %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_inc)
```

    ## [1] 1074

## Home Value

``` r
lihtc_did10_div_mhv <- svi_divisional_lihtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_10adj_log, lihtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "lihtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_10adj_log") 


nrow(lihtc_did10_div_mhv)
```

    ## [1] 514

``` r
lihtc_did19_div_mhv <- svi_divisional_lihtc_df %>% 
  filter(!is.na(Median_Home_Value_10adj_log)) %>% filter(!is.na(Median_Home_Value_19_log)) %>%
  select(GEOID_2010_trt, cbsa, Median_Home_Value_19_log, lihtc_flag) %>% 
  mutate(post = 1,
         year = 2019) %>%
  rename("treat" = "lihtc_flag",
         "MEDIAN_HOME_VALUE" = "Median_Home_Value_19_log") 


nrow(lihtc_did19_div_mhv)
```

    ## [1] 514

``` r
lihtc_diff_in_diff_div_mhv <- bind_rows(lihtc_did10_div_mhv, lihtc_did19_div_mhv)

lihtc_diff_in_diff_div_mhv <- lihtc_diff_in_diff_div_mhv %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_mhv)
```

    ## [1] 1028

# House Price Index

``` r
lihtc_did10_div_hpi <- svi_divisional_lihtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index10_log, lihtc_flag) %>% 
  mutate(post = 0,
         year = 2010) %>%
  rename("treat" = "lihtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index10_log") 


nrow(lihtc_did10_div_hpi)
```

    ## [1] 140

``` r
lihtc_did20_div_hpi <- svi_divisional_lihtc_df %>% 
  filter(!is.na(housing_price_index10_log)) %>% filter(!is.na(housing_price_index20_log)) %>%
  select(GEOID_2010_trt, cbsa, housing_price_index20_log, lihtc_flag) %>% 
  mutate(post = 1,
         year = 2020) %>%
  rename("treat" = "lihtc_flag",
         "HOUSE_PRICE_INDEX" = "housing_price_index20_log") 


nrow(lihtc_did20_div_hpi)
```

    ## [1] 140

``` r
lihtc_diff_in_diff_div_hpi <- bind_rows(lihtc_did10_div_hpi, lihtc_did20_div_hpi)

lihtc_diff_in_diff_div_hpi <- lihtc_diff_in_diff_div_hpi %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_hpi)
```

    ## [1] 280

## LIHTC Divisional Model

``` r
# SVI & Economic Models

m1_lihtc_div <- lm( SVI_FLAG_COUNT_SES ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_svi )

m2_lihtc_div <- lm( SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_svi )

m3_lihtc_div <- lm( SVI_FLAG_COUNT_REM ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_svi )

m4_lihtc_div <- lm( SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_svi )

m5_lihtc_div <- lm( SVI_FLAG_COUNT_OVERALL  ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_svi)

m6_lihtc_div <- lm( MEDIAN_INCOME ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_inc )

m7_lihtc_div <- lm( MEDIAN_HOME_VALUE ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_mhv )

m8_lihtc_div <- lm( HOUSE_PRICE_INDEX ~ treat + post + treat*post + cbsa, data=lihtc_diff_in_diff_div_hpi )

# Add all models to a list
models <- list(
  
  "SES" = m1_lihtc_div,
  "HHChar"  = m2_lihtc_div,
  "REM" = m3_lihtc_div,
  "HOUSETRANSPT" = m4_lihtc_div,
  "OVERALL" = m5_lihtc_div,
  "Median Income (USD, logged)" = m6_lihtc_div,
  "Median Home Value (USD, logged)" = m7_lihtc_div,
  "House Price Index (logged)" = m8_lihtc_div
)


# Display model results
modelsummary(models,  fmt = 2, stars = c('*' = .05, '**' = .01, '***' = .001), coef_omit = "cbsa", gof_omit = "IC|Log",
             notes = list('All models include metro-level fixed effects by core-based statistical area (cbsa).'),
             title = paste0("Differences-in-Differences Linear Regression Analysis of LIHTC in ", census_division)) %>%
  group_tt(j = list("Social Vulnerability" = 2:6, "Economic Outcomes" = 7:9))
```

<table style="width:96%;">
<caption>Differences-in-Differences Linear Regression Analysis of LIHTC
in South Atlantic Division</caption>
<colgroup>
<col style="width: 8%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 8%" />
<col style="width: 6%" />
<col style="width: 17%" />
<col style="width: 19%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th></th>
<th colspan="5">Social Vulnerability</th>
<th colspan="3">Economic Outcomes</th>
</tr>
<tr class="odd">
<th></th>
<th>SES</th>
<th>HHChar</th>
<th>REM</th>
<th>HOUSETRANSPT</th>
<th>OVERALL</th>
<th>Median Income (USD, logged)</th>
<th>Median Home Value (USD, logged)</th>
<th>House Price Index (logged)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>(Intercept)</td>
<td>4.64***</td>
<td>2.54***</td>
<td>1.03***</td>
<td>2.00**</td>
<td>10.21***</td>
<td>9.48***</td>
<td>11.14***</td>
<td>5.61***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.89)</td>
<td>(0.68)</td>
<td>(0.27)</td>
<td>(0.64)</td>
<td>(1.63)</td>
<td>(0.29)</td>
<td>(0.39)</td>
<td>(0.32)</td>
</tr>
<tr class="odd">
<td>treat</td>
<td>0.23</td>
<td>0.40***</td>
<td>0.11*</td>
<td>0.28**</td>
<td>1.02***</td>
<td>-0.01</td>
<td>-0.02</td>
<td>-0.16</td>
</tr>
<tr class="even">
<td></td>
<td>(0.15)</td>
<td>(0.11)</td>
<td>(0.05)</td>
<td>(0.11)</td>
<td>(0.27)</td>
<td>(0.05)</td>
<td>(0.07)</td>
<td>(0.11)</td>
</tr>
<tr class="odd">
<td>post</td>
<td>-0.28**</td>
<td>-0.09</td>
<td>-0.06*</td>
<td>0.01</td>
<td>-0.42**</td>
<td>0.08**</td>
<td>-0.11**</td>
<td>0.46***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.09)</td>
<td>(0.07)</td>
<td>(0.03)</td>
<td>(0.06)</td>
<td>(0.16)</td>
<td>(0.03)</td>
<td>(0.04)</td>
<td>(0.06)</td>
</tr>
<tr class="odd">
<td>treat × post</td>
<td>0.03</td>
<td>-0.12</td>
<td>0.00</td>
<td>-0.02</td>
<td>-0.10</td>
<td>-0.00</td>
<td>0.00</td>
<td>0.09</td>
</tr>
<tr class="even">
<td></td>
<td>(0.20)</td>
<td>(0.15)</td>
<td>(0.06)</td>
<td>(0.15)</td>
<td>(0.37)</td>
<td>(0.06)</td>
<td>(0.09)</td>
<td>(0.14)</td>
</tr>
<tr class="odd">
<td>Num.Obs.</td>
<td>1006</td>
<td>1006</td>
<td>1006</td>
<td>1006</td>
<td>1006</td>
<td>1004</td>
<td>958</td>
<td>274</td>
</tr>
<tr class="even">
<td>R2</td>
<td>0.264</td>
<td>0.243</td>
<td>0.367</td>
<td>0.168</td>
<td>0.278</td>
<td>0.313</td>
<td>0.412</td>
<td>0.398</td>
</tr>
<tr class="odd">
<td>R2 Adj.</td>
<td>0.203</td>
<td>0.180</td>
<td>0.315</td>
<td>0.100</td>
<td>0.218</td>
<td>0.256</td>
<td>0.360</td>
<td>0.318</td>
</tr>
<tr class="even">
<td>RMSE</td>
<td>1.21</td>
<td>0.92</td>
<td>0.37</td>
<td>0.87</td>
<td>2.21</td>
<td>0.39</td>
<td>0.53</td>
<td>0.42</td>
</tr>
<tr class="odd">
<td colspan="9"><ul>
<li>p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tbody><tfoot>
<tr class="odd">
<td colspan="9">All models include metro-level fixed effects by
core-based statistical area (cbsa).</td>
</tr>
</tfoot>
&#10;</table>

Differences-in-Differences Linear Regression Analysis of LIHTC in South
Atlantic Division

#### In the above graph, we can use the different combined results to understand how the LIHTC program affected, or did not affect, Social Economic Status (SES). We can see this through:

#### \* The starting amount of flags for the column (Intercept)

#### \* The effect of the program to the column (Intercept + Treat)

#### \* The change after the initial period, regaurdless of whether or not in the program (Intercept + Post)

#### \* The change after the initial period for those in the program (Intercept + Treat x Post)

#### In the South Atlantic Division for those in the LIHTC program, we see a slight increase for SES. However, the change is not statistically significant. For this reason, we are unable to determine whether or not the program was successful in affecting SES.

#### Due to our results, it is possible that a different model, or including omitted variables, would lead to better results.

## Visualize NMTC Divisional Models

#### Since we once again did not have any significant significance, we do not need to visualize our outcomes.

``` r
# Save data sets

saveRDS(svi_divisional_lihtc_df, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_divisional_lihtc.rds")))

saveRDS(svi_national_lihtc_df, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_national_lihtc.rds")))

saveRDS(svi_divisional_nmtc_df, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_divisional_nmtc.rds")))

saveRDS(svi_national_nmtc_df, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_national_nmtc.rds")))

# Save regression models

save(m1_nmtc_div, m2_nmtc_div, m3_nmtc_div, m4_nmtc_div, m5_nmtc_div, m6_nmtc_div, m7_nmtc_div, m8_nmtc_div, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_did_models_nmtc.RData")), compress=TRUE, compression_level = 9)

save(m1_lihtc_div, m2_lihtc_div, m3_lihtc_div, m4_lihtc_div, m5_lihtc_div, m6_lihtc_div, m7_lihtc_div, m8_lihtc_div, file = here::here(paste0("data/rodeo/", str_replace_all(census_division, " ", "_"), "_svi_did_models_lihtc.RData")), compress=TRUE, compression_level = 9)
```
