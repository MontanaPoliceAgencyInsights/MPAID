---
title: "NMTC & LIHTC Evaluation"
author: "Michelle Knopp"
#date: "2025-04-29"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

# Introduction

## Diff-in-Diff models

We will be utilizing diff-in-diff models to analyze the impacts of the
New Markets Tax Credit (NMTC) and the Low Income Housing Tax Credit
(LIHTC) programs as they relate to social vulnerability and economic
changes in Mountain Division tracts.

Diff-In-Diff models are useful as a statistical tool to analyze the
effects of a program when there is a treatment group and a group who did
not receive the treatment (control group). It can be used when there are
two periods, before intervention and after intervention. Since we have
tracts who did receive NMTC and LIHTC dollars and tracts who did not, we
can analyze the impact of these programs before and after intervention.

## Dependent Variables: SVI Variables, House Price Index, Median Home Values, and Median Income

These variables were chosen as dependent variables to look at the impact
of our tax programs. The social vulnerability index looks at 4
categories of interest that the CDC has determined impacts overall
vulnerability of communities. It is broken down in the following
categories: socioeconomic status, household characteristics, racial &
ethnic minority status, and housing type/transportation. We will also be
looking at economic variables. The house price index is determined by
analyzing mortgage transactions. The median home value and median
incomes will be collected by census data.

## Independent Variables: NMTC and LIHTC Data

New Markets Tax Credits are awarded to community development entities
for the purpose of investing in low income communities and recipients
must meet strict criteria to be eligible, but the credits are intended
to for areas with low median income and high poverty rates.

Low Income Housing Tax Credits are awarded to investors with the purpose
of investing in affordable housing for renters. Again, this program is
designed to improve neighborhood with low gross incomes and high poverty
rates.

# Library

``` r
# Load packages
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

# Load Functions

``` r
import::here( "fips_census_regions",
              "load_svi_data",
              "merge_svi_data",
              "census_division",
              "slopegraph_plot",
              "census_pull",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("analysis/project_data_steps_knopp.R"),
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

## View NMTC Data

\*Divisional\*\*

``` r
svi_divisional_nmtc %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

GEOID_2010_trt
</th>

<th style="text-align:left;">

FIPS_st
</th>

<th style="text-align:left;">

FIPS_county
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

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

04001942600
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942600
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

1150
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

73.67072
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

8.666667
</td>

<td style="text-align:right;">

0.6866
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

17.759563
</td>

<td style="text-align:right;">

0.10180
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

27.77778
</td>

<td style="text-align:right;">

0.19090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

18.22917
</td>

<td style="text-align:right;">

0.05781
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

839
</td>

<td style="text-align:right;">

36.11442
</td>

<td style="text-align:right;">

0.9335
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

282
</td>

<td style="text-align:right;">

1578
</td>

<td style="text-align:right;">

17.87072
</td>

<td style="text-align:right;">

0.5921
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

9.801409
</td>

<td style="text-align:right;">

0.4496
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

560
</td>

<td style="text-align:right;">

35.87444
</td>

<td style="text-align:right;">

0.9044
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

22.770398
</td>

<td style="text-align:right;">

0.9006
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

332
</td>

<td style="text-align:right;">

32.22892
</td>

<td style="text-align:right;">

0.9163
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

168
</td>

<td style="text-align:right;">

1431
</td>

<td style="text-align:right;">

11.740042
</td>

<td style="text-align:right;">

0.8831
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

215
</td>

<td style="text-align:right;">

28.21522
</td>

<td style="text-align:right;">

0.9088
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

117
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

30.46875
</td>

<td style="text-align:right;">

0.9979
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

8.59375
</td>

<td style="text-align:right;">

0.7842
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.26441
</td>

<td style="text-align:right;">

0.7248
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4.0540
</td>

<td style="text-align:right;">

0.9853
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2390
</td>

<td style="text-align:right;">

0.8004
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.55631
</td>

<td style="text-align:right;">

0.8966
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

930
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

54.35418
</td>

<td style="text-align:right;">

0.9708
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

44
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.8539
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

32
</td>

<td style="text-align:right;">

456
</td>

<td style="text-align:right;">

7.017544
</td>

<td style="text-align:right;">

0.02013
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

30.76923
</td>

<td style="text-align:right;">

0.24630
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

7.675906
</td>

<td style="text-align:right;">

0.005758
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

25.39683
</td>

<td style="text-align:right;">

0.9056
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

686
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

40.09351
</td>

<td style="text-align:right;">

0.9973
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

229
</td>

<td style="text-align:right;">

13.38399
</td>

<td style="text-align:right;">

0.4397
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

20.28054
</td>

<td style="text-align:right;">

0.3788
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

1363.979
</td>

<td style="text-align:right;">

17.962156
</td>

<td style="text-align:right;">

0.68240
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

304.000
</td>

<td style="text-align:right;">

16.11842
</td>

<td style="text-align:right;">

0.5859
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

1652
</td>

<td style="text-align:right;">

9.382567
</td>

<td style="text-align:right;">

0.8951
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

1710.980
</td>

<td style="text-align:right;">

100.00115
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

21.00592
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

83
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

17.697228
</td>

<td style="text-align:right;">

0.9774
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

99
</td>

<td style="text-align:right;">

469.000
</td>

<td style="text-align:right;">

21.10874
</td>

<td style="text-align:right;">

0.9655
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.733358
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.98190
</td>

<td style="text-align:right;">

0.7375
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

0.9958
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1596
</td>

<td style="text-align:right;">

0.7653
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.87486
</td>

<td style="text-align:right;">

0.8573
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

</tr>

<tr>

<td style="text-align:left;">

04001942700
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942700
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

2616
</td>

<td style="text-align:right;">

4871
</td>

<td style="text-align:right;">

53.70560
</td>

<td style="text-align:right;">

0.9480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

163
</td>

<td style="text-align:right;">

1398
</td>

<td style="text-align:right;">

11.659514
</td>

<td style="text-align:right;">

0.8577
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

1113
</td>

<td style="text-align:right;">

9.164421
</td>

<td style="text-align:right;">

0.01757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

178
</td>

<td style="text-align:right;">

30.33708
</td>

<td style="text-align:right;">

0.22790
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

156
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

12.08366
</td>

<td style="text-align:right;">

0.01652
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1039
</td>

<td style="text-align:right;">

2931
</td>

<td style="text-align:right;">

35.44865
</td>

<td style="text-align:right;">

0.9303
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1873
</td>

<td style="text-align:right;">

5249
</td>

<td style="text-align:right;">

35.68299
</td>

<td style="text-align:right;">

0.9436
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

688
</td>

<td style="text-align:right;">

14.081048
</td>

<td style="text-align:right;">

0.6870
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1530
</td>

<td style="text-align:right;">

31.31396
</td>

<td style="text-align:right;">

0.7718
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

772
</td>

<td style="text-align:right;">

3514
</td>

<td style="text-align:right;">

21.969266
</td>

<td style="text-align:right;">

0.8839
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

246
</td>

<td style="text-align:right;">

939
</td>

<td style="text-align:right;">

26.19808
</td>

<td style="text-align:right;">

0.8308
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

592
</td>

<td style="text-align:right;">

4631
</td>

<td style="text-align:right;">

12.783416
</td>

<td style="text-align:right;">

0.8975
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4846
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

99.18133
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

13.38411
</td>

<td style="text-align:right;">

0.7652
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

18.59024
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

188
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

14.56235
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.69612
</td>

<td style="text-align:right;">

0.8288
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.0710
</td>

<td style="text-align:right;">

0.9870
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9890
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1904
</td>

<td style="text-align:right;">

0.7848
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.95212
</td>

<td style="text-align:right;">

0.9295
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

2784
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

50.90510
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

358
</td>

<td style="text-align:right;">

1642
</td>

<td style="text-align:right;">

21.802680
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

1151
</td>

<td style="text-align:right;">

9.904431
</td>

<td style="text-align:right;">

0.04797
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

18.64952
</td>

<td style="text-align:right;">

0.09477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

172
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

11.764706
</td>

<td style="text-align:right;">

0.023990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

852
</td>

<td style="text-align:right;">

3274
</td>

<td style="text-align:right;">

26.02321
</td>

<td style="text-align:right;">

0.9120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1856
</td>

<td style="text-align:right;">

5466
</td>

<td style="text-align:right;">

33.95536
</td>

<td style="text-align:right;">

0.9919
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

13.87822
</td>

<td style="text-align:right;">

0.4657
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1555
</td>

<td style="text-align:right;">

28.43299
</td>

<td style="text-align:right;">

0.7739
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

706
</td>

<td style="text-align:right;">

3911.002
</td>

<td style="text-align:right;">

18.051640
</td>

<td style="text-align:right;">

0.68720
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1035.000
</td>

<td style="text-align:right;">

24.83091
</td>

<td style="text-align:right;">

0.8039
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

396
</td>

<td style="text-align:right;">

5078
</td>

<td style="text-align:right;">

7.798346
</td>

<td style="text-align:right;">

0.8624
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5420
</td>

<td style="text-align:right;">

5469.002
</td>

<td style="text-align:right;">

99.10401
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

400
</td>

<td style="text-align:right;">

18.00180
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

238
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

16.279070
</td>

<td style="text-align:right;">

0.9710
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

175
</td>

<td style="text-align:right;">

1462.001
</td>

<td style="text-align:right;">

11.96990
</td>

<td style="text-align:right;">

0.8742
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

0.4754068
</td>

<td style="text-align:right;">

0.6430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.876090
</td>

<td style="text-align:right;">

0.8796
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.59310
</td>

<td style="text-align:right;">

0.9421
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9905
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4646
</td>

<td style="text-align:right;">

0.8721
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.92839
</td>

<td style="text-align:right;">

0.9425
</td>

<td style="text-align:right;">

11
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

</tr>

<tr>

<td style="text-align:left;">

04001944000
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944000
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

2178
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

3112
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

52.23229
</td>

<td style="text-align:right;">

0.9399
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

1895
</td>

<td style="text-align:right;">

5.646438
</td>

<td style="text-align:right;">

0.4130
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

108
</td>

<td style="text-align:right;">

880
</td>

<td style="text-align:right;">

12.272727
</td>

<td style="text-align:right;">

0.03476
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

395
</td>

<td style="text-align:right;">

28.35443
</td>

<td style="text-align:right;">

0.19940
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

220
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

17.25490
</td>

<td style="text-align:right;">

0.04955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1030
</td>

<td style="text-align:right;">

3376
</td>

<td style="text-align:right;">

30.50948
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2632
</td>

<td style="text-align:right;">

5821
</td>

<td style="text-align:right;">

45.21560
</td>

<td style="text-align:right;">

0.9873
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

472
</td>

<td style="text-align:right;">

7.922122
</td>

<td style="text-align:right;">

0.3301
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1792
</td>

<td style="text-align:right;">

30.07721
</td>

<td style="text-align:right;">

0.7211
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

4027
</td>

<td style="text-align:right;">

7.424882
</td>

<td style="text-align:right;">

0.1343
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

272
</td>

<td style="text-align:right;">

979
</td>

<td style="text-align:right;">

27.78345
</td>

<td style="text-align:right;">

0.8590
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

5325
</td>

<td style="text-align:right;">

2.873239
</td>

<td style="text-align:right;">

0.6096
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5846
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

98.12017
</td>

<td style="text-align:right;">

0.9893
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2178
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

448
</td>

<td style="text-align:right;">

20.56933
</td>

<td style="text-align:right;">

0.8562
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

247
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

19.37255
</td>

<td style="text-align:right;">

0.9798
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

135
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

10.58824
</td>

<td style="text-align:right;">

0.8373
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.29125
</td>

<td style="text-align:right;">

0.7314
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

2.6541
</td>

<td style="text-align:right;">

0.5792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.9893
</td>

<td style="text-align:right;">

0.9836
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2214
</td>

<td style="text-align:right;">

0.7946
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.15605
</td>

<td style="text-align:right;">

0.7714
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

6583
</td>

<td style="text-align:right;">

2464
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

3270
</td>

<td style="text-align:right;">

6580
</td>

<td style="text-align:right;">

49.69605
</td>

<td style="text-align:right;">

0.9486
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

191
</td>

<td style="text-align:right;">

2029
</td>

<td style="text-align:right;">

9.413504
</td>

<td style="text-align:right;">

0.8663
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

89
</td>

<td style="text-align:right;">

1272
</td>

<td style="text-align:right;">

6.996855
</td>

<td style="text-align:right;">

0.01965
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

103
</td>

<td style="text-align:right;">

564
</td>

<td style="text-align:right;">

18.26241
</td>

<td style="text-align:right;">

0.09073
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

10.457516
</td>

<td style="text-align:right;">

0.015550
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

753
</td>

<td style="text-align:right;">

4321
</td>

<td style="text-align:right;">

17.42652
</td>

<td style="text-align:right;">

0.8100
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2993
</td>

<td style="text-align:right;">

6580
</td>

<td style="text-align:right;">

45.48632
</td>

<td style="text-align:right;">

0.9992
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1034
</td>

<td style="text-align:right;">

15.70712
</td>

<td style="text-align:right;">

0.5561
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1569
</td>

<td style="text-align:right;">

23.83412
</td>

<td style="text-align:right;">

0.5584
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1069
</td>

<td style="text-align:right;">

5014.189
</td>

<td style="text-align:right;">

21.319499
</td>

<td style="text-align:right;">

0.81410
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1237.278
</td>

<td style="text-align:right;">

24.57006
</td>

<td style="text-align:right;">

0.7989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

141
</td>

<td style="text-align:right;">

6193
</td>

<td style="text-align:right;">

2.276764
</td>

<td style="text-align:right;">

0.6147
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

6436
</td>

<td style="text-align:right;">

6583.375
</td>

<td style="text-align:right;">

97.76141
</td>

<td style="text-align:right;">

0.9876
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2464
</td>

<td style="text-align:right;">

20
</td>

<td style="text-align:right;">

0.8116883
</td>

<td style="text-align:right;">

0.3404
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

536
</td>

<td style="text-align:right;">

21.75325
</td>

<td style="text-align:right;">

0.8793
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

274
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

14.923747
</td>

<td style="text-align:right;">

0.9643
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

326
</td>

<td style="text-align:right;">

1836.376
</td>

<td style="text-align:right;">

17.75235
</td>

<td style="text-align:right;">

0.9488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

6583
</td>

<td style="text-align:right;">

0.0455719
</td>

<td style="text-align:right;">

0.4382
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.639650
</td>

<td style="text-align:right;">

0.8211
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.34220
</td>

<td style="text-align:right;">

0.8770
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9876
</td>

<td style="text-align:right;">

0.9834
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5710
</td>

<td style="text-align:right;">

0.9020
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.54045
</td>

<td style="text-align:right;">

0.9156
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

</tr>

<tr>

<td style="text-align:left;">

04001944100
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944100
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3251
</td>

<td style="text-align:right;">

4968
</td>

<td style="text-align:right;">

65.43881
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1254
</td>

<td style="text-align:right;">

16.746412
</td>

<td style="text-align:right;">

0.9576
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

122
</td>

<td style="text-align:right;">

905
</td>

<td style="text-align:right;">

13.480663
</td>

<td style="text-align:right;">

0.04383
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

30.43478
</td>

<td style="text-align:right;">

0.22960
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

213
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.69103
</td>

<td style="text-align:right;">

0.05320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

779
</td>

<td style="text-align:right;">

2325
</td>

<td style="text-align:right;">

33.50538
</td>

<td style="text-align:right;">

0.9203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1293
</td>

<td style="text-align:right;">

5511
</td>

<td style="text-align:right;">

23.46217
</td>

<td style="text-align:right;">

0.7705
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

344
</td>

<td style="text-align:right;">

6.914573
</td>

<td style="text-align:right;">

0.2701
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1993
</td>

<td style="text-align:right;">

40.06030
</td>

<td style="text-align:right;">

0.9701
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

577
</td>

<td style="text-align:right;">

3087
</td>

<td style="text-align:right;">

18.691286
</td>

<td style="text-align:right;">

0.7799
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

278
</td>

<td style="text-align:right;">

893
</td>

<td style="text-align:right;">

31.13102
</td>

<td style="text-align:right;">

0.9038
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

308
</td>

<td style="text-align:right;">

4470
</td>

<td style="text-align:right;">

6.890380
</td>

<td style="text-align:right;">

0.7895
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

98.79397
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

0.8450704
</td>

<td style="text-align:right;">

0.3700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

17.22334
</td>

<td style="text-align:right;">

0.8203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

21.34551
</td>

<td style="text-align:right;">

0.9843
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

212
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.60797
</td>

<td style="text-align:right;">

0.9391
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.68620
</td>

<td style="text-align:right;">

0.8261
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.7134
</td>

<td style="text-align:right;">

0.9528
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

0.9872
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5092
</td>

<td style="text-align:right;">

0.8926
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.90170
</td>

<td style="text-align:right;">

0.9244
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

3704
</td>

<td style="text-align:right;">

5789
</td>

<td style="text-align:right;">

63.98342
</td>

<td style="text-align:right;">

0.9912
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

425
</td>

<td style="text-align:right;">

1608
</td>

<td style="text-align:right;">

26.430348
</td>

<td style="text-align:right;">

0.9954
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

11.349957
</td>

<td style="text-align:right;">

0.07802
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

14.55939
</td>

<td style="text-align:right;">

0.06498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

170
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

11.938202
</td>

<td style="text-align:right;">

0.026300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

862
</td>

<td style="text-align:right;">

3259
</td>

<td style="text-align:right;">

26.44983
</td>

<td style="text-align:right;">

0.9148
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1320
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

21.34886
</td>

<td style="text-align:right;">

0.9283
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

637
</td>

<td style="text-align:right;">

10.30244
</td>

<td style="text-align:right;">

0.2718
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1869
</td>

<td style="text-align:right;">

30.22804
</td>

<td style="text-align:right;">

0.8396
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

626
</td>

<td style="text-align:right;">

3964.000
</td>

<td style="text-align:right;">

15.792129
</td>

<td style="text-align:right;">

0.57150
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

371
</td>

<td style="text-align:right;">

991.000
</td>

<td style="text-align:right;">

37.43693
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

315
</td>

<td style="text-align:right;">

5717
</td>

<td style="text-align:right;">

5.509883
</td>

<td style="text-align:right;">

0.8021
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5981
</td>

<td style="text-align:right;">

6182.998
</td>

<td style="text-align:right;">

96.73300
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

442
</td>

<td style="text-align:right;">

18.57924
</td>

<td style="text-align:right;">

0.8550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

26.615168
</td>

<td style="text-align:right;">

0.9969
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

1424.000
</td>

<td style="text-align:right;">

24.36798
</td>

<td style="text-align:right;">

0.9758
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

394
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

6.3723112
</td>

<td style="text-align:right;">

0.9380
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.856000
</td>

<td style="text-align:right;">

0.8749
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.44070
</td>

<td style="text-align:right;">

0.9070
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

0.9800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8933
</td>

<td style="text-align:right;">

0.9609
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.17410
</td>

<td style="text-align:right;">

0.9549
</td>

<td style="text-align:right;">

12
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

</tr>

<tr>

<td style="text-align:left;">

04001944202
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944202
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

1463
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

1814
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

54.47447
</td>

<td style="text-align:right;">

0.9514
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

345
</td>

<td style="text-align:right;">

1024
</td>

<td style="text-align:right;">

33.691406
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

745
</td>

<td style="text-align:right;">

7.785235
</td>

<td style="text-align:right;">

0.01352
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

152
</td>

<td style="text-align:right;">

25.00000
</td>

<td style="text-align:right;">

0.15680
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

96
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

10.70234
</td>

<td style="text-align:right;">

0.01191
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

742
</td>

<td style="text-align:right;">

2041
</td>

<td style="text-align:right;">

36.35473
</td>

<td style="text-align:right;">

0.9351
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1201
</td>

<td style="text-align:right;">

3754
</td>

<td style="text-align:right;">

31.99254
</td>

<td style="text-align:right;">

0.9089
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

10.990991
</td>

<td style="text-align:right;">

0.5201
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

873
</td>

<td style="text-align:right;">

26.21622
</td>

<td style="text-align:right;">

0.5389
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

2986
</td>

<td style="text-align:right;">

19.189551
</td>

<td style="text-align:right;">

0.8002
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

151
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

27.45455
</td>

<td style="text-align:right;">

0.8540
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

173
</td>

<td style="text-align:right;">

3057
</td>

<td style="text-align:right;">

5.659143
</td>

<td style="text-align:right;">

0.7527
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3306
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

99.27928
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1463
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

355
</td>

<td style="text-align:right;">

24.26521
</td>

<td style="text-align:right;">

0.8840
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

12.70903
</td>

<td style="text-align:right;">

0.9435
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

28.65106
</td>

<td style="text-align:right;">

0.9864
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

93
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

2.792793
</td>

<td style="text-align:right;">

0.8680
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.80561
</td>

<td style="text-align:right;">

0.8512
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.4659
</td>

<td style="text-align:right;">

0.8981
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

0.9891
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8345
</td>

<td style="text-align:right;">

0.9589
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.10081
</td>

<td style="text-align:right;">

0.9410
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

1508
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

2113
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

60.25093
</td>

<td style="text-align:right;">

0.9862
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

145
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

13.928914
</td>

<td style="text-align:right;">

0.9605
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

81
</td>

<td style="text-align:right;">

1040
</td>

<td style="text-align:right;">

7.788462
</td>

<td style="text-align:right;">

0.02620
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

169
</td>

<td style="text-align:right;">

15.38462
</td>

<td style="text-align:right;">

0.07170
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

8.850290
</td>

<td style="text-align:right;">

0.008637
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

2250
</td>

<td style="text-align:right;">

17.91111
</td>

<td style="text-align:right;">

0.8195
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

41.54548
</td>

<td style="text-align:right;">

0.9985
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

390
</td>

<td style="text-align:right;">

11.12062
</td>

<td style="text-align:right;">

0.3153
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

974
</td>

<td style="text-align:right;">

27.77303
</td>

<td style="text-align:right;">

0.7446
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

2533.000
</td>

<td style="text-align:right;">

4.500592
</td>

<td style="text-align:right;">

0.01399
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

189
</td>

<td style="text-align:right;">

717.000
</td>

<td style="text-align:right;">

26.35983
</td>

<td style="text-align:right;">

0.8350
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

389
</td>

<td style="text-align:right;">

3265
</td>

<td style="text-align:right;">

11.914242
</td>

<td style="text-align:right;">

0.9273
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3499
</td>

<td style="text-align:right;">

3507.000
</td>

<td style="text-align:right;">

99.77188
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1508
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

1.7241379
</td>

<td style="text-align:right;">

0.4052
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

434
</td>

<td style="text-align:right;">

28.77984
</td>

<td style="text-align:right;">

0.9188
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

98
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

8.105873
</td>

<td style="text-align:right;">

0.8737
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

146
</td>

<td style="text-align:right;">

1209.000
</td>

<td style="text-align:right;">

12.07610
</td>

<td style="text-align:right;">

0.8761
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.773337
</td>

<td style="text-align:right;">

0.8552
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.83619
</td>

<td style="text-align:right;">

0.6678
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

0.9941
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2893
</td>

<td style="text-align:right;">

0.8112
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.89713
</td>

<td style="text-align:right;">

0.8589
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

</tr>

<tr>

<td style="text-align:left;">

04001944300
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944300
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

4099
</td>

<td style="text-align:right;">

6797
</td>

<td style="text-align:right;">

60.30602
</td>

<td style="text-align:right;">

0.9762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

1777
</td>

<td style="text-align:right;">

22.678672
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

154
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

10.569664
</td>

<td style="text-align:right;">

0.02549
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

17.07317
</td>

<td style="text-align:right;">

0.08684
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

11.88390
</td>

<td style="text-align:right;">

0.01536
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1432
</td>

<td style="text-align:right;">

3367
</td>

<td style="text-align:right;">

42.53044
</td>

<td style="text-align:right;">

0.9623
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2305
</td>

<td style="text-align:right;">

7092
</td>

<td style="text-align:right;">

32.50141
</td>

<td style="text-align:right;">

0.9160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

746
</td>

<td style="text-align:right;">

10.960917
</td>

<td style="text-align:right;">

0.5176
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2767
</td>

<td style="text-align:right;">

40.65530
</td>

<td style="text-align:right;">

0.9761
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

842
</td>

<td style="text-align:right;">

4361
</td>

<td style="text-align:right;">

19.307498
</td>

<td style="text-align:right;">

0.8041
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

30.69647
</td>

<td style="text-align:right;">

0.8982
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

568
</td>

<td style="text-align:right;">

6178
</td>

<td style="text-align:right;">

9.193914
</td>

<td style="text-align:right;">

0.8423
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6750
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

99.17720
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

0.2418380
</td>

<td style="text-align:right;">

0.3113
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

440
</td>

<td style="text-align:right;">

13.30109
</td>

<td style="text-align:right;">

0.7638
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

22.12486
</td>

<td style="text-align:right;">

0.9856
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

388
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

21.24863
</td>

<td style="text-align:right;">

0.9627
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

2.042316
</td>

<td style="text-align:right;">

0.8458
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.85566
</td>

<td style="text-align:right;">

0.8602
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.0383
</td>

<td style="text-align:right;">

0.9844
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

0.9888
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8692
</td>

<td style="text-align:right;">

0.9619
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.75756
</td>

<td style="text-align:right;">

0.9749
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3548
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

59.97295
</td>

<td style="text-align:right;">

0.9854
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

67
</td>

<td style="text-align:right;">

1402
</td>

<td style="text-align:right;">

4.778887
</td>

<td style="text-align:right;">

0.5316
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

251
</td>

<td style="text-align:right;">

1664
</td>

<td style="text-align:right;">

15.084135
</td>

<td style="text-align:right;">

0.20570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

362
</td>

<td style="text-align:right;">

12.70718
</td>

<td style="text-align:right;">

0.05498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

14.659427
</td>

<td style="text-align:right;">

0.056430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

844
</td>

<td style="text-align:right;">

3696
</td>

<td style="text-align:right;">

22.83550
</td>

<td style="text-align:right;">

0.8792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2528
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

42.73158
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

793
</td>

<td style="text-align:right;">

13.39075
</td>

<td style="text-align:right;">

0.4401
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1663
</td>

<td style="text-align:right;">

28.08173
</td>

<td style="text-align:right;">

0.7575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

4258.743
</td>

<td style="text-align:right;">

13.454674
</td>

<td style="text-align:right;">

0.42530
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

1112.258
</td>

<td style="text-align:right;">

27.06206
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

851
</td>

<td style="text-align:right;">

5568
</td>

<td style="text-align:right;">

15.283764
</td>

<td style="text-align:right;">

0.9575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5880
</td>

<td style="text-align:right;">

5922.449
</td>

<td style="text-align:right;">

99.28326
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

0.7854338
</td>

<td style="text-align:right;">

0.3369
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

521
</td>

<td style="text-align:right;">

18.60050
</td>

<td style="text-align:right;">

0.8557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

267
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

13.178677
</td>

<td style="text-align:right;">

0.9482
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2025.690
</td>

<td style="text-align:right;">

14.66167
</td>

<td style="text-align:right;">

0.9158
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

0.1857481
</td>

<td style="text-align:right;">

0.5222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.451330
</td>

<td style="text-align:right;">

0.7773
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.42780
</td>

<td style="text-align:right;">

0.9008
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

0.9922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5788
</td>

<td style="text-align:right;">

0.9040
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.45433
</td>

<td style="text-align:right;">

0.9088
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

</tr>

</tbody>

</table>

</div>

**National**

``` r
svi_national_nmtc %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

GEOID_2010_trt
</th>

<th style="text-align:left;">

FIPS_st
</th>

<th style="text-align:left;">

FIPS_county
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

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

01001020200
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

001
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

26.79842
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

61.53465
</td>

<td style="text-align:right;">

0.7781
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

15.753425
</td>

<td style="text-align:right;">

0.8382
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

0.7781
</td>

<td style="text-align:right;">

0.7709
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2.5316
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

25.41363
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

0.4132
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

10.58644
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

0.2851
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

13.57616
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

11.699164
</td>

<td style="text-align:right;">

0.3998
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

63.51736
</td>

<td style="text-align:right;">

0.7591
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

0.4688
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

0.1025
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.7591
</td>

<td style="text-align:right;">

0.7527
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2.9130
</td>

<td style="text-align:right;">

0.6862
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

7.83579
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

</tr>

<tr>

<td style="text-align:left;">

01001020700
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

001
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

21.38229
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

26.05105
</td>

<td style="text-align:right;">

0.5138
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

10.974539
</td>

<td style="text-align:right;">

0.7477
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

0.5138
</td>

<td style="text-align:right;">

0.5090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.5000
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

38.83220
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

0.7935
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

17.91045
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

0.7923
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

24.25762
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

21.455458
</td>

<td style="text-align:right;">

0.7186
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

28.32678
</td>

<td style="text-align:right;">

0.4668
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

0.8211
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

0.5847
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.4668
</td>

<td style="text-align:right;">

0.4629
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.1107
</td>

<td style="text-align:right;">

0.7714
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.04659
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

</tr>

<tr>

<td style="text-align:left;">

01001021100
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

001
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

31.82429
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

60.00606
</td>

<td style="text-align:right;">

0.7703
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

10.355253
</td>

<td style="text-align:right;">

0.7313
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

0.7703
</td>

<td style="text-align:right;">

0.7631
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1098
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

50.30009
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

0.4539
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

16.96141
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

0.5829
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

33.74084
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

22.052524
</td>

<td style="text-align:right;">

0.7323
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

56.76373
</td>

<td style="text-align:right;">

0.7175
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

0.8269
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

0.9156
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.7175
</td>

<td style="text-align:right;">

0.7114
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.5791
</td>

<td style="text-align:right;">

0.9216
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

11.31660
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

</tr>

<tr>

<td style="text-align:left;">

01003010200
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

003
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

24.30556
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

12.59571
</td>

<td style="text-align:right;">

0.3113
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

4.003724
</td>

<td style="text-align:right;">

0.4088
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

0.3113
</td>

<td style="text-align:right;">

0.3084
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.7430
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

30.19126
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

0.1356
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

14.32749
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

0.6339
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

21.96317
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

24.365914
</td>

<td style="text-align:right;">

0.7799
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

13.59513
</td>

<td style="text-align:right;">

0.2511
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

0.2590
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

0.7634
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.2511
</td>

<td style="text-align:right;">

0.2490
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.6334
</td>

<td style="text-align:right;">

0.5496
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8.10119
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

</tr>

<tr>

<td style="text-align:left;">

01003010500
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

003
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

24.00679
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

17.82506
</td>

<td style="text-align:right;">

0.4023
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

6.315790
</td>

<td style="text-align:right;">

0.5691
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

0.4023
</td>

<td style="text-align:right;">

0.3986
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.3227
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

15.63692
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

0.3361
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

13.41808
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

0.3411
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

17.47696
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

8.008596
</td>

<td style="text-align:right;">

0.2341
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

14.76823
</td>

<td style="text-align:right;">

0.2709
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

0.2540
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

0.1961
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.2709
</td>

<td style="text-align:right;">

0.2686
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.7488
</td>

<td style="text-align:right;">

0.6077
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6.96352
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

</tr>

<tr>

<td style="text-align:left;">

01003010600
</td>

<td style="text-align:left;">

01
</td>

<td style="text-align:left;">

003
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

26.49254
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

69.97852
</td>

<td style="text-align:right;">

0.8184
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

14.559721
</td>

<td style="text-align:right;">

0.8209
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

0.8184
</td>

<td style="text-align:right;">

0.8108
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.3524
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

41.93145
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

0.9674
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

25.73196
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

0.8175
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

19.00301
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

29.650350
</td>

<td style="text-align:right;">

0.8592
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

65.97813
</td>

<td style="text-align:right;">

0.7732
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

0.8795
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

0.9081
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.7732
</td>

<td style="text-align:right;">

0.7667
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1450
</td>

<td style="text-align:right;">

0.7858
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

11.86010
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

</tr>

</tbody>

</table>

</div>

## View LIHTC Data

**Divisional**

``` r
svi_divisional_lihtc %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

GEOID_2010_trt
</th>

<th style="text-align:left;">

FIPS_st
</th>

<th style="text-align:left;">

FIPS_county
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

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

04001942600
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942600
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

1150
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

73.67072
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

8.666667
</td>

<td style="text-align:right;">

0.6866
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

17.759563
</td>

<td style="text-align:right;">

0.10180
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

27.77778
</td>

<td style="text-align:right;">

0.19090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

18.22917
</td>

<td style="text-align:right;">

0.05781
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

839
</td>

<td style="text-align:right;">

36.11442
</td>

<td style="text-align:right;">

0.9335
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

282
</td>

<td style="text-align:right;">

1578
</td>

<td style="text-align:right;">

17.87072
</td>

<td style="text-align:right;">

0.5921
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

9.801409
</td>

<td style="text-align:right;">

0.449600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

560
</td>

<td style="text-align:right;">

35.874440
</td>

<td style="text-align:right;">

0.90440
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

22.770398
</td>

<td style="text-align:right;">

0.90060
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

332
</td>

<td style="text-align:right;">

32.22892
</td>

<td style="text-align:right;">

0.9163
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

168
</td>

<td style="text-align:right;">

1431
</td>

<td style="text-align:right;">

11.7400419
</td>

<td style="text-align:right;">

0.8831
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

215
</td>

<td style="text-align:right;">

28.21522
</td>

<td style="text-align:right;">

0.9088
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

117
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

30.468750
</td>

<td style="text-align:right;">

0.9979
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

8.593750
</td>

<td style="text-align:right;">

0.7842
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.26441
</td>

<td style="text-align:right;">

0.7248
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4.054000
</td>

<td style="text-align:right;">

0.98530
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2390
</td>

<td style="text-align:right;">

0.8004
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.556310
</td>

<td style="text-align:right;">

0.8966
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

930
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

54.35418
</td>

<td style="text-align:right;">

0.9708
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

44
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.8539
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

32
</td>

<td style="text-align:right;">

456
</td>

<td style="text-align:right;">

7.017544
</td>

<td style="text-align:right;">

0.02013
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

30.76923
</td>

<td style="text-align:right;">

0.24630
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

7.675906
</td>

<td style="text-align:right;">

0.005758
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

25.396825
</td>

<td style="text-align:right;">

0.9056
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

686
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

40.093513
</td>

<td style="text-align:right;">

0.9973
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

229
</td>

<td style="text-align:right;">

13.3839860
</td>

<td style="text-align:right;">

0.439700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

20.280538
</td>

<td style="text-align:right;">

0.37880
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

1363.979
</td>

<td style="text-align:right;">

17.962156
</td>

<td style="text-align:right;">

0.6824
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

304.0000
</td>

<td style="text-align:right;">

16.11842
</td>

<td style="text-align:right;">

0.5859
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

1652
</td>

<td style="text-align:right;">

9.3825666
</td>

<td style="text-align:right;">

0.8951
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

1710.980
</td>

<td style="text-align:right;">

100.00115
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

21.0059172
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

83
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

17.697228
</td>

<td style="text-align:right;">

0.9774
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

99
</td>

<td style="text-align:right;">

469.0000
</td>

<td style="text-align:right;">

21.108742
</td>

<td style="text-align:right;">

0.9655
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.733358
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.981900
</td>

<td style="text-align:right;">

0.73750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

0.9958
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1596
</td>

<td style="text-align:right;">

0.7653
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.87486
</td>

<td style="text-align:right;">

0.8573
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

</tr>

<tr>

<td style="text-align:left;">

04001942700
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942700
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

2616
</td>

<td style="text-align:right;">

4871
</td>

<td style="text-align:right;">

53.70560
</td>

<td style="text-align:right;">

0.9480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

163
</td>

<td style="text-align:right;">

1398
</td>

<td style="text-align:right;">

11.659514
</td>

<td style="text-align:right;">

0.8577
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

1113
</td>

<td style="text-align:right;">

9.164421
</td>

<td style="text-align:right;">

0.01757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

178
</td>

<td style="text-align:right;">

30.33708
</td>

<td style="text-align:right;">

0.22790
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

156
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

12.08366
</td>

<td style="text-align:right;">

0.01652
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1039
</td>

<td style="text-align:right;">

2931
</td>

<td style="text-align:right;">

35.44865
</td>

<td style="text-align:right;">

0.9303
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1873
</td>

<td style="text-align:right;">

5249
</td>

<td style="text-align:right;">

35.68299
</td>

<td style="text-align:right;">

0.9436
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

688
</td>

<td style="text-align:right;">

14.081048
</td>

<td style="text-align:right;">

0.687000
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1530
</td>

<td style="text-align:right;">

31.313958
</td>

<td style="text-align:right;">

0.77180
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

772
</td>

<td style="text-align:right;">

3514
</td>

<td style="text-align:right;">

21.969266
</td>

<td style="text-align:right;">

0.88390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

246
</td>

<td style="text-align:right;">

939
</td>

<td style="text-align:right;">

26.19808
</td>

<td style="text-align:right;">

0.8308
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

592
</td>

<td style="text-align:right;">

4631
</td>

<td style="text-align:right;">

12.7834161
</td>

<td style="text-align:right;">

0.8975
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4846
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

99.18133
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

13.38411
</td>

<td style="text-align:right;">

0.7652
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

18.590240
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

188
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

14.562355
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.69612
</td>

<td style="text-align:right;">

0.8288
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.071000
</td>

<td style="text-align:right;">

0.98700
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9890
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1904
</td>

<td style="text-align:right;">

0.7848
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.952120
</td>

<td style="text-align:right;">

0.9295
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

2784
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

50.90510
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

358
</td>

<td style="text-align:right;">

1642
</td>

<td style="text-align:right;">

21.802680
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

1151
</td>

<td style="text-align:right;">

9.904431
</td>

<td style="text-align:right;">

0.04797
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

18.64952
</td>

<td style="text-align:right;">

0.09477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

172
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

11.764706
</td>

<td style="text-align:right;">

0.023990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

852
</td>

<td style="text-align:right;">

3274
</td>

<td style="text-align:right;">

26.023213
</td>

<td style="text-align:right;">

0.9120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1856
</td>

<td style="text-align:right;">

5466
</td>

<td style="text-align:right;">

33.955360
</td>

<td style="text-align:right;">

0.9919
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

13.8782227
</td>

<td style="text-align:right;">

0.465700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1555
</td>

<td style="text-align:right;">

28.432986
</td>

<td style="text-align:right;">

0.77390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

706
</td>

<td style="text-align:right;">

3911.002
</td>

<td style="text-align:right;">

18.051640
</td>

<td style="text-align:right;">

0.6872
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1035.0004
</td>

<td style="text-align:right;">

24.83091
</td>

<td style="text-align:right;">

0.8039
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

396
</td>

<td style="text-align:right;">

5078
</td>

<td style="text-align:right;">

7.7983458
</td>

<td style="text-align:right;">

0.8624
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5420
</td>

<td style="text-align:right;">

5469.002
</td>

<td style="text-align:right;">

99.10401
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

400
</td>

<td style="text-align:right;">

18.0018002
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

238
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

16.279070
</td>

<td style="text-align:right;">

0.9710
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

175
</td>

<td style="text-align:right;">

1462.0007
</td>

<td style="text-align:right;">

11.969898
</td>

<td style="text-align:right;">

0.8742
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

0.4754068
</td>

<td style="text-align:right;">

0.6430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.876090
</td>

<td style="text-align:right;">

0.8796
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.593100
</td>

<td style="text-align:right;">

0.94210
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9905
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4646
</td>

<td style="text-align:right;">

0.8721
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.92839
</td>

<td style="text-align:right;">

0.9425
</td>

<td style="text-align:right;">

11
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

</tr>

<tr>

<td style="text-align:left;">

04001944100
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944100
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3251
</td>

<td style="text-align:right;">

4968
</td>

<td style="text-align:right;">

65.43881
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1254
</td>

<td style="text-align:right;">

16.746412
</td>

<td style="text-align:right;">

0.9576
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

122
</td>

<td style="text-align:right;">

905
</td>

<td style="text-align:right;">

13.480663
</td>

<td style="text-align:right;">

0.04383
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

30.43478
</td>

<td style="text-align:right;">

0.22960
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

213
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.69103
</td>

<td style="text-align:right;">

0.05320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

779
</td>

<td style="text-align:right;">

2325
</td>

<td style="text-align:right;">

33.50538
</td>

<td style="text-align:right;">

0.9203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1293
</td>

<td style="text-align:right;">

5511
</td>

<td style="text-align:right;">

23.46217
</td>

<td style="text-align:right;">

0.7705
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

344
</td>

<td style="text-align:right;">

6.914573
</td>

<td style="text-align:right;">

0.270100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1993
</td>

<td style="text-align:right;">

40.060302
</td>

<td style="text-align:right;">

0.97010
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

577
</td>

<td style="text-align:right;">

3087
</td>

<td style="text-align:right;">

18.691286
</td>

<td style="text-align:right;">

0.77990
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

278
</td>

<td style="text-align:right;">

893
</td>

<td style="text-align:right;">

31.13102
</td>

<td style="text-align:right;">

0.9038
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

308
</td>

<td style="text-align:right;">

4470
</td>

<td style="text-align:right;">

6.8903803
</td>

<td style="text-align:right;">

0.7895
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

98.79397
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

0.8450704
</td>

<td style="text-align:right;">

0.3700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

17.22334
</td>

<td style="text-align:right;">

0.8203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

21.345515
</td>

<td style="text-align:right;">

0.9843
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

212
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.607973
</td>

<td style="text-align:right;">

0.9391
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.68620
</td>

<td style="text-align:right;">

0.8261
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.713400
</td>

<td style="text-align:right;">

0.95280
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

0.9872
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5092
</td>

<td style="text-align:right;">

0.8926
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.901700
</td>

<td style="text-align:right;">

0.9244
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

3704
</td>

<td style="text-align:right;">

5789
</td>

<td style="text-align:right;">

63.98342
</td>

<td style="text-align:right;">

0.9912
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

425
</td>

<td style="text-align:right;">

1608
</td>

<td style="text-align:right;">

26.430348
</td>

<td style="text-align:right;">

0.9954
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

11.349957
</td>

<td style="text-align:right;">

0.07802
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

14.55939
</td>

<td style="text-align:right;">

0.06498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

170
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

11.938202
</td>

<td style="text-align:right;">

0.026300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

862
</td>

<td style="text-align:right;">

3259
</td>

<td style="text-align:right;">

26.449831
</td>

<td style="text-align:right;">

0.9148
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1320
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

21.348860
</td>

<td style="text-align:right;">

0.9283
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

637
</td>

<td style="text-align:right;">

10.3024422
</td>

<td style="text-align:right;">

0.271800
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1869
</td>

<td style="text-align:right;">

30.228045
</td>

<td style="text-align:right;">

0.83960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

626
</td>

<td style="text-align:right;">

3964.000
</td>

<td style="text-align:right;">

15.792129
</td>

<td style="text-align:right;">

0.5715
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

371
</td>

<td style="text-align:right;">

991.0000
</td>

<td style="text-align:right;">

37.43693
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

315
</td>

<td style="text-align:right;">

5717
</td>

<td style="text-align:right;">

5.5098828
</td>

<td style="text-align:right;">

0.8021
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5981
</td>

<td style="text-align:right;">

6182.998
</td>

<td style="text-align:right;">

96.73300
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

442
</td>

<td style="text-align:right;">

18.5792350
</td>

<td style="text-align:right;">

0.8550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

26.615168
</td>

<td style="text-align:right;">

0.9969
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

1424.0000
</td>

<td style="text-align:right;">

24.367977
</td>

<td style="text-align:right;">

0.9758
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

394
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

6.3723112
</td>

<td style="text-align:right;">

0.9380
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.856000
</td>

<td style="text-align:right;">

0.8749
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.440700
</td>

<td style="text-align:right;">

0.90700
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

0.9800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8933
</td>

<td style="text-align:right;">

0.9609
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.17410
</td>

<td style="text-align:right;">

0.9549
</td>

<td style="text-align:right;">

12
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

</tr>

<tr>

<td style="text-align:left;">

04001944300
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944300
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

4099
</td>

<td style="text-align:right;">

6797
</td>

<td style="text-align:right;">

60.30602
</td>

<td style="text-align:right;">

0.9762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

1777
</td>

<td style="text-align:right;">

22.678672
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

154
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

10.569664
</td>

<td style="text-align:right;">

0.02549
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

17.07317
</td>

<td style="text-align:right;">

0.08684
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

11.88390
</td>

<td style="text-align:right;">

0.01536
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1432
</td>

<td style="text-align:right;">

3367
</td>

<td style="text-align:right;">

42.53044
</td>

<td style="text-align:right;">

0.9623
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2305
</td>

<td style="text-align:right;">

7092
</td>

<td style="text-align:right;">

32.50141
</td>

<td style="text-align:right;">

0.9160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

746
</td>

<td style="text-align:right;">

10.960917
</td>

<td style="text-align:right;">

0.517600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2767
</td>

<td style="text-align:right;">

40.655304
</td>

<td style="text-align:right;">

0.97610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

842
</td>

<td style="text-align:right;">

4361
</td>

<td style="text-align:right;">

19.307498
</td>

<td style="text-align:right;">

0.80410
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

30.69647
</td>

<td style="text-align:right;">

0.8982
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

568
</td>

<td style="text-align:right;">

6178
</td>

<td style="text-align:right;">

9.1939139
</td>

<td style="text-align:right;">

0.8423
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6750
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

99.17720
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

0.2418380
</td>

<td style="text-align:right;">

0.3113
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

440
</td>

<td style="text-align:right;">

13.30109
</td>

<td style="text-align:right;">

0.7638
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

22.124863
</td>

<td style="text-align:right;">

0.9856
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

388
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

21.248631
</td>

<td style="text-align:right;">

0.9627
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

2.042316
</td>

<td style="text-align:right;">

0.8458
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.85566
</td>

<td style="text-align:right;">

0.8602
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.038300
</td>

<td style="text-align:right;">

0.98440
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

0.9888
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8692
</td>

<td style="text-align:right;">

0.9619
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.757560
</td>

<td style="text-align:right;">

0.9749
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3548
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

59.97295
</td>

<td style="text-align:right;">

0.9854
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

67
</td>

<td style="text-align:right;">

1402
</td>

<td style="text-align:right;">

4.778887
</td>

<td style="text-align:right;">

0.5316
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

251
</td>

<td style="text-align:right;">

1664
</td>

<td style="text-align:right;">

15.084135
</td>

<td style="text-align:right;">

0.20570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

362
</td>

<td style="text-align:right;">

12.70718
</td>

<td style="text-align:right;">

0.05498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

14.659427
</td>

<td style="text-align:right;">

0.056430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

844
</td>

<td style="text-align:right;">

3696
</td>

<td style="text-align:right;">

22.835498
</td>

<td style="text-align:right;">

0.8792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2528
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

42.731575
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

793
</td>

<td style="text-align:right;">

13.3907464
</td>

<td style="text-align:right;">

0.440100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1663
</td>

<td style="text-align:right;">

28.081729
</td>

<td style="text-align:right;">

0.75750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

4258.743
</td>

<td style="text-align:right;">

13.454674
</td>

<td style="text-align:right;">

0.4253
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

1112.2581
</td>

<td style="text-align:right;">

27.06206
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

851
</td>

<td style="text-align:right;">

5568
</td>

<td style="text-align:right;">

15.2837644
</td>

<td style="text-align:right;">

0.9575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5880
</td>

<td style="text-align:right;">

5922.449
</td>

<td style="text-align:right;">

99.28326
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

0.7854338
</td>

<td style="text-align:right;">

0.3369
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

521
</td>

<td style="text-align:right;">

18.6004998
</td>

<td style="text-align:right;">

0.8557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

267
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

13.178677
</td>

<td style="text-align:right;">

0.9482
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2025.6898
</td>

<td style="text-align:right;">

14.661672
</td>

<td style="text-align:right;">

0.9158
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

0.1857481
</td>

<td style="text-align:right;">

0.5222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.451330
</td>

<td style="text-align:right;">

0.7773
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.427800
</td>

<td style="text-align:right;">

0.90080
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

0.9922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5788
</td>

<td style="text-align:right;">

0.9040
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.45433
</td>

<td style="text-align:right;">

0.9088
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

</tr>

<tr>

<td style="text-align:left;">

04005000800
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

005
</td>

<td style="text-align:left;">

000800
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

1511
</td>

<td style="text-align:right;">

2859
</td>

<td style="text-align:right;">

52.85065
</td>

<td style="text-align:right;">

0.9430
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1952
</td>

<td style="text-align:right;">

2.766393
</td>

<td style="text-align:right;">

0.1150
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

71
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

36.979167
</td>

<td style="text-align:right;">

0.73370
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

509
</td>

<td style="text-align:right;">

865
</td>

<td style="text-align:right;">

58.84393
</td>

<td style="text-align:right;">

0.83080
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

580
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

54.87228
</td>

<td style="text-align:right;">

0.96160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

265
</td>

<td style="text-align:right;">

1897
</td>

<td style="text-align:right;">

13.96943
</td>

<td style="text-align:right;">

0.6489
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

995
</td>

<td style="text-align:right;">

3589
</td>

<td style="text-align:right;">

27.72360
</td>

<td style="text-align:right;">

0.8536
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

121
</td>

<td style="text-align:right;">

3.093047
</td>

<td style="text-align:right;">

0.062070
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

208
</td>

<td style="text-align:right;">

5.316973
</td>

<td style="text-align:right;">

0.02835
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

248
</td>

<td style="text-align:right;">

3170
</td>

<td style="text-align:right;">

7.823344
</td>

<td style="text-align:right;">

0.15510
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

53
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

17.04180
</td>

<td style="text-align:right;">

0.5919
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

3898
</td>

<td style="text-align:right;">

0.6670087
</td>

<td style="text-align:right;">

0.3063
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1410
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

36.04294
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

12.9166667
</td>

<td style="text-align:right;">

0.7329
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.25000
</td>

<td style="text-align:right;">

0.3706
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

31
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

2.932829
</td>

<td style="text-align:right;">

0.6261
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

3.122044
</td>

<td style="text-align:right;">

0.4682
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1043
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

26.661554
</td>

<td style="text-align:right;">

0.9826
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.52210
</td>

<td style="text-align:right;">

0.7887
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.143720
</td>

<td style="text-align:right;">

0.02019
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0.6250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.1804
</td>

<td style="text-align:right;">

0.7810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8.474720
</td>

<td style="text-align:right;">

0.5850
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

3238
</td>

<td style="text-align:right;">

5850
</td>

<td style="text-align:right;">

55.35043
</td>

<td style="text-align:right;">

0.9741
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

399
</td>

<td style="text-align:right;">

3753
</td>

<td style="text-align:right;">

10.631495
</td>

<td style="text-align:right;">

0.9047
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

43
</td>

<td style="text-align:right;">

312
</td>

<td style="text-align:right;">

13.782051
</td>

<td style="text-align:right;">

0.15050
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1188
</td>

<td style="text-align:right;">

1850
</td>

<td style="text-align:right;">

64.21622
</td>

<td style="text-align:right;">

0.93540
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1231
</td>

<td style="text-align:right;">

2162
</td>

<td style="text-align:right;">

56.938020
</td>

<td style="text-align:right;">

0.988900
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

364
</td>

<td style="text-align:right;">

2823
</td>

<td style="text-align:right;">

12.894084
</td>

<td style="text-align:right;">

0.7116
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

5900
</td>

<td style="text-align:right;">

8.101695
</td>

<td style="text-align:right;">

0.4937
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

262
</td>

<td style="text-align:right;">

4.0759179
</td>

<td style="text-align:right;">

0.030250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

634
</td>

<td style="text-align:right;">

9.863099
</td>

<td style="text-align:right;">

0.06202
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

497
</td>

<td style="text-align:right;">

5227.333
</td>

<td style="text-align:right;">

9.507716
</td>

<td style="text-align:right;">

0.1782
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

544.6422
</td>

<td style="text-align:right;">

20.56396
</td>

<td style="text-align:right;">

0.7139
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

6207
</td>

<td style="text-align:right;">

0.9022072
</td>

<td style="text-align:right;">

0.4074
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2862
</td>

<td style="text-align:right;">

6428.175
</td>

<td style="text-align:right;">

44.52274
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

838
</td>

<td style="text-align:right;">

35.7661118
</td>

<td style="text-align:right;">

0.9165
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

0.4694836
</td>

<td style="text-align:right;">

0.4053
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

116
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

5.362922
</td>

<td style="text-align:right;">

0.7808
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

166
</td>

<td style="text-align:right;">

2162.6681
</td>

<td style="text-align:right;">

7.675704
</td>

<td style="text-align:right;">

0.7658
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

11.8077162
</td>

<td style="text-align:right;">

0.9625
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4.073000
</td>

<td style="text-align:right;">

0.9190
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.391770
</td>

<td style="text-align:right;">

0.04857
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0.6463
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.8309
</td>

<td style="text-align:right;">

0.9524
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

9.94467
</td>

<td style="text-align:right;">

0.7611
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

</tr>

<tr>

<td style="text-align:left;">

04005001000
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

005
</td>

<td style="text-align:left;">

001000
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

1744
</td>

<td style="text-align:right;">

68.63532
</td>

<td style="text-align:right;">

0.9894
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1067
</td>

<td style="text-align:right;">

4202
</td>

<td style="text-align:right;">

25.392670
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

68.000000
</td>

<td style="text-align:right;">

0.99610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

738
</td>

<td style="text-align:right;">

65.58266
</td>

<td style="text-align:right;">

0.91810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

501
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

65.66186
</td>

<td style="text-align:right;">

0.99650
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

47
</td>

<td style="text-align:right;">

886
</td>

<td style="text-align:right;">

5.30474
</td>

<td style="text-align:right;">

0.2676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1429
</td>

<td style="text-align:right;">

8331
</td>

<td style="text-align:right;">

17.15280
</td>

<td style="text-align:right;">

0.5641
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

0.003736
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

310
</td>

<td style="text-align:right;">

4.122889
</td>

<td style="text-align:right;">

0.02165
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1560
</td>

<td style="text-align:right;">

3.461539
</td>

<td style="text-align:right;">

0.01727
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

23
</td>

<td style="text-align:right;">

174
</td>

<td style="text-align:right;">

13.21839
</td>

<td style="text-align:right;">

0.4495
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

233
</td>

<td style="text-align:right;">

7411
</td>

<td style="text-align:right;">

3.1439752
</td>

<td style="text-align:right;">

0.6314
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2495
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

33.18260
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

441
</td>

<td style="text-align:right;">

51.1008111
</td>

<td style="text-align:right;">

0.9666
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

4.05562
</td>

<td style="text-align:right;">

0.6079
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

14
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1.834862
</td>

<td style="text-align:right;">

0.4856
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

119
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

15.596330
</td>

<td style="text-align:right;">

0.9127
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5775
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

76.805426
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.81010
</td>

<td style="text-align:right;">

0.8520
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.123556
</td>

<td style="text-align:right;">

0.01848
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0.5907
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.9674
</td>

<td style="text-align:right;">

0.9733
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

9.495156
</td>

<td style="text-align:right;">

0.7036
</td>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

1056
</td>

<td style="text-align:right;">

1313
</td>

<td style="text-align:right;">

80.42650
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1353
</td>

<td style="text-align:right;">

6344
</td>

<td style="text-align:right;">

21.327238
</td>

<td style="text-align:right;">

0.9918
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

62.857143
</td>

<td style="text-align:right;">

0.99810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

500
</td>

<td style="text-align:right;">

641
</td>

<td style="text-align:right;">

78.00312
</td>

<td style="text-align:right;">

0.99310
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

522
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

77.218935
</td>

<td style="text-align:right;">

0.999600
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

29
</td>

<td style="text-align:right;">

460
</td>

<td style="text-align:right;">

6.304348
</td>

<td style="text-align:right;">

0.4346
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1051
</td>

<td style="text-align:right;">

13483
</td>

<td style="text-align:right;">

7.795001
</td>

<td style="text-align:right;">

0.4716
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

0.1259353
</td>

<td style="text-align:right;">

0.004211
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

221
</td>

<td style="text-align:right;">

1.637158
</td>

<td style="text-align:right;">

0.01474
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

125
</td>

<td style="text-align:right;">

1282.667
</td>

<td style="text-align:right;">

9.745322
</td>

<td style="text-align:right;">

0.1874
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

42
</td>

<td style="text-align:right;">

114.3578
</td>

<td style="text-align:right;">

36.72685
</td>

<td style="text-align:right;">

0.9505
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

207
</td>

<td style="text-align:right;">

13491
</td>

<td style="text-align:right;">

1.5343562
</td>

<td style="text-align:right;">

0.5203
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4803
</td>

<td style="text-align:right;">

13498.825
</td>

<td style="text-align:right;">

35.58088
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

67.4846626
</td>

<td style="text-align:right;">

0.9864
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

0.8588957
</td>

<td style="text-align:right;">

0.4653
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

62
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

9.185185
</td>

<td style="text-align:right;">

0.8933
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

134
</td>

<td style="text-align:right;">

675.3319
</td>

<td style="text-align:right;">

19.842095
</td>

<td style="text-align:right;">

0.9607
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12185
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

90.2659456
</td>

<td style="text-align:right;">

0.9960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.896300
</td>

<td style="text-align:right;">

0.8850
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.677151
</td>

<td style="text-align:right;">

0.11070
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0.5516
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4.3017
</td>

<td style="text-align:right;">

0.9882
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

10.42905
</td>

<td style="text-align:right;">

0.8107
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

</tr>

</tbody>

</table>

</div>

**National**

``` r
svi_divisional_lihtc %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

GEOID_2010_trt
</th>

<th style="text-align:left;">

FIPS_st
</th>

<th style="text-align:left;">

FIPS_county
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

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

04001942600
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942600
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

1150
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

73.67072
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

8.666667
</td>

<td style="text-align:right;">

0.6866
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

17.759563
</td>

<td style="text-align:right;">

0.10180
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

27.77778
</td>

<td style="text-align:right;">

0.19090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

18.22917
</td>

<td style="text-align:right;">

0.05781
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

839
</td>

<td style="text-align:right;">

36.11442
</td>

<td style="text-align:right;">

0.9335
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

282
</td>

<td style="text-align:right;">

1578
</td>

<td style="text-align:right;">

17.87072
</td>

<td style="text-align:right;">

0.5921
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

9.801409
</td>

<td style="text-align:right;">

0.449600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

560
</td>

<td style="text-align:right;">

35.874440
</td>

<td style="text-align:right;">

0.90440
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

22.770398
</td>

<td style="text-align:right;">

0.90060
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

332
</td>

<td style="text-align:right;">

32.22892
</td>

<td style="text-align:right;">

0.9163
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

168
</td>

<td style="text-align:right;">

1431
</td>

<td style="text-align:right;">

11.7400419
</td>

<td style="text-align:right;">

0.8831
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

215
</td>

<td style="text-align:right;">

28.21522
</td>

<td style="text-align:right;">

0.9088
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

117
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

30.468750
</td>

<td style="text-align:right;">

0.9979
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

8.593750
</td>

<td style="text-align:right;">

0.7842
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.26441
</td>

<td style="text-align:right;">

0.7248
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4.054000
</td>

<td style="text-align:right;">

0.98530
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2390
</td>

<td style="text-align:right;">

0.8004
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.556310
</td>

<td style="text-align:right;">

0.8966
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

930
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

54.35418
</td>

<td style="text-align:right;">

0.9708
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

44
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.8539
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

32
</td>

<td style="text-align:right;">

456
</td>

<td style="text-align:right;">

7.017544
</td>

<td style="text-align:right;">

0.02013
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

30.76923
</td>

<td style="text-align:right;">

0.24630
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

7.675906
</td>

<td style="text-align:right;">

0.005758
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

25.396825
</td>

<td style="text-align:right;">

0.9056
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

686
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

40.093513
</td>

<td style="text-align:right;">

0.9973
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

229
</td>

<td style="text-align:right;">

13.3839860
</td>

<td style="text-align:right;">

0.439700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

20.280538
</td>

<td style="text-align:right;">

0.37880
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

1363.979
</td>

<td style="text-align:right;">

17.962156
</td>

<td style="text-align:right;">

0.6824
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

304.0000
</td>

<td style="text-align:right;">

16.11842
</td>

<td style="text-align:right;">

0.5859
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

1652
</td>

<td style="text-align:right;">

9.3825666
</td>

<td style="text-align:right;">

0.8951
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

1710.980
</td>

<td style="text-align:right;">

100.00115
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

21.0059172
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

83
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

17.697228
</td>

<td style="text-align:right;">

0.9774
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

99
</td>

<td style="text-align:right;">

469.0000
</td>

<td style="text-align:right;">

21.108742
</td>

<td style="text-align:right;">

0.9655
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.733358
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.981900
</td>

<td style="text-align:right;">

0.73750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

0.9958
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1596
</td>

<td style="text-align:right;">

0.7653
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.87486
</td>

<td style="text-align:right;">

0.8573
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

</tr>

<tr>

<td style="text-align:left;">

04001942700
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

942700
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

2616
</td>

<td style="text-align:right;">

4871
</td>

<td style="text-align:right;">

53.70560
</td>

<td style="text-align:right;">

0.9480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

163
</td>

<td style="text-align:right;">

1398
</td>

<td style="text-align:right;">

11.659514
</td>

<td style="text-align:right;">

0.8577
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

1113
</td>

<td style="text-align:right;">

9.164421
</td>

<td style="text-align:right;">

0.01757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

178
</td>

<td style="text-align:right;">

30.33708
</td>

<td style="text-align:right;">

0.22790
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

156
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

12.08366
</td>

<td style="text-align:right;">

0.01652
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1039
</td>

<td style="text-align:right;">

2931
</td>

<td style="text-align:right;">

35.44865
</td>

<td style="text-align:right;">

0.9303
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1873
</td>

<td style="text-align:right;">

5249
</td>

<td style="text-align:right;">

35.68299
</td>

<td style="text-align:right;">

0.9436
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

688
</td>

<td style="text-align:right;">

14.081048
</td>

<td style="text-align:right;">

0.687000
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1530
</td>

<td style="text-align:right;">

31.313958
</td>

<td style="text-align:right;">

0.77180
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

772
</td>

<td style="text-align:right;">

3514
</td>

<td style="text-align:right;">

21.969266
</td>

<td style="text-align:right;">

0.88390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

246
</td>

<td style="text-align:right;">

939
</td>

<td style="text-align:right;">

26.19808
</td>

<td style="text-align:right;">

0.8308
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

592
</td>

<td style="text-align:right;">

4631
</td>

<td style="text-align:right;">

12.7834161
</td>

<td style="text-align:right;">

0.8975
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4846
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

99.18133
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

13.38411
</td>

<td style="text-align:right;">

0.7652
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

18.590240
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

188
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

14.562355
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.69612
</td>

<td style="text-align:right;">

0.8288
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.071000
</td>

<td style="text-align:right;">

0.98700
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9890
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1904
</td>

<td style="text-align:right;">

0.7848
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.952120
</td>

<td style="text-align:right;">

0.9295
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

2784
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

50.90510
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

358
</td>

<td style="text-align:right;">

1642
</td>

<td style="text-align:right;">

21.802680
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

1151
</td>

<td style="text-align:right;">

9.904431
</td>

<td style="text-align:right;">

0.04797
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

18.64952
</td>

<td style="text-align:right;">

0.09477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

172
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

11.764706
</td>

<td style="text-align:right;">

0.023990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

852
</td>

<td style="text-align:right;">

3274
</td>

<td style="text-align:right;">

26.023213
</td>

<td style="text-align:right;">

0.9120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1856
</td>

<td style="text-align:right;">

5466
</td>

<td style="text-align:right;">

33.955360
</td>

<td style="text-align:right;">

0.9919
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

13.8782227
</td>

<td style="text-align:right;">

0.465700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1555
</td>

<td style="text-align:right;">

28.432986
</td>

<td style="text-align:right;">

0.77390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

706
</td>

<td style="text-align:right;">

3911.002
</td>

<td style="text-align:right;">

18.051640
</td>

<td style="text-align:right;">

0.6872
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1035.0004
</td>

<td style="text-align:right;">

24.83091
</td>

<td style="text-align:right;">

0.8039
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

396
</td>

<td style="text-align:right;">

5078
</td>

<td style="text-align:right;">

7.7983458
</td>

<td style="text-align:right;">

0.8624
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5420
</td>

<td style="text-align:right;">

5469.002
</td>

<td style="text-align:right;">

99.10401
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

400
</td>

<td style="text-align:right;">

18.0018002
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

238
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

16.279070
</td>

<td style="text-align:right;">

0.9710
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

175
</td>

<td style="text-align:right;">

1462.0007
</td>

<td style="text-align:right;">

11.969898
</td>

<td style="text-align:right;">

0.8742
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

0.4754068
</td>

<td style="text-align:right;">

0.6430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.876090
</td>

<td style="text-align:right;">

0.8796
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.593100
</td>

<td style="text-align:right;">

0.94210
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9905
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4646
</td>

<td style="text-align:right;">

0.8721
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.92839
</td>

<td style="text-align:right;">

0.9425
</td>

<td style="text-align:right;">

11
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

</tr>

<tr>

<td style="text-align:left;">

04001944100
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944100
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3251
</td>

<td style="text-align:right;">

4968
</td>

<td style="text-align:right;">

65.43881
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1254
</td>

<td style="text-align:right;">

16.746412
</td>

<td style="text-align:right;">

0.9576
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

122
</td>

<td style="text-align:right;">

905
</td>

<td style="text-align:right;">

13.480663
</td>

<td style="text-align:right;">

0.04383
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

30.43478
</td>

<td style="text-align:right;">

0.22960
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

213
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.69103
</td>

<td style="text-align:right;">

0.05320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

779
</td>

<td style="text-align:right;">

2325
</td>

<td style="text-align:right;">

33.50538
</td>

<td style="text-align:right;">

0.9203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1293
</td>

<td style="text-align:right;">

5511
</td>

<td style="text-align:right;">

23.46217
</td>

<td style="text-align:right;">

0.7705
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

344
</td>

<td style="text-align:right;">

6.914573
</td>

<td style="text-align:right;">

0.270100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1993
</td>

<td style="text-align:right;">

40.060302
</td>

<td style="text-align:right;">

0.97010
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

577
</td>

<td style="text-align:right;">

3087
</td>

<td style="text-align:right;">

18.691286
</td>

<td style="text-align:right;">

0.77990
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

278
</td>

<td style="text-align:right;">

893
</td>

<td style="text-align:right;">

31.13102
</td>

<td style="text-align:right;">

0.9038
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

308
</td>

<td style="text-align:right;">

4470
</td>

<td style="text-align:right;">

6.8903803
</td>

<td style="text-align:right;">

0.7895
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

98.79397
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

0.8450704
</td>

<td style="text-align:right;">

0.3700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

17.22334
</td>

<td style="text-align:right;">

0.8203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

21.345515
</td>

<td style="text-align:right;">

0.9843
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

212
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.607973
</td>

<td style="text-align:right;">

0.9391
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.68620
</td>

<td style="text-align:right;">

0.8261
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.713400
</td>

<td style="text-align:right;">

0.95280
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

0.9872
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5092
</td>

<td style="text-align:right;">

0.8926
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.901700
</td>

<td style="text-align:right;">

0.9244
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

3704
</td>

<td style="text-align:right;">

5789
</td>

<td style="text-align:right;">

63.98342
</td>

<td style="text-align:right;">

0.9912
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

425
</td>

<td style="text-align:right;">

1608
</td>

<td style="text-align:right;">

26.430348
</td>

<td style="text-align:right;">

0.9954
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

11.349957
</td>

<td style="text-align:right;">

0.07802
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

14.55939
</td>

<td style="text-align:right;">

0.06498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

170
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

11.938202
</td>

<td style="text-align:right;">

0.026300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

862
</td>

<td style="text-align:right;">

3259
</td>

<td style="text-align:right;">

26.449831
</td>

<td style="text-align:right;">

0.9148
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1320
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

21.348860
</td>

<td style="text-align:right;">

0.9283
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

637
</td>

<td style="text-align:right;">

10.3024422
</td>

<td style="text-align:right;">

0.271800
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1869
</td>

<td style="text-align:right;">

30.228045
</td>

<td style="text-align:right;">

0.83960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

626
</td>

<td style="text-align:right;">

3964.000
</td>

<td style="text-align:right;">

15.792129
</td>

<td style="text-align:right;">

0.5715
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

371
</td>

<td style="text-align:right;">

991.0000
</td>

<td style="text-align:right;">

37.43693
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

315
</td>

<td style="text-align:right;">

5717
</td>

<td style="text-align:right;">

5.5098828
</td>

<td style="text-align:right;">

0.8021
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5981
</td>

<td style="text-align:right;">

6182.998
</td>

<td style="text-align:right;">

96.73300
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

442
</td>

<td style="text-align:right;">

18.5792350
</td>

<td style="text-align:right;">

0.8550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

26.615168
</td>

<td style="text-align:right;">

0.9969
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

1424.0000
</td>

<td style="text-align:right;">

24.367977
</td>

<td style="text-align:right;">

0.9758
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

394
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

6.3723112
</td>

<td style="text-align:right;">

0.9380
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.856000
</td>

<td style="text-align:right;">

0.8749
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.440700
</td>

<td style="text-align:right;">

0.90700
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

0.9800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8933
</td>

<td style="text-align:right;">

0.9609
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.17410
</td>

<td style="text-align:right;">

0.9549
</td>

<td style="text-align:right;">

12
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

</tr>

<tr>

<td style="text-align:left;">

04001944300
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

001
</td>

<td style="text-align:left;">

944300
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

4099
</td>

<td style="text-align:right;">

6797
</td>

<td style="text-align:right;">

60.30602
</td>

<td style="text-align:right;">

0.9762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

1777
</td>

<td style="text-align:right;">

22.678672
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

154
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

10.569664
</td>

<td style="text-align:right;">

0.02549
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

17.07317
</td>

<td style="text-align:right;">

0.08684
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

11.88390
</td>

<td style="text-align:right;">

0.01536
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1432
</td>

<td style="text-align:right;">

3367
</td>

<td style="text-align:right;">

42.53044
</td>

<td style="text-align:right;">

0.9623
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2305
</td>

<td style="text-align:right;">

7092
</td>

<td style="text-align:right;">

32.50141
</td>

<td style="text-align:right;">

0.9160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

746
</td>

<td style="text-align:right;">

10.960917
</td>

<td style="text-align:right;">

0.517600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2767
</td>

<td style="text-align:right;">

40.655304
</td>

<td style="text-align:right;">

0.97610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

842
</td>

<td style="text-align:right;">

4361
</td>

<td style="text-align:right;">

19.307498
</td>

<td style="text-align:right;">

0.80410
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

30.69647
</td>

<td style="text-align:right;">

0.8982
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

568
</td>

<td style="text-align:right;">

6178
</td>

<td style="text-align:right;">

9.1939139
</td>

<td style="text-align:right;">

0.8423
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6750
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

99.17720
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

0.2418380
</td>

<td style="text-align:right;">

0.3113
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

440
</td>

<td style="text-align:right;">

13.30109
</td>

<td style="text-align:right;">

0.7638
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

22.124863
</td>

<td style="text-align:right;">

0.9856
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

388
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

21.248631
</td>

<td style="text-align:right;">

0.9627
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

2.042316
</td>

<td style="text-align:right;">

0.8458
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.85566
</td>

<td style="text-align:right;">

0.8602
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.038300
</td>

<td style="text-align:right;">

0.98440
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

0.9888
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8692
</td>

<td style="text-align:right;">

0.9619
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.757560
</td>

<td style="text-align:right;">

0.9749
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3548
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

59.97295
</td>

<td style="text-align:right;">

0.9854
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

67
</td>

<td style="text-align:right;">

1402
</td>

<td style="text-align:right;">

4.778887
</td>

<td style="text-align:right;">

0.5316
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

251
</td>

<td style="text-align:right;">

1664
</td>

<td style="text-align:right;">

15.084135
</td>

<td style="text-align:right;">

0.20570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

362
</td>

<td style="text-align:right;">

12.70718
</td>

<td style="text-align:right;">

0.05498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

14.659427
</td>

<td style="text-align:right;">

0.056430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

844
</td>

<td style="text-align:right;">

3696
</td>

<td style="text-align:right;">

22.835498
</td>

<td style="text-align:right;">

0.8792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2528
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

42.731575
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

793
</td>

<td style="text-align:right;">

13.3907464
</td>

<td style="text-align:right;">

0.440100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1663
</td>

<td style="text-align:right;">

28.081729
</td>

<td style="text-align:right;">

0.75750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

4258.743
</td>

<td style="text-align:right;">

13.454674
</td>

<td style="text-align:right;">

0.4253
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

1112.2581
</td>

<td style="text-align:right;">

27.06206
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

851
</td>

<td style="text-align:right;">

5568
</td>

<td style="text-align:right;">

15.2837644
</td>

<td style="text-align:right;">

0.9575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5880
</td>

<td style="text-align:right;">

5922.449
</td>

<td style="text-align:right;">

99.28326
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

0.7854338
</td>

<td style="text-align:right;">

0.3369
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

521
</td>

<td style="text-align:right;">

18.6004998
</td>

<td style="text-align:right;">

0.8557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

267
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

13.178677
</td>

<td style="text-align:right;">

0.9482
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2025.6898
</td>

<td style="text-align:right;">

14.661672
</td>

<td style="text-align:right;">

0.9158
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

0.1857481
</td>

<td style="text-align:right;">

0.5222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.451330
</td>

<td style="text-align:right;">

0.7773
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.427800
</td>

<td style="text-align:right;">

0.90080
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

0.9922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5788
</td>

<td style="text-align:right;">

0.9040
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.45433
</td>

<td style="text-align:right;">

0.9088
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

</tr>

<tr>

<td style="text-align:left;">

04005000800
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

005
</td>

<td style="text-align:left;">

000800
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

1511
</td>

<td style="text-align:right;">

2859
</td>

<td style="text-align:right;">

52.85065
</td>

<td style="text-align:right;">

0.9430
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1952
</td>

<td style="text-align:right;">

2.766393
</td>

<td style="text-align:right;">

0.1150
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

71
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

36.979167
</td>

<td style="text-align:right;">

0.73370
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

509
</td>

<td style="text-align:right;">

865
</td>

<td style="text-align:right;">

58.84393
</td>

<td style="text-align:right;">

0.83080
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

580
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

54.87228
</td>

<td style="text-align:right;">

0.96160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

265
</td>

<td style="text-align:right;">

1897
</td>

<td style="text-align:right;">

13.96943
</td>

<td style="text-align:right;">

0.6489
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

995
</td>

<td style="text-align:right;">

3589
</td>

<td style="text-align:right;">

27.72360
</td>

<td style="text-align:right;">

0.8536
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

121
</td>

<td style="text-align:right;">

3.093047
</td>

<td style="text-align:right;">

0.062070
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

208
</td>

<td style="text-align:right;">

5.316973
</td>

<td style="text-align:right;">

0.02835
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

248
</td>

<td style="text-align:right;">

3170
</td>

<td style="text-align:right;">

7.823344
</td>

<td style="text-align:right;">

0.15510
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

53
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

17.04180
</td>

<td style="text-align:right;">

0.5919
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

3898
</td>

<td style="text-align:right;">

0.6670087
</td>

<td style="text-align:right;">

0.3063
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1410
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

36.04294
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

12.9166667
</td>

<td style="text-align:right;">

0.7329
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.25000
</td>

<td style="text-align:right;">

0.3706
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

31
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

2.932829
</td>

<td style="text-align:right;">

0.6261
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

3.122044
</td>

<td style="text-align:right;">

0.4682
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1043
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

26.661554
</td>

<td style="text-align:right;">

0.9826
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.52210
</td>

<td style="text-align:right;">

0.7887
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.143720
</td>

<td style="text-align:right;">

0.02019
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0.6250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.1804
</td>

<td style="text-align:right;">

0.7810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8.474720
</td>

<td style="text-align:right;">

0.5850
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

3238
</td>

<td style="text-align:right;">

5850
</td>

<td style="text-align:right;">

55.35043
</td>

<td style="text-align:right;">

0.9741
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

399
</td>

<td style="text-align:right;">

3753
</td>

<td style="text-align:right;">

10.631495
</td>

<td style="text-align:right;">

0.9047
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

43
</td>

<td style="text-align:right;">

312
</td>

<td style="text-align:right;">

13.782051
</td>

<td style="text-align:right;">

0.15050
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1188
</td>

<td style="text-align:right;">

1850
</td>

<td style="text-align:right;">

64.21622
</td>

<td style="text-align:right;">

0.93540
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1231
</td>

<td style="text-align:right;">

2162
</td>

<td style="text-align:right;">

56.938020
</td>

<td style="text-align:right;">

0.988900
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

364
</td>

<td style="text-align:right;">

2823
</td>

<td style="text-align:right;">

12.894084
</td>

<td style="text-align:right;">

0.7116
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

5900
</td>

<td style="text-align:right;">

8.101695
</td>

<td style="text-align:right;">

0.4937
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

262
</td>

<td style="text-align:right;">

4.0759179
</td>

<td style="text-align:right;">

0.030250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

634
</td>

<td style="text-align:right;">

9.863099
</td>

<td style="text-align:right;">

0.06202
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

497
</td>

<td style="text-align:right;">

5227.333
</td>

<td style="text-align:right;">

9.507716
</td>

<td style="text-align:right;">

0.1782
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

544.6422
</td>

<td style="text-align:right;">

20.56396
</td>

<td style="text-align:right;">

0.7139
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

6207
</td>

<td style="text-align:right;">

0.9022072
</td>

<td style="text-align:right;">

0.4074
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2862
</td>

<td style="text-align:right;">

6428.175
</td>

<td style="text-align:right;">

44.52274
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

838
</td>

<td style="text-align:right;">

35.7661118
</td>

<td style="text-align:right;">

0.9165
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

0.4694836
</td>

<td style="text-align:right;">

0.4053
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

116
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

5.362922
</td>

<td style="text-align:right;">

0.7808
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

166
</td>

<td style="text-align:right;">

2162.6681
</td>

<td style="text-align:right;">

7.675704
</td>

<td style="text-align:right;">

0.7658
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

11.8077162
</td>

<td style="text-align:right;">

0.9625
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4.073000
</td>

<td style="text-align:right;">

0.9190
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.391770
</td>

<td style="text-align:right;">

0.04857
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0.6463
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.8309
</td>

<td style="text-align:right;">

0.9524
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

9.94467
</td>

<td style="text-align:right;">

0.7611
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

</tr>

<tr>

<td style="text-align:left;">

04005001000
</td>

<td style="text-align:left;">

04
</td>

<td style="text-align:left;">

005
</td>

<td style="text-align:left;">

001000
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

1744
</td>

<td style="text-align:right;">

68.63532
</td>

<td style="text-align:right;">

0.9894
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1067
</td>

<td style="text-align:right;">

4202
</td>

<td style="text-align:right;">

25.392670
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

68.000000
</td>

<td style="text-align:right;">

0.99610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

738
</td>

<td style="text-align:right;">

65.58266
</td>

<td style="text-align:right;">

0.91810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

501
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

65.66186
</td>

<td style="text-align:right;">

0.99650
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

47
</td>

<td style="text-align:right;">

886
</td>

<td style="text-align:right;">

5.30474
</td>

<td style="text-align:right;">

0.2676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1429
</td>

<td style="text-align:right;">

8331
</td>

<td style="text-align:right;">

17.15280
</td>

<td style="text-align:right;">

0.5641
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

0.003736
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

310
</td>

<td style="text-align:right;">

4.122889
</td>

<td style="text-align:right;">

0.02165
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1560
</td>

<td style="text-align:right;">

3.461539
</td>

<td style="text-align:right;">

0.01727
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

23
</td>

<td style="text-align:right;">

174
</td>

<td style="text-align:right;">

13.21839
</td>

<td style="text-align:right;">

0.4495
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

233
</td>

<td style="text-align:right;">

7411
</td>

<td style="text-align:right;">

3.1439752
</td>

<td style="text-align:right;">

0.6314
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2495
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

33.18260
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

441
</td>

<td style="text-align:right;">

51.1008111
</td>

<td style="text-align:right;">

0.9666
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

4.05562
</td>

<td style="text-align:right;">

0.6079
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

14
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1.834862
</td>

<td style="text-align:right;">

0.4856
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

119
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

15.596330
</td>

<td style="text-align:right;">

0.9127
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5775
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

76.805426
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.81010
</td>

<td style="text-align:right;">

0.8520
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.123556
</td>

<td style="text-align:right;">

0.01848
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0.5907
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.9674
</td>

<td style="text-align:right;">

0.9733
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

9.495156
</td>

<td style="text-align:right;">

0.7036
</td>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

1056
</td>

<td style="text-align:right;">

1313
</td>

<td style="text-align:right;">

80.42650
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1353
</td>

<td style="text-align:right;">

6344
</td>

<td style="text-align:right;">

21.327238
</td>

<td style="text-align:right;">

0.9918
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

62.857143
</td>

<td style="text-align:right;">

0.99810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

500
</td>

<td style="text-align:right;">

641
</td>

<td style="text-align:right;">

78.00312
</td>

<td style="text-align:right;">

0.99310
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

522
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

77.218935
</td>

<td style="text-align:right;">

0.999600
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

29
</td>

<td style="text-align:right;">

460
</td>

<td style="text-align:right;">

6.304348
</td>

<td style="text-align:right;">

0.4346
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1051
</td>

<td style="text-align:right;">

13483
</td>

<td style="text-align:right;">

7.795001
</td>

<td style="text-align:right;">

0.4716
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

0.1259353
</td>

<td style="text-align:right;">

0.004211
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

221
</td>

<td style="text-align:right;">

1.637158
</td>

<td style="text-align:right;">

0.01474
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

125
</td>

<td style="text-align:right;">

1282.667
</td>

<td style="text-align:right;">

9.745322
</td>

<td style="text-align:right;">

0.1874
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

42
</td>

<td style="text-align:right;">

114.3578
</td>

<td style="text-align:right;">

36.72685
</td>

<td style="text-align:right;">

0.9505
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

207
</td>

<td style="text-align:right;">

13491
</td>

<td style="text-align:right;">

1.5343562
</td>

<td style="text-align:right;">

0.5203
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4803
</td>

<td style="text-align:right;">

13498.825
</td>

<td style="text-align:right;">

35.58088
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

67.4846626
</td>

<td style="text-align:right;">

0.9864
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

0.8588957
</td>

<td style="text-align:right;">

0.4653
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

62
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

9.185185
</td>

<td style="text-align:right;">

0.8933
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

134
</td>

<td style="text-align:right;">

675.3319
</td>

<td style="text-align:right;">

19.842095
</td>

<td style="text-align:right;">

0.9607
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12185
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

90.2659456
</td>

<td style="text-align:right;">

0.9960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.896300
</td>

<td style="text-align:right;">

0.8850
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.677151
</td>

<td style="text-align:right;">

0.11070
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0.5516
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4.3017
</td>

<td style="text-align:right;">

0.9882
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

10.42905
</td>

<td style="text-align:right;">

0.8107
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

</tr>

</tbody>

</table>

</div>

## Housing Price Index Data

``` r
hpi_df <- read.csv("https://r-class.github.io/paf-515-course-materials/data/raw/HPI/HPI_AT_BDL_tract.csv")
```

``` r
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

## Core Based statistical Areas (CBSA) Crosswalk

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

# Census Data

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

# NMTC Data Sets

*Divisional*

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

04001942600
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

942600
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

1150
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

73.67072
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

8.666667
</td>

<td style="text-align:right;">

0.6866
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

17.759563
</td>

<td style="text-align:right;">

0.101800
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

27.77778
</td>

<td style="text-align:right;">

0.19090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

18.229167
</td>

<td style="text-align:right;">

0.057810
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

839
</td>

<td style="text-align:right;">

36.11442
</td>

<td style="text-align:right;">

0.9335
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

282
</td>

<td style="text-align:right;">

1578
</td>

<td style="text-align:right;">

17.87072
</td>

<td style="text-align:right;">

0.5921
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

9.801409
</td>

<td style="text-align:right;">

0.4496
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

560
</td>

<td style="text-align:right;">

35.87444
</td>

<td style="text-align:right;">

0.9044
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

22.770398
</td>

<td style="text-align:right;">

0.9006
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

332
</td>

<td style="text-align:right;">

32.22892
</td>

<td style="text-align:right;">

0.9163
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

168
</td>

<td style="text-align:right;">

1431
</td>

<td style="text-align:right;">

11.740042
</td>

<td style="text-align:right;">

0.8831
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

215
</td>

<td style="text-align:right;">

28.21522
</td>

<td style="text-align:right;">

0.9088
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

117
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

30.46875
</td>

<td style="text-align:right;">

0.9979
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

8.593750
</td>

<td style="text-align:right;">

0.7842
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.264410
</td>

<td style="text-align:right;">

0.7248
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4.0540
</td>

<td style="text-align:right;">

0.9853
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2390
</td>

<td style="text-align:right;">

0.8004
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.55631
</td>

<td style="text-align:right;">

0.8966
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

930
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

54.35418
</td>

<td style="text-align:right;">

0.9708
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

44
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.8539
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

32
</td>

<td style="text-align:right;">

456
</td>

<td style="text-align:right;">

7.017544
</td>

<td style="text-align:right;">

0.02013
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

30.769231
</td>

<td style="text-align:right;">

0.24630
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

7.675906
</td>

<td style="text-align:right;">

0.005758
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

25.39683
</td>

<td style="text-align:right;">

0.9056
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

686
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

40.09351
</td>

<td style="text-align:right;">

0.9973
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

229
</td>

<td style="text-align:right;">

13.38399
</td>

<td style="text-align:right;">

0.4397
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

20.28054
</td>

<td style="text-align:right;">

0.3788
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

1363.979
</td>

<td style="text-align:right;">

17.962156
</td>

<td style="text-align:right;">

0.68240
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

304.0000
</td>

<td style="text-align:right;">

16.11842
</td>

<td style="text-align:right;">

0.5859
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

1652
</td>

<td style="text-align:right;">

9.382567
</td>

<td style="text-align:right;">

0.8951
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

1710.980
</td>

<td style="text-align:right;">

100.00115
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

21.00592
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

83
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

17.697228
</td>

<td style="text-align:right;">

0.9774
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

99
</td>

<td style="text-align:right;">

469.000
</td>

<td style="text-align:right;">

21.10874
</td>

<td style="text-align:right;">

0.9655
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.733358
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.98190
</td>

<td style="text-align:right;">

0.7375
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

0.9958
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1596
</td>

<td style="text-align:right;">

0.7653
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.87486
</td>

<td style="text-align:right;">

0.8573
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

Census Tract 9426, Apache County, Arizona
</td>

<td style="text-align:right;">

10268
</td>

<td style="text-align:right;">

27600
</td>

<td style="text-align:right;">

15822
</td>

<td style="text-align:right;">

45700
</td>

<td style="text-align:right;">

11910.88
</td>

<td style="text-align:right;">

32016
</td>

<td style="text-align:right;">

3911.12
</td>

<td style="text-align:right;">

0.3283653
</td>

<td style="text-align:right;">

13684
</td>

<td style="text-align:right;">

0.4274113
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

04001942700
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

942700
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

2616
</td>

<td style="text-align:right;">

4871
</td>

<td style="text-align:right;">

53.70560
</td>

<td style="text-align:right;">

0.9480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

163
</td>

<td style="text-align:right;">

1398
</td>

<td style="text-align:right;">

11.659514
</td>

<td style="text-align:right;">

0.8577
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

1113
</td>

<td style="text-align:right;">

9.164421
</td>

<td style="text-align:right;">

0.017570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

178
</td>

<td style="text-align:right;">

30.33708
</td>

<td style="text-align:right;">

0.22790
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

156
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

12.083656
</td>

<td style="text-align:right;">

0.016520
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1039
</td>

<td style="text-align:right;">

2931
</td>

<td style="text-align:right;">

35.44865
</td>

<td style="text-align:right;">

0.9303
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1873
</td>

<td style="text-align:right;">

5249
</td>

<td style="text-align:right;">

35.68299
</td>

<td style="text-align:right;">

0.9436
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

688
</td>

<td style="text-align:right;">

14.081048
</td>

<td style="text-align:right;">

0.6870
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1530
</td>

<td style="text-align:right;">

31.31396
</td>

<td style="text-align:right;">

0.7718
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

772
</td>

<td style="text-align:right;">

3514
</td>

<td style="text-align:right;">

21.969266
</td>

<td style="text-align:right;">

0.8839
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

246
</td>

<td style="text-align:right;">

939
</td>

<td style="text-align:right;">

26.19808
</td>

<td style="text-align:right;">

0.8308
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

592
</td>

<td style="text-align:right;">

4631
</td>

<td style="text-align:right;">

12.783416
</td>

<td style="text-align:right;">

0.8975
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4846
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

99.18133
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

13.38411
</td>

<td style="text-align:right;">

0.7652
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

18.59024
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

188
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

14.562355
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.696120
</td>

<td style="text-align:right;">

0.8288
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.0710
</td>

<td style="text-align:right;">

0.9870
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9890
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1904
</td>

<td style="text-align:right;">

0.7848
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.95212
</td>

<td style="text-align:right;">

0.9295
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

2784
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

50.90510
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

358
</td>

<td style="text-align:right;">

1642
</td>

<td style="text-align:right;">

21.802680
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

1151
</td>

<td style="text-align:right;">

9.904431
</td>

<td style="text-align:right;">

0.04797
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

18.649518
</td>

<td style="text-align:right;">

0.09477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

172
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

11.764706
</td>

<td style="text-align:right;">

0.023990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

852
</td>

<td style="text-align:right;">

3274
</td>

<td style="text-align:right;">

26.02321
</td>

<td style="text-align:right;">

0.9120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1856
</td>

<td style="text-align:right;">

5466
</td>

<td style="text-align:right;">

33.95536
</td>

<td style="text-align:right;">

0.9919
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

13.87822
</td>

<td style="text-align:right;">

0.4657
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1555
</td>

<td style="text-align:right;">

28.43299
</td>

<td style="text-align:right;">

0.7739
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

706
</td>

<td style="text-align:right;">

3911.002
</td>

<td style="text-align:right;">

18.051640
</td>

<td style="text-align:right;">

0.68720
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1035.0004
</td>

<td style="text-align:right;">

24.83091
</td>

<td style="text-align:right;">

0.8039
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

396
</td>

<td style="text-align:right;">

5078
</td>

<td style="text-align:right;">

7.798346
</td>

<td style="text-align:right;">

0.8624
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5420
</td>

<td style="text-align:right;">

5469.002
</td>

<td style="text-align:right;">

99.10401
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

400
</td>

<td style="text-align:right;">

18.00180
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

238
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

16.279070
</td>

<td style="text-align:right;">

0.9710
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

175
</td>

<td style="text-align:right;">

1462.001
</td>

<td style="text-align:right;">

11.96990
</td>

<td style="text-align:right;">

0.8742
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

0.4754068
</td>

<td style="text-align:right;">

0.6430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.876090
</td>

<td style="text-align:right;">

0.8796
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.59310
</td>

<td style="text-align:right;">

0.9421
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9905
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4646
</td>

<td style="text-align:right;">

0.8721
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.92839
</td>

<td style="text-align:right;">

0.9425
</td>

<td style="text-align:right;">

11
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

Census Tract 9427, Apache County, Arizona
</td>

<td style="text-align:right;">

14348
</td>

<td style="text-align:right;">

55900
</td>

<td style="text-align:right;">

18740
</td>

<td style="text-align:right;">

47200
</td>

<td style="text-align:right;">

16643.68
</td>

<td style="text-align:right;">

64844
</td>

<td style="text-align:right;">

2096.32
</td>

<td style="text-align:right;">

0.1259529
</td>

<td style="text-align:right;">

-17644
</td>

<td style="text-align:right;">

-0.2720992
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

04001944000
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944000
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

2178
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

3112
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

52.23229
</td>

<td style="text-align:right;">

0.9399
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

1895
</td>

<td style="text-align:right;">

5.646438
</td>

<td style="text-align:right;">

0.4130
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

108
</td>

<td style="text-align:right;">

880
</td>

<td style="text-align:right;">

12.272727
</td>

<td style="text-align:right;">

0.034760
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

395
</td>

<td style="text-align:right;">

28.35443
</td>

<td style="text-align:right;">

0.19940
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

220
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

17.254902
</td>

<td style="text-align:right;">

0.049550
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1030
</td>

<td style="text-align:right;">

3376
</td>

<td style="text-align:right;">

30.50948
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2632
</td>

<td style="text-align:right;">

5821
</td>

<td style="text-align:right;">

45.21560
</td>

<td style="text-align:right;">

0.9873
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

472
</td>

<td style="text-align:right;">

7.922122
</td>

<td style="text-align:right;">

0.3301
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1792
</td>

<td style="text-align:right;">

30.07721
</td>

<td style="text-align:right;">

0.7211
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

4027
</td>

<td style="text-align:right;">

7.424882
</td>

<td style="text-align:right;">

0.1343
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

272
</td>

<td style="text-align:right;">

979
</td>

<td style="text-align:right;">

27.78345
</td>

<td style="text-align:right;">

0.8590
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

5325
</td>

<td style="text-align:right;">

2.873239
</td>

<td style="text-align:right;">

0.6096
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5846
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

98.12017
</td>

<td style="text-align:right;">

0.9893
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2178
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

448
</td>

<td style="text-align:right;">

20.56933
</td>

<td style="text-align:right;">

0.8562
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

247
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

19.37255
</td>

<td style="text-align:right;">

0.9798
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

135
</td>

<td style="text-align:right;">

1275
</td>

<td style="text-align:right;">

10.588235
</td>

<td style="text-align:right;">

0.8373
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5958
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.291250
</td>

<td style="text-align:right;">

0.7314
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

2.6541
</td>

<td style="text-align:right;">

0.5792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.9893
</td>

<td style="text-align:right;">

0.9836
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2214
</td>

<td style="text-align:right;">

0.7946
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.15605
</td>

<td style="text-align:right;">

0.7714
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

6583
</td>

<td style="text-align:right;">

2464
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

3270
</td>

<td style="text-align:right;">

6580
</td>

<td style="text-align:right;">

49.69605
</td>

<td style="text-align:right;">

0.9486
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

191
</td>

<td style="text-align:right;">

2029
</td>

<td style="text-align:right;">

9.413504
</td>

<td style="text-align:right;">

0.8663
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

89
</td>

<td style="text-align:right;">

1272
</td>

<td style="text-align:right;">

6.996855
</td>

<td style="text-align:right;">

0.01965
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

103
</td>

<td style="text-align:right;">

564
</td>

<td style="text-align:right;">

18.262411
</td>

<td style="text-align:right;">

0.09073
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

10.457516
</td>

<td style="text-align:right;">

0.015550
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

753
</td>

<td style="text-align:right;">

4321
</td>

<td style="text-align:right;">

17.42652
</td>

<td style="text-align:right;">

0.8100
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2993
</td>

<td style="text-align:right;">

6580
</td>

<td style="text-align:right;">

45.48632
</td>

<td style="text-align:right;">

0.9992
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1034
</td>

<td style="text-align:right;">

15.70712
</td>

<td style="text-align:right;">

0.5561
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1569
</td>

<td style="text-align:right;">

23.83412
</td>

<td style="text-align:right;">

0.5584
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1069
</td>

<td style="text-align:right;">

5014.189
</td>

<td style="text-align:right;">

21.319499
</td>

<td style="text-align:right;">

0.81410
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1237.2784
</td>

<td style="text-align:right;">

24.57006
</td>

<td style="text-align:right;">

0.7989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

141
</td>

<td style="text-align:right;">

6193
</td>

<td style="text-align:right;">

2.276764
</td>

<td style="text-align:right;">

0.6147
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

6436
</td>

<td style="text-align:right;">

6583.375
</td>

<td style="text-align:right;">

97.76141
</td>

<td style="text-align:right;">

0.9876
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2464
</td>

<td style="text-align:right;">

20
</td>

<td style="text-align:right;">

0.8116883
</td>

<td style="text-align:right;">

0.3404
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

536
</td>

<td style="text-align:right;">

21.75325
</td>

<td style="text-align:right;">

0.8793
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

274
</td>

<td style="text-align:right;">

1836
</td>

<td style="text-align:right;">

14.923747
</td>

<td style="text-align:right;">

0.9643
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

326
</td>

<td style="text-align:right;">

1836.376
</td>

<td style="text-align:right;">

17.75235
</td>

<td style="text-align:right;">

0.9488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

6583
</td>

<td style="text-align:right;">

0.0455719
</td>

<td style="text-align:right;">

0.4382
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.639650
</td>

<td style="text-align:right;">

0.8211
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.34220
</td>

<td style="text-align:right;">

0.8770
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9876
</td>

<td style="text-align:right;">

0.9834
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5710
</td>

<td style="text-align:right;">

0.9020
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.54045
</td>

<td style="text-align:right;">

0.9156
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

Census Tract 9440, Apache County, Arizona
</td>

<td style="text-align:right;">

17679
</td>

<td style="text-align:right;">

61100
</td>

<td style="text-align:right;">

21541
</td>

<td style="text-align:right;">

40000
</td>

<td style="text-align:right;">

20507.64
</td>

<td style="text-align:right;">

70876
</td>

<td style="text-align:right;">

1033.36
</td>

<td style="text-align:right;">

0.0503890
</td>

<td style="text-align:right;">

-30876
</td>

<td style="text-align:right;">

-0.4356341
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

04001944100
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944100
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3251
</td>

<td style="text-align:right;">

4968
</td>

<td style="text-align:right;">

65.43881
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1254
</td>

<td style="text-align:right;">

16.746412
</td>

<td style="text-align:right;">

0.9576
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

122
</td>

<td style="text-align:right;">

905
</td>

<td style="text-align:right;">

13.480663
</td>

<td style="text-align:right;">

0.043830
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

30.43478
</td>

<td style="text-align:right;">

0.22960
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

213
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.691030
</td>

<td style="text-align:right;">

0.053200
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

779
</td>

<td style="text-align:right;">

2325
</td>

<td style="text-align:right;">

33.50538
</td>

<td style="text-align:right;">

0.9203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1293
</td>

<td style="text-align:right;">

5511
</td>

<td style="text-align:right;">

23.46217
</td>

<td style="text-align:right;">

0.7705
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

344
</td>

<td style="text-align:right;">

6.914573
</td>

<td style="text-align:right;">

0.2701
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1993
</td>

<td style="text-align:right;">

40.06030
</td>

<td style="text-align:right;">

0.9701
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

577
</td>

<td style="text-align:right;">

3087
</td>

<td style="text-align:right;">

18.691286
</td>

<td style="text-align:right;">

0.7799
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

278
</td>

<td style="text-align:right;">

893
</td>

<td style="text-align:right;">

31.13102
</td>

<td style="text-align:right;">

0.9038
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

308
</td>

<td style="text-align:right;">

4470
</td>

<td style="text-align:right;">

6.890380
</td>

<td style="text-align:right;">

0.7895
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

98.79397
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

0.8450704
</td>

<td style="text-align:right;">

0.3700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

17.22334
</td>

<td style="text-align:right;">

0.8203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

21.34551
</td>

<td style="text-align:right;">

0.9843
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

212
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.607973
</td>

<td style="text-align:right;">

0.9391
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.686200
</td>

<td style="text-align:right;">

0.8261
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.7134
</td>

<td style="text-align:right;">

0.9528
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

0.9872
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5092
</td>

<td style="text-align:right;">

0.8926
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.90170
</td>

<td style="text-align:right;">

0.9244
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

3704
</td>

<td style="text-align:right;">

5789
</td>

<td style="text-align:right;">

63.98342
</td>

<td style="text-align:right;">

0.9912
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

425
</td>

<td style="text-align:right;">

1608
</td>

<td style="text-align:right;">

26.430348
</td>

<td style="text-align:right;">

0.9954
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

11.349957
</td>

<td style="text-align:right;">

0.07802
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

14.559387
</td>

<td style="text-align:right;">

0.06498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

170
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

11.938202
</td>

<td style="text-align:right;">

0.026300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

862
</td>

<td style="text-align:right;">

3259
</td>

<td style="text-align:right;">

26.44983
</td>

<td style="text-align:right;">

0.9148
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1320
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

21.34886
</td>

<td style="text-align:right;">

0.9283
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

637
</td>

<td style="text-align:right;">

10.30244
</td>

<td style="text-align:right;">

0.2718
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1869
</td>

<td style="text-align:right;">

30.22804
</td>

<td style="text-align:right;">

0.8396
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

626
</td>

<td style="text-align:right;">

3964.000
</td>

<td style="text-align:right;">

15.792129
</td>

<td style="text-align:right;">

0.57150
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

371
</td>

<td style="text-align:right;">

991.0000
</td>

<td style="text-align:right;">

37.43693
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

315
</td>

<td style="text-align:right;">

5717
</td>

<td style="text-align:right;">

5.509883
</td>

<td style="text-align:right;">

0.8021
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5981
</td>

<td style="text-align:right;">

6182.998
</td>

<td style="text-align:right;">

96.73300
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

442
</td>

<td style="text-align:right;">

18.57924
</td>

<td style="text-align:right;">

0.8550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

26.615168
</td>

<td style="text-align:right;">

0.9969
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

1424.000
</td>

<td style="text-align:right;">

24.36798
</td>

<td style="text-align:right;">

0.9758
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

394
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

6.3723112
</td>

<td style="text-align:right;">

0.9380
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.856000
</td>

<td style="text-align:right;">

0.8749
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.44070
</td>

<td style="text-align:right;">

0.9070
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

0.9800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8933
</td>

<td style="text-align:right;">

0.9609
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.17410
</td>

<td style="text-align:right;">

0.9549
</td>

<td style="text-align:right;">

12
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

Census Tract 9441, Apache County, Arizona
</td>

<td style="text-align:right;">

13469
</td>

<td style="text-align:right;">

60900
</td>

<td style="text-align:right;">

16162
</td>

<td style="text-align:right;">

46800
</td>

<td style="text-align:right;">

15624.04
</td>

<td style="text-align:right;">

70644
</td>

<td style="text-align:right;">

537.96
</td>

<td style="text-align:right;">

0.0344316
</td>

<td style="text-align:right;">

-23844
</td>

<td style="text-align:right;">

-0.3375234
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

04001944202
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944202
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

1463
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

1814
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

54.47447
</td>

<td style="text-align:right;">

0.9514
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

345
</td>

<td style="text-align:right;">

1024
</td>

<td style="text-align:right;">

33.691406
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

745
</td>

<td style="text-align:right;">

7.785235
</td>

<td style="text-align:right;">

0.013520
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

152
</td>

<td style="text-align:right;">

25.00000
</td>

<td style="text-align:right;">

0.15680
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

96
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

10.702341
</td>

<td style="text-align:right;">

0.011910
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

742
</td>

<td style="text-align:right;">

2041
</td>

<td style="text-align:right;">

36.35473
</td>

<td style="text-align:right;">

0.9351
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1201
</td>

<td style="text-align:right;">

3754
</td>

<td style="text-align:right;">

31.99254
</td>

<td style="text-align:right;">

0.9089
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

10.990991
</td>

<td style="text-align:right;">

0.5201
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

873
</td>

<td style="text-align:right;">

26.21622
</td>

<td style="text-align:right;">

0.5389
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

2986
</td>

<td style="text-align:right;">

19.189551
</td>

<td style="text-align:right;">

0.8002
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

151
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

27.45455
</td>

<td style="text-align:right;">

0.8540
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

173
</td>

<td style="text-align:right;">

3057
</td>

<td style="text-align:right;">

5.659143
</td>

<td style="text-align:right;">

0.7527
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3306
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

99.27928
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1463
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

355
</td>

<td style="text-align:right;">

24.26521
</td>

<td style="text-align:right;">

0.8840
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

12.70903
</td>

<td style="text-align:right;">

0.9435
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

897
</td>

<td style="text-align:right;">

28.651059
</td>

<td style="text-align:right;">

0.9864
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

93
</td>

<td style="text-align:right;">

3330
</td>

<td style="text-align:right;">

2.792793
</td>

<td style="text-align:right;">

0.8680
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.805610
</td>

<td style="text-align:right;">

0.8512
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.4659
</td>

<td style="text-align:right;">

0.8981
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

0.9891
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8345
</td>

<td style="text-align:right;">

0.9589
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.10081
</td>

<td style="text-align:right;">

0.9410
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

1508
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

2113
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

60.25093
</td>

<td style="text-align:right;">

0.9862
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

145
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

13.928914
</td>

<td style="text-align:right;">

0.9605
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

81
</td>

<td style="text-align:right;">

1040
</td>

<td style="text-align:right;">

7.788462
</td>

<td style="text-align:right;">

0.02620
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

169
</td>

<td style="text-align:right;">

15.384615
</td>

<td style="text-align:right;">

0.07170
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

8.850290
</td>

<td style="text-align:right;">

0.008637
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

2250
</td>

<td style="text-align:right;">

17.91111
</td>

<td style="text-align:right;">

0.8195
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

41.54548
</td>

<td style="text-align:right;">

0.9985
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

390
</td>

<td style="text-align:right;">

11.12062
</td>

<td style="text-align:right;">

0.3153
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

974
</td>

<td style="text-align:right;">

27.77303
</td>

<td style="text-align:right;">

0.7446
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

2533.000
</td>

<td style="text-align:right;">

4.500592
</td>

<td style="text-align:right;">

0.01399
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

189
</td>

<td style="text-align:right;">

717.0000
</td>

<td style="text-align:right;">

26.35983
</td>

<td style="text-align:right;">

0.8350
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

389
</td>

<td style="text-align:right;">

3265
</td>

<td style="text-align:right;">

11.914242
</td>

<td style="text-align:right;">

0.9273
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3499
</td>

<td style="text-align:right;">

3507.000
</td>

<td style="text-align:right;">

99.77188
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1508
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

1.7241379
</td>

<td style="text-align:right;">

0.4052
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

434
</td>

<td style="text-align:right;">

28.77984
</td>

<td style="text-align:right;">

0.9188
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

98
</td>

<td style="text-align:right;">

1209
</td>

<td style="text-align:right;">

8.105873
</td>

<td style="text-align:right;">

0.8737
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

146
</td>

<td style="text-align:right;">

1209.000
</td>

<td style="text-align:right;">

12.07610
</td>

<td style="text-align:right;">

0.8761
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3507
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.773337
</td>

<td style="text-align:right;">

0.8552
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.83619
</td>

<td style="text-align:right;">

0.6678
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9983
</td>

<td style="text-align:right;">

0.9941
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2893
</td>

<td style="text-align:right;">

0.8112
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.89713
</td>

<td style="text-align:right;">

0.8589
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

Census Tract 9442.02, Apache County, Arizona
</td>

<td style="text-align:right;">

11741
</td>

<td style="text-align:right;">

53100
</td>

<td style="text-align:right;">

16052
</td>

<td style="text-align:right;">

25400
</td>

<td style="text-align:right;">

13619.56
</td>

<td style="text-align:right;">

61596
</td>

<td style="text-align:right;">

2432.44
</td>

<td style="text-align:right;">

0.1785990
</td>

<td style="text-align:right;">

-36196
</td>

<td style="text-align:right;">

-0.5876356
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

04001944300
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944300
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

4099
</td>

<td style="text-align:right;">

6797
</td>

<td style="text-align:right;">

60.30602
</td>

<td style="text-align:right;">

0.9762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

1777
</td>

<td style="text-align:right;">

22.678672
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

154
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

10.569664
</td>

<td style="text-align:right;">

0.025490
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

17.07317
</td>

<td style="text-align:right;">

0.08684
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

11.883899
</td>

<td style="text-align:right;">

0.015360
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1432
</td>

<td style="text-align:right;">

3367
</td>

<td style="text-align:right;">

42.53044
</td>

<td style="text-align:right;">

0.9623
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2305
</td>

<td style="text-align:right;">

7092
</td>

<td style="text-align:right;">

32.50141
</td>

<td style="text-align:right;">

0.9160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

746
</td>

<td style="text-align:right;">

10.960917
</td>

<td style="text-align:right;">

0.5176
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2767
</td>

<td style="text-align:right;">

40.65530
</td>

<td style="text-align:right;">

0.9761
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

842
</td>

<td style="text-align:right;">

4361
</td>

<td style="text-align:right;">

19.307498
</td>

<td style="text-align:right;">

0.8041
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

30.69647
</td>

<td style="text-align:right;">

0.8982
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

568
</td>

<td style="text-align:right;">

6178
</td>

<td style="text-align:right;">

9.193914
</td>

<td style="text-align:right;">

0.8423
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6750
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

99.17720
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

0.2418380
</td>

<td style="text-align:right;">

0.3113
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

440
</td>

<td style="text-align:right;">

13.30109
</td>

<td style="text-align:right;">

0.7638
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

22.12486
</td>

<td style="text-align:right;">

0.9856
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

388
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

21.248631
</td>

<td style="text-align:right;">

0.9627
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

2.042316
</td>

<td style="text-align:right;">

0.8458
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.855660
</td>

<td style="text-align:right;">

0.8602
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.0383
</td>

<td style="text-align:right;">

0.9844
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

0.9888
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8692
</td>

<td style="text-align:right;">

0.9619
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.75756
</td>

<td style="text-align:right;">

0.9749
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3548
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

59.97295
</td>

<td style="text-align:right;">

0.9854
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

67
</td>

<td style="text-align:right;">

1402
</td>

<td style="text-align:right;">

4.778887
</td>

<td style="text-align:right;">

0.5316
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

251
</td>

<td style="text-align:right;">

1664
</td>

<td style="text-align:right;">

15.084135
</td>

<td style="text-align:right;">

0.20570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

362
</td>

<td style="text-align:right;">

12.707182
</td>

<td style="text-align:right;">

0.05498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

14.659427
</td>

<td style="text-align:right;">

0.056430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

844
</td>

<td style="text-align:right;">

3696
</td>

<td style="text-align:right;">

22.83550
</td>

<td style="text-align:right;">

0.8792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2528
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

42.73158
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

793
</td>

<td style="text-align:right;">

13.39075
</td>

<td style="text-align:right;">

0.4401
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1663
</td>

<td style="text-align:right;">

28.08173
</td>

<td style="text-align:right;">

0.7575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

4258.743
</td>

<td style="text-align:right;">

13.454674
</td>

<td style="text-align:right;">

0.42530
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

1112.2581
</td>

<td style="text-align:right;">

27.06206
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

851
</td>

<td style="text-align:right;">

5568
</td>

<td style="text-align:right;">

15.283764
</td>

<td style="text-align:right;">

0.9575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5880
</td>

<td style="text-align:right;">

5922.449
</td>

<td style="text-align:right;">

99.28326
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

0.7854338
</td>

<td style="text-align:right;">

0.3369
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

521
</td>

<td style="text-align:right;">

18.60050
</td>

<td style="text-align:right;">

0.8557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

267
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

13.178677
</td>

<td style="text-align:right;">

0.9482
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2025.690
</td>

<td style="text-align:right;">

14.66167
</td>

<td style="text-align:right;">

0.9158
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

0.1857481
</td>

<td style="text-align:right;">

0.5222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.451330
</td>

<td style="text-align:right;">

0.7773
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.42780
</td>

<td style="text-align:right;">

0.9008
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

0.9922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5788
</td>

<td style="text-align:right;">

0.9040
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.45433
</td>

<td style="text-align:right;">

0.9088
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

Census Tract 9443, Apache County, Arizona
</td>

<td style="text-align:right;">

11133
</td>

<td style="text-align:right;">

48700
</td>

<td style="text-align:right;">

15051
</td>

<td style="text-align:right;">

53700
</td>

<td style="text-align:right;">

12914.28
</td>

<td style="text-align:right;">

56492
</td>

<td style="text-align:right;">

2136.72
</td>

<td style="text-align:right;">

0.1654541
</td>

<td style="text-align:right;">

-2792
</td>

<td style="text-align:right;">

-0.0494229
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

04001944901
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944901
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3538
</td>

<td style="text-align:right;">

2001
</td>

<td style="text-align:right;">

868
</td>

<td style="text-align:right;">

2034
</td>

<td style="text-align:right;">

3506
</td>

<td style="text-align:right;">

58.01483
</td>

<td style="text-align:right;">

0.9664
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

926
</td>

<td style="text-align:right;">

16.522678
</td>

<td style="text-align:right;">

0.9551
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

68
</td>

<td style="text-align:right;">

621
</td>

<td style="text-align:right;">

10.950081
</td>

<td style="text-align:right;">

0.027230
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

47
</td>

<td style="text-align:right;">

247
</td>

<td style="text-align:right;">

19.02834
</td>

<td style="text-align:right;">

0.10240
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

115
</td>

<td style="text-align:right;">

868
</td>

<td style="text-align:right;">

13.248848
</td>

<td style="text-align:right;">

0.023430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

615
</td>

<td style="text-align:right;">

1757
</td>

<td style="text-align:right;">

35.00285
</td>

<td style="text-align:right;">

0.9280
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3723
</td>

<td style="text-align:right;">

32.33951
</td>

<td style="text-align:right;">

0.9127
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

409
</td>

<td style="text-align:right;">

11.560204
</td>

<td style="text-align:right;">

0.5556
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1406
</td>

<td style="text-align:right;">

39.73997
</td>

<td style="text-align:right;">

0.9672
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

598
</td>

<td style="text-align:right;">

2467
</td>

<td style="text-align:right;">

24.239968
</td>

<td style="text-align:right;">

0.9257
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

181
</td>

<td style="text-align:right;">

629
</td>

<td style="text-align:right;">

28.77583
</td>

<td style="text-align:right;">

0.8759
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

244
</td>

<td style="text-align:right;">

3213
</td>

<td style="text-align:right;">

7.594149
</td>

<td style="text-align:right;">

0.8079
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3491
</td>

<td style="text-align:right;">

3538
</td>

<td style="text-align:right;">

98.67157
</td>

<td style="text-align:right;">

0.9923
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2001
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

269
</td>

<td style="text-align:right;">

13.44328
</td>

<td style="text-align:right;">

0.7659
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

206
</td>

<td style="text-align:right;">

868
</td>

<td style="text-align:right;">

23.73272
</td>

<td style="text-align:right;">

0.9887
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

868
</td>

<td style="text-align:right;">

12.903226
</td>

<td style="text-align:right;">

0.8773
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3538
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.785630
</td>

<td style="text-align:right;">

0.8476
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.1323
</td>

<td style="text-align:right;">

0.9882
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9923
</td>

<td style="text-align:right;">

0.9867
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1800
</td>

<td style="text-align:right;">

0.7807
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

12.09023
</td>

<td style="text-align:right;">

0.9402
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

4008
</td>

<td style="text-align:right;">

1775
</td>

<td style="text-align:right;">

1127
</td>

<td style="text-align:right;">

2545
</td>

<td style="text-align:right;">

4008
</td>

<td style="text-align:right;">

63.49800
</td>

<td style="text-align:right;">

0.9902
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

43
</td>

<td style="text-align:right;">

1000
</td>

<td style="text-align:right;">

4.300000
</td>

<td style="text-align:right;">

0.4727
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

946
</td>

<td style="text-align:right;">

7.399577
</td>

<td style="text-align:right;">

0.02292
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

14
</td>

<td style="text-align:right;">

181
</td>

<td style="text-align:right;">

7.734807
</td>

<td style="text-align:right;">

0.03172
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

84
</td>

<td style="text-align:right;">

1127
</td>

<td style="text-align:right;">

7.453416
</td>

<td style="text-align:right;">

0.005182
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

558
</td>

<td style="text-align:right;">

2312
</td>

<td style="text-align:right;">

24.13495
</td>

<td style="text-align:right;">

0.8942
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

598
</td>

<td style="text-align:right;">

4008
</td>

<td style="text-align:right;">

14.92016
</td>

<td style="text-align:right;">

0.8150
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

446
</td>

<td style="text-align:right;">

11.12774
</td>

<td style="text-align:right;">

0.3160
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1361
</td>

<td style="text-align:right;">

33.95709
</td>

<td style="text-align:right;">

0.9342
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

393
</td>

<td style="text-align:right;">

2647.000
</td>

<td style="text-align:right;">

14.846997
</td>

<td style="text-align:right;">

0.51690
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

276
</td>

<td style="text-align:right;">

723.0000
</td>

<td style="text-align:right;">

38.17427
</td>

<td style="text-align:right;">

0.9599
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

177
</td>

<td style="text-align:right;">

3788
</td>

<td style="text-align:right;">

4.672650
</td>

<td style="text-align:right;">

0.7720
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3957
</td>

<td style="text-align:right;">

4008.000
</td>

<td style="text-align:right;">

98.72754
</td>

<td style="text-align:right;">

0.9920
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1775
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

393
</td>

<td style="text-align:right;">

22.14085
</td>

<td style="text-align:right;">

0.8824
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

234
</td>

<td style="text-align:right;">

1127
</td>

<td style="text-align:right;">

20.763088
</td>

<td style="text-align:right;">

0.9868
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

280
</td>

<td style="text-align:right;">

1127.000
</td>

<td style="text-align:right;">

24.84472
</td>

<td style="text-align:right;">

0.9785
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4008
</td>

<td style="text-align:right;">

0.0249501
</td>

<td style="text-align:right;">

0.4340
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.177282
</td>

<td style="text-align:right;">

0.7088
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.49900
</td>

<td style="text-align:right;">

0.9216
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9920
</td>

<td style="text-align:right;">

0.9878
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4093
</td>

<td style="text-align:right;">

0.8520
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.07758
</td>

<td style="text-align:right;">

0.8758
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

Census Tract 9449.01, Apache County, Arizona
</td>

<td style="text-align:right;">

13033
</td>

<td style="text-align:right;">

60200
</td>

<td style="text-align:right;">

20349
</td>

<td style="text-align:right;">

38200
</td>

<td style="text-align:right;">

15118.28
</td>

<td style="text-align:right;">

69832
</td>

<td style="text-align:right;">

5230.72
</td>

<td style="text-align:right;">

0.3459864
</td>

<td style="text-align:right;">

-31632
</td>

<td style="text-align:right;">

-0.4529728
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

04001944902
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944902
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6532
</td>

<td style="text-align:right;">

2589
</td>

<td style="text-align:right;">

1471
</td>

<td style="text-align:right;">

4250
</td>

<td style="text-align:right;">

6532
</td>

<td style="text-align:right;">

65.06430
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

564
</td>

<td style="text-align:right;">

1838
</td>

<td style="text-align:right;">

30.685528
</td>

<td style="text-align:right;">

0.9971
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

94
</td>

<td style="text-align:right;">

1267
</td>

<td style="text-align:right;">

7.419100
</td>

<td style="text-align:right;">

0.012740
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

204
</td>

<td style="text-align:right;">

18.62745
</td>

<td style="text-align:right;">

0.09853
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1471
</td>

<td style="text-align:right;">

8.973487
</td>

<td style="text-align:right;">

0.007874
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1496
</td>

<td style="text-align:right;">

3893
</td>

<td style="text-align:right;">

38.42795
</td>

<td style="text-align:right;">

0.9450
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1637
</td>

<td style="text-align:right;">

5606
</td>

<td style="text-align:right;">

29.20086
</td>

<td style="text-align:right;">

0.8785
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

751
</td>

<td style="text-align:right;">

11.497244
</td>

<td style="text-align:right;">

0.5527
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1893
</td>

<td style="text-align:right;">

28.98040
</td>

<td style="text-align:right;">

0.6741
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

919
</td>

<td style="text-align:right;">

3843
</td>

<td style="text-align:right;">

23.913609
</td>

<td style="text-align:right;">

0.9204
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

969
</td>

<td style="text-align:right;">

22.39422
</td>

<td style="text-align:right;">

0.7518
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

934
</td>

<td style="text-align:right;">

6035
</td>

<td style="text-align:right;">

15.476388
</td>

<td style="text-align:right;">

0.9216
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6415
</td>

<td style="text-align:right;">

6532
</td>

<td style="text-align:right;">

98.20882
</td>

<td style="text-align:right;">

0.9902
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2589
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

0.2703747
</td>

<td style="text-align:right;">

0.3137
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

13.40286
</td>

<td style="text-align:right;">

0.7654
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1471
</td>

<td style="text-align:right;">

20.66621
</td>

<td style="text-align:right;">

0.9833
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

418
</td>

<td style="text-align:right;">

1471
</td>

<td style="text-align:right;">

28.416044
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

767
</td>

<td style="text-align:right;">

6532
</td>

<td style="text-align:right;">

11.742192
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.812574
</td>

<td style="text-align:right;">

0.8526
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.8206
</td>

<td style="text-align:right;">

0.9657
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9902
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4.0039
</td>

<td style="text-align:right;">

0.9775
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.62727
</td>

<td style="text-align:right;">

0.9703
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

4952
</td>

<td style="text-align:right;">

2210
</td>

<td style="text-align:right;">

1419
</td>

<td style="text-align:right;">

3101
</td>

<td style="text-align:right;">

4952
</td>

<td style="text-align:right;">

62.62116
</td>

<td style="text-align:right;">

0.9887
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

130
</td>

<td style="text-align:right;">

1341
</td>

<td style="text-align:right;">

9.694258
</td>

<td style="text-align:right;">

0.8776
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

128
</td>

<td style="text-align:right;">

1299
</td>

<td style="text-align:right;">

9.853734
</td>

<td style="text-align:right;">

0.04623
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

120
</td>

<td style="text-align:right;">

9.166667
</td>

<td style="text-align:right;">

0.03614
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

1419
</td>

<td style="text-align:right;">

9.795631
</td>

<td style="text-align:right;">

0.011710
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

3361
</td>

<td style="text-align:right;">

22.58256
</td>

<td style="text-align:right;">

0.8769
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

983
</td>

<td style="text-align:right;">

4952
</td>

<td style="text-align:right;">

19.85057
</td>

<td style="text-align:right;">

0.9107
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

15.32714
</td>

<td style="text-align:right;">

0.5379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1115
</td>

<td style="text-align:right;">

22.51616
</td>

<td style="text-align:right;">

0.4881
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

720
</td>

<td style="text-align:right;">

3837.257
</td>

<td style="text-align:right;">

18.763404
</td>

<td style="text-align:right;">

0.72230
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

232
</td>

<td style="text-align:right;">

934.7419
</td>

<td style="text-align:right;">

24.81969
</td>

<td style="text-align:right;">

0.8037
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

342
</td>

<td style="text-align:right;">

4667
</td>

<td style="text-align:right;">

7.328048
</td>

<td style="text-align:right;">

0.8515
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4951.551
</td>

<td style="text-align:right;">

99.26182
</td>

<td style="text-align:right;">

0.9962
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2210
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

18.28054
</td>

<td style="text-align:right;">

0.8519
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

287
</td>

<td style="text-align:right;">

1419
</td>

<td style="text-align:right;">

20.225511
</td>

<td style="text-align:right;">

0.9850
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1419.310
</td>

<td style="text-align:right;">

28.46453
</td>

<td style="text-align:right;">

0.9881
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

4952
</td>

<td style="text-align:right;">

0.5048465
</td>

<td style="text-align:right;">

0.6529
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.665610
</td>

<td style="text-align:right;">

0.8272
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.40350
</td>

<td style="text-align:right;">

0.8950
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9962
</td>

<td style="text-align:right;">

0.9920
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.6055
</td>

<td style="text-align:right;">

0.9109
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.67081
</td>

<td style="text-align:right;">

0.9240
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

Census Tract 9449.02, Apache County, Arizona
</td>

<td style="text-align:right;">

9837
</td>

<td style="text-align:right;">

64500
</td>

<td style="text-align:right;">

17988
</td>

<td style="text-align:right;">

30300
</td>

<td style="text-align:right;">

11410.92
</td>

<td style="text-align:right;">

74820
</td>

<td style="text-align:right;">

6577.08
</td>

<td style="text-align:right;">

0.5763847
</td>

<td style="text-align:right;">

-44520
</td>

<td style="text-align:right;">

-0.5950281
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

04001945001
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

945001
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4746
</td>

<td style="text-align:right;">

1477
</td>

<td style="text-align:right;">

993
</td>

<td style="text-align:right;">

2072
</td>

<td style="text-align:right;">

4523
</td>

<td style="text-align:right;">

45.81030
</td>

<td style="text-align:right;">

0.8983
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1440
</td>

<td style="text-align:right;">

14.583333
</td>

<td style="text-align:right;">

0.9298
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

23
</td>

<td style="text-align:right;">

435
</td>

<td style="text-align:right;">

5.287356
</td>

<td style="text-align:right;">

0.008689
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

203
</td>

<td style="text-align:right;">

558
</td>

<td style="text-align:right;">

36.37993
</td>

<td style="text-align:right;">

0.34020
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

226
</td>

<td style="text-align:right;">

993
</td>

<td style="text-align:right;">

22.759315
</td>

<td style="text-align:right;">

0.129200
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

272
</td>

<td style="text-align:right;">

2249
</td>

<td style="text-align:right;">

12.09426
</td>

<td style="text-align:right;">

0.5906
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1244
</td>

<td style="text-align:right;">

4576
</td>

<td style="text-align:right;">

27.18531
</td>

<td style="text-align:right;">

0.8446
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

195
</td>

<td style="text-align:right;">

4.108723
</td>

<td style="text-align:right;">

0.1071
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1806
</td>

<td style="text-align:right;">

38.05310
</td>

<td style="text-align:right;">

0.9454
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

397
</td>

<td style="text-align:right;">

3289
</td>

<td style="text-align:right;">

12.070538
</td>

<td style="text-align:right;">

0.4212
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

294
</td>

<td style="text-align:right;">

722
</td>

<td style="text-align:right;">

40.72022
</td>

<td style="text-align:right;">

0.9743
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

37
</td>

<td style="text-align:right;">

4167
</td>

<td style="text-align:right;">

0.887929
</td>

<td style="text-align:right;">

0.3569
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4676
</td>

<td style="text-align:right;">

4746
</td>

<td style="text-align:right;">

98.52507
</td>

<td style="text-align:right;">

0.9914
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

365
</td>

<td style="text-align:right;">

24.71225
</td>

<td style="text-align:right;">

0.8873
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

140
</td>

<td style="text-align:right;">

993
</td>

<td style="text-align:right;">

14.09869
</td>

<td style="text-align:right;">

0.9529
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

993
</td>

<td style="text-align:right;">

3.625378
</td>

<td style="text-align:right;">

0.5120
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

271
</td>

<td style="text-align:right;">

4746
</td>

<td style="text-align:right;">

5.710072
</td>

<td style="text-align:right;">

0.9170
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.392500
</td>

<td style="text-align:right;">

0.7522
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

2.8049
</td>

<td style="text-align:right;">

0.6463
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9914
</td>

<td style="text-align:right;">

0.9857
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4218
</td>

<td style="text-align:right;">

0.8668
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.61060
</td>

<td style="text-align:right;">

0.8171
</td>

<td style="text-align:right;">

9
</td>

<td style="text-align:right;">

4085
</td>

<td style="text-align:right;">

1794
</td>

<td style="text-align:right;">

1251
</td>

<td style="text-align:right;">

1170
</td>

<td style="text-align:right;">

3940
</td>

<td style="text-align:right;">

29.69543
</td>

<td style="text-align:right;">

0.7399
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

1640
</td>

<td style="text-align:right;">

3.414634
</td>

<td style="text-align:right;">

0.3522
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

69
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.03679
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

492
</td>

<td style="text-align:right;">

4.471545
</td>

<td style="text-align:right;">

0.02268
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

1251
</td>

<td style="text-align:right;">

7.274181
</td>

<td style="text-align:right;">

0.004990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

364
</td>

<td style="text-align:right;">

2717
</td>

<td style="text-align:right;">

13.39713
</td>

<td style="text-align:right;">

0.7250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

975
</td>

<td style="text-align:right;">

4058
</td>

<td style="text-align:right;">

24.02661
</td>

<td style="text-align:right;">

0.9538
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

476
</td>

<td style="text-align:right;">

11.65239
</td>

<td style="text-align:right;">

0.3461
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1006
</td>

<td style="text-align:right;">

24.62668
</td>

<td style="text-align:right;">

0.5988
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

3059.000
</td>

<td style="text-align:right;">

15.822164
</td>

<td style="text-align:right;">

0.57440
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

185
</td>

<td style="text-align:right;">

787.0000
</td>

<td style="text-align:right;">

23.50699
</td>

<td style="text-align:right;">

0.7766
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

59
</td>

<td style="text-align:right;">

3882
</td>

<td style="text-align:right;">

1.519835
</td>

<td style="text-align:right;">

0.5168
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4012
</td>

<td style="text-align:right;">

4085.000
</td>

<td style="text-align:right;">

98.21297
</td>

<td style="text-align:right;">

0.9902
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1794
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

395
</td>

<td style="text-align:right;">

22.01784
</td>

<td style="text-align:right;">

0.8814
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

182
</td>

<td style="text-align:right;">

1251
</td>

<td style="text-align:right;">

14.548361
</td>

<td style="text-align:right;">

0.9626
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

141
</td>

<td style="text-align:right;">

1251.000
</td>

<td style="text-align:right;">

11.27098
</td>

<td style="text-align:right;">

0.8621
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

77
</td>

<td style="text-align:right;">

4085
</td>

<td style="text-align:right;">

1.8849449
</td>

<td style="text-align:right;">

0.8277
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2.775890
</td>

<td style="text-align:right;">

0.5926
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2.81270
</td>

<td style="text-align:right;">

0.6550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.9902
</td>

<td style="text-align:right;">

0.9861
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.6614
</td>

<td style="text-align:right;">

0.9221
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

10.24019
</td>

<td style="text-align:right;">

0.7910
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

1
</td>

<td style="text-align:right;">

12544000
</td>

<td style="text-align:left;">

\$12,544,000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:left;">

Census Tract 9450.01, Apache County, Arizona
</td>

<td style="text-align:right;">

13049
</td>

<td style="text-align:right;">

50500
</td>

<td style="text-align:right;">

25587
</td>

<td style="text-align:right;">

66700
</td>

<td style="text-align:right;">

15136.84
</td>

<td style="text-align:right;">

58580
</td>

<td style="text-align:right;">

10450.16
</td>

<td style="text-align:right;">

0.6903792
</td>

<td style="text-align:right;">

8120
</td>

<td style="text-align:right;">

0.1386139
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

04001945002
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

945002
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4093
</td>

<td style="text-align:right;">

1831
</td>

<td style="text-align:right;">

1075
</td>

<td style="text-align:right;">

2257
</td>

<td style="text-align:right;">

4093
</td>

<td style="text-align:right;">

55.14293
</td>

<td style="text-align:right;">

0.9553
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

66
</td>

<td style="text-align:right;">

1026
</td>

<td style="text-align:right;">

6.432748
</td>

<td style="text-align:right;">

0.4929
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

140
</td>

<td style="text-align:right;">

968
</td>

<td style="text-align:right;">

14.462810
</td>

<td style="text-align:right;">

0.054450
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

19.62617
</td>

<td style="text-align:right;">

0.10760
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

161
</td>

<td style="text-align:right;">

1075
</td>

<td style="text-align:right;">

14.976744
</td>

<td style="text-align:right;">

0.033030
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

698
</td>

<td style="text-align:right;">

2337
</td>

<td style="text-align:right;">

29.86735
</td>

<td style="text-align:right;">

0.8977
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1357
</td>

<td style="text-align:right;">

4258
</td>

<td style="text-align:right;">

31.86942
</td>

<td style="text-align:right;">

0.9075
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

449
</td>

<td style="text-align:right;">

10.969949
</td>

<td style="text-align:right;">

0.5188
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1355
</td>

<td style="text-align:right;">

33.10530
</td>

<td style="text-align:right;">

0.8284
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

3071
</td>

<td style="text-align:right;">

13.936828
</td>

<td style="text-align:right;">

0.5396
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

173
</td>

<td style="text-align:right;">

677
</td>

<td style="text-align:right;">

25.55391
</td>

<td style="text-align:right;">

0.8189
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

232
</td>

<td style="text-align:right;">

3846
</td>

<td style="text-align:right;">

6.032241
</td>

<td style="text-align:right;">

0.7667
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4083
</td>

<td style="text-align:right;">

4093
</td>

<td style="text-align:right;">

99.75568
</td>

<td style="text-align:right;">

0.9971
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1831
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

333
</td>

<td style="text-align:right;">

18.18678
</td>

<td style="text-align:right;">

0.8305
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

1075
</td>

<td style="text-align:right;">

24.27907
</td>

<td style="text-align:right;">

0.9898
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

292
</td>

<td style="text-align:right;">

1075
</td>

<td style="text-align:right;">

27.162791
</td>

<td style="text-align:right;">

0.9835
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4093
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.286430
</td>

<td style="text-align:right;">

0.7303
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.4724
</td>

<td style="text-align:right;">

0.8998
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9971
</td>

<td style="text-align:right;">

0.9914
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.3519
</td>

<td style="text-align:right;">

0.8430
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.10783
</td>

<td style="text-align:right;">

0.8573
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

4053
</td>

<td style="text-align:right;">

1729
</td>

<td style="text-align:right;">

1156
</td>

<td style="text-align:right;">

2013
</td>

<td style="text-align:right;">

4050
</td>

<td style="text-align:right;">

49.70370
</td>

<td style="text-align:right;">

0.9488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

136
</td>

<td style="text-align:right;">

1268
</td>

<td style="text-align:right;">

10.725552
</td>

<td style="text-align:right;">

0.9064
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

68
</td>

<td style="text-align:right;">

1072
</td>

<td style="text-align:right;">

6.343284
</td>

<td style="text-align:right;">

0.01445
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

9
</td>

<td style="text-align:right;">

84
</td>

<td style="text-align:right;">

10.714286
</td>

<td style="text-align:right;">

0.04296
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

77
</td>

<td style="text-align:right;">

1156
</td>

<td style="text-align:right;">

6.660900
</td>

<td style="text-align:right;">

0.004223
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

607
</td>

<td style="text-align:right;">

2836
</td>

<td style="text-align:right;">

21.40339
</td>

<td style="text-align:right;">

0.8655
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1166
</td>

<td style="text-align:right;">

4053
</td>

<td style="text-align:right;">

28.76881
</td>

<td style="text-align:right;">

0.9803
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

13.57019
</td>

<td style="text-align:right;">

0.4498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

869
</td>

<td style="text-align:right;">

21.44091
</td>

<td style="text-align:right;">

0.4357
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

488
</td>

<td style="text-align:right;">

3184.000
</td>

<td style="text-align:right;">

15.326633
</td>

<td style="text-align:right;">

0.54540
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

224
</td>

<td style="text-align:right;">

763.0000
</td>

<td style="text-align:right;">

29.35780
</td>

<td style="text-align:right;">

0.8826
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

84
</td>

<td style="text-align:right;">

3910
</td>

<td style="text-align:right;">

2.148338
</td>

<td style="text-align:right;">

0.6005
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3971
</td>

<td style="text-align:right;">

4053.000
</td>

<td style="text-align:right;">

97.97681
</td>

<td style="text-align:right;">

0.9885
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1729
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

471
</td>

<td style="text-align:right;">

27.24118
</td>

<td style="text-align:right;">

0.9100
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

280
</td>

<td style="text-align:right;">

1156
</td>

<td style="text-align:right;">

24.221453
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

197
</td>

<td style="text-align:right;">

1156.000
</td>

<td style="text-align:right;">

17.04152
</td>

<td style="text-align:right;">

0.9413
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

4053
</td>

<td style="text-align:right;">

0.1480385
</td>

<td style="text-align:right;">

0.4982
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.705223
</td>

<td style="text-align:right;">

0.8383
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.91400
</td>

<td style="text-align:right;">

0.7057
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.9885
</td>

<td style="text-align:right;">

0.9844
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.4715
</td>

<td style="text-align:right;">

0.8754
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.07922
</td>

<td style="text-align:right;">

0.8760
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

Census Tract 9450.02, Apache County, Arizona
</td>

<td style="text-align:right;">

12308
</td>

<td style="text-align:right;">

56600
</td>

<td style="text-align:right;">

20899
</td>

<td style="text-align:right;">

34700
</td>

<td style="text-align:right;">

14277.28
</td>

<td style="text-align:right;">

65656
</td>

<td style="text-align:right;">

6621.72
</td>

<td style="text-align:right;">

0.4637942
</td>

<td style="text-align:right;">

-30956
</td>

<td style="text-align:right;">

-0.4714878
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

</tbody>

</table>

</div>

*National*

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

# LIHTC Data

*Divisional*

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

04001942600
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

942600
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

1150
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

73.67072
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

8.666667
</td>

<td style="text-align:right;">

0.6866
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

366
</td>

<td style="text-align:right;">

17.759563
</td>

<td style="text-align:right;">

0.10180
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

27.77778
</td>

<td style="text-align:right;">

0.19090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

70
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

18.22917
</td>

<td style="text-align:right;">

0.05781
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

839
</td>

<td style="text-align:right;">

36.11442
</td>

<td style="text-align:right;">

0.9335
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

282
</td>

<td style="text-align:right;">

1578
</td>

<td style="text-align:right;">

17.87072
</td>

<td style="text-align:right;">

0.5921
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

153
</td>

<td style="text-align:right;">

9.801409
</td>

<td style="text-align:right;">

0.449600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

560
</td>

<td style="text-align:right;">

35.874440
</td>

<td style="text-align:right;">

0.90440
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

22.770398
</td>

<td style="text-align:right;">

0.90060
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

107
</td>

<td style="text-align:right;">

332
</td>

<td style="text-align:right;">

32.22892
</td>

<td style="text-align:right;">

0.9163
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

168
</td>

<td style="text-align:right;">

1431
</td>

<td style="text-align:right;">

11.7400419
</td>

<td style="text-align:right;">

0.8831
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

762
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

215
</td>

<td style="text-align:right;">

28.21522
</td>

<td style="text-align:right;">

0.9088
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

117
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

30.468750
</td>

<td style="text-align:right;">

0.9979
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

384
</td>

<td style="text-align:right;">

8.593750
</td>

<td style="text-align:right;">

0.7842
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1561
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.26441
</td>

<td style="text-align:right;">

0.7248
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4.054000
</td>

<td style="text-align:right;">

0.98530
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2390
</td>

<td style="text-align:right;">

0.8004
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.556310
</td>

<td style="text-align:right;">

0.8966
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

930
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

54.35418
</td>

<td style="text-align:right;">

0.9708
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

44
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

9.090909
</td>

<td style="text-align:right;">

0.8539
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

32
</td>

<td style="text-align:right;">

456
</td>

<td style="text-align:right;">

7.017544
</td>

<td style="text-align:right;">

0.02013
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

30.76923
</td>

<td style="text-align:right;">

0.24630
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

7.675906
</td>

<td style="text-align:right;">

0.005758
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

304
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

25.396825
</td>

<td style="text-align:right;">

0.9056
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

686
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

40.093513
</td>

<td style="text-align:right;">

0.9973
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

229
</td>

<td style="text-align:right;">

13.3839860
</td>

<td style="text-align:right;">

0.439700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

20.280538
</td>

<td style="text-align:right;">

0.37880
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

1363.979
</td>

<td style="text-align:right;">

17.962156
</td>

<td style="text-align:right;">

0.6824
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

304.0000
</td>

<td style="text-align:right;">

16.118421
</td>

<td style="text-align:right;">

0.5859
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

1652
</td>

<td style="text-align:right;">

9.3825666
</td>

<td style="text-align:right;">

0.8951
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

1710.980
</td>

<td style="text-align:right;">

100.00115
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

21.0059172
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

83
</td>

<td style="text-align:right;">

469
</td>

<td style="text-align:right;">

17.697228
</td>

<td style="text-align:right;">

0.9774
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

99
</td>

<td style="text-align:right;">

469.0000
</td>

<td style="text-align:right;">

21.108742
</td>

<td style="text-align:right;">

0.96550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1711
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.733358
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.981900
</td>

<td style="text-align:right;">

0.73750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.0000
</td>

<td style="text-align:right;">

0.9958
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.15960
</td>

<td style="text-align:right;">

0.7653
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

10.87486
</td>

<td style="text-align:right;">

0.8573
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

Census Tract 9426, Apache County, Arizona
</td>

<td style="text-align:right;">

10268
</td>

<td style="text-align:right;">

27600
</td>

<td style="text-align:right;">

15822
</td>

<td style="text-align:right;">

45700
</td>

<td style="text-align:right;">

11910.88
</td>

<td style="text-align:right;">

32016
</td>

<td style="text-align:right;">

3911.12
</td>

<td style="text-align:right;">

0.3283653
</td>

<td style="text-align:right;">

13684
</td>

<td style="text-align:right;">

0.4274113
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

04001942700
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

942700
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

2616
</td>

<td style="text-align:right;">

4871
</td>

<td style="text-align:right;">

53.70560
</td>

<td style="text-align:right;">

0.9480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

163
</td>

<td style="text-align:right;">

1398
</td>

<td style="text-align:right;">

11.659514
</td>

<td style="text-align:right;">

0.8577
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

1113
</td>

<td style="text-align:right;">

9.164421
</td>

<td style="text-align:right;">

0.01757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

178
</td>

<td style="text-align:right;">

30.33708
</td>

<td style="text-align:right;">

0.22790
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

156
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

12.08366
</td>

<td style="text-align:right;">

0.01652
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1039
</td>

<td style="text-align:right;">

2931
</td>

<td style="text-align:right;">

35.44865
</td>

<td style="text-align:right;">

0.9303
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1873
</td>

<td style="text-align:right;">

5249
</td>

<td style="text-align:right;">

35.68299
</td>

<td style="text-align:right;">

0.9436
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

688
</td>

<td style="text-align:right;">

14.081048
</td>

<td style="text-align:right;">

0.687000
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1530
</td>

<td style="text-align:right;">

31.313958
</td>

<td style="text-align:right;">

0.77180
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

772
</td>

<td style="text-align:right;">

3514
</td>

<td style="text-align:right;">

21.969266
</td>

<td style="text-align:right;">

0.88390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

246
</td>

<td style="text-align:right;">

939
</td>

<td style="text-align:right;">

26.19808
</td>

<td style="text-align:right;">

0.8308
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

592
</td>

<td style="text-align:right;">

4631
</td>

<td style="text-align:right;">

12.7834161
</td>

<td style="text-align:right;">

0.8975
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4846
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

99.18133
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2757
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

13.38411
</td>

<td style="text-align:right;">

0.7652
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

240
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

18.590240
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

188
</td>

<td style="text-align:right;">

1291
</td>

<td style="text-align:right;">

14.562355
</td>

<td style="text-align:right;">

0.9015
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4886
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.69612
</td>

<td style="text-align:right;">

0.8288
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.071000
</td>

<td style="text-align:right;">

0.98700
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9890
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.1904
</td>

<td style="text-align:right;">

0.7848
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.952120
</td>

<td style="text-align:right;">

0.9295
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

2784
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

50.90510
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

358
</td>

<td style="text-align:right;">

1642
</td>

<td style="text-align:right;">

21.802680
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

1151
</td>

<td style="text-align:right;">

9.904431
</td>

<td style="text-align:right;">

0.04797
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

58
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

18.64952
</td>

<td style="text-align:right;">

0.09477
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

172
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

11.764706
</td>

<td style="text-align:right;">

0.023990
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

852
</td>

<td style="text-align:right;">

3274
</td>

<td style="text-align:right;">

26.023213
</td>

<td style="text-align:right;">

0.9120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1856
</td>

<td style="text-align:right;">

5466
</td>

<td style="text-align:right;">

33.955360
</td>

<td style="text-align:right;">

0.9919
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

13.8782227
</td>

<td style="text-align:right;">

0.465700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1555
</td>

<td style="text-align:right;">

28.432986
</td>

<td style="text-align:right;">

0.77390
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

706
</td>

<td style="text-align:right;">

3911.002
</td>

<td style="text-align:right;">

18.051640
</td>

<td style="text-align:right;">

0.6872
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1035.0004
</td>

<td style="text-align:right;">

24.830908
</td>

<td style="text-align:right;">

0.8039
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

396
</td>

<td style="text-align:right;">

5078
</td>

<td style="text-align:right;">

7.7983458
</td>

<td style="text-align:right;">

0.8624
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5420
</td>

<td style="text-align:right;">

5469.002
</td>

<td style="text-align:right;">

99.10401
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

400
</td>

<td style="text-align:right;">

18.0018002
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

238
</td>

<td style="text-align:right;">

1462
</td>

<td style="text-align:right;">

16.279070
</td>

<td style="text-align:right;">

0.9710
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

175
</td>

<td style="text-align:right;">

1462.0007
</td>

<td style="text-align:right;">

11.969898
</td>

<td style="text-align:right;">

0.87420
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

5469
</td>

<td style="text-align:right;">

0.4754068
</td>

<td style="text-align:right;">

0.6430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.876090
</td>

<td style="text-align:right;">

0.8796
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.593100
</td>

<td style="text-align:right;">

0.94210
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

0.9905
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.46460
</td>

<td style="text-align:right;">

0.8721
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.92839
</td>

<td style="text-align:right;">

0.9425
</td>

<td style="text-align:right;">

11
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

Census Tract 9427, Apache County, Arizona
</td>

<td style="text-align:right;">

14348
</td>

<td style="text-align:right;">

55900
</td>

<td style="text-align:right;">

18740
</td>

<td style="text-align:right;">

47200
</td>

<td style="text-align:right;">

16643.68
</td>

<td style="text-align:right;">

64844
</td>

<td style="text-align:right;">

2096.32
</td>

<td style="text-align:right;">

0.1259529
</td>

<td style="text-align:right;">

-17644
</td>

<td style="text-align:right;">

-0.2720992
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

04001944100
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944100
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

3251
</td>

<td style="text-align:right;">

4968
</td>

<td style="text-align:right;">

65.43881
</td>

<td style="text-align:right;">

0.9846
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

210
</td>

<td style="text-align:right;">

1254
</td>

<td style="text-align:right;">

16.746412
</td>

<td style="text-align:right;">

0.9576
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

122
</td>

<td style="text-align:right;">

905
</td>

<td style="text-align:right;">

13.480663
</td>

<td style="text-align:right;">

0.04383
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

91
</td>

<td style="text-align:right;">

299
</td>

<td style="text-align:right;">

30.43478
</td>

<td style="text-align:right;">

0.22960
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

213
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.69103
</td>

<td style="text-align:right;">

0.05320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

779
</td>

<td style="text-align:right;">

2325
</td>

<td style="text-align:right;">

33.50538
</td>

<td style="text-align:right;">

0.9203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1293
</td>

<td style="text-align:right;">

5511
</td>

<td style="text-align:right;">

23.46217
</td>

<td style="text-align:right;">

0.7705
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

344
</td>

<td style="text-align:right;">

6.914573
</td>

<td style="text-align:right;">

0.270100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1993
</td>

<td style="text-align:right;">

40.060302
</td>

<td style="text-align:right;">

0.97010
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

577
</td>

<td style="text-align:right;">

3087
</td>

<td style="text-align:right;">

18.691286
</td>

<td style="text-align:right;">

0.77990
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

278
</td>

<td style="text-align:right;">

893
</td>

<td style="text-align:right;">

31.13102
</td>

<td style="text-align:right;">

0.9038
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

308
</td>

<td style="text-align:right;">

4470
</td>

<td style="text-align:right;">

6.8903803
</td>

<td style="text-align:right;">

0.7895
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4915
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

98.79397
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2485
</td>

<td style="text-align:right;">

21
</td>

<td style="text-align:right;">

0.8450704
</td>

<td style="text-align:right;">

0.3700
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

428
</td>

<td style="text-align:right;">

17.22334
</td>

<td style="text-align:right;">

0.8203
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

257
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

21.345515
</td>

<td style="text-align:right;">

0.9843
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

212
</td>

<td style="text-align:right;">

1204
</td>

<td style="text-align:right;">

17.607973
</td>

<td style="text-align:right;">

0.9391
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4975
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.68620
</td>

<td style="text-align:right;">

0.8261
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.713400
</td>

<td style="text-align:right;">

0.95280
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9929
</td>

<td style="text-align:right;">

0.9872
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.5092
</td>

<td style="text-align:right;">

0.8926
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.901700
</td>

<td style="text-align:right;">

0.9244
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

3704
</td>

<td style="text-align:right;">

5789
</td>

<td style="text-align:right;">

63.98342
</td>

<td style="text-align:right;">

0.9912
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

425
</td>

<td style="text-align:right;">

1608
</td>

<td style="text-align:right;">

26.430348
</td>

<td style="text-align:right;">

0.9954
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

11.349957
</td>

<td style="text-align:right;">

0.07802
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

38
</td>

<td style="text-align:right;">

261
</td>

<td style="text-align:right;">

14.55939
</td>

<td style="text-align:right;">

0.06498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

170
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

11.938202
</td>

<td style="text-align:right;">

0.026300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

862
</td>

<td style="text-align:right;">

3259
</td>

<td style="text-align:right;">

26.449831
</td>

<td style="text-align:right;">

0.9148
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1320
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

21.348860
</td>

<td style="text-align:right;">

0.9283
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

637
</td>

<td style="text-align:right;">

10.3024422
</td>

<td style="text-align:right;">

0.271800
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1869
</td>

<td style="text-align:right;">

30.228045
</td>

<td style="text-align:right;">

0.83960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

626
</td>

<td style="text-align:right;">

3964.000
</td>

<td style="text-align:right;">

15.792129
</td>

<td style="text-align:right;">

0.5715
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

371
</td>

<td style="text-align:right;">

991.0000
</td>

<td style="text-align:right;">

37.436932
</td>

<td style="text-align:right;">

0.9557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

315
</td>

<td style="text-align:right;">

5717
</td>

<td style="text-align:right;">

5.5098828
</td>

<td style="text-align:right;">

0.8021
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5981
</td>

<td style="text-align:right;">

6182.998
</td>

<td style="text-align:right;">

96.73300
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

442
</td>

<td style="text-align:right;">

18.5792350
</td>

<td style="text-align:right;">

0.8550
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

379
</td>

<td style="text-align:right;">

1424
</td>

<td style="text-align:right;">

26.615168
</td>

<td style="text-align:right;">

0.9969
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

347
</td>

<td style="text-align:right;">

1424.0000
</td>

<td style="text-align:right;">

24.367977
</td>

<td style="text-align:right;">

0.97580
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

394
</td>

<td style="text-align:right;">

6183
</td>

<td style="text-align:right;">

6.3723112
</td>

<td style="text-align:right;">

0.9380
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.856000
</td>

<td style="text-align:right;">

0.8749
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.440700
</td>

<td style="text-align:right;">

0.90700
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9841
</td>

<td style="text-align:right;">

0.9800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.89330
</td>

<td style="text-align:right;">

0.9609
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.17410
</td>

<td style="text-align:right;">

0.9549
</td>

<td style="text-align:right;">

12
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

Census Tract 9441, Apache County, Arizona
</td>

<td style="text-align:right;">

13469
</td>

<td style="text-align:right;">

60900
</td>

<td style="text-align:right;">

16162
</td>

<td style="text-align:right;">

46800
</td>

<td style="text-align:right;">

15624.04
</td>

<td style="text-align:right;">

70644
</td>

<td style="text-align:right;">

537.96
</td>

<td style="text-align:right;">

0.0344316
</td>

<td style="text-align:right;">

-23844
</td>

<td style="text-align:right;">

-0.3375234
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

04001944300
</td>

<td style="text-align:left;">

04001
</td>

<td style="text-align:left;">

944300
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Apache County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

4099
</td>

<td style="text-align:right;">

6797
</td>

<td style="text-align:right;">

60.30602
</td>

<td style="text-align:right;">

0.9762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

403
</td>

<td style="text-align:right;">

1777
</td>

<td style="text-align:right;">

22.678672
</td>

<td style="text-align:right;">

0.9858
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

154
</td>

<td style="text-align:right;">

1457
</td>

<td style="text-align:right;">

10.569664
</td>

<td style="text-align:right;">

0.02549
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:right;">

369
</td>

<td style="text-align:right;">

17.07317
</td>

<td style="text-align:right;">

0.08684
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

217
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

11.88390
</td>

<td style="text-align:right;">

0.01536
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1432
</td>

<td style="text-align:right;">

3367
</td>

<td style="text-align:right;">

42.53044
</td>

<td style="text-align:right;">

0.9623
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2305
</td>

<td style="text-align:right;">

7092
</td>

<td style="text-align:right;">

32.50141
</td>

<td style="text-align:right;">

0.9160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

746
</td>

<td style="text-align:right;">

10.960917
</td>

<td style="text-align:right;">

0.517600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2767
</td>

<td style="text-align:right;">

40.655304
</td>

<td style="text-align:right;">

0.97610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

842
</td>

<td style="text-align:right;">

4361
</td>

<td style="text-align:right;">

19.307498
</td>

<td style="text-align:right;">

0.80410
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1163
</td>

<td style="text-align:right;">

30.69647
</td>

<td style="text-align:right;">

0.8982
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

568
</td>

<td style="text-align:right;">

6178
</td>

<td style="text-align:right;">

9.1939139
</td>

<td style="text-align:right;">

0.8423
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

6750
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

99.17720
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3308
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

0.2418380
</td>

<td style="text-align:right;">

0.3113
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

440
</td>

<td style="text-align:right;">

13.30109
</td>

<td style="text-align:right;">

0.7638
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

404
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

22.124863
</td>

<td style="text-align:right;">

0.9856
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

388
</td>

<td style="text-align:right;">

1826
</td>

<td style="text-align:right;">

21.248631
</td>

<td style="text-align:right;">

0.9627
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

139
</td>

<td style="text-align:right;">

6806
</td>

<td style="text-align:right;">

2.042316
</td>

<td style="text-align:right;">

0.8458
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.85566
</td>

<td style="text-align:right;">

0.8602
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4.038300
</td>

<td style="text-align:right;">

0.98440
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

0.9944
</td>

<td style="text-align:right;">

0.9888
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.8692
</td>

<td style="text-align:right;">

0.9619
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12.757560
</td>

<td style="text-align:right;">

0.9749
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3548
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

59.97295
</td>

<td style="text-align:right;">

0.9854
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

67
</td>

<td style="text-align:right;">

1402
</td>

<td style="text-align:right;">

4.778887
</td>

<td style="text-align:right;">

0.5316
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

251
</td>

<td style="text-align:right;">

1664
</td>

<td style="text-align:right;">

15.084135
</td>

<td style="text-align:right;">

0.20570
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

362
</td>

<td style="text-align:right;">

12.70718
</td>

<td style="text-align:right;">

0.05498
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

14.659427
</td>

<td style="text-align:right;">

0.056430
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

844
</td>

<td style="text-align:right;">

3696
</td>

<td style="text-align:right;">

22.835498
</td>

<td style="text-align:right;">

0.8792
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2528
</td>

<td style="text-align:right;">

5916
</td>

<td style="text-align:right;">

42.731575
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

793
</td>

<td style="text-align:right;">

13.3907464
</td>

<td style="text-align:right;">

0.440100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1663
</td>

<td style="text-align:right;">

28.081729
</td>

<td style="text-align:right;">

0.75750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

573
</td>

<td style="text-align:right;">

4258.743
</td>

<td style="text-align:right;">

13.454674
</td>

<td style="text-align:right;">

0.4253
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

1112.2581
</td>

<td style="text-align:right;">

27.062064
</td>

<td style="text-align:right;">

0.8474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

851
</td>

<td style="text-align:right;">

5568
</td>

<td style="text-align:right;">

15.2837644
</td>

<td style="text-align:right;">

0.9575
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5880
</td>

<td style="text-align:right;">

5922.449
</td>

<td style="text-align:right;">

99.28326
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2801
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

0.7854338
</td>

<td style="text-align:right;">

0.3369
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

521
</td>

<td style="text-align:right;">

18.6004998
</td>

<td style="text-align:right;">

0.8557
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

267
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

13.178677
</td>

<td style="text-align:right;">

0.9482
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

297
</td>

<td style="text-align:right;">

2025.6898
</td>

<td style="text-align:right;">

14.661672
</td>

<td style="text-align:right;">

0.91580
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5922
</td>

<td style="text-align:right;">

0.1857481
</td>

<td style="text-align:right;">

0.5222
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.451330
</td>

<td style="text-align:right;">

0.7773
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.427800
</td>

<td style="text-align:right;">

0.90080
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9964
</td>

<td style="text-align:right;">

0.9922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.57880
</td>

<td style="text-align:right;">

0.9040
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.45433
</td>

<td style="text-align:right;">

0.9088
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

Census Tract 9443, Apache County, Arizona
</td>

<td style="text-align:right;">

11133
</td>

<td style="text-align:right;">

48700
</td>

<td style="text-align:right;">

15051
</td>

<td style="text-align:right;">

53700
</td>

<td style="text-align:right;">

12914.28
</td>

<td style="text-align:right;">

56492
</td>

<td style="text-align:right;">

2136.72
</td>

<td style="text-align:right;">

0.1654541
</td>

<td style="text-align:right;">

-2792
</td>

<td style="text-align:right;">

-0.0494229
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

04005000800
</td>

<td style="text-align:left;">

04005
</td>

<td style="text-align:left;">

000800
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

1511
</td>

<td style="text-align:right;">

2859
</td>

<td style="text-align:right;">

52.85065
</td>

<td style="text-align:right;">

0.9430
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1952
</td>

<td style="text-align:right;">

2.766393
</td>

<td style="text-align:right;">

0.1150
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

71
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

36.979167
</td>

<td style="text-align:right;">

0.73370
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

509
</td>

<td style="text-align:right;">

865
</td>

<td style="text-align:right;">

58.84393
</td>

<td style="text-align:right;">

0.83080
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

580
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

54.87228
</td>

<td style="text-align:right;">

0.96160
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

265
</td>

<td style="text-align:right;">

1897
</td>

<td style="text-align:right;">

13.96943
</td>

<td style="text-align:right;">

0.6489
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

995
</td>

<td style="text-align:right;">

3589
</td>

<td style="text-align:right;">

27.72360
</td>

<td style="text-align:right;">

0.8536
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

121
</td>

<td style="text-align:right;">

3.093047
</td>

<td style="text-align:right;">

0.062070
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

208
</td>

<td style="text-align:right;">

5.316973
</td>

<td style="text-align:right;">

0.02835
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

248
</td>

<td style="text-align:right;">

3170
</td>

<td style="text-align:right;">

7.823344
</td>

<td style="text-align:right;">

0.15510
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

53
</td>

<td style="text-align:right;">

311
</td>

<td style="text-align:right;">

17.04180
</td>

<td style="text-align:right;">

0.5919
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

3898
</td>

<td style="text-align:right;">

0.6670087
</td>

<td style="text-align:right;">

0.3063
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1410
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

36.04294
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1200
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

12.9166667
</td>

<td style="text-align:right;">

0.7329
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.25000
</td>

<td style="text-align:right;">

0.3706
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

31
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

2.932829
</td>

<td style="text-align:right;">

0.6261
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

1057
</td>

<td style="text-align:right;">

3.122044
</td>

<td style="text-align:right;">

0.4682
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1043
</td>

<td style="text-align:right;">

3912
</td>

<td style="text-align:right;">

26.661554
</td>

<td style="text-align:right;">

0.9826
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.52210
</td>

<td style="text-align:right;">

0.7887
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.143720
</td>

<td style="text-align:right;">

0.02019
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6285
</td>

<td style="text-align:right;">

0.6250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.1804
</td>

<td style="text-align:right;">

0.7810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8.474720
</td>

<td style="text-align:right;">

0.5850
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

3238
</td>

<td style="text-align:right;">

5850
</td>

<td style="text-align:right;">

55.35043
</td>

<td style="text-align:right;">

0.9741
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

399
</td>

<td style="text-align:right;">

3753
</td>

<td style="text-align:right;">

10.631495
</td>

<td style="text-align:right;">

0.9047
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

43
</td>

<td style="text-align:right;">

312
</td>

<td style="text-align:right;">

13.782051
</td>

<td style="text-align:right;">

0.15050
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1188
</td>

<td style="text-align:right;">

1850
</td>

<td style="text-align:right;">

64.21622
</td>

<td style="text-align:right;">

0.93540
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1231
</td>

<td style="text-align:right;">

2162
</td>

<td style="text-align:right;">

56.938020
</td>

<td style="text-align:right;">

0.988900
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

364
</td>

<td style="text-align:right;">

2823
</td>

<td style="text-align:right;">

12.894084
</td>

<td style="text-align:right;">

0.7116
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

5900
</td>

<td style="text-align:right;">

8.101695
</td>

<td style="text-align:right;">

0.4937
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

262
</td>

<td style="text-align:right;">

4.0759179
</td>

<td style="text-align:right;">

0.030250
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

634
</td>

<td style="text-align:right;">

9.863099
</td>

<td style="text-align:right;">

0.06202
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

497
</td>

<td style="text-align:right;">

5227.333
</td>

<td style="text-align:right;">

9.507716
</td>

<td style="text-align:right;">

0.1782
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

112
</td>

<td style="text-align:right;">

544.6422
</td>

<td style="text-align:right;">

20.563958
</td>

<td style="text-align:right;">

0.7139
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

6207
</td>

<td style="text-align:right;">

0.9022072
</td>

<td style="text-align:right;">

0.4074
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2862
</td>

<td style="text-align:right;">

6428.175
</td>

<td style="text-align:right;">

44.52274
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2343
</td>

<td style="text-align:right;">

838
</td>

<td style="text-align:right;">

35.7661118
</td>

<td style="text-align:right;">

0.9165
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

0.4694836
</td>

<td style="text-align:right;">

0.4053
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

116
</td>

<td style="text-align:right;">

2163
</td>

<td style="text-align:right;">

5.362922
</td>

<td style="text-align:right;">

0.7808
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

166
</td>

<td style="text-align:right;">

2162.6681
</td>

<td style="text-align:right;">

7.675704
</td>

<td style="text-align:right;">

0.76580
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

759
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

11.8077162
</td>

<td style="text-align:right;">

0.9625
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4.073000
</td>

<td style="text-align:right;">

0.9190
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.391770
</td>

<td style="text-align:right;">

0.04857
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.6490
</td>

<td style="text-align:right;">

0.6463
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.83090
</td>

<td style="text-align:right;">

0.9524
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

9.94467
</td>

<td style="text-align:right;">

0.7611
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

Census Tract 8, Coconino County, Arizona
</td>

<td style="text-align:right;">

8201
</td>

<td style="text-align:right;">

236500
</td>

<td style="text-align:right;">

14117
</td>

<td style="text-align:right;">

292500
</td>

<td style="text-align:right;">

9513.16
</td>

<td style="text-align:right;">

274340
</td>

<td style="text-align:right;">

4603.84
</td>

<td style="text-align:right;">

0.4839443
</td>

<td style="text-align:right;">

18160
</td>

<td style="text-align:right;">

0.0661952
</td>

<td style="text-align:right;">

151.60
</td>

<td style="text-align:right;">

249.17
</td>

<td style="text-align:left;">

Coconino County, Arizona
</td>

<td style="text-align:left;">

Flagstaff, AZ MSA
</td>

<td style="text-align:left;">

C2238
</td>

</tr>

<tr>

<td style="text-align:left;">

04005001000
</td>

<td style="text-align:left;">

04005
</td>

<td style="text-align:left;">

001000
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Coconino County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1197
</td>

<td style="text-align:right;">

1744
</td>

<td style="text-align:right;">

68.63532
</td>

<td style="text-align:right;">

0.9894
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1067
</td>

<td style="text-align:right;">

4202
</td>

<td style="text-align:right;">

25.392670
</td>

<td style="text-align:right;">

0.9925
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

68.000000
</td>

<td style="text-align:right;">

0.99610
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

484
</td>

<td style="text-align:right;">

738
</td>

<td style="text-align:right;">

65.58266
</td>

<td style="text-align:right;">

0.91810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

501
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

65.66186
</td>

<td style="text-align:right;">

0.99650
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

47
</td>

<td style="text-align:right;">

886
</td>

<td style="text-align:right;">

5.30474
</td>

<td style="text-align:right;">

0.2676
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1429
</td>

<td style="text-align:right;">

8331
</td>

<td style="text-align:right;">

17.15280
</td>

<td style="text-align:right;">

0.5641
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

0.003736
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

310
</td>

<td style="text-align:right;">

4.122889
</td>

<td style="text-align:right;">

0.02165
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

54
</td>

<td style="text-align:right;">

1560
</td>

<td style="text-align:right;">

3.461539
</td>

<td style="text-align:right;">

0.01727
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

23
</td>

<td style="text-align:right;">

174
</td>

<td style="text-align:right;">

13.21839
</td>

<td style="text-align:right;">

0.4495
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

233
</td>

<td style="text-align:right;">

7411
</td>

<td style="text-align:right;">

3.1439752
</td>

<td style="text-align:right;">

0.6314
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2495
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

33.18260
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

863
</td>

<td style="text-align:right;">

441
</td>

<td style="text-align:right;">

51.1008111
</td>

<td style="text-align:right;">

0.9666
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

4.05562
</td>

<td style="text-align:right;">

0.6079
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

14
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

1.834862
</td>

<td style="text-align:right;">

0.4856
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

119
</td>

<td style="text-align:right;">

763
</td>

<td style="text-align:right;">

15.596330
</td>

<td style="text-align:right;">

0.9127
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

5775
</td>

<td style="text-align:right;">

7519
</td>

<td style="text-align:right;">

76.805426
</td>

<td style="text-align:right;">

0.9946
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.81010
</td>

<td style="text-align:right;">

0.8520
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.123556
</td>

<td style="text-align:right;">

0.01848
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.5941
</td>

<td style="text-align:right;">

0.5907
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.9674
</td>

<td style="text-align:right;">

0.9733
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

9.495156
</td>

<td style="text-align:right;">

0.7036
</td>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

1056
</td>

<td style="text-align:right;">

1313
</td>

<td style="text-align:right;">

80.42650
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1353
</td>

<td style="text-align:right;">

6344
</td>

<td style="text-align:right;">

21.327238
</td>

<td style="text-align:right;">

0.9918
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

62.857143
</td>

<td style="text-align:right;">

0.99810
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

500
</td>

<td style="text-align:right;">

641
</td>

<td style="text-align:right;">

78.00312
</td>

<td style="text-align:right;">

0.99310
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

522
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

77.218935
</td>

<td style="text-align:right;">

0.999600
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

29
</td>

<td style="text-align:right;">

460
</td>

<td style="text-align:right;">

6.304348
</td>

<td style="text-align:right;">

0.4346
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1051
</td>

<td style="text-align:right;">

13483
</td>

<td style="text-align:right;">

7.795001
</td>

<td style="text-align:right;">

0.4716
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

17
</td>

<td style="text-align:right;">

0.1259353
</td>

<td style="text-align:right;">

0.004211
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

221
</td>

<td style="text-align:right;">

1.637158
</td>

<td style="text-align:right;">

0.01474
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

125
</td>

<td style="text-align:right;">

1282.667
</td>

<td style="text-align:right;">

9.745322
</td>

<td style="text-align:right;">

0.1874
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

42
</td>

<td style="text-align:right;">

114.3578
</td>

<td style="text-align:right;">

36.726848
</td>

<td style="text-align:right;">

0.9505
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

207
</td>

<td style="text-align:right;">

13491
</td>

<td style="text-align:right;">

1.5343562
</td>

<td style="text-align:right;">

0.5203
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4803
</td>

<td style="text-align:right;">

13498.825
</td>

<td style="text-align:right;">

35.58088
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

815
</td>

<td style="text-align:right;">

550
</td>

<td style="text-align:right;">

67.4846626
</td>

<td style="text-align:right;">

0.9864
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

0.8588957
</td>

<td style="text-align:right;">

0.4653
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

62
</td>

<td style="text-align:right;">

675
</td>

<td style="text-align:right;">

9.185185
</td>

<td style="text-align:right;">

0.8933
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

134
</td>

<td style="text-align:right;">

675.3319
</td>

<td style="text-align:right;">

19.842095
</td>

<td style="text-align:right;">

0.96070
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12185
</td>

<td style="text-align:right;">

13499
</td>

<td style="text-align:right;">

90.2659456
</td>

<td style="text-align:right;">

0.9960
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.896300
</td>

<td style="text-align:right;">

0.8850
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.677151
</td>

<td style="text-align:right;">

0.11070
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.5539
</td>

<td style="text-align:right;">

0.5516
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4.30170
</td>

<td style="text-align:right;">

0.9882
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

10.42905
</td>

<td style="text-align:right;">

0.8107
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

Census Tract 10, Coconino County, Arizona
</td>

<td style="text-align:right;">

4710
</td>

<td style="text-align:right;">

118400
</td>

<td style="text-align:right;">

4039
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:right;">

5463.60
</td>

<td style="text-align:right;">

137344
</td>

<td style="text-align:right;">

-1424.60
</td>

<td style="text-align:right;">

-0.2607438
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

Coconino County, Arizona
</td>

<td style="text-align:left;">

Flagstaff, AZ MSA
</td>

<td style="text-align:left;">

C2238
</td>

</tr>

<tr>

<td style="text-align:left;">

04007940200
</td>

<td style="text-align:left;">

04007
</td>

<td style="text-align:left;">

940200
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Gila County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

760
</td>

<td style="text-align:right;">

380
</td>

<td style="text-align:right;">

198
</td>

<td style="text-align:right;">

599
</td>

<td style="text-align:right;">

760
</td>

<td style="text-align:right;">

78.81579
</td>

<td style="text-align:right;">

0.9971
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

14
</td>

<td style="text-align:right;">

202
</td>

<td style="text-align:right;">

6.930693
</td>

<td style="text-align:right;">

0.5411
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

130
</td>

<td style="text-align:right;">

43.076923
</td>

<td style="text-align:right;">

0.87120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

68
</td>

<td style="text-align:right;">

17.64706
</td>

<td style="text-align:right;">

0.09167
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

68
</td>

<td style="text-align:right;">

198
</td>

<td style="text-align:right;">

34.34343
</td>

<td style="text-align:right;">

0.48740
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

386
</td>

<td style="text-align:right;">

36.78756
</td>

<td style="text-align:right;">

0.9383
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

494
</td>

<td style="text-align:right;">

1394
</td>

<td style="text-align:right;">

35.43759
</td>

<td style="text-align:right;">

0.9419
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

39
</td>

<td style="text-align:right;">

5.131579
</td>

<td style="text-align:right;">

0.165100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

294
</td>

<td style="text-align:right;">

38.684210
</td>

<td style="text-align:right;">

0.95480
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

245
</td>

<td style="text-align:right;">

807
</td>

<td style="text-align:right;">

30.359356
</td>

<td style="text-align:right;">

0.98120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

33
</td>

<td style="text-align:right;">

141
</td>

<td style="text-align:right;">

23.40426
</td>

<td style="text-align:right;">

0.7730
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

36
</td>

<td style="text-align:right;">

676
</td>

<td style="text-align:right;">

5.3254438
</td>

<td style="text-align:right;">

0.7379
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

760
</td>

<td style="text-align:right;">

760
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

380
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

55
</td>

<td style="text-align:right;">

14.47368
</td>

<td style="text-align:right;">

0.7834
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

198
</td>

<td style="text-align:right;">

6.060606
</td>

<td style="text-align:right;">

0.8228
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

31
</td>

<td style="text-align:right;">

198
</td>

<td style="text-align:right;">

15.656566
</td>

<td style="text-align:right;">

0.9136
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

760
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.90580
</td>

<td style="text-align:right;">

0.8699
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.612000
</td>

<td style="text-align:right;">

0.93710
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.0679
</td>

<td style="text-align:right;">

0.7370
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.584600
</td>

<td style="text-align:right;">

0.8992
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

2341
</td>

<td style="text-align:right;">

555
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

1464
</td>

<td style="text-align:right;">

2332
</td>

<td style="text-align:right;">

62.77873
</td>

<td style="text-align:right;">

0.9891
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

103
</td>

<td style="text-align:right;">

582
</td>

<td style="text-align:right;">

17.697595
</td>

<td style="text-align:right;">

0.9847
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

28
</td>

<td style="text-align:right;">

301
</td>

<td style="text-align:right;">

9.302326
</td>

<td style="text-align:right;">

0.03891
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

31
</td>

<td style="text-align:right;">

177
</td>

<td style="text-align:right;">

17.51412
</td>

<td style="text-align:right;">

0.08439
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

59
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

12.343096
</td>

<td style="text-align:right;">

0.031290
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

364
</td>

<td style="text-align:right;">

1073
</td>

<td style="text-align:right;">

33.923579
</td>

<td style="text-align:right;">

0.9585
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

300
</td>

<td style="text-align:right;">

2341
</td>

<td style="text-align:right;">

12.815036
</td>

<td style="text-align:right;">

0.7377
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

149
</td>

<td style="text-align:right;">

6.3648014
</td>

<td style="text-align:right;">

0.087670
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1122
</td>

<td style="text-align:right;">

47.928236
</td>

<td style="text-align:right;">

0.99900
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

1219.000
</td>

<td style="text-align:right;">

24.856440
</td>

<td style="text-align:right;">

0.9002
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

133
</td>

<td style="text-align:right;">

395.0000
</td>

<td style="text-align:right;">

33.670886
</td>

<td style="text-align:right;">

0.9294
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

27
</td>

<td style="text-align:right;">

2020
</td>

<td style="text-align:right;">

1.3366337
</td>

<td style="text-align:right;">

0.4895
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2321
</td>

<td style="text-align:right;">

2341.000
</td>

<td style="text-align:right;">

99.14566
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

555
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

22
</td>

<td style="text-align:right;">

3.9639640
</td>

<td style="text-align:right;">

0.6253
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

137
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

28.661088
</td>

<td style="text-align:right;">

0.9977
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:right;">

478.0000
</td>

<td style="text-align:right;">

21.338912
</td>

<td style="text-align:right;">

0.96700
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2341
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.2155
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.701290
</td>

<td style="text-align:right;">

0.8371
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.405770
</td>

<td style="text-align:right;">

0.89580
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9948
</td>

<td style="text-align:right;">

0.9907
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2.93310
</td>

<td style="text-align:right;">

0.6760
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

11.03496
</td>

<td style="text-align:right;">

0.8720
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

Census Tract 9402, Gila County, Arizona
</td>

<td style="text-align:right;">

20607
</td>

<td style="text-align:right;">

83800
</td>

<td style="text-align:right;">

14301
</td>

<td style="text-align:right;">

55800
</td>

<td style="text-align:right;">

23904.12
</td>

<td style="text-align:right;">

97208
</td>

<td style="text-align:right;">

-9603.12
</td>

<td style="text-align:right;">

-0.4017349
</td>

<td style="text-align:right;">

-41408
</td>

<td style="text-align:right;">

-0.4259732
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:left;">

Gila County, Arizona
</td>

<td style="text-align:left;">

Payson, AZ MicroSA
</td>

<td style="text-align:left;">

C3774
</td>

</tr>

<tr>

<td style="text-align:left;">

04007940400
</td>

<td style="text-align:left;">

04007
</td>

<td style="text-align:left;">

940400
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Gila County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

6485
</td>

<td style="text-align:right;">

1464
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

3673
</td>

<td style="text-align:right;">

6485
</td>

<td style="text-align:right;">

56.63840
</td>

<td style="text-align:right;">

0.9620
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

277
</td>

<td style="text-align:right;">

1834
</td>

<td style="text-align:right;">

15.103599
</td>

<td style="text-align:right;">

0.9368
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

101
</td>

<td style="text-align:right;">

681
</td>

<td style="text-align:right;">

14.831131
</td>

<td style="text-align:right;">

0.05870
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

56
</td>

<td style="text-align:right;">

360
</td>

<td style="text-align:right;">

15.55556
</td>

<td style="text-align:right;">

0.07525
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

157
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

15.08165
</td>

<td style="text-align:right;">

0.03361
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1155
</td>

<td style="text-align:right;">

3309
</td>

<td style="text-align:right;">

34.90481
</td>

<td style="text-align:right;">

0.9266
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2644
</td>

<td style="text-align:right;">

5767
</td>

<td style="text-align:right;">

45.84706
</td>

<td style="text-align:right;">

0.9889
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

408
</td>

<td style="text-align:right;">

6.291442
</td>

<td style="text-align:right;">

0.234900
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2406
</td>

<td style="text-align:right;">

37.101002
</td>

<td style="text-align:right;">

0.93050
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

692
</td>

<td style="text-align:right;">

3817
</td>

<td style="text-align:right;">

18.129421
</td>

<td style="text-align:right;">

0.76010
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

354
</td>

<td style="text-align:right;">

861
</td>

<td style="text-align:right;">

41.11498
</td>

<td style="text-align:right;">

0.9756
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

30
</td>

<td style="text-align:right;">

5565
</td>

<td style="text-align:right;">

0.5390836
</td>

<td style="text-align:right;">

0.2729
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

6428
</td>

<td style="text-align:right;">

6485
</td>

<td style="text-align:right;">

99.12105
</td>

<td style="text-align:right;">

0.9937
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1464
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

335
</td>

<td style="text-align:right;">

22.88251
</td>

<td style="text-align:right;">

0.8750
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

248
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

23.823247
</td>

<td style="text-align:right;">

0.9891
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

202
</td>

<td style="text-align:right;">

1041
</td>

<td style="text-align:right;">

19.404419
</td>

<td style="text-align:right;">

0.9537
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

6485
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.84791
</td>

<td style="text-align:right;">

0.8589
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.174000
</td>

<td style="text-align:right;">

0.80420
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9937
</td>

<td style="text-align:right;">

0.9880
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.3659
</td>

<td style="text-align:right;">

0.8488
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.381510
</td>

<td style="text-align:right;">

0.8800
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

5873
</td>

<td style="text-align:right;">

1751
</td>

<td style="text-align:right;">

1496
</td>

<td style="text-align:right;">

3435
</td>

<td style="text-align:right;">

5862
</td>

<td style="text-align:right;">

58.59775
</td>

<td style="text-align:right;">

0.9829
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

357
</td>

<td style="text-align:right;">

1977
</td>

<td style="text-align:right;">

18.057663
</td>

<td style="text-align:right;">

0.9860
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

799
</td>

<td style="text-align:right;">

14.267835
</td>

<td style="text-align:right;">

0.17090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

114
</td>

<td style="text-align:right;">

697
</td>

<td style="text-align:right;">

16.35581
</td>

<td style="text-align:right;">

0.07632
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

228
</td>

<td style="text-align:right;">

1496
</td>

<td style="text-align:right;">

15.240642
</td>

<td style="text-align:right;">

0.066600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

819
</td>

<td style="text-align:right;">

3169
</td>

<td style="text-align:right;">

25.844115
</td>

<td style="text-align:right;">

0.9099
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

486
</td>

<td style="text-align:right;">

5872
</td>

<td style="text-align:right;">

8.276567
</td>

<td style="text-align:right;">

0.5054
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

464
</td>

<td style="text-align:right;">

7.9005619
</td>

<td style="text-align:right;">

0.154300
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2015
</td>

<td style="text-align:right;">

34.309552
</td>

<td style="text-align:right;">

0.94120
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

697
</td>

<td style="text-align:right;">

3857.000
</td>

<td style="text-align:right;">

18.071040
</td>

<td style="text-align:right;">

0.6887
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

399
</td>

<td style="text-align:right;">

1240.0000
</td>

<td style="text-align:right;">

32.177419
</td>

<td style="text-align:right;">

0.9121
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

116
</td>

<td style="text-align:right;">

5320
</td>

<td style="text-align:right;">

2.1804511
</td>

<td style="text-align:right;">

0.6047
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

5766
</td>

<td style="text-align:right;">

5873.000
</td>

<td style="text-align:right;">

98.17810
</td>

<td style="text-align:right;">

0.9899
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1751
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

0.5711022
</td>

<td style="text-align:right;">

0.3116
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

410
</td>

<td style="text-align:right;">

23.4151913
</td>

<td style="text-align:right;">

0.8922
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

290
</td>

<td style="text-align:right;">

1496
</td>

<td style="text-align:right;">

19.385027
</td>

<td style="text-align:right;">

0.9818
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

322
</td>

<td style="text-align:right;">

1496.0000
</td>

<td style="text-align:right;">

21.524064
</td>

<td style="text-align:right;">

0.96800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

5873
</td>

<td style="text-align:right;">

0.0681083
</td>

<td style="text-align:right;">

0.4458
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.450800
</td>

<td style="text-align:right;">

0.7771
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

3.301000
</td>

<td style="text-align:right;">

0.86590
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9899
</td>

<td style="text-align:right;">

0.9857
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.59940
</td>

<td style="text-align:right;">

0.9095
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.34110
</td>

<td style="text-align:right;">

0.8981
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

1
</td>

<td style="text-align:right;">

547218
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:left;">

Yes
</td>

<td style="text-align:left;">

Census Tract 9404, Gila County, Arizona
</td>

<td style="text-align:right;">

14125
</td>

<td style="text-align:right;">

57900
</td>

<td style="text-align:right;">

19488
</td>

<td style="text-align:right;">

40200
</td>

<td style="text-align:right;">

16385.00
</td>

<td style="text-align:right;">

67164
</td>

<td style="text-align:right;">

3103.00
</td>

<td style="text-align:right;">

0.1893805
</td>

<td style="text-align:right;">

-26964
</td>

<td style="text-align:right;">

-0.4014651
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:left;">

Gila County, Arizona
</td>

<td style="text-align:left;">

Payson, AZ MicroSA
</td>

<td style="text-align:left;">

C3774
</td>

</tr>

<tr>

<td style="text-align:left;">

04009940500
</td>

<td style="text-align:left;">

04009
</td>

<td style="text-align:left;">

940500
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Graham County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

4838
</td>

<td style="text-align:right;">

1186
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

3261
</td>

<td style="text-align:right;">

4811
</td>

<td style="text-align:right;">

67.78217
</td>

<td style="text-align:right;">

0.9883
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

392
</td>

<td style="text-align:right;">

1501
</td>

<td style="text-align:right;">

26.115923
</td>

<td style="text-align:right;">

0.9935
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

118
</td>

<td style="text-align:right;">

582
</td>

<td style="text-align:right;">

20.274914
</td>

<td style="text-align:right;">

0.15470
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

86
</td>

<td style="text-align:right;">

472
</td>

<td style="text-align:right;">

18.22034
</td>

<td style="text-align:right;">

0.09660
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

204
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

19.35484
</td>

<td style="text-align:right;">

0.07125
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

622
</td>

<td style="text-align:right;">

2290
</td>

<td style="text-align:right;">

27.16157
</td>

<td style="text-align:right;">

0.8736
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2211
</td>

<td style="text-align:right;">

4615
</td>

<td style="text-align:right;">

47.90899
</td>

<td style="text-align:right;">

0.9927
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

235
</td>

<td style="text-align:right;">

4.857379
</td>

<td style="text-align:right;">

0.147100
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2057
</td>

<td style="text-align:right;">

42.517569
</td>

<td style="text-align:right;">

0.98700
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

599
</td>

<td style="text-align:right;">

2750
</td>

<td style="text-align:right;">

21.781818
</td>

<td style="text-align:right;">

0.87800
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

453
</td>

<td style="text-align:right;">

874
</td>

<td style="text-align:right;">

51.83066
</td>

<td style="text-align:right;">

0.9942
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

134
</td>

<td style="text-align:right;">

4253
</td>

<td style="text-align:right;">

3.1507171
</td>

<td style="text-align:right;">

0.6320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4838
</td>

<td style="text-align:right;">

4838
</td>

<td style="text-align:right;">

100.00000
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1186
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

157
</td>

<td style="text-align:right;">

13.23777
</td>

<td style="text-align:right;">

0.7625
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

259
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

24.573055
</td>

<td style="text-align:right;">

0.9906
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

256
</td>

<td style="text-align:right;">

1054
</td>

<td style="text-align:right;">

24.288425
</td>

<td style="text-align:right;">

0.9752
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4838
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.91935
</td>

<td style="text-align:right;">

0.8730
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3.638300
</td>

<td style="text-align:right;">

0.94100
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

0.9989
</td>

<td style="text-align:right;">

0.9931
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.2764
</td>

<td style="text-align:right;">

0.8163
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

11.832950
</td>

<td style="text-align:right;">

0.9185
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

4698
</td>

<td style="text-align:right;">

1271
</td>

<td style="text-align:right;">

1088
</td>

<td style="text-align:right;">

2479
</td>

<td style="text-align:right;">

4644
</td>

<td style="text-align:right;">

53.38071
</td>

<td style="text-align:right;">

0.9680
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

320
</td>

<td style="text-align:right;">

1512
</td>

<td style="text-align:right;">

21.164021
</td>

<td style="text-align:right;">

0.9916
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

49
</td>

<td style="text-align:right;">

635
</td>

<td style="text-align:right;">

7.716535
</td>

<td style="text-align:right;">

0.02543
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

59
</td>

<td style="text-align:right;">

453
</td>

<td style="text-align:right;">

13.02428
</td>

<td style="text-align:right;">

0.05556
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

108
</td>

<td style="text-align:right;">

1088
</td>

<td style="text-align:right;">

9.926471
</td>

<td style="text-align:right;">

0.011900
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

524
</td>

<td style="text-align:right;">

2457
</td>

<td style="text-align:right;">

21.326821
</td>

<td style="text-align:right;">

0.8647
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

748
</td>

<td style="text-align:right;">

4698
</td>

<td style="text-align:right;">

15.921669
</td>

<td style="text-align:right;">

0.8382
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

411
</td>

<td style="text-align:right;">

8.7484036
</td>

<td style="text-align:right;">

0.196800
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1750
</td>

<td style="text-align:right;">

37.249894
</td>

<td style="text-align:right;">

0.97360
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

483
</td>

<td style="text-align:right;">

2948.001
</td>

<td style="text-align:right;">

16.383982
</td>

<td style="text-align:right;">

0.6023
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

243
</td>

<td style="text-align:right;">

867.0002
</td>

<td style="text-align:right;">

28.027676
</td>

<td style="text-align:right;">

0.8613
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

28
</td>

<td style="text-align:right;">

4096
</td>

<td style="text-align:right;">

0.6835938
</td>

<td style="text-align:right;">

0.3526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

4691
</td>

<td style="text-align:right;">

4698.001
</td>

<td style="text-align:right;">

99.85097
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1271
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

132
</td>

<td style="text-align:right;">

10.3855232
</td>

<td style="text-align:right;">

0.7441
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

187
</td>

<td style="text-align:right;">

1088
</td>

<td style="text-align:right;">

17.187500
</td>

<td style="text-align:right;">

0.9751
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

190
</td>

<td style="text-align:right;">

1088.0003
</td>

<td style="text-align:right;">

17.463231
</td>

<td style="text-align:right;">

0.94690
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:right;">

4698
</td>

<td style="text-align:right;">

0.1702852
</td>

<td style="text-align:right;">

0.5117
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.674400
</td>

<td style="text-align:right;">

0.8291
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

2.986600
</td>

<td style="text-align:right;">

0.73960
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.9987
</td>

<td style="text-align:right;">

0.9945
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3.30540
</td>

<td style="text-align:right;">

0.8183
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

10.96510
</td>

<td style="text-align:right;">

0.8644
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

Census Tract 9405, Graham County, Arizona
</td>

<td style="text-align:right;">

12156
</td>

<td style="text-align:right;">

52100
</td>

<td style="text-align:right;">

17406
</td>

<td style="text-align:right;">

30200
</td>

<td style="text-align:right;">

14100.96
</td>

<td style="text-align:right;">

60436
</td>

<td style="text-align:right;">

3305.04
</td>

<td style="text-align:right;">

0.2343840
</td>

<td style="text-align:right;">

-30236
</td>

<td style="text-align:right;">

-0.5002978
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:right;">

NA
</td>

<td style="text-align:left;">

Graham County, Arizona
</td>

<td style="text-align:left;">

Safford, AZ MicroSA
</td>

<td style="text-align:left;">

C4094
</td>

</tr>

<tr>

<td style="text-align:left;">

04013050603
</td>

<td style="text-align:left;">

04013
</td>

<td style="text-align:left;">

050603
</td>

<td style="text-align:left;">

AZ
</td>

<td style="text-align:left;">

Arizona
</td>

<td style="text-align:left;">

Maricopa County
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:left;">

West Region
</td>

<td style="text-align:right;">

8
</td>

<td style="text-align:left;">

Mountain Division
</td>

<td style="text-align:right;">

3210
</td>

<td style="text-align:right;">

1306
</td>

<td style="text-align:right;">

1019
</td>

<td style="text-align:right;">

935
</td>

<td style="text-align:right;">

3203
</td>

<td style="text-align:right;">

29.19138
</td>

<td style="text-align:right;">

0.6976
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

123
</td>

<td style="text-align:right;">

1440
</td>

<td style="text-align:right;">

8.541667
</td>

<td style="text-align:right;">

0.6788
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

173
</td>

<td style="text-align:right;">

827
</td>

<td style="text-align:right;">

20.918984
</td>

<td style="text-align:right;">

0.17220
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

80
</td>

<td style="text-align:right;">

192
</td>

<td style="text-align:right;">

41.66667
</td>

<td style="text-align:right;">

0.44980
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

253
</td>

<td style="text-align:right;">

1019
</td>

<td style="text-align:right;">

24.82826
</td>

<td style="text-align:right;">

0.17710
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

478
</td>

<td style="text-align:right;">

1973
</td>

<td style="text-align:right;">

24.22707
</td>

<td style="text-align:right;">

0.8412
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

973
</td>

<td style="text-align:right;">

3641
</td>

<td style="text-align:right;">

26.72343
</td>

<td style="text-align:right;">

0.8371
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

284
</td>

<td style="text-align:right;">

8.847352
</td>

<td style="text-align:right;">

0.386600
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

996
</td>

<td style="text-align:right;">

31.028037
</td>

<td style="text-align:right;">

0.76090
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

303
</td>

<td style="text-align:right;">

2615
</td>

<td style="text-align:right;">

11.586998
</td>

<td style="text-align:right;">

0.38900
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

88
</td>

<td style="text-align:right;">

810
</td>

<td style="text-align:right;">

10.86420
</td>

<td style="text-align:right;">

0.3488
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

138
</td>

<td style="text-align:right;">

3010
</td>

<td style="text-align:right;">

4.5847176
</td>

<td style="text-align:right;">

0.7109
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1310
</td>

<td style="text-align:right;">

3210
</td>

<td style="text-align:right;">

40.80997
</td>

<td style="text-align:right;">

0.6759
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1306
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1526
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

720
</td>

<td style="text-align:right;">

55.13017
</td>

<td style="text-align:right;">

0.9795
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

69
</td>

<td style="text-align:right;">

1019
</td>

<td style="text-align:right;">

6.771344
</td>

<td style="text-align:right;">

0.8464
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

39
</td>

<td style="text-align:right;">

1019
</td>

<td style="text-align:right;">

3.827282
</td>

<td style="text-align:right;">

0.5281
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3210
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.3955
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.23180
</td>

<td style="text-align:right;">

0.7166
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

2.596200
</td>

<td style="text-align:right;">

0.55280
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

0.6759
</td>

<td style="text-align:right;">

0.6720
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.9021
</td>

<td style="text-align:right;">

0.6670
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

9.406000
</td>

<td style="text-align:right;">

0.6968
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

6148
</td>

<td style="text-align:right;">

2245
</td>

<td style="text-align:right;">

1921
</td>

<td style="text-align:right;">

1186
</td>

<td style="text-align:right;">

6098
</td>

<td style="text-align:right;">

19.44900
</td>

<td style="text-align:right;">

0.5140
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

378
</td>

<td style="text-align:right;">

2678
</td>

<td style="text-align:right;">

14.115011
</td>

<td style="text-align:right;">

0.9622
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

277
</td>

<td style="text-align:right;">

1535
</td>

<td style="text-align:right;">

18.045603
</td>

<td style="text-align:right;">

0.35540
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

43
</td>

<td style="text-align:right;">

387
</td>

<td style="text-align:right;">

11.11111
</td>

<td style="text-align:right;">

0.04642
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

320
</td>

<td style="text-align:right;">

1922
</td>

<td style="text-align:right;">

16.649324
</td>

<td style="text-align:right;">

0.093090
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1099
</td>

<td style="text-align:right;">

4207
</td>

<td style="text-align:right;">

26.123128
</td>

<td style="text-align:right;">

0.9131
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1084
</td>

<td style="text-align:right;">

6144
</td>

<td style="text-align:right;">

17.643229
</td>

<td style="text-align:right;">

0.8762
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

814
</td>

<td style="text-align:right;">

13.2400781
</td>

<td style="text-align:right;">

0.433200
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1313
</td>

<td style="text-align:right;">

21.356539
</td>

<td style="text-align:right;">

0.43200
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1259
</td>

<td style="text-align:right;">

4836.918
</td>

<td style="text-align:right;">

26.028972
</td>

<td style="text-align:right;">

0.9197
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

72
</td>

<td style="text-align:right;">

1493.4212
</td>

<td style="text-align:right;">

4.821145
</td>

<td style="text-align:right;">

0.1184
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

372
</td>

<td style="text-align:right;">

5967
</td>

<td style="text-align:right;">

6.2342886
</td>

<td style="text-align:right;">

0.8243
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2088
</td>

<td style="text-align:right;">

6148.289
</td>

<td style="text-align:right;">

33.96067
</td>

<td style="text-align:right;">

0.5342
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2245
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0.0000000
</td>

<td style="text-align:right;">

0.1276
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1081
</td>

<td style="text-align:right;">

48.1514477
</td>

<td style="text-align:right;">

0.9699
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

65
</td>

<td style="text-align:right;">

1921
</td>

<td style="text-align:right;">

3.383654
</td>

<td style="text-align:right;">

0.6475
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1921.1833
</td>

<td style="text-align:right;">

0.000000
</td>

<td style="text-align:right;">

0.03808
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

6148
</td>

<td style="text-align:right;">

0.1138582
</td>

<td style="text-align:right;">

0.4734
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

3.358590
</td>

<td style="text-align:right;">

0.7560
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

2.727600
</td>

<td style="text-align:right;">

0.61500
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

0.5342
</td>

<td style="text-align:right;">

0.5320
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

2.25648
</td>

<td style="text-align:right;">

0.3825
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

8.87687
</td>

<td style="text-align:right;">

0.6322
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

Census Tract 506.03, Maricopa County, Arizona
</td>

<td style="text-align:right;">

26439
</td>

<td style="text-align:right;">

156000
</td>

<td style="text-align:right;">

23698
</td>

<td style="text-align:right;">

165600
</td>

<td style="text-align:right;">

30669.24
</td>

<td style="text-align:right;">

180960
</td>

<td style="text-align:right;">

-6971.24
</td>

<td style="text-align:right;">

-0.2273040
</td>

<td style="text-align:right;">

-15360
</td>

<td style="text-align:right;">

-0.0848806
</td>

<td style="text-align:right;">

83.88
</td>

<td style="text-align:right;">

195.56
</td>

<td style="text-align:left;">

Maricopa County, Arizona
</td>

<td style="text-align:left;">

Phoenix-Mesa-Scottsdale, AZ MSA
</td>

<td style="text-align:left;">

C3806
</td>

</tr>

</tbody>

</table>

</div>

*National*

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

# NMTC Variable Distribution: Mountain Division

## SVI Theme 1: Socioeconomic Status

``` r
hist(svi_divisional_nmtc_df$F_THEME1_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME1_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME1_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME1_10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME1_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME1_10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME1_10))))
```

    ## [1] "Absolute Skewness: 0.0249901327808313"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME1_10))))
```

    ## [1] "Absolute Excess Kurtosis: 1.12999825726"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME1_10) < mean(svi_divisional_nmtc_df$F_THEME1_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2020*

``` r
hist(svi_divisional_nmtc_df$F_THEME1_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME1_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME1_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME1_20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME1_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME1_20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME1_20))))
```

    ## [1] "Absolute Skewness: 0.0216149135904862"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME1_20))))
```

    ## [1] "Absolute Excess Kurtosis: 1.03461573701947"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME1_20) < mean(svi_divisional_nmtc_df$F_THEME1_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

## SVI THeme 2: Household Characteristics

*2010*

``` r
hist(svi_divisional_nmtc_df$F_THEME2_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME2_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME2_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-40-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME2_10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME2_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-41-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME2_10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME2_10))))
```

    ## [1] "Absolute Skewness: 0.00100423682188465"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME2_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.651194090353722"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME2_10) < mean(svi_divisional_nmtc_df$F_THEME2_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2020*

``` r
hist(svi_divisional_nmtc_df$F_THEME2_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-46-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME2_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-47-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME2_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-48-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME2_20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME2_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-49-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME2_20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME2_20))))
```

    ## [1] "Absolute Skewness: 0.0215143038130277"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME2_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.701346689837882"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME2_20) < mean(svi_divisional_nmtc_df$F_THEME2_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

## SVI Theme 3: Racial & Ethnic Minority Status

*2010*

``` r
hist(svi_divisional_nmtc_df$F_THEME3_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-54-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME3_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-55-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME3_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-56-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME3_10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME1_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-57-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME3_10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME3_10))))
```

    ## [1] "Absolute Skewness: 0.0309634623783316"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME3_10))))
```

    ## [1] "Absolute Excess Kurtosis: 1.99904126399755"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME3_10) < mean(svi_divisional_nmtc_df$F_THEME3_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

``` r
table(svi_divisional_nmtc_df$F_THEME3_10)
```

    ## 
    ##   0   1 
    ## 984 954

*2020*

``` r
hist(svi_divisional_nmtc_df$F_THEME3_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-63-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME3_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-64-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME3_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-65-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME3_20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME3_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-66-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME3_20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME3_20))))
```

    ## [1] "Absolute Skewness: 0.0805606315825733"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME3_20))))
```

    ## [1] "Absolute Excess Kurtosis: 1.99350998463902"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME3_20) < mean(svi_divisional_nmtc_df$F_THEME3_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

``` r
table(svi_divisional_nmtc_df$F_THEME3_20)
```

    ## 
    ##    0    1 
    ## 1008  930

## SVI Theme 4: Housing Type & Transportation

*2010*

``` r
hist(svi_divisional_nmtc_df$F_THEME4_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-72-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME4_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-73-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME4_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-74-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME4_10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME4_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-75-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME4_10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME4_10))))
```

    ## [1] "Absolute Skewness: 0.0628118773173425"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME4_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.578223205433793"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME4_10) < mean(svi_divisional_nmtc_df$F_THEME4_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2020*

``` r
hist(svi_divisional_nmtc_df$F_THEME4_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-80-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_THEME4_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-81-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_THEME4_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-82-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_THEME4_20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_THEME4_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-83-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_THEME4_20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_THEME4_20))))
```

    ## [1] "Absolute Skewness: 0.0605950491829714"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_THEME4_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.658673836104457"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_THEME4_20) < mean(svi_divisional_nmtc_df$F_THEME4_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

## SVI OVerall

*2010*

``` r
hist(svi_divisional_nmtc_df$F_TOTAL_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-88-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_TOTAL_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-89-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_TOTAL_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-90-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_TOTAL_10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_TOTAL_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-91-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_TOTAL_10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_TOTAL_10))))
```

    ## [1] "Absolute Skewness: 0.0311483749255969"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_TOTAL_10))))
```

    ## [1] "Absolute Excess Kurtosis: 1.04070433814952"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_TOTAL_10) < mean(svi_divisional_nmtc_df$F_TOTAL_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2020*

``` r
hist(svi_divisional_nmtc_df$F_TOTAL_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-96-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$F_TOTAL_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-97-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "F_TOTAL_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-98-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$F_TOTAL_20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$F_TOTAL_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-99-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$F_TOTAL_20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$F_TOTAL_20))))
```

    ## [1] "Absolute Skewness: 0.0629866656842071"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$F_TOTAL_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.878387884554749"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$F_TOTAL_20) < mean(svi_divisional_nmtc_df$F_TOTAL_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Median Income

*2010*

``` r
options(scipen = 999)
hist(svi_divisional_nmtc_df$Median_Income_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-104-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Income_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-105-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Income_10adj", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-106-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Income_10adj, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Income_10adj, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-107-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Income_10adj)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Income_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.139463092047866"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Income_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.652592362975045"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Income_10adj, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Income_10adj, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2010 Log*

``` r
hist(svi_divisional_nmtc_df$Median_Income_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-112-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Income_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-113-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Income_10adj_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-114-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Income_10adj_log, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Income_10adj_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-115-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Income_10adj_log)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Income_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.42384668286417"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Income_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 5.55272518758958"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Income_10adj_log, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Income_10adj_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2019*

``` r
options(scipen = 999)
hist(svi_divisional_nmtc_df$Median_Income_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-120-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Income_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-121-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Income_19", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-122-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Income_19, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Income_19, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-123-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Income_19)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Income_19, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.124785761521551"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Income_19, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.973068468347"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Income_19, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Income_19, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Median Home Value

*2010*

``` r
hist(svi_divisional_nmtc_df$Median_Home_Value_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-128-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Home_Value_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-129-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Home_Value_10adj", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 30 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 30 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-130-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Home_Value_10adj, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Home_Value_10adj, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-131-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Home_Value_10adj)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Home_Value_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 2.29498564482883"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Home_Value_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 16.4426441276446"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Home_Value_10adj, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Home_Value_10adj, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2010 Log*

``` r
hist(svi_divisional_nmtc_df$Median_Home_Value_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-136-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Home_Value_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-137-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Home_Value_10adj_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 30 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 30 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-138-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-139-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Home_Value_10adj_log)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.17511485647903"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 3.40043121085217"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Home_Value_10adj_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2019*

``` r
hist(svi_divisional_nmtc_df$Median_Home_Value_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-144-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Home_Value_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-145-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Home_Value_19", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 51 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 51 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-146-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Home_Value_19, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Home_Value_19, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-147-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Home_Value_19)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Home_Value_19, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 2.60320862844623"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Home_Value_19, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 18.5791808764468"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Home_Value_19, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Home_Value_19, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2019 Log*

``` r
hist(svi_divisional_nmtc_df$Median_Home_Value_19_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-152-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$Median_Home_Value_19_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-153-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "Median_Home_Value_19_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 51 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 51 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-154-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$Median_Home_Value_19_log, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$Median_Home_Value_19_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-155-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$Median_Home_Value_19_log)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$Median_Home_Value_19_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.862701684939476"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$Median_Home_Value_19_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 2.58686759381741"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$Median_Home_Value_19_log, na.rm = TRUE) < mean(svi_divisional_nmtc_df$Median_Home_Value_19_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Housing Price Index

\*2010

``` r
hist(svi_divisional_nmtc_df$housing_price_index10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-160-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$housing_price_index10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-161-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "housing_price_index10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 857 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 857 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-162-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$housing_price_index10, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$housing_price_index10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-163-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$housing_price_index10)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.13858022197036"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.13858022197036"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 2.36895681000769"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$housing_price_index10, na.rm = TRUE) < mean(svi_divisional_nmtc_df$housing_price_index10, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2010 Log*

``` r
hist(svi_divisional_nmtc_df$housing_price_index10_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-169-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$housing_price_index10_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-170-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "housing_price_index10_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 857 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 857 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-171-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$housing_price_index10_log, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$housing_price_index10_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-172-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$housing_price_index10_log)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$housing_price_index10_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.0435644823884166"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$housing_price_index10_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.0142493700199102"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$housing_price_index10_log, na.rm = TRUE) < mean(svi_divisional_nmtc_df$housing_price_index10_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020*

``` r
hist(svi_divisional_nmtc_df$housing_price_index20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-177-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$housing_price_index20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-178-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "housing_price_index20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 722 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 722 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-179-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$housing_price_index20, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$housing_price_index20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-180-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$housing_price_index20)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$housing_price_index20, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.33009328321753"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$housing_price_index20, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 3.08862562179683"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$housing_price_index20, na.rm = TRUE) < mean(svi_divisional_nmtc_df$housing_price_index20, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020 Log*

``` r
hist(svi_divisional_nmtc_df$housing_price_index20_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-185-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_nmtc_df$housing_price_index20_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-186-1.png)<!-- -->

``` r
ggdensity(svi_divisional_nmtc_df, x = "housing_price_index20_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 722 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 722 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-187-1.png)<!-- -->

``` r
qqnorm(svi_divisional_nmtc_df$housing_price_index20_log, pch = 1, frame = FALSE)
qqline(svi_divisional_nmtc_df$housing_price_index20_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-188-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_nmtc_df$housing_price_index20_log)))
```

    ## [1] "Length: 1938"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_nmtc_df$housing_price_index20_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.0722867843904414"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_nmtc_df$housing_price_index20_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.0755339224588782"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_nmtc_df$housing_price_index20_log, na.rm = TRUE) < mean(svi_divisional_nmtc_df$housing_price_index20_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

# LIHTC Variable Distribution: Mountain Division

## SVI Theme 1: Socioeconomic Status

``` r
hist(svi_divisional_lihtc_df$F_THEME1_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-193-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME1_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-194-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME1_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-195-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME1_10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME1_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-196-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME1_10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME1_10))))
```

    ## [1] "Absolute Skewness: 0.698742055986755"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME1_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.299137459182033"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME1_10) < mean(svi_divisional_lihtc_df$F_THEME1_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020*

``` r
hist(svi_divisional_lihtc_df$F_THEME1_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-201-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME1_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-202-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME1_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-203-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME1_20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME1_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-204-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME1_20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME1_20))))
```

    ## [1] "Absolute Skewness: 0.591300029458139"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME1_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.587568327007457"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME1_20) < mean(svi_divisional_lihtc_df$F_THEME1_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## SVI THeme 2: Household Characteristics

*2010*

``` r
hist(svi_divisional_lihtc_df$F_THEME2_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-209-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME2_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-210-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME2_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-211-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME2_10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME2_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-212-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME2_10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME2_10))))
```

    ## [1] "Absolute Skewness: 0.282745286649261"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME2_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.916403920458291"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME2_10) < mean(svi_divisional_lihtc_df$F_THEME2_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2020*

``` r
hist(svi_divisional_lihtc_df$F_THEME2_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-217-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME2_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-218-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME2_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-219-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME2_20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME2_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-220-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME2_20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME2_20))))
```

    ## [1] "Absolute Skewness: 0.323066588839606"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME2_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.949799629112459"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME2_20) < mean(svi_divisional_lihtc_df$F_THEME2_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

## SVI Theme 3: Racial & Ethnic Minority Status

*2010*

``` r
hist(svi_divisional_lihtc_df$F_THEME3_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-225-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME3_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-226-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME3_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-227-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME3_10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME1_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-228-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME3_10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME3_10))))
```

    ## [1] "Absolute Skewness: 0.812149380607502"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME3_10))))
```

    ## [1] "Absolute Excess Kurtosis: 1.34041338357885"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME3_10) < mean(svi_divisional_lihtc_df$F_THEME3_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

``` r
table(svi_divisional_lihtc_df$F_THEME3_10)
```

    ## 
    ##   0   1 
    ##  63 139

*2020*

``` r
hist(svi_divisional_lihtc_df$F_THEME3_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-234-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME3_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-235-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME3_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-236-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME3_20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME3_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-237-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME3_20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME3_20))))
```

    ## [1] "Absolute Skewness: 0.812149380607502"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME3_20))))
```

    ## [1] "Absolute Excess Kurtosis: 1.34041338357885"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME3_20) < mean(svi_divisional_lihtc_df$F_THEME3_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

``` r
table(svi_divisional_lihtc_df$F_THEME3_20)
```

    ## 
    ##   0   1 
    ##  63 139

## SVI Theme 4: Housing Type & Transportation

*2010*

``` r
hist(svi_divisional_lihtc_df$F_THEME4_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-243-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME4_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-244-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME4_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-245-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME4_10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME4_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-246-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME4_10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME4_10))))
```

    ## [1] "Absolute Skewness: 0.314984102241371"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME4_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.215212929257489"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME4_10) < mean(svi_divisional_lihtc_df$F_THEME4_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020*

``` r
hist(svi_divisional_lihtc_df$F_THEME4_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-251-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_THEME4_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-252-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_THEME4_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-253-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_THEME4_20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_THEME4_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-254-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_THEME4_20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_THEME4_20))))
```

    ## [1] "Absolute Skewness: 0.192855546387606"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_THEME4_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.327891361511281"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_THEME4_20) < mean(svi_divisional_lihtc_df$F_THEME4_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## SVI Overall

*2010*

``` r
hist(svi_divisional_lihtc_df$F_TOTAL_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-259-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_TOTAL_10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-260-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_TOTAL_10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-261-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_TOTAL_10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_TOTAL_10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-262-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_TOTAL_10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_TOTAL_10))))
```

    ## [1] "Absolute Skewness: 0.525398616902496"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_TOTAL_10))))
```

    ## [1] "Absolute Excess Kurtosis: 0.467799904292678"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_TOTAL_10) < mean(svi_divisional_lihtc_df$F_TOTAL_10)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020*

``` r
hist(svi_divisional_lihtc_df$F_TOTAL_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-267-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$F_TOTAL_20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-268-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "F_TOTAL_20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-269-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$F_TOTAL_20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$F_TOTAL_20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-270-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$F_TOTAL_20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$F_TOTAL_20))))
```

    ## [1] "Absolute Skewness: 0.430674795613127"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$F_TOTAL_20))))
```

    ## [1] "Absolute Excess Kurtosis: 0.280822546693426"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$F_TOTAL_20) < mean(svi_divisional_lihtc_df$F_TOTAL_20)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Median Income

*2010*

``` r
options(scipen = 999)
hist(svi_divisional_lihtc_df$Median_Income_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-275-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Income_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-276-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Income_10adj", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-277-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Income_10adj, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Income_10adj, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-278-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Income_10adj)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Income_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.00188005391528848"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Income_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.991594713590978"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Income_10adj, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Income_10adj, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2010 Log*

``` r
hist(svi_divisional_lihtc_df$Median_Income_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-283-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Income_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-284-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Income_10adj_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-285-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Income_10adj_log, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Income_10adj_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-286-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Income_10adj_log)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Income_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.54255461177144"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Income_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 2.73888280996131"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Income_10adj_log, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Income_10adj_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2019*

``` r
options(scipen = 999)
hist(svi_divisional_lihtc_df$Median_Income_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-291-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Income_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-292-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Income_19", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-293-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Income_19, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Income_19, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-294-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Income_19)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Income_19, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.738967218711519"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Income_19, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 3.96758907065596"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Income_19, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Income_19, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Median Home Value

*2010*

``` r
hist(svi_divisional_lihtc_df$Median_Home_Value_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-299-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Home_Value_10adj)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-300-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Home_Value_10adj", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 9 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 9 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-301-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Home_Value_10adj, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Home_Value_10adj, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-302-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Home_Value_10adj)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Home_Value_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 2.9478613739634"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Home_Value_10adj, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 13.6859110055077"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Home_Value_10adj, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Home_Value_10adj, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2010 Log*

``` r
hist(svi_divisional_lihtc_df$Median_Home_Value_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-307-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Home_Value_10adj_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-308-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Home_Value_10adj_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 9 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 9 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-309-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-310-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Home_Value_10adj_log)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.399708664679192"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 1.67692481223881"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Home_Value_10adj_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2019*

``` r
hist(svi_divisional_lihtc_df$Median_Home_Value_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-315-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Home_Value_19)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-316-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Home_Value_19", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 14 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 14 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-317-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Home_Value_19, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Home_Value_19, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-318-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Home_Value_19)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Home_Value_19, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 3.19090980091081"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Home_Value_19, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 17.6985347895785"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Home_Value_19, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Home_Value_19, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: FALSE"

*2019 Log*

``` r
hist(svi_divisional_lihtc_df$Median_Home_Value_19_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-323-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$Median_Home_Value_19_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-324-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "Median_Home_Value_19_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 14 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 14 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-325-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$Median_Home_Value_19_log, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$Median_Home_Value_19_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-326-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$Median_Home_Value_19_log)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$Median_Home_Value_19_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.0237161694371718"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$Median_Home_Value_19_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.202114576132213"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$Median_Home_Value_19_log, na.rm = TRUE) < mean(svi_divisional_lihtc_df$Median_Home_Value_19_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

## Housing Price Index

\*2010

``` r
hist(svi_divisional_lihtc_df$housing_price_index10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-331-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$housing_price_index10)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-332-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "housing_price_index10", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 136 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 136 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-333-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$housing_price_index10, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$housing_price_index10, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-334-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$housing_price_index10)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.45735350547226"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.45735350547226"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$housing_price_index10, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 2.4013271457039"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$housing_price_index10, na.rm = TRUE) < mean(svi_divisional_lihtc_df$housing_price_index10, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2010 Log*

``` r
hist(svi_divisional_lihtc_df$housing_price_index10_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-340-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$housing_price_index10_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-341-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "housing_price_index10_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 136 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 136 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-342-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$housing_price_index10_log, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$housing_price_index10_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-343-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$housing_price_index10_log)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$housing_price_index10_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.323584982353486"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$housing_price_index10_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.235071725246949"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$housing_price_index10_log, na.rm = TRUE) < mean(svi_divisional_lihtc_df$housing_price_index10_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020*

``` r
hist(svi_divisional_lihtc_df$housing_price_index20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-348-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$housing_price_index20)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-349-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "housing_price_index20", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 113 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 113 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-350-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$housing_price_index20, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$housing_price_index20, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-351-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$housing_price_index20)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$housing_price_index20, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 1.48182201048028"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$housing_price_index20, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 2.32450252812465"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$housing_price_index20, na.rm = TRUE) < mean(svi_divisional_lihtc_df$housing_price_index20, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

*2020 Log*

``` r
hist(svi_divisional_lihtc_df$housing_price_index20_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-356-1.png)<!-- -->

``` r
plotNormalHistogram(svi_divisional_lihtc_df$housing_price_index20_log)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-357-1.png)<!-- -->

``` r
ggdensity(svi_divisional_lihtc_df, x = "housing_price_index20_log", fill = "lightgray") +
  stat_overlay_normal_density(color = "red", linetype = "dashed")
```

    ## Warning: Removed 113 rows containing non-finite outside the scale range
    ## (`stat_density()`).

    ## Warning: Removed 113 rows containing non-finite outside the scale range
    ## (`stat_overlay_normal_density()`).

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-358-1.png)<!-- -->

``` r
qqnorm(svi_divisional_lihtc_df$housing_price_index20_log, pch = 1, frame = FALSE)
qqline(svi_divisional_lihtc_df$housing_price_index20_log, col = "steelblue", lwd = 2)
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-359-1.png)<!-- -->

``` r
# Statistics

print(paste0("Length: ", length(svi_divisional_lihtc_df$housing_price_index20_log)))
```

    ## [1] "Length: 202"

``` r
print(paste0("Absolute Skewness: ", abs(skewness(svi_divisional_lihtc_df$housing_price_index20_log, na.rm = TRUE))))
```

    ## [1] "Absolute Skewness: 0.25859338485172"

``` r
print(paste0("Absolute Excess Kurtosis: ", abs(3 - kurtosis(svi_divisional_lihtc_df$housing_price_index20_log, na.rm = TRUE))))
```

    ## [1] "Absolute Excess Kurtosis: 0.237165858523208"

``` r
print(paste0("Standard deviation is less than 1/2 mean: ", sd(svi_divisional_lihtc_df$housing_price_index20_log, na.rm = TRUE) < mean(svi_divisional_lihtc_df$housing_price_index20_log, na.rm = TRUE)/2))
```

    ## [1] "Standard deviation is less than 1/2 mean: TRUE"

# Differences-in-Differences Models

## NMTC Evaluation

### Divisional SVI

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

    ## [1] 1938

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

    ## [1] 1938

``` r
nmtc_diff_in_diff_div_svi <- bind_rows(nmtc_did10_div_svi, nmtc_did20_div_svi)

nmtc_diff_in_diff_div_svi <- nmtc_diff_in_diff_div_svi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_svi)
```

    ## [1] 3876

### Divisional Median Income

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

    ## [1] 1938

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

    ## [1] 1938

``` r
nmtc_diff_in_diff_div_inc <- bind_rows(nmtc_did10_div_inc, nmtc_did19_div_inc)

nmtc_diff_in_diff_div_inc <- nmtc_diff_in_diff_div_inc %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_inc)
```

    ## [1] 3876

``` r
nmtc_diff_in_diff_div_svi %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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

04001942600
</td>

<td style="text-align:left;">

NA
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3
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

2010
</td>

</tr>

<tr>

<td style="text-align:left;">

04001942700
</td>

<td style="text-align:left;">

NA
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

12
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

04001944000
</td>

<td style="text-align:left;">

NA
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

3
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

2010
</td>

</tr>

<tr>

<td style="text-align:left;">

04001944100
</td>

<td style="text-align:left;">

NA
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

12
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

04001944202
</td>

<td style="text-align:left;">

NA
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

12
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

04001944300
</td>

<td style="text-align:left;">

NA
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

13
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

</tbody>

</table>

</div>

### Divisional Home Value

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

    ## [1] 1882

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

    ## [1] 1882

``` r
nmtc_diff_in_diff_div_mhv <- bind_rows(nmtc_did10_div_mhv, nmtc_did19_div_mhv)

nmtc_diff_in_diff_div_mhv <- nmtc_diff_in_diff_div_mhv %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_mhv)
```

    ## [1] 3764

### Divisional House Price Index

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

    ## [1] 1080

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

    ## [1] 1080

``` r
nmtc_diff_in_diff_div_hpi <- bind_rows(nmtc_did10_div_hpi, nmtc_did20_div_hpi)

nmtc_diff_in_diff_div_hpi <- nmtc_diff_in_diff_div_hpi %>% arrange(post, treat, GEOID_2010_trt)

nrow(nmtc_diff_in_diff_div_hpi)
```

    ## [1] 2160

## NMTC Divisional Model

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
in Mountain Division</caption>
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
<tr>
<th></th>
<th colspan="5">Social Vulnerability</th>
<th colspan="3">Economic Outcomes</th>
</tr>
<tr>
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
<tr>
<td>(Intercept)</td>
<td>2.22***</td>
<td>2.27***</td>
<td>0.44***</td>
<td>1.74***</td>
<td>6.67***</td>
<td>9.87***</td>
<td>11.43***</td>
<td>4.93***</td>
</tr>
<tr>
<td></td>
<td>(0.36)</td>
<td>(0.25)</td>
<td>(0.10)</td>
<td>(0.27)</td>
<td>(0.73)</td>
<td>(0.07)</td>
<td>(0.12)</td>
<td>(0.03)</td>
</tr>
<tr>
<td>treat</td>
<td>0.43**</td>
<td>0.10</td>
<td>0.05</td>
<td>0.48***</td>
<td>1.06***</td>
<td>-0.09***</td>
<td>-0.05</td>
<td>-0.07</td>
</tr>
<tr>
<td></td>
<td>(0.14)</td>
<td>(0.09)</td>
<td>(0.04)</td>
<td>(0.10)</td>
<td>(0.28)</td>
<td>(0.03)</td>
<td>(0.04)</td>
<td>(0.04)</td>
</tr>
<tr>
<td>post</td>
<td>-0.07</td>
<td>-0.04</td>
<td>-0.01</td>
<td>0.03</td>
<td>-0.10</td>
<td>0.00</td>
<td>-0.05**</td>
<td>0.61***</td>
</tr>
<tr>
<td></td>
<td>(0.05)</td>
<td>(0.04)</td>
<td>(0.01)</td>
<td>(0.04)</td>
<td>(0.10)</td>
<td>(0.01)</td>
<td>(0.02)</td>
<td>(0.01)</td>
</tr>
<tr>
<td>treat × post</td>
<td>0.02</td>
<td>0.00</td>
<td>-0.00</td>
<td>0.09</td>
<td>0.11</td>
<td>0.03</td>
<td>0.05</td>
<td>-0.00</td>
</tr>
<tr>
<td></td>
<td>(0.19)</td>
<td>(0.13)</td>
<td>(0.05)</td>
<td>(0.14)</td>
<td>(0.38)</td>
<td>(0.04)</td>
<td>(0.06)</td>
<td>(0.06)</td>
</tr>
<tr>
<td>Num.Obs.</td>
<td>3436</td>
<td>3436</td>
<td>3436</td>
<td>3436</td>
<td>3436</td>
<td>3436</td>
<td>3324</td>
<td>1974</td>
</tr>
<tr>
<td>R2</td>
<td>0.185</td>
<td>0.187</td>
<td>0.342</td>
<td>0.113</td>
<td>0.235</td>
<td>0.171</td>
<td>0.257</td>
<td>0.610</td>
</tr>
<tr>
<td>R2 Adj.</td>
<td>0.167</td>
<td>0.169</td>
<td>0.327</td>
<td>0.093</td>
<td>0.218</td>
<td>0.153</td>
<td>0.240</td>
<td>0.596</td>
</tr>
<tr>
<td>RMSE</td>
<td>1.41</td>
<td>0.99</td>
<td>0.41</td>
<td>1.05</td>
<td>2.87</td>
<td>0.27</td>
<td>0.45</td>
<td>0.30</td>
</tr>
<tr>
<td colspan="9"><ul>
<li>p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tbody><tfoot>
<tr>
<td colspan="9">All models include metro-level fixed effects by
core-based statistical area (cbsa).</td>
</tr>
</tfoot>
&#10;</table>

In looking at our social vulnerability index models, we see that there
were no categories in the Mountain Division that experienced
statistically significant changes in regards to those counties receiving
NMTC funding. In particular, we are looking for statistically
significant changes in the treat x post variable and none exist in the
Mountain Division.

In evaluating the indicators of economic conditions, again we do not see
any significantly significant changes in economic outcomes in counties
receiving NMTC funding versus those that did not.

### Visualize SES

``` r
status <- c("NMTC Non-Participant", 
             "NMTC Participant Counterfactual", 
             "NMTC Participant", 
             "NMTC Non-Participant", 
             "NMTC Participant Counterfactual", 
             "NMTC Participant")
year <- c(2010, 
          2010, 
          2010, 
          2020, 
          2020, 
          2020)
outcome <- c(m1_nmtc_div$coefficients[1], 
           m1_nmtc_div$coefficients[1] + m1_nmtc_div$coefficients[2], 
           m1_nmtc_div$coefficients[1] + m1_nmtc_div$coefficients[2],
           m1_nmtc_div$coefficients[1] + m1_nmtc_div$coefficients[3], 
           m1_nmtc_div$coefficients[1] + m1_nmtc_div$coefficients[2] + m1_nmtc_div$coefficients[3],
           m1_nmtc_div$coefficients[1] + m1_nmtc_div$coefficients[2] + m1_nmtc_div$coefficients[3] + m1_nmtc_div$coefficients[length(m1_nmtc_div$coefficients)])

svidiv_viz_ses_nmtc <- data.frame(status, year, outcome)
svidiv_viz_ses_nmtc$outcome_label <- round(svidiv_viz_ses_nmtc$outcome, 2)
svidiv_viz_ses_nmtc
```

    ##                            status year  outcome outcome_label
    ## 1            NMTC Non-Participant 2010 2.221420          2.22
    ## 2 NMTC Participant Counterfactual 2010 2.654338          2.65
    ## 3                NMTC Participant 2010 2.654338          2.65
    ## 4            NMTC Non-Participant 2020 2.153580          2.15
    ## 5 NMTC Participant Counterfactual 2020 2.586499          2.59
    ## 6                NMTC Participant 2020 2.606719          2.61

``` r
slopegraph_plot(svidiv_viz_ses_nmtc, "NMTC Participant", "NMTC Non-Participant","Impact of NMTC Program on SVI SES Flag Count", paste0(census_division, " | 2010 - 2020"))
```

![](lab-05-knopp_files/figure-gfm/unnamed-chunk-379-1.png)<!-- -->

The slopegraph for SES SVI flags for the NMTC program indicates that in
the Mountain Division our NMTC Participant Tracts did not experience a
notable decrease in socioeconomic social vulnerability flags in 2020
from the expected count of 2.59 for the counterfactual to 2.61 for the
actual outcome.

Because we do not have any statistically significants changes in our
outcomes we not need to visualize the counterfactual and outcome graphs.
This slopegraph for the SES flag was included for demonstration.

## LIHTC Evaluation

### Divisional SVI

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

    ## [1] 202

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

    ## [1] 202

``` r
lihtc_diff_in_diff_div_svi <- bind_rows(lihtc_did10_div_svi, lihtc_did20_div_svi)

lihtc_diff_in_diff_div_svi <- lihtc_diff_in_diff_div_svi %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_svi)
```

    ## [1] 404

### Divisional Median Income

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

    ## [1] 202

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

    ## [1] 202

``` r
lihtc_diff_in_diff_div_inc <- bind_rows(lihtc_did10_div_inc, lihtc_did19_div_inc)

lihtc_diff_in_diff_div_inc <- lihtc_diff_in_diff_div_inc %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_inc)
```

    ## [1] 404

### Divisional Median Home Value

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

    ## [1] 187

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

    ## [1] 187

``` r
lihtc_diff_in_diff_div_mhv <- bind_rows(lihtc_did10_div_mhv, lihtc_did19_div_mhv)

lihtc_diff_in_diff_div_mhv <- lihtc_diff_in_diff_div_mhv %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_mhv)
```

    ## [1] 374

### Divisional House Price Index

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

    ## [1] 66

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

    ## [1] 66

``` r
lihtc_diff_in_diff_div_hpi <- bind_rows(lihtc_did10_div_hpi, lihtc_did20_div_hpi)

lihtc_diff_in_diff_div_hpi <- lihtc_diff_in_diff_div_hpi %>% arrange(post, treat, GEOID_2010_trt)

nrow(lihtc_diff_in_diff_div_hpi)
```

    ## [1] 132

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
in Mountain Division</caption>
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
<tr>
<th></th>
<th colspan="5">Social Vulnerability</th>
<th colspan="3">Economic Outcomes</th>
</tr>
<tr>
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
<tr>
<td>(Intercept)</td>
<td>3.44***</td>
<td>1.87***</td>
<td>0.84***</td>
<td>1.93***</td>
<td>8.09***</td>
<td>9.77***</td>
<td>11.96***</td>
<td>4.84***</td>
</tr>
<tr>
<td></td>
<td>(0.19)</td>
<td>(0.18)</td>
<td>(0.06)</td>
<td>(0.17)</td>
<td>(0.38)</td>
<td>(0.07)</td>
<td>(0.08)</td>
<td>(0.09)</td>
</tr>
<tr>
<td>treat</td>
<td>-0.05</td>
<td>0.10</td>
<td>-0.05</td>
<td>-0.06</td>
<td>-0.05</td>
<td>0.11</td>
<td>0.07</td>
<td>0.20</td>
</tr>
<tr>
<td></td>
<td>(0.23)</td>
<td>(0.22)</td>
<td>(0.07)</td>
<td>(0.21)</td>
<td>(0.48)</td>
<td>(0.09)</td>
<td>(0.11)</td>
<td>(0.16)</td>
</tr>
<tr>
<td>post</td>
<td>-0.12</td>
<td>-0.07</td>
<td>0.01</td>
<td>0.02</td>
<td>-0.16</td>
<td>0.02</td>
<td>-0.07</td>
<td>0.62***</td>
</tr>
<tr>
<td></td>
<td>(0.11)</td>
<td>(0.11)</td>
<td>(0.03)</td>
<td>(0.10)</td>
<td>(0.23)</td>
<td>(0.04)</td>
<td>(0.05)</td>
<td>(0.06)</td>
</tr>
<tr>
<td>treat × post</td>
<td>-0.26</td>
<td>-0.06</td>
<td>-0.01</td>
<td>0.19</td>
<td>-0.13</td>
<td>0.04</td>
<td>0.04</td>
<td>0.03</td>
</tr>
<tr>
<td></td>
<td>(0.31)</td>
<td>(0.30)</td>
<td>(0.10)</td>
<td>(0.28)</td>
<td>(0.64)</td>
<td>(0.12)</td>
<td>(0.15)</td>
<td>(0.20)</td>
</tr>
<tr>
<td>Num.Obs.</td>
<td>372</td>
<td>372</td>
<td>372</td>
<td>372</td>
<td>372</td>
<td>372</td>
<td>342</td>
<td>126</td>
</tr>
<tr>
<td>R2</td>
<td>0.255</td>
<td>0.434</td>
<td>0.589</td>
<td>0.197</td>
<td>0.421</td>
<td>0.325</td>
<td>0.479</td>
<td>0.655</td>
</tr>
<tr>
<td>R2 Adj.</td>
<td>0.168</td>
<td>0.367</td>
<td>0.541</td>
<td>0.102</td>
<td>0.353</td>
<td>0.246</td>
<td>0.411</td>
<td>0.577</td>
</tr>
<tr>
<td>RMSE</td>
<td>0.95</td>
<td>0.90</td>
<td>0.30</td>
<td>0.87</td>
<td>1.95</td>
<td>0.36</td>
<td>0.42</td>
<td>0.30</td>
</tr>
<tr>
<td colspan="9"><ul>
<li>p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</li>
</ul></td>
</tr>
</tbody><tfoot>
<tr>
<td colspan="9">All models include metro-level fixed effects by
core-based statistical area (cbsa).</td>
</tr>
</tfoot>
&#10;</table>

As with our national data, we do not see a statistically significant
changes in social vulnerability or economic outcomes for tracts
participating in the LIHTC program. We cannot conclude that the program
had a measurable impact in the Mountain Division tracts.

### Visualize Divisional Models

Because we do not have any statistically significant changes in our
outcomes we not need to visualize the counterfactual and outcome
slopegraphs.
