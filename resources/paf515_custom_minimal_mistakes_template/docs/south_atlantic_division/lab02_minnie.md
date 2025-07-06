---
title: "Social Vulnerability Index"
author: "Minnie Mouse"
#date: "2024-03-12"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

- SVI SUMMARY INTRO

**NOTE: Values below are duplicates from Middle Atlantic Division and serve solely as an example**

# Library

``` r
# Load packages
library(here)        # relative filepaths for reproducibility
library(tidyverse)   # data wrangling
library(stringi)     # string wrangling
library(kableExtra)  # table formatting
library(tidycensus)  # census data
```

# API Key and Variable Import

``` r
# Load API key, assign to TidyCensus Package
source(here::here("analysis/password.R"))
census_api_key(census_api_key)
```

``` r
import::here( "author",
              "census_division",
              "region",
              "state",
              "county",
              "fips_region_assignment",
              "rank_variables",
              "svi_theme_variables",
              "svi_theme_flags",
             # notice the use of here::here() that points to the .R file
             # where all these R objects are created
             .from = here::here("analysis/project_data_steps_minnie.R"),
             .character_only = TRUE)
```

# Data

``` r
# Load SVI data sets
svi_2010 <- readRDS(here::here("data/raw/Census_Data_SVI/svi_2010_trt10.rds"))
svi_2020 <- readRDS(here::here("data/raw/Census_Data_SVI/svi_2020_trt10.rds"))
```

``` r
svi_2010 %>% colnames()
```

    ##  [1] "GEOID_2010_trt"         "E_TOTPOP_10"            "E_HU_10"               
    ##  [4] "E_HH_10"                "E_POV150_10"            "ET_POVSTATUS_10"       
    ##  [7] "EP_POV150_10"           "EPL_POV150_10"          "E_UNEMP_10"            
    ## [10] "ET_EMPSTATUS_10"        "EP_UNEMP_10"            "EPL_UNEMP_10"          
    ## [13] "E_HBURD_OWN_10"         "ET_HOUSINGCOST_OWN_10"  "EP_HBURD_OWN_10"       
    ## [16] "EPL_HBURD_OWN_10"       "E_HBURD_RENT_10"        "ET_HOUSINGCOST_RENT_10"
    ## [19] "EP_HBURD_RENT_10"       "EPL_HBURD_RENT_10"      "E_HBURD_10"            
    ## [22] "ET_HOUSINGCOST_10"      "EP_HBURD_10"            "EPL_HBURD_10"          
    ## [25] "E_NOHSDP_10"            "ET_EDSTATUS_10"         "EP_NOHSDP_10"          
    ## [28] "EPL_NOHSDP_10"          "E_UNINSUR_12"           "ET_INSURSTATUS_12"     
    ## [31] "EP_UNINSUR_12"          "EPL_UNINSUR_12"         "E_AGE65_10"            
    ## [34] "EP_AGE65_10"            "EPL_AGE65_10"           "E_AGE17_10"            
    ## [37] "EP_AGE17_10"            "EPL_AGE17_10"           "E_DISABL_12"           
    ## [40] "ET_DISABLSTATUS_12"     "EP_DISABL_12"           "EPL_DISABL_12"         
    ## [43] "E_SNGPNT_10"            "ET_FAMILIES_10"         "EP_SNGPNT_10"          
    ## [46] "EPL_SNGPNT_10"          "E_LIMENG_10"            "ET_POPAGE5UP_10"       
    ## [49] "EP_LIMENG_10"           "EPL_LIMENG_10"          "E_MINRTY_10"           
    ## [52] "ET_POPETHRACE_10"       "EP_MINRTY_10"           "EPL_MINRTY_10"         
    ## [55] "E_STRHU_10"             "E_MUNIT_10"             "EP_MUNIT_10"           
    ## [58] "EPL_MUNIT_10"           "E_MOBILE_10"            "EP_MOBILE_10"          
    ## [61] "EPL_MOBILE_10"          "E_CROWD_10"             "ET_OCCUPANTS_10"       
    ## [64] "EP_CROWD_10"            "EPL_CROWD_10"           "E_NOVEH_10"            
    ## [67] "ET_KNOWNVEH_10"         "EP_NOVEH_10"            "EPL_NOVEH_10"          
    ## [70] "E_GROUPQ_10"            "ET_HHTYPE_10"           "EP_GROUPQ_10"          
    ## [73] "EPL_GROUPQ_10"

``` r
svi_2010 %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
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
<th style="text-align:left;">
EPL_POV150_10
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
<th style="text-align:left;">
EPL_UNEMP_10
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
<th style="text-align:left;">
EPL_HBURD_OWN_10
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
<th style="text-align:left;">
EPL_HBURD_RENT_10
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
<th style="text-align:left;">
EPL_HBURD_10
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
<th style="text-align:left;">
EPL_NOHSDP_10
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
<th style="text-align:left;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:left;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:left;">
EPL_AGE17_10
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
<th style="text-align:left;">
EPL_DISABL_12
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
<th style="text-align:left;">
EPL_SNGPNT_10
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
<th style="text-align:left;">
EPL_LIMENG_10
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
<th style="text-align:left;">
EPL_MINRTY_10
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
<th style="text-align:left;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:left;">
EPL_MOBILE_10
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
<th style="text-align:left;">
EPL_CROWD_10
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
<th style="text-align:left;">
EPL_NOVEH_10
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
<th style="text-align:left;">
EPL_GROUPQ_10
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
16.41791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
889
</td>
<td style="text-align:right;">
4.049494
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
598
</td>
<td style="text-align:right;">
21.23746
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
47.95918
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
174
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
25.00000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
15.780998
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1759
</td>
<td style="text-align:right;">
10.574190
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
12.271973
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
24.59923
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
22.32210
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
4.954128
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
1705
</td>
<td style="text-align:right;">
2.1114370
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
21.282477
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
11.9325551
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
7.183908
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
15.556660
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
10.099010
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
29.55446
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
4.1666667
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
1.7808219
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
656
</td>
<td style="text-align:right;">
3533
</td>
<td style="text-align:right;">
18.56779
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
1552
</td>
<td style="text-align:right;">
5.992268
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
28.52665
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
178
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
53.93939
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
451
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
35.04274
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
2260
</td>
<td style="text-align:right;">
15.309734
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
3102
</td>
<td style="text-align:right;">
8.123791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
487
</td>
<td style="text-align:right;">
13.745413
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
28.16822
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
371
</td>
<td style="text-align:right;">
2224
</td>
<td style="text-align:right;">
16.68165
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
913
</td>
<td style="text-align:right;">
13.800657
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3365
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
637
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
17.979114
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.7127584
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.1425517
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
7.847708
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
501
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
10.35124
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
2129
</td>
<td style="text-align:right;">
4.744011
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
310
</td>
<td style="text-align:right;">
1549
</td>
<td style="text-align:right;">
20.01291
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
30.68966
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
21.69657
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
3280
</td>
<td style="text-align:right;">
8.353658
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
4293
</td>
<td style="text-align:right;">
9.294200
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
955
</td>
<td style="text-align:right;">
19.731405
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1195
</td>
<td style="text-align:right;">
24.69008
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
625
</td>
<td style="text-align:right;">
3328
</td>
<td style="text-align:right;">
18.78005
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
1374
</td>
<td style="text-align:right;">
11.062591
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
4537
</td>
<td style="text-align:right;">
0.2204100
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
6.136364
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1.6862545
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.2774655
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
0.7612833
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
1.033170
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
11.02838
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
4937
</td>
<td style="text-align:right;">
3.807981
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
2406
</td>
<td style="text-align:right;">
17.70574
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
39.55056
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
25.50120
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
5983
</td>
<td style="text-align:right;">
4.897209
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
740
</td>
<td style="text-align:right;">
10110
</td>
<td style="text-align:right;">
7.319486
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
8.422218
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
3012
</td>
<td style="text-align:right;">
30.30791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
7155
</td>
<td style="text-align:right;">
10.60797
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
2529
</td>
<td style="text-align:right;">
18.821669
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
9297
</td>
<td style="text-align:right;">
0.8389803
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1970
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
19.822902
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
7.7097506
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
0.1871157
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
223
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
5.960973
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
735
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.60494
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
1720
</td>
<td style="text-align:right;">
7.790698
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
23.44961
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
22.46377
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
23.24159
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
2151
</td>
<td style="text-align:right;">
13.993491
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
3445
</td>
<td style="text-align:right;">
10.304790
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
11.346267
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
931
</td>
<td style="text-align:right;">
27.36626
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
2439
</td>
<td style="text-align:right;">
18.04018
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
924
</td>
<td style="text-align:right;">
15.476190
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3254
</td>
<td style="text-align:right;">
0.1229256
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
723
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.252205
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
1.2362637
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
433
</td>
<td style="text-align:right;">
29.7390110
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
1.2232416
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
2.140673
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_2010 %>% nrow()
```

    ## [1] 73057

``` r
svi_2020 %>% colnames()
```

    ##  [1] "GEOID_2010_trt"         "E_TOTPOP_20"            "E_HU_20"               
    ##  [4] "E_HH_20"                "E_POV150_20"            "ET_POVSTATUS_20"       
    ##  [7] "EP_POV150_20"           "EPL_POV150_20"          "E_UNEMP_20"            
    ## [10] "ET_EMPSTATUS_20"        "EP_UNEMP_20"            "EPL_UNEMP_20"          
    ## [13] "E_HBURD_OWN_20"         "ET_HOUSINGCOST_OWN_20"  "EP_HBURD_OWN_20"       
    ## [16] "EPL_HBURD_OWN_20"       "E_HBURD_RENT_20"        "ET_HOUSINGCOST_RENT_20"
    ## [19] "EP_HBURD_RENT_20"       "EPL_HBURD_RENT_20"      "E_HBURD_20"            
    ## [22] "ET_HOUSINGCOST_20"      "EP_HBURD_20"            "EPL_HBURD_20"          
    ## [25] "E_NOHSDP_20"            "ET_EDSTATUS_20"         "EP_NOHSDP_20"          
    ## [28] "EPL_NOHSDP_20"          "E_UNINSUR_20"           "ET_INSURSTATUS_20"     
    ## [31] "EP_UNINSUR_20"          "EPL_UNINSUR_20"         "E_AGE65_20"            
    ## [34] "EP_AGE65_20"            "EPL_AGE65_20"           "E_AGE17_20"            
    ## [37] "EP_AGE17_20"            "EPL_AGE17_20"           "E_DISABL_20"           
    ## [40] "ET_DISABLSTATUS_20"     "EP_DISABL_20"           "EPL_DISABL_20"         
    ## [43] "E_SNGPNT_20"            "ET_FAMILIES_20"         "EP_SNGPNT_20"          
    ## [46] "EPL_SNGPNT_20"          "E_LIMENG_20"            "ET_POPAGE5UP_20"       
    ## [49] "EP_LIMENG_20"           "EPL_LIMENG_20"          "E_MINRTY_20"           
    ## [52] "ET_POPETHRACE_20"       "EP_MINRTY_20"           "EPL_MINRTY_20"         
    ## [55] "E_STRHU_20"             "E_MUNIT_20"             "EP_MUNIT_20"           
    ## [58] "EPL_MUNIT_20"           "E_MOBILE_20"            "EP_MOBILE_20"          
    ## [61] "EPL_MOBILE_20"          "E_CROWD_20"             "ET_OCCUPANTS_20"       
    ## [64] "EP_CROWD_20"            "EPL_CROWD_20"           "E_NOVEH_20"            
    ## [67] "ET_KNOWNVEH_20"         "EP_NOVEH_20"            "EPL_NOVEH_20"          
    ## [70] "E_GROUPQ_20"            "ET_HHTYPE_20"           "EP_GROUPQ_20"          
    ## [73] "EPL_GROUPQ_20"

``` r
svi_2020 %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
GEOID_2010_trt
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
<th style="text-align:left;">
EPL_POV150_20
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
<th style="text-align:left;">
EPL_UNEMP_20
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
<th style="text-align:left;">
EPL_HBURD_OWN_20
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
<th style="text-align:left;">
EPL_HBURD_RENT_20
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
<th style="text-align:left;">
EPL_HBURD_20
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
<th style="text-align:left;">
EPL_NOHSDP_20
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
<th style="text-align:left;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:left;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:left;">
EPL_AGE17_20
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
<th style="text-align:left;">
EPL_DISABL_20
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
<th style="text-align:left;">
EPL_SNGPNT_20
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
<th style="text-align:left;">
EPL_LIMENG_20
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
<th style="text-align:left;">
EPL_MINRTY_20
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
<th style="text-align:left;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:left;">
EPL_MOBILE_20
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
<th style="text-align:left;">
EPL_CROWD_20
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
<th style="text-align:left;">
EPL_NOVEH_20
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
<th style="text-align:left;">
EPL_GROUPQ_20
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
18.13498
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
852
</td>
<td style="text-align:right;">
2.112676
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
15.976331
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
33.87097
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
20.77922
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1309
</td>
<td style="text-align:right;">
14.285714
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
9.634209
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
15.19835
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
21.38073
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1526
</td>
<td style="text-align:right;">
25.62254
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
10.45045
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1843
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
22.51417
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
12.3943662
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
1.443001
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020200
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
16.16392
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
325
</td>
<td style="text-align:right;">
18.49744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
164
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
13.57616
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
11.69916
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1116
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
63.51736
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0.6944444
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
9.947644
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
12.066022
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
842
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
22.79372
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
1994
</td>
<td style="text-align:right;">
2.657974
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
967
</td>
<td style="text-align:right;">
12.099276
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
38.28125
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
19.54108
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
317
</td>
<td style="text-align:right;">
2477
</td>
<td style="text-align:right;">
12.797739
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
3673
</td>
<td style="text-align:right;">
3.457664
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
12.56091
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
929
</td>
<td style="text-align:right;">
25.14889
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
2744
</td>
<td style="text-align:right;">
17.23761
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
975
</td>
<td style="text-align:right;">
26.97436
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
3586
</td>
<td style="text-align:right;">
3.5694367
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1331
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
36.03140
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1.7759563
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.9562842
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
2.5906736
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
3.108808
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
14.21305
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
1658
</td>
<td style="text-align:right;">
2.352232
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
1290
</td>
<td style="text-align:right;">
16.976744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
21.38728
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
17.90954
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
2775
</td>
<td style="text-align:right;">
6.234234
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
3529
</td>
<td style="text-align:right;">
4.788892
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
27.38062
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
14.41085
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
670
</td>
<td style="text-align:right;">
3019
</td>
<td style="text-align:right;">
22.19278
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1137
</td>
<td style="text-align:right;">
13.01671
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3409
</td>
<td style="text-align:right;">
2.6107363
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
12.82848
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
8.2136703
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
0.6112469
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
4.400978
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
1626
</td>
<td style="text-align:right;">
10509
</td>
<td style="text-align:right;">
15.47245
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
5048
</td>
<td style="text-align:right;">
1.604596
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
2299
</td>
<td style="text-align:right;">
13.962592
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
2125
</td>
<td style="text-align:right;">
33.45882
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
23.32731
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
6816
</td>
<td style="text-align:right;">
7.790493
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
10046
</td>
<td style="text-align:right;">
2.996217
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1613
</td>
<td style="text-align:right;">
15.11149
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2765
</td>
<td style="text-align:right;">
25.90407
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1124
</td>
<td style="text-align:right;">
7281
</td>
<td style="text-align:right;">
15.43744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2912
</td>
<td style="text-align:right;">
11.74451
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
9920
</td>
<td style="text-align:right;">
0.5241935
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2603
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
24.38636
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
15.6083481
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
0.6438721
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
0.8363472
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
4.679023
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
1.648866
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1279
</td>
<td style="text-align:right;">
3523
</td>
<td style="text-align:right;">
36.30429
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
2.780049
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1111
</td>
<td style="text-align:right;">
28.892889
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
30.59361
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
29.17293
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
12.857143
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
3496
</td>
<td style="text-align:right;">
11.870709
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
15.46946
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
982
</td>
<td style="text-align:right;">
27.77149
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
729
</td>
<td style="text-align:right;">
2514
</td>
<td style="text-align:right;">
28.99761
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
880
</td>
<td style="text-align:right;">
10.79545
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3394
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
27.85633
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
24.8633880
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1.278196
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_2020 %>% nrow()
```

    ## [1] 73057

# Data Wrangling

``` r
svi_2010 <- fips_region_assignment(svi_2010)

svi_2010 %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
<th style="text-align:left;">
EPL_POV150_10
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
<th style="text-align:left;">
EPL_UNEMP_10
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
<th style="text-align:left;">
EPL_HBURD_OWN_10
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
<th style="text-align:left;">
EPL_HBURD_RENT_10
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
<th style="text-align:left;">
EPL_HBURD_10
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
<th style="text-align:left;">
EPL_NOHSDP_10
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
<th style="text-align:left;">
EPL_UNINSUR_12
</th>
<th style="text-align:right;">
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:left;">
EPL_AGE65_10
</th>
<th style="text-align:right;">
E_AGE17_10
</th>
<th style="text-align:right;">
EP_AGE17_10
</th>
<th style="text-align:left;">
EPL_AGE17_10
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
<th style="text-align:left;">
EPL_DISABL_12
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
<th style="text-align:left;">
EPL_SNGPNT_10
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
<th style="text-align:left;">
EPL_LIMENG_10
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
<th style="text-align:left;">
EPL_MINRTY_10
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
<th style="text-align:left;">
EPL_MUNIT_10
</th>
<th style="text-align:right;">
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:left;">
EPL_MOBILE_10
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
<th style="text-align:left;">
EPL_CROWD_10
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
<th style="text-align:left;">
EPL_NOVEH_10
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
<th style="text-align:left;">
EPL_GROUPQ_10
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020100
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
1809
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
16.41791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
889
</td>
<td style="text-align:right;">
4.049494
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
598
</td>
<td style="text-align:right;">
21.23746
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
47.95918
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
174
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
25.00000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
15.780998
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1759
</td>
<td style="text-align:right;">
10.574190
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
12.271973
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
24.59923
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
22.32210
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
4.954128
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
1705
</td>
<td style="text-align:right;">
2.1114370
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
21.282477
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
11.9325551
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
7.183908
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
313
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
15.556660
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
10.099010
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
29.55446
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
4.1666667
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
1.7808219
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020300
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
3543
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
656
</td>
<td style="text-align:right;">
3533
</td>
<td style="text-align:right;">
18.56779
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
1552
</td>
<td style="text-align:right;">
5.992268
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
28.52665
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
178
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
53.93939
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
451
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
35.04274
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
2260
</td>
<td style="text-align:right;">
15.309734
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
3102
</td>
<td style="text-align:right;">
8.123791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
487
</td>
<td style="text-align:right;">
13.745413
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
28.16822
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
371
</td>
<td style="text-align:right;">
2224
</td>
<td style="text-align:right;">
16.68165
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
913
</td>
<td style="text-align:right;">
13.800657
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3365
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
637
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
17.979114
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.7127584
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.1425517
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
7.847708
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020400
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
4840
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
501
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
10.35124
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
2129
</td>
<td style="text-align:right;">
4.744011
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
310
</td>
<td style="text-align:right;">
1549
</td>
<td style="text-align:right;">
20.01291
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
30.68966
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
21.69657
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
3280
</td>
<td style="text-align:right;">
8.353658
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
4293
</td>
<td style="text-align:right;">
9.294200
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
955
</td>
<td style="text-align:right;">
19.731405
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1195
</td>
<td style="text-align:right;">
24.69008
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
625
</td>
<td style="text-align:right;">
3328
</td>
<td style="text-align:right;">
18.78005
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
1374
</td>
<td style="text-align:right;">
11.062591
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
4537
</td>
<td style="text-align:right;">
0.2204100
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
6.136364
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1.6862545
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.2774655
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
0.7612833
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
1.033170
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020500
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
9938
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
11.02838
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
4937
</td>
<td style="text-align:right;">
3.807981
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
2406
</td>
<td style="text-align:right;">
17.70574
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
39.55056
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
25.50120
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
5983
</td>
<td style="text-align:right;">
4.897209
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
740
</td>
<td style="text-align:right;">
10110
</td>
<td style="text-align:right;">
7.319486
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
8.422218
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
3012
</td>
<td style="text-align:right;">
30.30791
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
7155
</td>
<td style="text-align:right;">
10.60797
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
2529
</td>
<td style="text-align:right;">
18.821669
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
9297
</td>
<td style="text-align:right;">
0.8389803
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1970
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
19.822902
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
7.7097506
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
0.1871157
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
223
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
5.960973
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020600
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
3402
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
735
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.60494
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
1720
</td>
<td style="text-align:right;">
7.790698
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
23.44961
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
22.46377
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
23.24159
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
2151
</td>
<td style="text-align:right;">
13.993491
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
3445
</td>
<td style="text-align:right;">
10.304790
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
11.346267
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
931
</td>
<td style="text-align:right;">
27.36626
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
2439
</td>
<td style="text-align:right;">
18.04018
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
924
</td>
<td style="text-align:right;">
15.476190
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3254
</td>
<td style="text-align:right;">
0.1229256
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
723
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.252205
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
1.2362637
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
433
</td>
<td style="text-align:right;">
29.7390110
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
1.2232416
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
2.140673
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_2020 <- fips_region_assignment(svi_2020)

svi_2020 %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
<th style="text-align:left;">
EPL_POV150_20
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
<th style="text-align:left;">
EPL_UNEMP_20
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
<th style="text-align:left;">
EPL_HBURD_OWN_20
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
<th style="text-align:left;">
EPL_HBURD_RENT_20
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
<th style="text-align:left;">
EPL_HBURD_20
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
<th style="text-align:left;">
EPL_NOHSDP_20
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
<th style="text-align:left;">
EPL_UNINSUR_20
</th>
<th style="text-align:right;">
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:left;">
EPL_AGE65_20
</th>
<th style="text-align:right;">
E_AGE17_20
</th>
<th style="text-align:right;">
EP_AGE17_20
</th>
<th style="text-align:left;">
EPL_AGE17_20
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
<th style="text-align:left;">
EPL_DISABL_20
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
<th style="text-align:left;">
EPL_SNGPNT_20
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
<th style="text-align:left;">
EPL_LIMENG_20
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
<th style="text-align:left;">
EPL_MINRTY_20
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
<th style="text-align:left;">
EPL_MUNIT_20
</th>
<th style="text-align:right;">
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:left;">
EPL_MOBILE_20
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
<th style="text-align:left;">
EPL_CROWD_20
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
<th style="text-align:left;">
EPL_NOVEH_20
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
<th style="text-align:left;">
EPL_GROUPQ_20
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020100
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
1941
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
18.13498
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
852
</td>
<td style="text-align:right;">
2.112676
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
15.976331
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
33.87097
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
20.77922
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1309
</td>
<td style="text-align:right;">
14.285714
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
9.634209
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
15.19835
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
21.38073
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1526
</td>
<td style="text-align:right;">
25.62254
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
10.45045
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1843
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
22.51417
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
12.3943662
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
1.443001
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
16.16392
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
325
</td>
<td style="text-align:right;">
18.49744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
164
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
13.57616
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
11.69916
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1116
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
63.51736
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
0.6944444
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
9.947644
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
12.066022
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020300
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
3694
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
842
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
22.79372
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
1994
</td>
<td style="text-align:right;">
2.657974
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
967
</td>
<td style="text-align:right;">
12.099276
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
38.28125
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
19.54108
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
317
</td>
<td style="text-align:right;">
2477
</td>
<td style="text-align:right;">
12.797739
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
3673
</td>
<td style="text-align:right;">
3.457664
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
12.56091
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
929
</td>
<td style="text-align:right;">
25.14889
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
2744
</td>
<td style="text-align:right;">
17.23761
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
975
</td>
<td style="text-align:right;">
26.97436
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
3586
</td>
<td style="text-align:right;">
3.5694367
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1331
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
36.03140
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1.7759563
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.9562842
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
2.5906736
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
3.108808
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020400
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
3539
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
14.21305
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
1658
</td>
<td style="text-align:right;">
2.352232
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
1290
</td>
<td style="text-align:right;">
16.976744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
21.38728
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
17.90954
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
2775
</td>
<td style="text-align:right;">
6.234234
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
3529
</td>
<td style="text-align:right;">
4.788892
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
27.38062
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
14.41085
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
670
</td>
<td style="text-align:right;">
3019
</td>
<td style="text-align:right;">
22.19278
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1137
</td>
<td style="text-align:right;">
13.01671
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3409
</td>
<td style="text-align:right;">
2.6107363
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
12.82848
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
8.2136703
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
0.6112469
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
4.400978
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020500
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
10674
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
1626
</td>
<td style="text-align:right;">
10509
</td>
<td style="text-align:right;">
15.47245
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
5048
</td>
<td style="text-align:right;">
1.604596
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
2299
</td>
<td style="text-align:right;">
13.962592
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
2125
</td>
<td style="text-align:right;">
33.45882
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
23.32731
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
6816
</td>
<td style="text-align:right;">
7.790493
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
10046
</td>
<td style="text-align:right;">
2.996217
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1613
</td>
<td style="text-align:right;">
15.11149
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2765
</td>
<td style="text-align:right;">
25.90407
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
1124
</td>
<td style="text-align:right;">
7281
</td>
<td style="text-align:right;">
15.43744
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2912
</td>
<td style="text-align:right;">
11.74451
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
9920
</td>
<td style="text-align:right;">
0.5241935
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
2603
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
24.38636
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
15.6083481
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
0.6438721
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
0.8363472
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
4.679023
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
1.648866
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020600
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
3536
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1279
</td>
<td style="text-align:right;">
3523
</td>
<td style="text-align:right;">
36.30429
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
2.780049
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1111
</td>
<td style="text-align:right;">
28.892889
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
30.59361
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
29.17293
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
12.857143
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
3496
</td>
<td style="text-align:right;">
11.870709
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
15.46946
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
982
</td>
<td style="text-align:right;">
27.77149
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
729
</td>
<td style="text-align:right;">
2514
</td>
<td style="text-align:right;">
28.99761
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
880
</td>
<td style="text-align:right;">
10.79545
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3394
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
27.85633
</td>
<td style="text-align:left;">
NA
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
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
24.8633880
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1.278196
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

</div>

``` r
# National
svi_2010_national <- rank_variables(svi_2010)
svi_2010_national %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
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
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020100
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
1809
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
16.41791
</td>
<td style="text-align:right;">
0.3871
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
889
</td>
<td style="text-align:right;">
4.049494
</td>
<td style="text-align:right;">
0.1790
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
598
</td>
<td style="text-align:right;">
21.23746
</td>
<td style="text-align:right;">
0.20770
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
47.95918
</td>
<td style="text-align:right;">
0.5767
</td>
<td style="text-align:right;">
174
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
25.00000
</td>
<td style="text-align:right;">
0.18790
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
15.780998
</td>
<td style="text-align:right;">
0.6093
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1759
</td>
<td style="text-align:right;">
10.574190
</td>
<td style="text-align:right;">
0.3790
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
12.271973
</td>
<td style="text-align:right;">
0.4876
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
24.59923
</td>
<td style="text-align:right;">
0.5473
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
22.32210
</td>
<td style="text-align:right;">
0.8454
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
4.954128
</td>
<td style="text-align:right;">
0.09275
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
1705
</td>
<td style="text-align:right;">
2.1114370
</td>
<td style="text-align:right;">
0.59040
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
21.282477
</td>
<td style="text-align:right;">
0.4524
</td>
<td style="text-align:right;">
771
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
92
</td>
<td style="text-align:right;">
11.9325551
</td>
<td style="text-align:right;">
0.8005
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1238
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
7.183908
</td>
<td style="text-align:right;">
0.6134
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
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
68
</td>
<td style="text-align:right;">
834
</td>
<td style="text-align:right;">
8.153477
</td>
<td style="text-align:right;">
0.5754
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
105
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
36.08247
</td>
<td style="text-align:right;">
0.3019
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
313
</td>
<td style="text-align:right;">
2012
</td>
<td style="text-align:right;">
15.556660
</td>
<td style="text-align:right;">
0.6000
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
10.099010
</td>
<td style="text-align:right;">
0.3419
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
132
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
28.947368
</td>
<td style="text-align:right;">
0.83510
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
1243
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
61.534653
</td>
<td style="text-align:right;">
0.7781
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
34
</td>
<td style="text-align:right;">
4.1666667
</td>
<td style="text-align:right;">
0.6664
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
730
</td>
<td style="text-align:right;">
1.7808219
</td>
<td style="text-align:right;">
0.5406
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
0
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020300
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
3543
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
656
</td>
<td style="text-align:right;">
3533
</td>
<td style="text-align:right;">
18.56779
</td>
<td style="text-align:right;">
0.4443
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
1552
</td>
<td style="text-align:right;">
5.992268
</td>
<td style="text-align:right;">
0.3724
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
28.52665
</td>
<td style="text-align:right;">
0.45780
</td>
<td style="text-align:right;">
178
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
53.93939
</td>
<td style="text-align:right;">
0.7152
</td>
<td style="text-align:right;">
451
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
35.04274
</td>
<td style="text-align:right;">
0.49930
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
2260
</td>
<td style="text-align:right;">
15.309734
</td>
<td style="text-align:right;">
0.5950
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
3102
</td>
<td style="text-align:right;">
8.123791
</td>
<td style="text-align:right;">
0.2596
</td>
<td style="text-align:right;">
487
</td>
<td style="text-align:right;">
13.745413
</td>
<td style="text-align:right;">
0.5868
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
28.16822
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
371
</td>
<td style="text-align:right;">
2224
</td>
<td style="text-align:right;">
16.68165
</td>
<td style="text-align:right;">
0.6266
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
913
</td>
<td style="text-align:right;">
13.800657
</td>
<td style="text-align:right;">
0.46350
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3365
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09298
</td>
<td style="text-align:right;">
637
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
17.979114
</td>
<td style="text-align:right;">
0.4049
</td>
<td style="text-align:right;">
1403
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.7127584
</td>
<td style="text-align:right;">
0.3015
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.1425517
</td>
<td style="text-align:right;">
0.4407
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1238
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1287
</td>
<td style="text-align:right;">
7.847708
</td>
<td style="text-align:right;">
0.6443
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3543
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020400
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
4840
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
501
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
10.35124
</td>
<td style="text-align:right;">
0.2177
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
2129
</td>
<td style="text-align:right;">
4.744011
</td>
<td style="text-align:right;">
0.2447
</td>
<td style="text-align:right;">
310
</td>
<td style="text-align:right;">
1549
</td>
<td style="text-align:right;">
20.01291
</td>
<td style="text-align:right;">
0.17080
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
30.68966
</td>
<td style="text-align:right;">
0.2044
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
21.69657
</td>
<td style="text-align:right;">
0.10540
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
3280
</td>
<td style="text-align:right;">
8.353658
</td>
<td style="text-align:right;">
0.3205
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
4293
</td>
<td style="text-align:right;">
9.294200
</td>
<td style="text-align:right;">
0.3171
</td>
<td style="text-align:right;">
955
</td>
<td style="text-align:right;">
19.731405
</td>
<td style="text-align:right;">
0.8643
</td>
<td style="text-align:right;">
1195
</td>
<td style="text-align:right;">
24.69008
</td>
<td style="text-align:right;">
0.5530
</td>
<td style="text-align:right;">
625
</td>
<td style="text-align:right;">
3328
</td>
<td style="text-align:right;">
18.78005
</td>
<td style="text-align:right;">
0.7233
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
1374
</td>
<td style="text-align:right;">
11.062591
</td>
<td style="text-align:right;">
0.34710
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
4537
</td>
<td style="text-align:right;">
0.2204100
</td>
<td style="text-align:right;">
0.22560
</td>
<td style="text-align:right;">
297
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
6.136364
</td>
<td style="text-align:right;">
0.1647
</td>
<td style="text-align:right;">
1957
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1.6862545
</td>
<td style="text-align:right;">
0.3843
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.2774655
</td>
<td style="text-align:right;">
0.5516
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
0.7612833
</td>
<td style="text-align:right;">
0.3564
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
1.033170
</td>
<td style="text-align:right;">
0.1127
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020500
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
9938
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
11.02838
</td>
<td style="text-align:right;">
0.2364
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
4937
</td>
<td style="text-align:right;">
3.807981
</td>
<td style="text-align:right;">
0.1577
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
2406
</td>
<td style="text-align:right;">
17.70574
</td>
<td style="text-align:right;">
0.11050
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
1335
</td>
<td style="text-align:right;">
39.55056
</td>
<td style="text-align:right;">
0.3753
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
25.50120
</td>
<td style="text-align:right;">
0.20140
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
5983
</td>
<td style="text-align:right;">
4.897209
</td>
<td style="text-align:right;">
0.1655
</td>
<td style="text-align:right;">
740
</td>
<td style="text-align:right;">
10110
</td>
<td style="text-align:right;">
7.319486
</td>
<td style="text-align:right;">
0.2211
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
8.422218
</td>
<td style="text-align:right;">
0.2408
</td>
<td style="text-align:right;">
3012
</td>
<td style="text-align:right;">
30.30791
</td>
<td style="text-align:right;">
0.8455
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
7155
</td>
<td style="text-align:right;">
10.60797
</td>
<td style="text-align:right;">
0.2668
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
2529
</td>
<td style="text-align:right;">
18.821669
</td>
<td style="text-align:right;">
0.63540
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
9297
</td>
<td style="text-align:right;">
0.8389803
</td>
<td style="text-align:right;">
0.41110
</td>
<td style="text-align:right;">
1970
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
19.822902
</td>
<td style="text-align:right;">
0.4330
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
7.7097506
</td>
<td style="text-align:right;">
0.6153
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2198
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
0.1871157
</td>
<td style="text-align:right;">
0.2535
</td>
<td style="text-align:right;">
223
</td>
<td style="text-align:right;">
3741
</td>
<td style="text-align:right;">
5.960973
</td>
<td style="text-align:right;">
0.5483
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9938
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020600
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
3402
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
735
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.60494
</td>
<td style="text-align:right;">
0.5199
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
1720
</td>
<td style="text-align:right;">
7.790698
</td>
<td style="text-align:right;">
0.5436
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
23.44961
</td>
<td style="text-align:right;">
0.28010
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
22.46377
</td>
<td style="text-align:right;">
0.1035
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
23.24159
</td>
<td style="text-align:right;">
0.14070
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
2151
</td>
<td style="text-align:right;">
13.993491
</td>
<td style="text-align:right;">
0.5510
</td>
<td style="text-align:right;">
355
</td>
<td style="text-align:right;">
3445
</td>
<td style="text-align:right;">
10.304790
</td>
<td style="text-align:right;">
0.3656
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
11.346267
</td>
<td style="text-align:right;">
0.4232
</td>
<td style="text-align:right;">
931
</td>
<td style="text-align:right;">
27.36626
</td>
<td style="text-align:right;">
0.7200
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
2439
</td>
<td style="text-align:right;">
18.04018
</td>
<td style="text-align:right;">
0.6912
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
924
</td>
<td style="text-align:right;">
15.476190
</td>
<td style="text-align:right;">
0.52900
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3254
</td>
<td style="text-align:right;">
0.1229256
</td>
<td style="text-align:right;">
0.19840
</td>
<td style="text-align:right;">
723
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
21.252205
</td>
<td style="text-align:right;">
0.4519
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
1.2362637
</td>
<td style="text-align:right;">
0.3507
</td>
<td style="text-align:right;">
433
</td>
<td style="text-align:right;">
29.7390110
</td>
<td style="text-align:right;">
0.9468
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
1.2232416
</td>
<td style="text-align:right;">
0.4493
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1308
</td>
<td style="text-align:right;">
2.140673
</td>
<td style="text-align:right;">
0.2298
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3402
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.364
</td>
</tr>
</tbody>
</table>

</div>

``` r
# National
svi_2020_national <- rank_variables(svi_2020)
svi_2020_national %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020100
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
1941
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
18.13498
</td>
<td style="text-align:right;">
0.4630
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
852
</td>
<td style="text-align:right;">
2.112676
</td>
<td style="text-align:right;">
0.15070
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
15.976331
</td>
<td style="text-align:right;">
0.26320
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
33.87097
</td>
<td style="text-align:right;">
0.2913
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
20.77922
</td>
<td style="text-align:right;">
0.2230
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1309
</td>
<td style="text-align:right;">
14.285714
</td>
<td style="text-align:right;">
0.6928
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
9.634209
</td>
<td style="text-align:right;">
0.6617
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
15.19835
</td>
<td style="text-align:right;">
0.4601
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
21.38073
</td>
<td style="text-align:right;">
0.4681
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1526
</td>
<td style="text-align:right;">
25.62254
</td>
<td style="text-align:right;">
0.9011
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
10.45045
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1843
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
22.51417
</td>
<td style="text-align:right;">
0.3902
</td>
<td style="text-align:right;">
710
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
88
</td>
<td style="text-align:right;">
12.3943662
</td>
<td style="text-align:right;">
0.8263
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
1.443001
</td>
<td style="text-align:right;">
0.1643
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
</tr>
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
149
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
26.00349
</td>
<td style="text-align:right;">
0.4041
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
284
</td>
<td style="text-align:right;">
16.16392
</td>
<td style="text-align:right;">
0.5169
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
164
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
13.57616
</td>
<td style="text-align:right;">
0.4127
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
11.69916
</td>
<td style="text-align:right;">
0.3998
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
1116
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
63.51736
</td>
<td style="text-align:right;">
0.7591
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
5
</td>
<td style="text-align:right;">
0.6944444
</td>
<td style="text-align:right;">
0.5106
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
57
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
9.947644
</td>
<td style="text-align:right;">
0.7317
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
12.066022
</td>
<td style="text-align:right;">
0.9549
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020300
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
3694
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
842
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
22.79372
</td>
<td style="text-align:right;">
0.5833
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
1994
</td>
<td style="text-align:right;">
2.657974
</td>
<td style="text-align:right;">
0.22050
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
967
</td>
<td style="text-align:right;">
12.099276
</td>
<td style="text-align:right;">
0.11370
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
38.28125
</td>
<td style="text-align:right;">
0.3856
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
19.54108
</td>
<td style="text-align:right;">
0.1827
</td>
<td style="text-align:right;">
317
</td>
<td style="text-align:right;">
2477
</td>
<td style="text-align:right;">
12.797739
</td>
<td style="text-align:right;">
0.6460
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
3673
</td>
<td style="text-align:right;">
3.457664
</td>
<td style="text-align:right;">
0.2308
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
12.56091
</td>
<td style="text-align:right;">
0.3088
</td>
<td style="text-align:right;">
929
</td>
<td style="text-align:right;">
25.14889
</td>
<td style="text-align:right;">
0.7080
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
2744
</td>
<td style="text-align:right;">
17.23761
</td>
<td style="text-align:right;">
0.6211
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
975
</td>
<td style="text-align:right;">
26.97436
</td>
<td style="text-align:right;">
0.8234
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
3586
</td>
<td style="text-align:right;">
3.5694367
</td>
<td style="text-align:right;">
0.70770
</td>
<td style="text-align:right;">
1331
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
36.03140
</td>
<td style="text-align:right;">
0.5515
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1.7759563
</td>
<td style="text-align:right;">
0.3675
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.9562842
</td>
<td style="text-align:right;">
0.5389
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
2.5906736
</td>
<td style="text-align:right;">
0.60550
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
3.108808
</td>
<td style="text-align:right;">
0.3415
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020400
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
3539
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
14.21305
</td>
<td style="text-align:right;">
0.3472
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
1658
</td>
<td style="text-align:right;">
2.352232
</td>
<td style="text-align:right;">
0.17990
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
1290
</td>
<td style="text-align:right;">
16.976744
</td>
<td style="text-align:right;">
0.30880
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
21.38728
</td>
<td style="text-align:right;">
0.1037
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
17.90954
</td>
<td style="text-align:right;">
0.1333
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
2775
</td>
<td style="text-align:right;">
6.234234
</td>
<td style="text-align:right;">
0.3351
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
3529
</td>
<td style="text-align:right;">
4.788892
</td>
<td style="text-align:right;">
0.3448
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
27.38062
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
14.41085
</td>
<td style="text-align:right;">
0.1208
</td>
<td style="text-align:right;">
670
</td>
<td style="text-align:right;">
3019
</td>
<td style="text-align:right;">
22.19278
</td>
<td style="text-align:right;">
0.8194
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1137
</td>
<td style="text-align:right;">
13.01671
</td>
<td style="text-align:right;">
0.4541
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3409
</td>
<td style="text-align:right;">
2.6107363
</td>
<td style="text-align:right;">
0.64690
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
12.82848
</td>
<td style="text-align:right;">
0.2364
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
8.2136703
</td>
<td style="text-align:right;">
0.6028
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
10
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
0.6112469
</td>
<td style="text-align:right;">
0.28340
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
4.400978
</td>
<td style="text-align:right;">
0.4538
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020500
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
10674
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
1626
</td>
<td style="text-align:right;">
10509
</td>
<td style="text-align:right;">
15.47245
</td>
<td style="text-align:right;">
0.3851
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
5048
</td>
<td style="text-align:right;">
1.604596
</td>
<td style="text-align:right;">
0.09431
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
2299
</td>
<td style="text-align:right;">
13.962592
</td>
<td style="text-align:right;">
0.17970
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
2125
</td>
<td style="text-align:right;">
33.45882
</td>
<td style="text-align:right;">
0.2836
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
23.32731
</td>
<td style="text-align:right;">
0.3109
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
6816
</td>
<td style="text-align:right;">
7.790493
</td>
<td style="text-align:right;">
0.4251
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
10046
</td>
<td style="text-align:right;">
2.996217
</td>
<td style="text-align:right;">
0.1894
</td>
<td style="text-align:right;">
1613
</td>
<td style="text-align:right;">
15.11149
</td>
<td style="text-align:right;">
0.4553
</td>
<td style="text-align:right;">
2765
</td>
<td style="text-align:right;">
25.90407
</td>
<td style="text-align:right;">
0.7494
</td>
<td style="text-align:right;">
1124
</td>
<td style="text-align:right;">
7281
</td>
<td style="text-align:right;">
15.43744
</td>
<td style="text-align:right;">
0.5253
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2912
</td>
<td style="text-align:right;">
11.74451
</td>
<td style="text-align:right;">
0.4019
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
9920
</td>
<td style="text-align:right;">
0.5241935
</td>
<td style="text-align:right;">
0.35230
</td>
<td style="text-align:right;">
2603
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
24.38636
</td>
<td style="text-align:right;">
0.4160
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
15.6083481
</td>
<td style="text-align:right;">
0.7378
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
0.6438721
</td>
<td style="text-align:right;">
0.5037
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
0.8363472
</td>
<td style="text-align:right;">
0.33420
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
4.679023
</td>
<td style="text-align:right;">
0.4754
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
1.648866
</td>
<td style="text-align:right;">
0.7598
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020600
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
3536
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1279
</td>
<td style="text-align:right;">
3523
</td>
<td style="text-align:right;">
36.30429
</td>
<td style="text-align:right;">
0.8215
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
2.780049
</td>
<td style="text-align:right;">
0.23780
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1111
</td>
<td style="text-align:right;">
28.892889
</td>
<td style="text-align:right;">
0.75870
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
30.59361
</td>
<td style="text-align:right;">
0.2305
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
29.17293
</td>
<td style="text-align:right;">
0.5075
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
12.857143
</td>
<td style="text-align:right;">
0.6480
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
3496
</td>
<td style="text-align:right;">
11.870709
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
15.46946
</td>
<td style="text-align:right;">
0.4760
</td>
<td style="text-align:right;">
982
</td>
<td style="text-align:right;">
27.77149
</td>
<td style="text-align:right;">
0.8327
</td>
<td style="text-align:right;">
729
</td>
<td style="text-align:right;">
2514
</td>
<td style="text-align:right;">
28.99761
</td>
<td style="text-align:right;">
0.9488
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
880
</td>
<td style="text-align:right;">
10.79545
</td>
<td style="text-align:right;">
0.3601
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3394
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
27.85633
</td>
<td style="text-align:right;">
0.4608
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
0.1079
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
24.8633880
</td>
<td style="text-align:right;">
0.9300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1.278196
</td>
<td style="text-align:right;">
0.1463
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Regional
svi_2010_regional <- rank_variables(svi_2010, rank_by = "regional", location = region)
svi_2010_regional %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
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
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
09001010101
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010101
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
4053
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
1416
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
3851
</td>
<td style="text-align:right;">
6.284082
</td>
<td style="text-align:right;">
0.16010
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
1511
</td>
<td style="text-align:right;">
3.441429
</td>
<td style="text-align:right;">
0.1265
</td>
<td style="text-align:right;">
429
</td>
<td style="text-align:right;">
1240
</td>
<td style="text-align:right;">
34.59677
</td>
<td style="text-align:right;">
0.5194
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
13.63636
</td>
<td style="text-align:right;">
0.03745
</td>
<td style="text-align:right;">
453
</td>
<td style="text-align:right;">
1416
</td>
<td style="text-align:right;">
31.99153
</td>
<td style="text-align:right;">
0.29440
</td>
<td style="text-align:right;">
234
</td>
<td style="text-align:right;">
2778
</td>
<td style="text-align:right;">
8.423326
</td>
<td style="text-align:right;">
0.35790
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
3851
</td>
<td style="text-align:right;">
3.895092
</td>
<td style="text-align:right;">
0.17230
</td>
<td style="text-align:right;">
959
</td>
<td style="text-align:right;">
23.66149
</td>
<td style="text-align:right;">
0.9384
</td>
<td style="text-align:right;">
1115
</td>
<td style="text-align:right;">
27.51049
</td>
<td style="text-align:right;">
0.8155
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
2898
</td>
<td style="text-align:right;">
8.695652
</td>
<td style="text-align:right;">
0.1725
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
1041
</td>
<td style="text-align:right;">
3.073967
</td>
<td style="text-align:right;">
0.05352
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
3821
</td>
<td style="text-align:right;">
2.5124313
</td>
<td style="text-align:right;">
0.6127
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
4053
</td>
<td style="text-align:right;">
4.317789
</td>
<td style="text-align:right;">
0.1678
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
2.8606965
</td>
<td style="text-align:right;">
0.38610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3204
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1416
</td>
<td style="text-align:right;">
0.7768362
</td>
<td style="text-align:right;">
0.4311
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
1416
</td>
<td style="text-align:right;">
3.036723
</td>
<td style="text-align:right;">
0.22200
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
4053
</td>
<td style="text-align:right;">
4.983962
</td>
<td style="text-align:right;">
0.8725
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010102
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010102
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
4833
</td>
<td style="text-align:right;">
1538
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
4.257529
</td>
<td style="text-align:right;">
0.08309
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
1799
</td>
<td style="text-align:right;">
4.335742
</td>
<td style="text-align:right;">
0.2178
</td>
<td style="text-align:right;">
478
</td>
<td style="text-align:right;">
1352
</td>
<td style="text-align:right;">
35.35503
</td>
<td style="text-align:right;">
0.5437
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
47.43590
</td>
<td style="text-align:right;">
0.54680
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
36.01399
</td>
<td style="text-align:right;">
0.42400
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
3159
</td>
<td style="text-align:right;">
2.089269
</td>
<td style="text-align:right;">
0.04865
</td>
<td style="text-align:right;">
156
</td>
<td style="text-align:right;">
4544
</td>
<td style="text-align:right;">
3.433099
</td>
<td style="text-align:right;">
0.14220
</td>
<td style="text-align:right;">
750
</td>
<td style="text-align:right;">
15.51831
</td>
<td style="text-align:right;">
0.6469
</td>
<td style="text-align:right;">
1419
</td>
<td style="text-align:right;">
29.36065
</td>
<td style="text-align:right;">
0.8840
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
3345
</td>
<td style="text-align:right;">
8.669656
</td>
<td style="text-align:right;">
0.1708
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1235
</td>
<td style="text-align:right;">
2.267206
</td>
<td style="text-align:right;">
0.03553
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
4538
</td>
<td style="text-align:right;">
2.8867342
</td>
<td style="text-align:right;">
0.6395
</td>
<td style="text-align:right;">
1176
</td>
<td style="text-align:right;">
4833
</td>
<td style="text-align:right;">
24.332713
</td>
<td style="text-align:right;">
0.5919
</td>
<td style="text-align:right;">
1538
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09502
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3204
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1525
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
7.062937
</td>
<td style="text-align:right;">
0.46710
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
4833
</td>
<td style="text-align:right;">
4.903786
</td>
<td style="text-align:right;">
0.8706
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010201
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010201
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
3550
</td>
<td style="text-align:right;">
1091
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
108
</td>
<td style="text-align:right;">
3346
</td>
<td style="text-align:right;">
3.227735
</td>
<td style="text-align:right;">
0.05048
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
950
</td>
<td style="text-align:right;">
5.578947
</td>
<td style="text-align:right;">
0.3654
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
903
</td>
<td style="text-align:right;">
27.24252
</td>
<td style="text-align:right;">
0.2833
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
17.77778
</td>
<td style="text-align:right;">
0.05548
</td>
<td style="text-align:right;">
254
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
26.79325
</td>
<td style="text-align:right;">
0.14380
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
2117
</td>
<td style="text-align:right;">
4.676429
</td>
<td style="text-align:right;">
0.15780
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
3217
</td>
<td style="text-align:right;">
1.523158
</td>
<td style="text-align:right;">
0.04121
</td>
<td style="text-align:right;">
672
</td>
<td style="text-align:right;">
18.92958
</td>
<td style="text-align:right;">
0.8255
</td>
<td style="text-align:right;">
1282
</td>
<td style="text-align:right;">
36.11268
</td>
<td style="text-align:right;">
0.9778
</td>
<td style="text-align:right;">
244
</td>
<td style="text-align:right;">
2146
</td>
<td style="text-align:right;">
11.369991
</td>
<td style="text-align:right;">
0.3628
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
894
</td>
<td style="text-align:right;">
7.941834
</td>
<td style="text-align:right;">
0.26130
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
3422
</td>
<td style="text-align:right;">
0.7305669
</td>
<td style="text-align:right;">
0.3653
</td>
<td style="text-align:right;">
300
</td>
<td style="text-align:right;">
3550
</td>
<td style="text-align:right;">
8.450704
</td>
<td style="text-align:right;">
0.3187
</td>
<td style="text-align:right;">
1091
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09502
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3204
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1525
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.01141
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
3550
</td>
<td style="text-align:right;">
5.746479
</td>
<td style="text-align:right;">
0.8862
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010202
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010202
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
4839
</td>
<td style="text-align:right;">
1928
</td>
<td style="text-align:right;">
1729
</td>
<td style="text-align:right;">
215
</td>
<td style="text-align:right;">
4826
</td>
<td style="text-align:right;">
4.455035
</td>
<td style="text-align:right;">
0.08982
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
2116
</td>
<td style="text-align:right;">
3.733459
</td>
<td style="text-align:right;">
0.1528
</td>
<td style="text-align:right;">
335
</td>
<td style="text-align:right;">
1413
</td>
<td style="text-align:right;">
23.70842
</td>
<td style="text-align:right;">
0.1771
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
316
</td>
<td style="text-align:right;">
20.25316
</td>
<td style="text-align:right;">
0.06942
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
1729
</td>
<td style="text-align:right;">
23.07692
</td>
<td style="text-align:right;">
0.06555
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
3374
</td>
<td style="text-align:right;">
4.416123
</td>
<td style="text-align:right;">
0.14510
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
5430
</td>
<td style="text-align:right;">
1.694291
</td>
<td style="text-align:right;">
0.04860
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
14.32114
</td>
<td style="text-align:right;">
0.5654
</td>
<td style="text-align:right;">
1304
</td>
<td style="text-align:right;">
26.94772
</td>
<td style="text-align:right;">
0.7899
</td>
<td style="text-align:right;">
332
</td>
<td style="text-align:right;">
3969
</td>
<td style="text-align:right;">
8.364827
</td>
<td style="text-align:right;">
0.1531
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
1323
</td>
<td style="text-align:right;">
5.366591
</td>
<td style="text-align:right;">
0.13510
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
4514
</td>
<td style="text-align:right;">
2.7248560
</td>
<td style="text-align:right;">
0.6284
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
4839
</td>
<td style="text-align:right;">
17.296962
</td>
<td style="text-align:right;">
0.5062
</td>
<td style="text-align:right;">
1928
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0.4668050
</td>
<td style="text-align:right;">
0.20820
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.5186722
</td>
<td style="text-align:right;">
0.6707
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1729
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1525
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1729
</td>
<td style="text-align:right;">
0.578369
</td>
<td style="text-align:right;">
0.03255
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4839
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3433
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010300
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010300
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
3847
</td>
<td style="text-align:right;">
1632
</td>
<td style="text-align:right;">
1421
</td>
<td style="text-align:right;">
218
</td>
<td style="text-align:right;">
3847
</td>
<td style="text-align:right;">
5.666753
</td>
<td style="text-align:right;">
0.13480
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
1463
</td>
<td style="text-align:right;">
7.245386
</td>
<td style="text-align:right;">
0.5540
</td>
<td style="text-align:right;">
398
</td>
<td style="text-align:right;">
1125
</td>
<td style="text-align:right;">
35.37778
</td>
<td style="text-align:right;">
0.5447
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
296
</td>
<td style="text-align:right;">
39.18919
</td>
<td style="text-align:right;">
0.34300
</td>
<td style="text-align:right;">
514
</td>
<td style="text-align:right;">
1421
</td>
<td style="text-align:right;">
36.17171
</td>
<td style="text-align:right;">
0.42800
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
2762
</td>
<td style="text-align:right;">
3.656770
</td>
<td style="text-align:right;">
0.10950
</td>
<td style="text-align:right;">
215
</td>
<td style="text-align:right;">
3910
</td>
<td style="text-align:right;">
5.498721
</td>
<td style="text-align:right;">
0.28470
</td>
<td style="text-align:right;">
732
</td>
<td style="text-align:right;">
19.02781
</td>
<td style="text-align:right;">
0.8296
</td>
<td style="text-align:right;">
961
</td>
<td style="text-align:right;">
24.98050
</td>
<td style="text-align:right;">
0.6777
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
2898
</td>
<td style="text-align:right;">
7.556936
</td>
<td style="text-align:right;">
0.1061
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1076
</td>
<td style="text-align:right;">
2.230483
</td>
<td style="text-align:right;">
0.03478
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
3668
</td>
<td style="text-align:right;">
0.4362050
</td>
<td style="text-align:right;">
0.2769
</td>
<td style="text-align:right;">
536
</td>
<td style="text-align:right;">
3847
</td>
<td style="text-align:right;">
13.932935
</td>
<td style="text-align:right;">
0.4482
</td>
<td style="text-align:right;">
1632
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
0.4901961
</td>
<td style="text-align:right;">
0.21090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3204
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1421
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1525
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1421
</td>
<td style="text-align:right;">
1.829697
</td>
<td style="text-align:right;">
0.11950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3847
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3433
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010400
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010400
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
5181
</td>
<td style="text-align:right;">
2250
</td>
<td style="text-align:right;">
2108
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
5181
</td>
<td style="text-align:right;">
7.044972
</td>
<td style="text-align:right;">
0.18980
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
2379
</td>
<td style="text-align:right;">
4.287516
</td>
<td style="text-align:right;">
0.2118
</td>
<td style="text-align:right;">
764
</td>
<td style="text-align:right;">
1600
</td>
<td style="text-align:right;">
47.75000
</td>
<td style="text-align:right;">
0.8269
</td>
<td style="text-align:right;">
275
</td>
<td style="text-align:right;">
508
</td>
<td style="text-align:right;">
54.13386
</td>
<td style="text-align:right;">
0.70890
</td>
<td style="text-align:right;">
1039
</td>
<td style="text-align:right;">
2108
</td>
<td style="text-align:right;">
49.28842
</td>
<td style="text-align:right;">
0.79620
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
3682
</td>
<td style="text-align:right;">
8.174905
</td>
<td style="text-align:right;">
0.34450
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
5252
</td>
<td style="text-align:right;">
9.006093
</td>
<td style="text-align:right;">
0.52990
</td>
<td style="text-align:right;">
1035
</td>
<td style="text-align:right;">
19.97684
</td>
<td style="text-align:right;">
0.8601
</td>
<td style="text-align:right;">
1333
</td>
<td style="text-align:right;">
25.72862
</td>
<td style="text-align:right;">
0.7257
</td>
<td style="text-align:right;">
661
</td>
<td style="text-align:right;">
4151
</td>
<td style="text-align:right;">
15.923874
</td>
<td style="text-align:right;">
0.6668
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
14.517318
</td>
<td style="text-align:right;">
0.55450
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
4767
</td>
<td style="text-align:right;">
1.4054961
</td>
<td style="text-align:right;">
0.4895
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
5181
</td>
<td style="text-align:right;">
11.484269
</td>
<td style="text-align:right;">
0.3994
</td>
<td style="text-align:right;">
2250
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
5.4666667
</td>
<td style="text-align:right;">
0.49320
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.4444444
</td>
<td style="text-align:right;">
0.6594
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
2108
</td>
<td style="text-align:right;">
1.2333966
</td>
<td style="text-align:right;">
0.5267
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
2108
</td>
<td style="text-align:right;">
2.988615
</td>
<td style="text-align:right;">
0.21810
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5181
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3433
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Regional
svi_2020_regional <- rank_variables(svi_2020, rank_by = "regional", location = region)
svi_2020_regional %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
09001010101
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010101
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
4192
</td>
<td style="text-align:right;">
1591
</td>
<td style="text-align:right;">
1347
</td>
<td style="text-align:right;">
241
</td>
<td style="text-align:right;">
3922
</td>
<td style="text-align:right;">
6.144824
</td>
<td style="text-align:right;">
0.144600
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
1947
</td>
<td style="text-align:right;">
3.903441
</td>
<td style="text-align:right;">
0.3806
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
1108
</td>
<td style="text-align:right;">
50.00000
</td>
<td style="text-align:right;">
0.9397
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
35.98326
</td>
<td style="text-align:right;">
0.29250
</td>
<td style="text-align:right;">
640
</td>
<td style="text-align:right;">
1347
</td>
<td style="text-align:right;">
47.51299
</td>
<td style="text-align:right;">
0.8415
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
3061
</td>
<td style="text-align:right;">
3.038223
</td>
<td style="text-align:right;">
0.14930
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
3922
</td>
<td style="text-align:right;">
0.1784804
</td>
<td style="text-align:right;">
0.014040
</td>
<td style="text-align:right;">
1238
</td>
<td style="text-align:right;">
29.53244
</td>
<td style="text-align:right;">
0.9500
</td>
<td style="text-align:right;">
908
</td>
<td style="text-align:right;">
21.66031
</td>
<td style="text-align:right;">
0.6033
</td>
<td style="text-align:right;">
259
</td>
<td style="text-align:right;">
3014.000
</td>
<td style="text-align:right;">
8.593232
</td>
<td style="text-align:right;">
0.15340
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
1033.000
</td>
<td style="text-align:right;">
6.2923524
</td>
<td style="text-align:right;">
0.20440
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
4022
</td>
<td style="text-align:right;">
1.5663849
</td>
<td style="text-align:right;">
0.50770
</td>
<td style="text-align:right;">
453
</td>
<td style="text-align:right;">
4192.000
</td>
<td style="text-align:right;">
10.80630
</td>
<td style="text-align:right;">
0.2732
</td>
<td style="text-align:right;">
1591
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.5713388
</td>
<td style="text-align:right;">
0.29150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3172
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1347
</td>
<td style="text-align:right;">
1.8559762
</td>
<td style="text-align:right;">
0.5608
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1347.000
</td>
<td style="text-align:right;">
2.4498886
</td>
<td style="text-align:right;">
0.17820
</td>
<td style="text-align:right;">
275
</td>
<td style="text-align:right;">
4192
</td>
<td style="text-align:right;">
6.5601145
</td>
<td style="text-align:right;">
0.9107
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010102
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010102
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
4419
</td>
<td style="text-align:right;">
1602
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
4419
</td>
<td style="text-align:right;">
1.357773
</td>
<td style="text-align:right;">
0.007698
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
2032
</td>
<td style="text-align:right;">
3.297244
</td>
<td style="text-align:right;">
0.2916
</td>
<td style="text-align:right;">
363
</td>
<td style="text-align:right;">
1231
</td>
<td style="text-align:right;">
29.48822
</td>
<td style="text-align:right;">
0.6387
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
22.13740
</td>
<td style="text-align:right;">
0.08811
</td>
<td style="text-align:right;">
392
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
28.78120
</td>
<td style="text-align:right;">
0.3840
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
2827
</td>
<td style="text-align:right;">
1.167315
</td>
<td style="text-align:right;">
0.03804
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4419
</td>
<td style="text-align:right;">
0.0905182
</td>
<td style="text-align:right;">
0.011050
</td>
<td style="text-align:right;">
828
</td>
<td style="text-align:right;">
18.73727
</td>
<td style="text-align:right;">
0.6218
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
27.33650
</td>
<td style="text-align:right;">
0.8876
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
3211.000
</td>
<td style="text-align:right;">
7.443164
</td>
<td style="text-align:right;">
0.09654
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1255.000
</td>
<td style="text-align:right;">
0.6374502
</td>
<td style="text-align:right;">
0.01594
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
4186
</td>
<td style="text-align:right;">
0.4061156
</td>
<td style="text-align:right;">
0.27980
</td>
<td style="text-align:right;">
539
</td>
<td style="text-align:right;">
4419.000
</td>
<td style="text-align:right;">
12.19733
</td>
<td style="text-align:right;">
0.3037
</td>
<td style="text-align:right;">
1602
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.08313
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3172
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1362
</td>
<td style="text-align:right;">
0.6607930
</td>
<td style="text-align:right;">
0.3515
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1362.000
</td>
<td style="text-align:right;">
1.2481645
</td>
<td style="text-align:right;">
0.08452
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
4419
</td>
<td style="text-align:right;">
0.4525911
</td>
<td style="text-align:right;">
0.5565
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010201
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010201
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
3429
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
181
</td>
<td style="text-align:right;">
3277
</td>
<td style="text-align:right;">
5.523345
</td>
<td style="text-align:right;">
0.120100
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
1201
</td>
<td style="text-align:right;">
6.328060
</td>
<td style="text-align:right;">
0.6691
</td>
<td style="text-align:right;">
255
</td>
<td style="text-align:right;">
978
</td>
<td style="text-align:right;">
26.07362
</td>
<td style="text-align:right;">
0.5312
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
141
</td>
<td style="text-align:right;">
17.02128
</td>
<td style="text-align:right;">
0.05272
</td>
<td style="text-align:right;">
279
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
24.93298
</td>
<td style="text-align:right;">
0.2590
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
2207
</td>
<td style="text-align:right;">
1.993656
</td>
<td style="text-align:right;">
0.07981
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3277
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.004705
</td>
<td style="text-align:right;">
741
</td>
<td style="text-align:right;">
21.60980
</td>
<td style="text-align:right;">
0.7671
</td>
<td style="text-align:right;">
964
</td>
<td style="text-align:right;">
28.11315
</td>
<td style="text-align:right;">
0.9053
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
2313.000
</td>
<td style="text-align:right;">
6.830955
</td>
<td style="text-align:right;">
0.07420
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
871.000
</td>
<td style="text-align:right;">
2.4110218
</td>
<td style="text-align:right;">
0.04849
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
3218
</td>
<td style="text-align:right;">
0.3107520
</td>
<td style="text-align:right;">
0.24640
</td>
<td style="text-align:right;">
561
</td>
<td style="text-align:right;">
3429.000
</td>
<td style="text-align:right;">
16.36045
</td>
<td style="text-align:right;">
0.3846
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1.9123506
</td>
<td style="text-align:right;">
0.31520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3172
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1244
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1119.000
</td>
<td style="text-align:right;">
2.1447721
</td>
<td style="text-align:right;">
0.15360
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
3429
</td>
<td style="text-align:right;">
7.3199183
</td>
<td style="text-align:right;">
0.9178
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010202
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010202
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
5262
</td>
<td style="text-align:right;">
1917
</td>
<td style="text-align:right;">
1811
</td>
<td style="text-align:right;">
647
</td>
<td style="text-align:right;">
5245
</td>
<td style="text-align:right;">
12.335558
</td>
<td style="text-align:right;">
0.390800
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
2620
</td>
<td style="text-align:right;">
6.450382
</td>
<td style="text-align:right;">
0.6798
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
1294
</td>
<td style="text-align:right;">
26.73879
</td>
<td style="text-align:right;">
0.5524
</td>
<td style="text-align:right;">
272
</td>
<td style="text-align:right;">
517
</td>
<td style="text-align:right;">
52.61122
</td>
<td style="text-align:right;">
0.68900
</td>
<td style="text-align:right;">
618
</td>
<td style="text-align:right;">
1811
</td>
<td style="text-align:right;">
34.12479
</td>
<td style="text-align:right;">
0.5544
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
3433
</td>
<td style="text-align:right;">
5.097582
</td>
<td style="text-align:right;">
0.29890
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
5263
</td>
<td style="text-align:right;">
1.5770473
</td>
<td style="text-align:right;">
0.158300
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
16.78069
</td>
<td style="text-align:right;">
0.5027
</td>
<td style="text-align:right;">
1550
</td>
<td style="text-align:right;">
29.45648
</td>
<td style="text-align:right;">
0.9311
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
3713.163
</td>
<td style="text-align:right;">
10.314657
</td>
<td style="text-align:right;">
0.26320
</td>
<td style="text-align:right;">
136
</td>
<td style="text-align:right;">
1483.018
</td>
<td style="text-align:right;">
9.1704909
</td>
<td style="text-align:right;">
0.34670
</td>
<td style="text-align:right;">
157
</td>
<td style="text-align:right;">
5042
</td>
<td style="text-align:right;">
3.1138437
</td>
<td style="text-align:right;">
0.64660
</td>
<td style="text-align:right;">
1339
</td>
<td style="text-align:right;">
5261.892
</td>
<td style="text-align:right;">
25.44712
</td>
<td style="text-align:right;">
0.5154
</td>
<td style="text-align:right;">
1917
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
0.3651539
</td>
<td style="text-align:right;">
0.18520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3172
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1811
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1244
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1811.390
</td>
<td style="text-align:right;">
2.3186617
</td>
<td style="text-align:right;">
0.16720
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
5262
</td>
<td style="text-align:right;">
0.1520334
</td>
<td style="text-align:right;">
0.3711
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010300
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010300
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
3815
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
1457
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3810
</td>
<td style="text-align:right;">
2.335958
</td>
<td style="text-align:right;">
0.020850
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
4.404568
</td>
<td style="text-align:right;">
0.4541
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1038
</td>
<td style="text-align:right;">
28.22736
</td>
<td style="text-align:right;">
0.6002
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
419
</td>
<td style="text-align:right;">
17.89976
</td>
<td style="text-align:right;">
0.05786
</td>
<td style="text-align:right;">
368
</td>
<td style="text-align:right;">
1457
</td>
<td style="text-align:right;">
25.25738
</td>
<td style="text-align:right;">
0.2693
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
2698
</td>
<td style="text-align:right;">
1.297257
</td>
<td style="text-align:right;">
0.04371
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
3809
</td>
<td style="text-align:right;">
0.9976372
</td>
<td style="text-align:right;">
0.083710
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
19.44954
</td>
<td style="text-align:right;">
0.6605
</td>
<td style="text-align:right;">
881
</td>
<td style="text-align:right;">
23.09305
</td>
<td style="text-align:right;">
0.6986
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
2928.576
</td>
<td style="text-align:right;">
4.234140
</td>
<td style="text-align:right;">
0.01599
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
1164.582
</td>
<td style="text-align:right;">
2.6618993
</td>
<td style="text-align:right;">
0.05612
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3612
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.07348
</td>
<td style="text-align:right;">
502
</td>
<td style="text-align:right;">
3815.450
</td>
<td style="text-align:right;">
13.15703
</td>
<td style="text-align:right;">
0.3245
</td>
<td style="text-align:right;">
1664
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
3.0649038
</td>
<td style="text-align:right;">
0.37610
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
0.781250
</td>
<td style="text-align:right;">
0.7117
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1457
</td>
<td style="text-align:right;">
0.8922443
</td>
<td style="text-align:right;">
0.4053
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1456.744
</td>
<td style="text-align:right;">
0.8924009
</td>
<td style="text-align:right;">
0.05999
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
3815
</td>
<td style="text-align:right;">
1.5203145
</td>
<td style="text-align:right;">
0.7278
</td>
</tr>
<tr>
<td style="text-align:left;">
09001010400
</td>
<td style="text-align:left;">
09
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
010400
</td>
<td style="text-align:left;">
CT
</td>
<td style="text-align:left;">
Connecticut
</td>
<td style="text-align:left;">
Fairfield County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
New England Division
</td>
<td style="text-align:right;">
5846
</td>
<td style="text-align:right;">
2131
</td>
<td style="text-align:right;">
1978
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
5846
</td>
<td style="text-align:right;">
6.021211
</td>
<td style="text-align:right;">
0.139600
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
3470
</td>
<td style="text-align:right;">
4.927954
</td>
<td style="text-align:right;">
0.5229
</td>
<td style="text-align:right;">
259
</td>
<td style="text-align:right;">
1285
</td>
<td style="text-align:right;">
20.15564
</td>
<td style="text-align:right;">
0.3169
</td>
<td style="text-align:right;">
339
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
48.91775
</td>
<td style="text-align:right;">
0.59620
</td>
<td style="text-align:right;">
598
</td>
<td style="text-align:right;">
1978
</td>
<td style="text-align:right;">
30.23256
</td>
<td style="text-align:right;">
0.4314
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
4282
</td>
<td style="text-align:right;">
3.946754
</td>
<td style="text-align:right;">
0.21520
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
5846
</td>
<td style="text-align:right;">
5.8501540
</td>
<td style="text-align:right;">
0.656600
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
16.21622
</td>
<td style="text-align:right;">
0.4662
</td>
<td style="text-align:right;">
1144
</td>
<td style="text-align:right;">
19.56894
</td>
<td style="text-align:right;">
0.4424
</td>
<td style="text-align:right;">
590
</td>
<td style="text-align:right;">
4702.000
</td>
<td style="text-align:right;">
12.547852
</td>
<td style="text-align:right;">
0.41400
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1561.000
</td>
<td style="text-align:right;">
11.9795003
</td>
<td style="text-align:right;">
0.47280
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
5567
</td>
<td style="text-align:right;">
1.2933357
</td>
<td style="text-align:right;">
0.47110
</td>
<td style="text-align:right;">
946
</td>
<td style="text-align:right;">
5846.000
</td>
<td style="text-align:right;">
16.18200
</td>
<td style="text-align:right;">
0.3817
</td>
<td style="text-align:right;">
2131
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
4.3172220
</td>
<td style="text-align:right;">
0.42850
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
1.079306
</td>
<td style="text-align:right;">
0.7367
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
1978
</td>
<td style="text-align:right;">
3.8422649
</td>
<td style="text-align:right;">
0.7360
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
1978.000
</td>
<td style="text-align:right;">
0.7583418
</td>
<td style="text-align:right;">
0.04981
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
5846
</td>
<td style="text-align:right;">
0.3934314
</td>
<td style="text-align:right;">
0.5304
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Divisional
svi_2010_divisional <- rank_variables(svi_2010, rank_by = "divisional", location = census_division)
svi_2010_divisional %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
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
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
34001000100
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2907
</td>
<td style="text-align:right;">
1088
</td>
<td style="text-align:right;">
983
</td>
<td style="text-align:right;">
1127
</td>
<td style="text-align:right;">
2907
</td>
<td style="text-align:right;">
38.76849
</td>
<td style="text-align:right;">
0.8482
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
1433
</td>
<td style="text-align:right;">
10.048849
</td>
<td style="text-align:right;">
0.7544
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
435
</td>
<td style="text-align:right;">
64.36782
</td>
<td style="text-align:right;">
0.9529
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
548
</td>
<td style="text-align:right;">
37.22628
</td>
<td style="text-align:right;">
0.2998
</td>
<td style="text-align:right;">
484
</td>
<td style="text-align:right;">
983
</td>
<td style="text-align:right;">
49.23703
</td>
<td style="text-align:right;">
0.7813
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
1759
</td>
<td style="text-align:right;">
26.60603
</td>
<td style="text-align:right;">
0.8634
</td>
<td style="text-align:right;">
532
</td>
<td style="text-align:right;">
2543
</td>
<td style="text-align:right;">
20.92017
</td>
<td style="text-align:right;">
0.8978
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
8.599931
</td>
<td style="text-align:right;">
0.1777
</td>
<td style="text-align:right;">
944
</td>
<td style="text-align:right;">
32.47334
</td>
<td style="text-align:right;">
0.94170
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
1851
</td>
<td style="text-align:right;">
10.04862
</td>
<td style="text-align:right;">
0.2706
</td>
<td style="text-align:right;">
266
</td>
<td style="text-align:right;">
678
</td>
<td style="text-align:right;">
39.233038
</td>
<td style="text-align:right;">
0.8981
</td>
<td style="text-align:right;">
177
</td>
<td style="text-align:right;">
2611
</td>
<td style="text-align:right;">
6.779012
</td>
<td style="text-align:right;">
0.7778
</td>
<td style="text-align:right;">
1928
</td>
<td style="text-align:right;">
2907
</td>
<td style="text-align:right;">
66.32267
</td>
<td style="text-align:right;">
0.7743
</td>
<td style="text-align:right;">
1088
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
10.386029
</td>
<td style="text-align:right;">
0.6229
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0.8272059
</td>
<td style="text-align:right;">
0.7223
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
983
</td>
<td style="text-align:right;">
8.138352
</td>
<td style="text-align:right;">
0.8657
</td>
<td style="text-align:right;">
265
</td>
<td style="text-align:right;">
983
</td>
<td style="text-align:right;">
26.95829
</td>
<td style="text-align:right;">
0.7354
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2907
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3512
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000200
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000200
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3189
</td>
<td style="text-align:right;">
2217
</td>
<td style="text-align:right;">
1473
</td>
<td style="text-align:right;">
519
</td>
<td style="text-align:right;">
3189
</td>
<td style="text-align:right;">
16.27469
</td>
<td style="text-align:right;">
0.4806
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
6.996149
</td>
<td style="text-align:right;">
0.5179
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
955
</td>
<td style="text-align:right;">
60.00000
</td>
<td style="text-align:right;">
0.9323
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
518
</td>
<td style="text-align:right;">
38.41699
</td>
<td style="text-align:right;">
0.3261
</td>
<td style="text-align:right;">
772
</td>
<td style="text-align:right;">
1473
</td>
<td style="text-align:right;">
52.41005
</td>
<td style="text-align:right;">
0.8418
</td>
<td style="text-align:right;">
405
</td>
<td style="text-align:right;">
2579
</td>
<td style="text-align:right;">
15.70376
</td>
<td style="text-align:right;">
0.6491
</td>
<td style="text-align:right;">
484
</td>
<td style="text-align:right;">
3547
</td>
<td style="text-align:right;">
13.64533
</td>
<td style="text-align:right;">
0.7154
</td>
<td style="text-align:right;">
847
</td>
<td style="text-align:right;">
26.560050
</td>
<td style="text-align:right;">
0.9629
</td>
<td style="text-align:right;">
436
</td>
<td style="text-align:right;">
13.67200
</td>
<td style="text-align:right;">
0.08181
</td>
<td style="text-align:right;">
608
</td>
<td style="text-align:right;">
3005
</td>
<td style="text-align:right;">
20.23295
</td>
<td style="text-align:right;">
0.8466
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
857
</td>
<td style="text-align:right;">
4.900817
</td>
<td style="text-align:right;">
0.1204
</td>
<td style="text-align:right;">
422
</td>
<td style="text-align:right;">
3072
</td>
<td style="text-align:right;">
13.736979
</td>
<td style="text-align:right;">
0.8799
</td>
<td style="text-align:right;">
1792
</td>
<td style="text-align:right;">
3189
</td>
<td style="text-align:right;">
56.19316
</td>
<td style="text-align:right;">
0.7390
</td>
<td style="text-align:right;">
2217
</td>
<td style="text-align:right;">
901
</td>
<td style="text-align:right;">
40.640505
</td>
<td style="text-align:right;">
0.8693
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3251
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
1473
</td>
<td style="text-align:right;">
3.258656
</td>
<td style="text-align:right;">
0.7064
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
1473
</td>
<td style="text-align:right;">
16.97217
</td>
<td style="text-align:right;">
0.6444
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3189
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3512
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000300
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000300
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3997
</td>
<td style="text-align:right;">
1823
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
1401
</td>
<td style="text-align:right;">
3968
</td>
<td style="text-align:right;">
35.30746
</td>
<td style="text-align:right;">
0.8164
</td>
<td style="text-align:right;">
382
</td>
<td style="text-align:right;">
2238
</td>
<td style="text-align:right;">
17.068811
</td>
<td style="text-align:right;">
0.9376
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
53.49544
</td>
<td style="text-align:right;">
0.8855
</td>
<td style="text-align:right;">
604
</td>
<td style="text-align:right;">
1028
</td>
<td style="text-align:right;">
58.75486
</td>
<td style="text-align:right;">
0.7947
</td>
<td style="text-align:right;">
780
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
57.47973
</td>
<td style="text-align:right;">
0.9165
</td>
<td style="text-align:right;">
920
</td>
<td style="text-align:right;">
2677
</td>
<td style="text-align:right;">
34.36683
</td>
<td style="text-align:right;">
0.9346
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
4149
</td>
<td style="text-align:right;">
32.56206
</td>
<td style="text-align:right;">
0.9811
</td>
<td style="text-align:right;">
314
</td>
<td style="text-align:right;">
7.855892
</td>
<td style="text-align:right;">
0.1437
</td>
<td style="text-align:right;">
937
</td>
<td style="text-align:right;">
23.44258
</td>
<td style="text-align:right;">
0.55900
</td>
<td style="text-align:right;">
319
</td>
<td style="text-align:right;">
3054
</td>
<td style="text-align:right;">
10.44532
</td>
<td style="text-align:right;">
0.3000
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
782
</td>
<td style="text-align:right;">
23.913044
</td>
<td style="text-align:right;">
0.7498
</td>
<td style="text-align:right;">
1080
</td>
<td style="text-align:right;">
3671
</td>
<td style="text-align:right;">
29.419777
</td>
<td style="text-align:right;">
0.9742
</td>
<td style="text-align:right;">
3357
</td>
<td style="text-align:right;">
3997
</td>
<td style="text-align:right;">
83.98799
</td>
<td style="text-align:right;">
0.8419
</td>
<td style="text-align:right;">
1823
</td>
<td style="text-align:right;">
363
</td>
<td style="text-align:right;">
19.912233
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3251
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
11.053795
</td>
<td style="text-align:right;">
0.9136
</td>
<td style="text-align:right;">
651
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
47.97347
</td>
<td style="text-align:right;">
0.8585
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3997
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3512
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000400
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000400
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2902
</td>
<td style="text-align:right;">
2683
</td>
<td style="text-align:right;">
1401
</td>
<td style="text-align:right;">
1172
</td>
<td style="text-align:right;">
2902
</td>
<td style="text-align:right;">
40.38594
</td>
<td style="text-align:right;">
0.8615
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
1389
</td>
<td style="text-align:right;">
13.678906
</td>
<td style="text-align:right;">
0.8811
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
707
</td>
<td style="text-align:right;">
51.48515
</td>
<td style="text-align:right;">
0.8627
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
73.05476
</td>
<td style="text-align:right;">
0.9503
</td>
<td style="text-align:right;">
871
</td>
<td style="text-align:right;">
1401
</td>
<td style="text-align:right;">
62.16988
</td>
<td style="text-align:right;">
0.9572
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
1981
</td>
<td style="text-align:right;">
24.28067
</td>
<td style="text-align:right;">
0.8339
</td>
<td style="text-align:right;">
674
</td>
<td style="text-align:right;">
3204
</td>
<td style="text-align:right;">
21.03620
</td>
<td style="text-align:right;">
0.8998
</td>
<td style="text-align:right;">
434
</td>
<td style="text-align:right;">
14.955203
</td>
<td style="text-align:right;">
0.6083
</td>
<td style="text-align:right;">
596
</td>
<td style="text-align:right;">
20.53756
</td>
<td style="text-align:right;">
0.33980
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
2607
</td>
<td style="text-align:right;">
16.34062
</td>
<td style="text-align:right;">
0.6886
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
652
</td>
<td style="text-align:right;">
17.024540
</td>
<td style="text-align:right;">
0.6204
</td>
<td style="text-align:right;">
215
</td>
<td style="text-align:right;">
2736
</td>
<td style="text-align:right;">
7.858187
</td>
<td style="text-align:right;">
0.8008
</td>
<td style="text-align:right;">
1792
</td>
<td style="text-align:right;">
2902
</td>
<td style="text-align:right;">
61.75052
</td>
<td style="text-align:right;">
0.7584
</td>
<td style="text-align:right;">
2683
</td>
<td style="text-align:right;">
2049
</td>
<td style="text-align:right;">
76.369735
</td>
<td style="text-align:right;">
0.9401
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3251
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
1401
</td>
<td style="text-align:right;">
4.925053
</td>
<td style="text-align:right;">
0.7847
</td>
<td style="text-align:right;">
511
</td>
<td style="text-align:right;">
1401
</td>
<td style="text-align:right;">
36.47395
</td>
<td style="text-align:right;">
0.7992
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
2902
</td>
<td style="text-align:right;">
2.481048
</td>
<td style="text-align:right;">
0.8114
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000500
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000500
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3483
</td>
<td style="text-align:right;">
1241
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
1938
</td>
<td style="text-align:right;">
3483
</td>
<td style="text-align:right;">
55.64169
</td>
<td style="text-align:right;">
0.9533
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
1630
</td>
<td style="text-align:right;">
7.607362
</td>
<td style="text-align:right;">
0.5830
</td>
<td style="text-align:right;">
227
</td>
<td style="text-align:right;">
446
</td>
<td style="text-align:right;">
50.89686
</td>
<td style="text-align:right;">
0.8549
</td>
<td style="text-align:right;">
478
</td>
<td style="text-align:right;">
581
</td>
<td style="text-align:right;">
82.27194
</td>
<td style="text-align:right;">
0.9799
</td>
<td style="text-align:right;">
705
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
68.64654
</td>
<td style="text-align:right;">
0.9863
</td>
<td style="text-align:right;">
733
</td>
<td style="text-align:right;">
2077
</td>
<td style="text-align:right;">
35.29129
</td>
<td style="text-align:right;">
0.9396
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
3258
</td>
<td style="text-align:right;">
22.31430
</td>
<td style="text-align:right;">
0.9149
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
10.824002
</td>
<td style="text-align:right;">
0.3081
</td>
<td style="text-align:right;">
1055
</td>
<td style="text-align:right;">
30.28998
</td>
<td style="text-align:right;">
0.90140
</td>
<td style="text-align:right;">
268
</td>
<td style="text-align:right;">
2401
</td>
<td style="text-align:right;">
11.16202
</td>
<td style="text-align:right;">
0.3549
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
763
</td>
<td style="text-align:right;">
27.391874
</td>
<td style="text-align:right;">
0.7940
</td>
<td style="text-align:right;">
911
</td>
<td style="text-align:right;">
3077
</td>
<td style="text-align:right;">
29.606760
</td>
<td style="text-align:right;">
0.9746
</td>
<td style="text-align:right;">
3036
</td>
<td style="text-align:right;">
3483
</td>
<td style="text-align:right;">
87.16624
</td>
<td style="text-align:right;">
0.8550
</td>
<td style="text-align:right;">
1241
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
4.190169
</td>
<td style="text-align:right;">
0.4505
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.3223207
</td>
<td style="text-align:right;">
0.6567
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
11.002921
</td>
<td style="text-align:right;">
0.9128
</td>
<td style="text-align:right;">
422
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
41.09056
</td>
<td style="text-align:right;">
0.8250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3483
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3512
</td>
</tr>
<tr>
<td style="text-align:left;">
34001001100
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
001100
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2204
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
1185
</td>
<td style="text-align:right;">
2204
</td>
<td style="text-align:right;">
53.76588
</td>
<td style="text-align:right;">
0.9457
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
927
</td>
<td style="text-align:right;">
23.624596
</td>
<td style="text-align:right;">
0.9830
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
56.39535
</td>
<td style="text-align:right;">
0.9094
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
44.76744
</td>
<td style="text-align:right;">
0.4746
</td>
<td style="text-align:right;">
559
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
46.42857
</td>
<td style="text-align:right;">
0.7197
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
24.02778
</td>
<td style="text-align:right;">
0.8306
</td>
<td style="text-align:right;">
469
</td>
<td style="text-align:right;">
1942
</td>
<td style="text-align:right;">
24.15036
</td>
<td style="text-align:right;">
0.9360
</td>
<td style="text-align:right;">
363
</td>
<td style="text-align:right;">
16.470054
</td>
<td style="text-align:right;">
0.7020
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:right;">
26.22505
</td>
<td style="text-align:right;">
0.74410
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
28.36970
</td>
<td style="text-align:right;">
0.9675
</td>
<td style="text-align:right;">
247
</td>
<td style="text-align:right;">
396
</td>
<td style="text-align:right;">
62.373737
</td>
<td style="text-align:right;">
0.9898
</td>
<td style="text-align:right;">
104
</td>
<td style="text-align:right;">
2051
</td>
<td style="text-align:right;">
5.070697
</td>
<td style="text-align:right;">
0.7260
</td>
<td style="text-align:right;">
2118
</td>
<td style="text-align:right;">
2204
</td>
<td style="text-align:right;">
96.09800
</td>
<td style="text-align:right;">
0.9204
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
47.342193
</td>
<td style="text-align:right;">
0.8858
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3251
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
1.162791
</td>
<td style="text-align:right;">
0.4877
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
67.85714
</td>
<td style="text-align:right;">
0.9413
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2204
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3512
</td>
</tr>
</tbody>
</table>

</div>

``` r
# Divisional
svi_2020_divisional <- rank_variables(svi_2020, rank_by = "divisional", location = census_division)
svi_2020_divisional %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
34001000100
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2157
</td>
<td style="text-align:right;">
941
</td>
<td style="text-align:right;">
784
</td>
<td style="text-align:right;">
1182
</td>
<td style="text-align:right;">
2157
</td>
<td style="text-align:right;">
54.79833
</td>
<td style="text-align:right;">
0.9571
</td>
<td style="text-align:right;">
242
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
22.873346
</td>
<td style="text-align:right;">
0.9922
</td>
<td style="text-align:right;">
215
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
62.86550
</td>
<td style="text-align:right;">
0.9780
</td>
<td style="text-align:right;">
316
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
71.49321
</td>
<td style="text-align:right;">
0.9481
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
784
</td>
<td style="text-align:right;">
67.72959
</td>
<td style="text-align:right;">
0.9893
</td>
<td style="text-align:right;">
396
</td>
<td style="text-align:right;">
1274
</td>
<td style="text-align:right;">
31.08320
</td>
<td style="text-align:right;">
0.9497
</td>
<td style="text-align:right;">
266
</td>
<td style="text-align:right;">
2157
</td>
<td style="text-align:right;">
12.331943
</td>
<td style="text-align:right;">
0.9041
</td>
<td style="text-align:right;">
185
</td>
<td style="text-align:right;">
8.576727
</td>
<td style="text-align:right;">
0.09430
</td>
<td style="text-align:right;">
552
</td>
<td style="text-align:right;">
25.59110
</td>
<td style="text-align:right;">
0.8128
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
0.74880
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
16.27451
</td>
<td style="text-align:right;">
0.6090
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
12.425743
</td>
<td style="text-align:right;">
0.8710
</td>
<td style="text-align:right;">
1852
</td>
<td style="text-align:right;">
2157
</td>
<td style="text-align:right;">
85.85999
</td>
<td style="text-align:right;">
0.8476
</td>
<td style="text-align:right;">
941
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
12.5398512
</td>
<td style="text-align:right;">
0.6385
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
784
</td>
<td style="text-align:right;">
8.545918
</td>
<td style="text-align:right;">
0.8657
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
784
</td>
<td style="text-align:right;">
27.04082
</td>
<td style="text-align:right;">
0.7502
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2157
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1517
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000200
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000200
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3510
</td>
<td style="text-align:right;">
2046
</td>
<td style="text-align:right;">
1353
</td>
<td style="text-align:right;">
1021
</td>
<td style="text-align:right;">
3510
</td>
<td style="text-align:right;">
29.08832
</td>
<td style="text-align:right;">
0.7682
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
1852
</td>
<td style="text-align:right;">
6.533477
</td>
<td style="text-align:right;">
0.6717
</td>
<td style="text-align:right;">
343
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
49.28161
</td>
<td style="text-align:right;">
0.9273
</td>
<td style="text-align:right;">
416
</td>
<td style="text-align:right;">
657
</td>
<td style="text-align:right;">
63.31811
</td>
<td style="text-align:right;">
0.8696
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
1353
</td>
<td style="text-align:right;">
56.09756
</td>
<td style="text-align:right;">
0.9321
</td>
<td style="text-align:right;">
553
</td>
<td style="text-align:right;">
2338
</td>
<td style="text-align:right;">
23.65269
</td>
<td style="text-align:right;">
0.8871
</td>
<td style="text-align:right;">
354
</td>
<td style="text-align:right;">
3510
</td>
<td style="text-align:right;">
10.085470
</td>
<td style="text-align:right;">
0.8530
</td>
<td style="text-align:right;">
643
</td>
<td style="text-align:right;">
18.319088
</td>
<td style="text-align:right;">
0.60310
</td>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
28.54701
</td>
<td style="text-align:right;">
0.9055
</td>
<td style="text-align:right;">
450
</td>
<td style="text-align:right;">
2508
</td>
<td style="text-align:right;">
17.942584
</td>
<td style="text-align:right;">
0.72330
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
786
</td>
<td style="text-align:right;">
30.15267
</td>
<td style="text-align:right;">
0.8539
</td>
<td style="text-align:right;">
534
</td>
<td style="text-align:right;">
3375
</td>
<td style="text-align:right;">
15.822222
</td>
<td style="text-align:right;">
0.9062
</td>
<td style="text-align:right;">
2534
</td>
<td style="text-align:right;">
3510
</td>
<td style="text-align:right;">
72.19373
</td>
<td style="text-align:right;">
0.7818
</td>
<td style="text-align:right;">
2046
</td>
<td style="text-align:right;">
906
</td>
<td style="text-align:right;">
44.2815249
</td>
<td style="text-align:right;">
0.8690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
119
</td>
<td style="text-align:right;">
1353
</td>
<td style="text-align:right;">
8.795270
</td>
<td style="text-align:right;">
0.8711
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
1353
</td>
<td style="text-align:right;">
23.94678
</td>
<td style="text-align:right;">
0.7255
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3510
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1517
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000300
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000300
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3801
</td>
<td style="text-align:right;">
1640
</td>
<td style="text-align:right;">
1226
</td>
<td style="text-align:right;">
1857
</td>
<td style="text-align:right;">
3801
</td>
<td style="text-align:right;">
48.85556
</td>
<td style="text-align:right;">
0.9333
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
1800
</td>
<td style="text-align:right;">
12.555556
</td>
<td style="text-align:right;">
0.9267
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
39.64286
</td>
<td style="text-align:right;">
0.8339
</td>
<td style="text-align:right;">
608
</td>
<td style="text-align:right;">
946
</td>
<td style="text-align:right;">
64.27061
</td>
<td style="text-align:right;">
0.8842
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
1226
</td>
<td style="text-align:right;">
58.64600
</td>
<td style="text-align:right;">
0.9528
</td>
<td style="text-align:right;">
650
</td>
<td style="text-align:right;">
2275
</td>
<td style="text-align:right;">
28.57143
</td>
<td style="text-align:right;">
0.9337
</td>
<td style="text-align:right;">
1027
</td>
<td style="text-align:right;">
3801
</td>
<td style="text-align:right;">
27.019206
</td>
<td style="text-align:right;">
0.9914
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
9.997369
</td>
<td style="text-align:right;">
0.14040
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
32.17574
</td>
<td style="text-align:right;">
0.9607
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
2578
</td>
<td style="text-align:right;">
8.494957
</td>
<td style="text-align:right;">
0.15680
</td>
<td style="text-align:right;">
268
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
29.48295
</td>
<td style="text-align:right;">
0.8456
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
3400
</td>
<td style="text-align:right;">
27.647059
</td>
<td style="text-align:right;">
0.9728
</td>
<td style="text-align:right;">
3318
</td>
<td style="text-align:right;">
3801
</td>
<td style="text-align:right;">
87.29282
</td>
<td style="text-align:right;">
0.8579
</td>
<td style="text-align:right;">
1640
</td>
<td style="text-align:right;">
262
</td>
<td style="text-align:right;">
15.9756098
</td>
<td style="text-align:right;">
0.6917
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
1226
</td>
<td style="text-align:right;">
10.114192
</td>
<td style="text-align:right;">
0.8955
</td>
<td style="text-align:right;">
477
</td>
<td style="text-align:right;">
1226
</td>
<td style="text-align:right;">
38.90701
</td>
<td style="text-align:right;">
0.8258
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3801
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1517
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000400
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000400
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3178
</td>
<td style="text-align:right;">
2264
</td>
<td style="text-align:right;">
1390
</td>
<td style="text-align:right;">
1508
</td>
<td style="text-align:right;">
3176
</td>
<td style="text-align:right;">
47.48111
</td>
<td style="text-align:right;">
0.9246
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
1804
</td>
<td style="text-align:right;">
9.534368
</td>
<td style="text-align:right;">
0.8460
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
43.80342
</td>
<td style="text-align:right;">
0.8858
</td>
<td style="text-align:right;">
622
</td>
<td style="text-align:right;">
922
</td>
<td style="text-align:right;">
67.46204
</td>
<td style="text-align:right;">
0.9192
</td>
<td style="text-align:right;">
827
</td>
<td style="text-align:right;">
1390
</td>
<td style="text-align:right;">
59.49640
</td>
<td style="text-align:right;">
0.9587
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
2076
</td>
<td style="text-align:right;">
17.53372
</td>
<td style="text-align:right;">
0.8013
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
3178
</td>
<td style="text-align:right;">
14.977974
</td>
<td style="text-align:right;">
0.9390
</td>
<td style="text-align:right;">
483
</td>
<td style="text-align:right;">
15.198238
</td>
<td style="text-align:right;">
0.41220
</td>
<td style="text-align:right;">
539
</td>
<td style="text-align:right;">
16.96035
</td>
<td style="text-align:right;">
0.2484
</td>
<td style="text-align:right;">
319
</td>
<td style="text-align:right;">
2639
</td>
<td style="text-align:right;">
12.087912
</td>
<td style="text-align:right;">
0.38790
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
565
</td>
<td style="text-align:right;">
17.87611
</td>
<td style="text-align:right;">
0.6539
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
3022
</td>
<td style="text-align:right;">
19.291860
</td>
<td style="text-align:right;">
0.9349
</td>
<td style="text-align:right;">
2186
</td>
<td style="text-align:right;">
3178
</td>
<td style="text-align:right;">
68.78540
</td>
<td style="text-align:right;">
0.7658
</td>
<td style="text-align:right;">
2264
</td>
<td style="text-align:right;">
1609
</td>
<td style="text-align:right;">
71.0689046
</td>
<td style="text-align:right;">
0.9266
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
0.6625442
</td>
<td style="text-align:right;">
0.7078
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
1390
</td>
<td style="text-align:right;">
16.258993
</td>
<td style="text-align:right;">
0.9567
</td>
<td style="text-align:right;">
599
</td>
<td style="text-align:right;">
1390
</td>
<td style="text-align:right;">
43.09353
</td>
<td style="text-align:right;">
0.8474
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
3178
</td>
<td style="text-align:right;">
0.6293266
</td>
<td style="text-align:right;">
0.6292
</td>
</tr>
<tr>
<td style="text-align:left;">
34001000500
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
000500
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3385
</td>
<td style="text-align:right;">
1185
</td>
<td style="text-align:right;">
945
</td>
<td style="text-align:right;">
1682
</td>
<td style="text-align:right;">
3364
</td>
<td style="text-align:right;">
50.00000
</td>
<td style="text-align:right;">
0.9391
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1577
</td>
<td style="text-align:right;">
4.565631
</td>
<td style="text-align:right;">
0.4586
</td>
<td style="text-align:right;">
185
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
39.52991
</td>
<td style="text-align:right;">
0.8332
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
477
</td>
<td style="text-align:right;">
75.89099
</td>
<td style="text-align:right;">
0.9703
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
945
</td>
<td style="text-align:right;">
57.88360
</td>
<td style="text-align:right;">
0.9477
</td>
<td style="text-align:right;">
592
</td>
<td style="text-align:right;">
1983
</td>
<td style="text-align:right;">
29.85376
</td>
<td style="text-align:right;">
0.9422
</td>
<td style="text-align:right;">
738
</td>
<td style="text-align:right;">
3385
</td>
<td style="text-align:right;">
21.802068
</td>
<td style="text-align:right;">
0.9817
</td>
<td style="text-align:right;">
240
</td>
<td style="text-align:right;">
7.090103
</td>
<td style="text-align:right;">
0.05988
</td>
<td style="text-align:right;">
1129
</td>
<td style="text-align:right;">
33.35303
</td>
<td style="text-align:right;">
0.9689
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
2256
</td>
<td style="text-align:right;">
5.984043
</td>
<td style="text-align:right;">
0.04817
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
15.34170
</td>
<td style="text-align:right;">
0.5822
</td>
<td style="text-align:right;">
721
</td>
<td style="text-align:right;">
3076
</td>
<td style="text-align:right;">
23.439532
</td>
<td style="text-align:right;">
0.9569
</td>
<td style="text-align:right;">
3029
</td>
<td style="text-align:right;">
3385
</td>
<td style="text-align:right;">
89.48301
</td>
<td style="text-align:right;">
0.8727
</td>
<td style="text-align:right;">
1185
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
0.7594937
</td>
<td style="text-align:right;">
0.2382
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
945
</td>
<td style="text-align:right;">
10.899471
</td>
<td style="text-align:right;">
0.9072
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
945
</td>
<td style="text-align:right;">
27.83069
</td>
<td style="text-align:right;">
0.7560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3385
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1517
</td>
</tr>
<tr>
<td style="text-align:left;">
34001001100
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
001100
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
1267
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
1131
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
58.00000
</td>
<td style="text-align:right;">
0.9678
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
706
</td>
<td style="text-align:right;">
9.348442
</td>
<td style="text-align:right;">
0.8395
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
41.58416
</td>
<td style="text-align:right;">
0.8612
</td>
<td style="text-align:right;">
309
</td>
<td style="text-align:right;">
995
</td>
<td style="text-align:right;">
31.05528
</td>
<td style="text-align:right;">
0.1959
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
32.02555
</td>
<td style="text-align:right;">
0.4782
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
1379
</td>
<td style="text-align:right;">
36.98332
</td>
<td style="text-align:right;">
0.9763
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
7.948718
</td>
<td style="text-align:right;">
0.7660
</td>
<td style="text-align:right;">
392
</td>
<td style="text-align:right;">
20.102564
</td>
<td style="text-align:right;">
0.69880
</td>
<td style="text-align:right;">
447
</td>
<td style="text-align:right;">
22.92308
</td>
<td style="text-align:right;">
0.6712
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
1503
</td>
<td style="text-align:right;">
37.924152
</td>
<td style="text-align:right;">
0.99200
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
374
</td>
<td style="text-align:right;">
38.23529
</td>
<td style="text-align:right;">
0.9167
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
1841
</td>
<td style="text-align:right;">
5.920695
</td>
<td style="text-align:right;">
0.7464
</td>
<td style="text-align:right;">
1909
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
97.89744
</td>
<td style="text-align:right;">
0.9529
</td>
<td style="text-align:right;">
1267
</td>
<td style="text-align:right;">
479
</td>
<td style="text-align:right;">
37.8058406
</td>
<td style="text-align:right;">
0.8464
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
3.010949
</td>
<td style="text-align:right;">
0.6446
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
67.79197
</td>
<td style="text-align:right;">
0.9414
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1950
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1517
</td>
</tr>
</tbody>
</table>

</div>

``` r
# State
svi_2010_state <- rank_variables(svi_2010, rank_by = "state", location = state)
svi_2010_state %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
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
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
42001030101
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030101
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2597
</td>
<td style="text-align:right;">
993
</td>
<td style="text-align:right;">
915
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
2597
</td>
<td style="text-align:right;">
8.856373
</td>
<td style="text-align:right;">
0.1950
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
1399
</td>
<td style="text-align:right;">
3.645461
</td>
<td style="text-align:right;">
0.14870
</td>
<td style="text-align:right;">
279
</td>
<td style="text-align:right;">
840
</td>
<td style="text-align:right;">
33.21429
</td>
<td style="text-align:right;">
0.7852
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
36.00000
</td>
<td style="text-align:right;">
0.3706
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
915
</td>
<td style="text-align:right;">
33.44262
</td>
<td style="text-align:right;">
0.6063
</td>
<td style="text-align:right;">
185
</td>
<td style="text-align:right;">
1784
</td>
<td style="text-align:right;">
10.36996
</td>
<td style="text-align:right;">
0.4372
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
2580
</td>
<td style="text-align:right;">
6.666667
</td>
<td style="text-align:right;">
0.3133
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
10.781671
</td>
<td style="text-align:right;">
0.1947
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
26.72314
</td>
<td style="text-align:right;">
0.8216
</td>
<td style="text-align:right;">
281
</td>
<td style="text-align:right;">
1963
</td>
<td style="text-align:right;">
14.31482
</td>
<td style="text-align:right;">
0.4013
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
808
</td>
<td style="text-align:right;">
4.455445
</td>
<td style="text-align:right;">
0.09445
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
2481
</td>
<td style="text-align:right;">
0.6449012
</td>
<td style="text-align:right;">
0.5528
</td>
<td style="text-align:right;">
120
</td>
<td style="text-align:right;">
2597
</td>
<td style="text-align:right;">
4.620716
</td>
<td style="text-align:right;">
0.3091
</td>
<td style="text-align:right;">
993
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1312
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
5.538771
</td>
<td style="text-align:right;">
0.7558
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
915
</td>
<td style="text-align:right;">
0.5464481
</td>
<td style="text-align:right;">
0.4989
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
915
</td>
<td style="text-align:right;">
0.9836066
</td>
<td style="text-align:right;">
0.06514
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2597
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030102
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030102
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5709
</td>
<td style="text-align:right;">
2415
</td>
<td style="text-align:right;">
2220
</td>
<td style="text-align:right;">
675
</td>
<td style="text-align:right;">
5709
</td>
<td style="text-align:right;">
11.823437
</td>
<td style="text-align:right;">
0.2920
</td>
<td style="text-align:right;">
236
</td>
<td style="text-align:right;">
3176
</td>
<td style="text-align:right;">
7.430731
</td>
<td style="text-align:right;">
0.59030
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
1894
</td>
<td style="text-align:right;">
31.41499
</td>
<td style="text-align:right;">
0.7163
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
326
</td>
<td style="text-align:right;">
40.18405
</td>
<td style="text-align:right;">
0.4772
</td>
<td style="text-align:right;">
726
</td>
<td style="text-align:right;">
2220
</td>
<td style="text-align:right;">
32.70270
</td>
<td style="text-align:right;">
0.5744
</td>
<td style="text-align:right;">
645
</td>
<td style="text-align:right;">
3990
</td>
<td style="text-align:right;">
16.16541
</td>
<td style="text-align:right;">
0.7281
</td>
<td style="text-align:right;">
326
</td>
<td style="text-align:right;">
5717
</td>
<td style="text-align:right;">
5.702291
</td>
<td style="text-align:right;">
0.2461
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
12.313890
</td>
<td style="text-align:right;">
0.2850
</td>
<td style="text-align:right;">
1332
</td>
<td style="text-align:right;">
23.33158
</td>
<td style="text-align:right;">
0.6116
</td>
<td style="text-align:right;">
674
</td>
<td style="text-align:right;">
4490
</td>
<td style="text-align:right;">
15.01114
</td>
<td style="text-align:right;">
0.4460
</td>
<td style="text-align:right;">
185
</td>
<td style="text-align:right;">
1727
</td>
<td style="text-align:right;">
10.712218
</td>
<td style="text-align:right;">
0.41920
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
5461
</td>
<td style="text-align:right;">
1.7396081
</td>
<td style="text-align:right;">
0.7700
</td>
<td style="text-align:right;">
370
</td>
<td style="text-align:right;">
5709
</td>
<td style="text-align:right;">
6.480995
</td>
<td style="text-align:right;">
0.3994
</td>
<td style="text-align:right;">
2415
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1312
</td>
<td style="text-align:right;">
261
</td>
<td style="text-align:right;">
10.807453
</td>
<td style="text-align:right;">
0.8497
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
2220
</td>
<td style="text-align:right;">
2.7477477
</td>
<td style="text-align:right;">
0.8804
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
2220
</td>
<td style="text-align:right;">
2.7927928
</td>
<td style="text-align:right;">
0.21860
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5709
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030200
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030200
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5656
</td>
<td style="text-align:right;">
2180
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
983
</td>
<td style="text-align:right;">
5588
</td>
<td style="text-align:right;">
17.591267
</td>
<td style="text-align:right;">
0.4964
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
3170
</td>
<td style="text-align:right;">
5.078864
</td>
<td style="text-align:right;">
0.30640
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
1677
</td>
<td style="text-align:right;">
28.68217
</td>
<td style="text-align:right;">
0.6106
</td>
<td style="text-align:right;">
154
</td>
<td style="text-align:right;">
434
</td>
<td style="text-align:right;">
35.48387
</td>
<td style="text-align:right;">
0.3586
</td>
<td style="text-align:right;">
635
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
30.08053
</td>
<td style="text-align:right;">
0.4666
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
3785
</td>
<td style="text-align:right;">
20.36988
</td>
<td style="text-align:right;">
0.8475
</td>
<td style="text-align:right;">
877
</td>
<td style="text-align:right;">
5471
</td>
<td style="text-align:right;">
16.029976
</td>
<td style="text-align:right;">
0.8743
</td>
<td style="text-align:right;">
664
</td>
<td style="text-align:right;">
11.739745
</td>
<td style="text-align:right;">
0.2453
</td>
<td style="text-align:right;">
1428
</td>
<td style="text-align:right;">
25.24752
</td>
<td style="text-align:right;">
0.7469
</td>
<td style="text-align:right;">
630
</td>
<td style="text-align:right;">
4135
</td>
<td style="text-align:right;">
15.23579
</td>
<td style="text-align:right;">
0.4586
</td>
<td style="text-align:right;">
247
</td>
<td style="text-align:right;">
1594
</td>
<td style="text-align:right;">
15.495608
</td>
<td style="text-align:right;">
0.61690
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
5363
</td>
<td style="text-align:right;">
3.5987321
</td>
<td style="text-align:right;">
0.8791
</td>
<td style="text-align:right;">
866
</td>
<td style="text-align:right;">
5656
</td>
<td style="text-align:right;">
15.311174
</td>
<td style="text-align:right;">
0.6466
</td>
<td style="text-align:right;">
2180
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1312
</td>
<td style="text-align:right;">
302
</td>
<td style="text-align:right;">
13.853211
</td>
<td style="text-align:right;">
0.8982
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
3.3159640
</td>
<td style="text-align:right;">
0.9126
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
4.0265277
</td>
<td style="text-align:right;">
0.31290
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5656
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030300
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030300
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3932
</td>
<td style="text-align:right;">
1561
</td>
<td style="text-align:right;">
1438
</td>
<td style="text-align:right;">
522
</td>
<td style="text-align:right;">
3913
</td>
<td style="text-align:right;">
13.340148
</td>
<td style="text-align:right;">
0.3424
</td>
<td style="text-align:right;">
103
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
4.842501
</td>
<td style="text-align:right;">
0.27670
</td>
<td style="text-align:right;">
357
</td>
<td style="text-align:right;">
1097
</td>
<td style="text-align:right;">
32.54330
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
26.09971
</td>
<td style="text-align:right;">
0.1637
</td>
<td style="text-align:right;">
446
</td>
<td style="text-align:right;">
1438
</td>
<td style="text-align:right;">
31.01530
</td>
<td style="text-align:right;">
0.5089
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
2560
</td>
<td style="text-align:right;">
17.65625
</td>
<td style="text-align:right;">
0.7828
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
4125
</td>
<td style="text-align:right;">
15.369697
</td>
<td style="text-align:right;">
0.8549
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
9.664293
</td>
<td style="text-align:right;">
0.1431
</td>
<td style="text-align:right;">
1059
</td>
<td style="text-align:right;">
26.93286
</td>
<td style="text-align:right;">
0.8306
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
3011
</td>
<td style="text-align:right;">
12.25506
</td>
<td style="text-align:right;">
0.2787
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
1125
</td>
<td style="text-align:right;">
15.644444
</td>
<td style="text-align:right;">
0.62220
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
3617
</td>
<td style="text-align:right;">
5.2529721
</td>
<td style="text-align:right;">
0.9178
</td>
<td style="text-align:right;">
673
</td>
<td style="text-align:right;">
3932
</td>
<td style="text-align:right;">
17.115972
</td>
<td style="text-align:right;">
0.6756
</td>
<td style="text-align:right;">
1561
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1312
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
5.765535
</td>
<td style="text-align:right;">
0.7592
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
1438
</td>
<td style="text-align:right;">
4.6592490
</td>
<td style="text-align:right;">
0.9511
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1438
</td>
<td style="text-align:right;">
0.4172462
</td>
<td style="text-align:right;">
0.03038
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3932
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030400
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030400
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5661
</td>
<td style="text-align:right;">
2359
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
765
</td>
<td style="text-align:right;">
5658
</td>
<td style="text-align:right;">
13.520679
</td>
<td style="text-align:right;">
0.3512
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
3122
</td>
<td style="text-align:right;">
2.370275
</td>
<td style="text-align:right;">
0.05383
</td>
<td style="text-align:right;">
577
</td>
<td style="text-align:right;">
1766
</td>
<td style="text-align:right;">
32.67271
</td>
<td style="text-align:right;">
0.7653
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
48.89381
</td>
<td style="text-align:right;">
0.6877
</td>
<td style="text-align:right;">
798
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
35.97836
</td>
<td style="text-align:right;">
0.6846
</td>
<td style="text-align:right;">
520
</td>
<td style="text-align:right;">
3886
</td>
<td style="text-align:right;">
13.38137
</td>
<td style="text-align:right;">
0.5988
</td>
<td style="text-align:right;">
697
</td>
<td style="text-align:right;">
5692
</td>
<td style="text-align:right;">
12.245256
</td>
<td style="text-align:right;">
0.7295
</td>
<td style="text-align:right;">
688
</td>
<td style="text-align:right;">
12.153330
</td>
<td style="text-align:right;">
0.2731
</td>
<td style="text-align:right;">
1423
</td>
<td style="text-align:right;">
25.13690
</td>
<td style="text-align:right;">
0.7381
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
4338
</td>
<td style="text-align:right;">
15.99816
</td>
<td style="text-align:right;">
0.5052
</td>
<td style="text-align:right;">
320
</td>
<td style="text-align:right;">
1633
</td>
<td style="text-align:right;">
19.595836
</td>
<td style="text-align:right;">
0.71700
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
5276
</td>
<td style="text-align:right;">
0.5496588
</td>
<td style="text-align:right;">
0.5116
</td>
<td style="text-align:right;">
644
</td>
<td style="text-align:right;">
5661
</td>
<td style="text-align:right;">
11.376082
</td>
<td style="text-align:right;">
0.5712
</td>
<td style="text-align:right;">
2359
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
3.264095
</td>
<td style="text-align:right;">
0.5131
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
9.495549
</td>
<td style="text-align:right;">
0.8303
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
0.9918846
</td>
<td style="text-align:right;">
0.6427
</td>
<td style="text-align:right;">
141
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
6.3570784
</td>
<td style="text-align:right;">
0.47170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5661
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030500
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030500
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3676
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
1541
</td>
<td style="text-align:right;">
568
</td>
<td style="text-align:right;">
3670
</td>
<td style="text-align:right;">
15.476839
</td>
<td style="text-align:right;">
0.4235
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
1952
</td>
<td style="text-align:right;">
4.918033
</td>
<td style="text-align:right;">
0.28480
</td>
<td style="text-align:right;">
275
</td>
<td style="text-align:right;">
1214
</td>
<td style="text-align:right;">
22.65239
</td>
<td style="text-align:right;">
0.2979
</td>
<td style="text-align:right;">
142
</td>
<td style="text-align:right;">
327
</td>
<td style="text-align:right;">
43.42508
</td>
<td style="text-align:right;">
0.5586
</td>
<td style="text-align:right;">
417
</td>
<td style="text-align:right;">
1541
</td>
<td style="text-align:right;">
27.06035
</td>
<td style="text-align:right;">
0.3301
</td>
<td style="text-align:right;">
477
</td>
<td style="text-align:right;">
2622
</td>
<td style="text-align:right;">
18.19222
</td>
<td style="text-align:right;">
0.7978
</td>
<td style="text-align:right;">
565
</td>
<td style="text-align:right;">
3711
</td>
<td style="text-align:right;">
15.225007
</td>
<td style="text-align:right;">
0.8483
</td>
<td style="text-align:right;">
631
</td>
<td style="text-align:right;">
17.165397
</td>
<td style="text-align:right;">
0.6422
</td>
<td style="text-align:right;">
737
</td>
<td style="text-align:right;">
20.04897
</td>
<td style="text-align:right;">
0.3312
</td>
<td style="text-align:right;">
566
</td>
<td style="text-align:right;">
3026
</td>
<td style="text-align:right;">
18.70456
</td>
<td style="text-align:right;">
0.6753
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
1013
</td>
<td style="text-align:right;">
11.451135
</td>
<td style="text-align:right;">
0.45280
</td>
<td style="text-align:right;">
87
</td>
<td style="text-align:right;">
3464
</td>
<td style="text-align:right;">
2.5115473
</td>
<td style="text-align:right;">
0.8356
</td>
<td style="text-align:right;">
500
</td>
<td style="text-align:right;">
3676
</td>
<td style="text-align:right;">
13.601741
</td>
<td style="text-align:right;">
0.6162
</td>
<td style="text-align:right;">
1585
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
2.460568
</td>
<td style="text-align:right;">
0.4703
</td>
<td style="text-align:right;">
160
</td>
<td style="text-align:right;">
10.094637
</td>
<td style="text-align:right;">
0.8406
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
1541
</td>
<td style="text-align:right;">
1.4276444
</td>
<td style="text-align:right;">
0.7285
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
1541
</td>
<td style="text-align:right;">
3.8286827
</td>
<td style="text-align:right;">
0.29970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3676
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.3334
</td>
</tr>
</tbody>
</table>

</div>

``` r
# State
svi_2020_state <- rank_variables(svi_2020, rank_by = "state", location = state)
svi_2020_state %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
42001030101
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030101
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
1160
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
9.279517
</td>
<td style="text-align:right;">
0.2243
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
1433
</td>
<td style="text-align:right;">
0.837404
</td>
<td style="text-align:right;">
0.02914
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
21.27660
</td>
<td style="text-align:right;">
0.6030
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
27.96610
</td>
<td style="text-align:right;">
0.20760
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
22.02268
</td>
<td style="text-align:right;">
0.3198
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
1930
</td>
<td style="text-align:right;">
8.65285
</td>
<td style="text-align:right;">
0.5666
</td>
<td style="text-align:right;">
182
</td>
<td style="text-align:right;">
2652
</td>
<td style="text-align:right;">
6.862745
</td>
<td style="text-align:right;">
0.7413
</td>
<td style="text-align:right;">
521
</td>
<td style="text-align:right;">
19.65296
</td>
<td style="text-align:right;">
0.5860
</td>
<td style="text-align:right;">
601
</td>
<td style="text-align:right;">
22.67069
</td>
<td style="text-align:right;">
0.6889
</td>
<td style="text-align:right;">
262
</td>
<td style="text-align:right;">
2050.964
</td>
<td style="text-align:right;">
12.77448
</td>
<td style="text-align:right;">
0.2721
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
760.4212
</td>
<td style="text-align:right;">
4.339700
</td>
<td style="text-align:right;">
0.09897
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
2495
</td>
<td style="text-align:right;">
1.683367
</td>
<td style="text-align:right;">
0.7392
</td>
<td style="text-align:right;">
397
</td>
<td style="text-align:right;">
2650.619
</td>
<td style="text-align:right;">
14.977633
</td>
<td style="text-align:right;">
0.5194
</td>
<td style="text-align:right;">
1160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1113
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
4.310345
</td>
<td style="text-align:right;">
0.7433
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
1058
</td>
<td style="text-align:right;">
1.984877
</td>
<td style="text-align:right;">
0.7410
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1057.939
</td>
<td style="text-align:right;">
0.7561874
</td>
<td style="text-align:right;">
0.04917
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1546
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030102
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030102
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5873
</td>
<td style="text-align:right;">
2397
</td>
<td style="text-align:right;">
2211
</td>
<td style="text-align:right;">
591
</td>
<td style="text-align:right;">
5837
</td>
<td style="text-align:right;">
10.125064
</td>
<td style="text-align:right;">
0.2547
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
3182
</td>
<td style="text-align:right;">
4.336895
</td>
<td style="text-align:right;">
0.46080
</td>
<td style="text-align:right;">
296
</td>
<td style="text-align:right;">
2028
</td>
<td style="text-align:right;">
14.59566
</td>
<td style="text-align:right;">
0.2304
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
40.98361
</td>
<td style="text-align:right;">
0.51510
</td>
<td style="text-align:right;">
371
</td>
<td style="text-align:right;">
2211
</td>
<td style="text-align:right;">
16.77974
</td>
<td style="text-align:right;">
0.1063
</td>
<td style="text-align:right;">
455
</td>
<td style="text-align:right;">
4273
</td>
<td style="text-align:right;">
10.64826
</td>
<td style="text-align:right;">
0.6904
</td>
<td style="text-align:right;">
337
</td>
<td style="text-align:right;">
5873
</td>
<td style="text-align:right;">
5.738124
</td>
<td style="text-align:right;">
0.6508
</td>
<td style="text-align:right;">
1256
</td>
<td style="text-align:right;">
21.38600
</td>
<td style="text-align:right;">
0.6876
</td>
<td style="text-align:right;">
1286
</td>
<td style="text-align:right;">
21.89682
</td>
<td style="text-align:right;">
0.6345
</td>
<td style="text-align:right;">
751
</td>
<td style="text-align:right;">
4587.000
</td>
<td style="text-align:right;">
16.37236
</td>
<td style="text-align:right;">
0.4975
</td>
<td style="text-align:right;">
130
</td>
<td style="text-align:right;">
1733.0000
</td>
<td style="text-align:right;">
7.501443
</td>
<td style="text-align:right;">
0.24150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5729
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1334
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
5873.000
</td>
<td style="text-align:right;">
4.767581
</td>
<td style="text-align:right;">
0.1981
</td>
<td style="text-align:right;">
2397
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1113
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
14.226116
</td>
<td style="text-align:right;">
0.9282
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
2211
</td>
<td style="text-align:right;">
1.130710
</td>
<td style="text-align:right;">
0.6043
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
2211.000
</td>
<td style="text-align:right;">
1.4925373
</td>
<td style="text-align:right;">
0.10300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5873
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1546
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030200
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030200
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5824
</td>
<td style="text-align:right;">
2189
</td>
<td style="text-align:right;">
2044
</td>
<td style="text-align:right;">
1054
</td>
<td style="text-align:right;">
5816
</td>
<td style="text-align:right;">
18.122421
</td>
<td style="text-align:right;">
0.5288
</td>
<td style="text-align:right;">
170
</td>
<td style="text-align:right;">
2876
</td>
<td style="text-align:right;">
5.910988
</td>
<td style="text-align:right;">
0.64130
</td>
<td style="text-align:right;">
341
</td>
<td style="text-align:right;">
1574
</td>
<td style="text-align:right;">
21.66455
</td>
<td style="text-align:right;">
0.6237
</td>
<td style="text-align:right;">
206
</td>
<td style="text-align:right;">
470
</td>
<td style="text-align:right;">
43.82979
</td>
<td style="text-align:right;">
0.59050
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
2044
</td>
<td style="text-align:right;">
26.76125
</td>
<td style="text-align:right;">
0.5394
</td>
<td style="text-align:right;">
718
</td>
<td style="text-align:right;">
4007
</td>
<td style="text-align:right;">
17.91864
</td>
<td style="text-align:right;">
0.8949
</td>
<td style="text-align:right;">
756
</td>
<td style="text-align:right;">
5808
</td>
<td style="text-align:right;">
13.016529
</td>
<td style="text-align:right;">
0.9439
</td>
<td style="text-align:right;">
976
</td>
<td style="text-align:right;">
16.75824
</td>
<td style="text-align:right;">
0.4081
</td>
<td style="text-align:right;">
1432
</td>
<td style="text-align:right;">
24.58791
</td>
<td style="text-align:right;">
0.7930
</td>
<td style="text-align:right;">
609
</td>
<td style="text-align:right;">
4376.036
</td>
<td style="text-align:right;">
13.91670
</td>
<td style="text-align:right;">
0.3447
</td>
<td style="text-align:right;">
130
</td>
<td style="text-align:right;">
1572.5788
</td>
<td style="text-align:right;">
8.266676
</td>
<td style="text-align:right;">
0.28590
</td>
<td style="text-align:right;">
266
</td>
<td style="text-align:right;">
5495
</td>
<td style="text-align:right;">
4.840764
</td>
<td style="text-align:right;">
0.8937
</td>
<td style="text-align:right;">
1357
</td>
<td style="text-align:right;">
5824.381
</td>
<td style="text-align:right;">
23.298614
</td>
<td style="text-align:right;">
0.6566
</td>
<td style="text-align:right;">
2189
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1113
</td>
<td style="text-align:right;">
393
</td>
<td style="text-align:right;">
17.953403
</td>
<td style="text-align:right;">
0.9602
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
2044
</td>
<td style="text-align:right;">
2.690802
</td>
<td style="text-align:right;">
0.8172
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
2044.061
</td>
<td style="text-align:right;">
2.8864106
</td>
<td style="text-align:right;">
0.22300
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
5824
</td>
<td style="text-align:right;">
0.1201923
</td>
<td style="text-align:right;">
0.3637
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030300
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030300
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
4306
</td>
<td style="text-align:right;">
1763
</td>
<td style="text-align:right;">
1620
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
4298
</td>
<td style="text-align:right;">
7.538390
</td>
<td style="text-align:right;">
0.1620
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
2528
</td>
<td style="text-align:right;">
2.254747
</td>
<td style="text-align:right;">
0.16040
</td>
<td style="text-align:right;">
245
</td>
<td style="text-align:right;">
1358
</td>
<td style="text-align:right;">
18.04124
</td>
<td style="text-align:right;">
0.4282
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
262
</td>
<td style="text-align:right;">
20.22901
</td>
<td style="text-align:right;">
0.09642
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
1620
</td>
<td style="text-align:right;">
18.39506
</td>
<td style="text-align:right;">
0.1703
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
3137
</td>
<td style="text-align:right;">
11.44405
</td>
<td style="text-align:right;">
0.7264
</td>
<td style="text-align:right;">
310
</td>
<td style="text-align:right;">
4299
</td>
<td style="text-align:right;">
7.210979
</td>
<td style="text-align:right;">
0.7670
</td>
<td style="text-align:right;">
666
</td>
<td style="text-align:right;">
15.46679
</td>
<td style="text-align:right;">
0.3333
</td>
<td style="text-align:right;">
824
</td>
<td style="text-align:right;">
19.13609
</td>
<td style="text-align:right;">
0.4109
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
3475.000
</td>
<td style="text-align:right;">
13.61151
</td>
<td style="text-align:right;">
0.3262
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
1173.0000
</td>
<td style="text-align:right;">
1.705030
</td>
<td style="text-align:right;">
0.02443
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
4119
</td>
<td style="text-align:right;">
3.665938
</td>
<td style="text-align:right;">
0.8624
</td>
<td style="text-align:right;">
813
</td>
<td style="text-align:right;">
4306.000
</td>
<td style="text-align:right;">
18.880632
</td>
<td style="text-align:right;">
0.5894
</td>
<td style="text-align:right;">
1763
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1113
</td>
<td style="text-align:right;">
182
</td>
<td style="text-align:right;">
10.323313
</td>
<td style="text-align:right;">
0.8665
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
1620
</td>
<td style="text-align:right;">
3.641975
</td>
<td style="text-align:right;">
0.8786
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
1620.000
</td>
<td style="text-align:right;">
1.9753086
</td>
<td style="text-align:right;">
0.14030
</td>
<td style="text-align:right;">
87
</td>
<td style="text-align:right;">
4306
</td>
<td style="text-align:right;">
2.0204366
</td>
<td style="text-align:right;">
0.7477
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030400
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030400
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5798
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
2271
</td>
<td style="text-align:right;">
967
</td>
<td style="text-align:right;">
5697
</td>
<td style="text-align:right;">
16.973846
</td>
<td style="text-align:right;">
0.4937
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
2979
</td>
<td style="text-align:right;">
2.316213
</td>
<td style="text-align:right;">
0.16920
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
24.14356
</td>
<td style="text-align:right;">
0.7325
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
432
</td>
<td style="text-align:right;">
31.94444
</td>
<td style="text-align:right;">
0.28360
</td>
<td style="text-align:right;">
582
</td>
<td style="text-align:right;">
2271
</td>
<td style="text-align:right;">
25.62748
</td>
<td style="text-align:right;">
0.4917
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
4198
</td>
<td style="text-align:right;">
16.57932
</td>
<td style="text-align:right;">
0.8705
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
5697
</td>
<td style="text-align:right;">
9.636651
</td>
<td style="text-align:right;">
0.8697
</td>
<td style="text-align:right;">
1196
</td>
<td style="text-align:right;">
20.62780
</td>
<td style="text-align:right;">
0.6426
</td>
<td style="text-align:right;">
1192
</td>
<td style="text-align:right;">
20.55881
</td>
<td style="text-align:right;">
0.5253
</td>
<td style="text-align:right;">
871
</td>
<td style="text-align:right;">
4505.000
</td>
<td style="text-align:right;">
19.33407
</td>
<td style="text-align:right;">
0.6741
</td>
<td style="text-align:right;">
220
</td>
<td style="text-align:right;">
1721.0000
</td>
<td style="text-align:right;">
12.783266
</td>
<td style="text-align:right;">
0.49800
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
5437
</td>
<td style="text-align:right;">
2.482987
</td>
<td style="text-align:right;">
0.8093
</td>
<td style="text-align:right;">
513
</td>
<td style="text-align:right;">
5798.000
</td>
<td style="text-align:right;">
8.847879
</td>
<td style="text-align:right;">
0.3531
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
2.333588
</td>
<td style="text-align:right;">
0.4313
</td>
<td style="text-align:right;">
283
</td>
<td style="text-align:right;">
10.826320
</td>
<td style="text-align:right;">
0.8752
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
2271
</td>
<td style="text-align:right;">
4.007045
</td>
<td style="text-align:right;">
0.8990
</td>
<td style="text-align:right;">
210
</td>
<td style="text-align:right;">
2271.000
</td>
<td style="text-align:right;">
9.2470277
</td>
<td style="text-align:right;">
0.60570
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
5798
</td>
<td style="text-align:right;">
2.3973784
</td>
<td style="text-align:right;">
0.7745
</td>
</tr>
<tr>
<td style="text-align:left;">
42001030500
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
030500
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Adams County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3879
</td>
<td style="text-align:right;">
1675
</td>
<td style="text-align:right;">
1531
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
3879
</td>
<td style="text-align:right;">
19.876257
</td>
<td style="text-align:right;">
0.5852
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
2120
</td>
<td style="text-align:right;">
5.188679
</td>
<td style="text-align:right;">
0.56360
</td>
<td style="text-align:right;">
189
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
16.11253
</td>
<td style="text-align:right;">
0.3112
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
358
</td>
<td style="text-align:right;">
44.97207
</td>
<td style="text-align:right;">
0.61870
</td>
<td style="text-align:right;">
350
</td>
<td style="text-align:right;">
1531
</td>
<td style="text-align:right;">
22.86088
</td>
<td style="text-align:right;">
0.3590
</td>
<td style="text-align:right;">
418
</td>
<td style="text-align:right;">
2743
</td>
<td style="text-align:right;">
15.23879
</td>
<td style="text-align:right;">
0.8458
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
3879
</td>
<td style="text-align:right;">
6.780098
</td>
<td style="text-align:right;">
0.7376
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
21.01057
</td>
<td style="text-align:right;">
0.6679
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
20.52075
</td>
<td style="text-align:right;">
0.5235
</td>
<td style="text-align:right;">
513
</td>
<td style="text-align:right;">
3083.000
</td>
<td style="text-align:right;">
16.63964
</td>
<td style="text-align:right;">
0.5125
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
1139.0000
</td>
<td style="text-align:right;">
12.028095
</td>
<td style="text-align:right;">
0.46350
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
3667
</td>
<td style="text-align:right;">
3.572402
</td>
<td style="text-align:right;">
0.8587
</td>
<td style="text-align:right;">
831
</td>
<td style="text-align:right;">
3879.000
</td>
<td style="text-align:right;">
21.423047
</td>
<td style="text-align:right;">
0.6300
</td>
<td style="text-align:right;">
1675
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1.671642
</td>
<td style="text-align:right;">
0.3824
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
8.776119
</td>
<td style="text-align:right;">
0.8404
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
1531
</td>
<td style="text-align:right;">
1.502286
</td>
<td style="text-align:right;">
0.6736
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
1531.000
</td>
<td style="text-align:right;">
2.2860875
</td>
<td style="text-align:right;">
0.16500
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
3879
</td>
<td style="text-align:right;">
0.3093581
</td>
<td style="text-align:right;">
0.5109
</td>
</tr>
</tbody>
</table>

</div>

``` r
# County
svi_2010_county <- rank_variables(svi_2010, rank_by = "county", location = county, state_abbr = state)
svi_2010_county %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_10
</th>
<th style="text-align:right;">
EP_AGE65_10
</th>
<th style="text-align:right;">
EPL_AGE65_10
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
E_MOBILE_10
</th>
<th style="text-align:right;">
EP_MOBILE_10
</th>
<th style="text-align:right;">
EPL_MOBILE_10
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
42017100102
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100102
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2520
</td>
<td style="text-align:right;">
1559
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
501
</td>
<td style="text-align:right;">
2484
</td>
<td style="text-align:right;">
20.16908
</td>
<td style="text-align:right;">
0.9437
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
1281
</td>
<td style="text-align:right;">
8.587041
</td>
<td style="text-align:right;">
0.8732
</td>
<td style="text-align:right;">
179
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
43.13253
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
387
</td>
<td style="text-align:right;">
840
</td>
<td style="text-align:right;">
46.07143
</td>
<td style="text-align:right;">
0.4648
</td>
<td style="text-align:right;">
566
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
45.09960
</td>
<td style="text-align:right;">
0.9014
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
1952
</td>
<td style="text-align:right;">
11.936475
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
2770
</td>
<td style="text-align:right;">
7.545126
</td>
<td style="text-align:right;">
0.6549
</td>
<td style="text-align:right;">
455
</td>
<td style="text-align:right;">
18.055556
</td>
<td style="text-align:right;">
0.8169
</td>
<td style="text-align:right;">
429
</td>
<td style="text-align:right;">
17.02381
</td>
<td style="text-align:right;">
0.08451
</td>
<td style="text-align:right;">
466
</td>
<td style="text-align:right;">
2391
</td>
<td style="text-align:right;">
19.48975
</td>
<td style="text-align:right;">
0.8873
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
575
</td>
<td style="text-align:right;">
17.739130
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
2373
</td>
<td style="text-align:right;">
1.6013485
</td>
<td style="text-align:right;">
0.6972
</td>
<td style="text-align:right;">
361
</td>
<td style="text-align:right;">
2520
</td>
<td style="text-align:right;">
14.32540
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
1559
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
23.476588
</td>
<td style="text-align:right;">
0.9014
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.603592
</td>
<td style="text-align:right;">
0.8310
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
2.310757
</td>
<td style="text-align:right;">
0.9296
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
3.266932
</td>
<td style="text-align:right;">
0.5986
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2520
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3275
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100103
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100103
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2677
</td>
<td style="text-align:right;">
1134
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
303
</td>
<td style="text-align:right;">
2136
</td>
<td style="text-align:right;">
14.18539
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
1204
</td>
<td style="text-align:right;">
5.315615
</td>
<td style="text-align:right;">
0.4225
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
38.42105
</td>
<td style="text-align:right;">
0.8310
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
39.17995
</td>
<td style="text-align:right;">
0.3521
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
38.75124
</td>
<td style="text-align:right;">
0.6972
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
1568
</td>
<td style="text-align:right;">
12.882653
</td>
<td style="text-align:right;">
0.7958
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
2161
</td>
<td style="text-align:right;">
8.792226
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
14.942099
</td>
<td style="text-align:right;">
0.6549
</td>
<td style="text-align:right;">
709
</td>
<td style="text-align:right;">
26.48487
</td>
<td style="text-align:right;">
0.78870
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
1880
</td>
<td style="text-align:right;">
20.63830
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
9.106830
</td>
<td style="text-align:right;">
0.5070
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
2545
</td>
<td style="text-align:right;">
0.8644401
</td>
<td style="text-align:right;">
0.4648
</td>
<td style="text-align:right;">
972
</td>
<td style="text-align:right;">
2677
</td>
<td style="text-align:right;">
36.30930
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
1134
</td>
<td style="text-align:right;">
185
</td>
<td style="text-align:right;">
16.313933
</td>
<td style="text-align:right;">
0.8310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.2535
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
1009
</td>
<td style="text-align:right;">
7.730426
</td>
<td style="text-align:right;">
0.8662
</td>
<td style="text-align:right;">
541
</td>
<td style="text-align:right;">
2677
</td>
<td style="text-align:right;">
20.2091894
</td>
<td style="text-align:right;">
0.9789
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100104
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100104
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
4613
</td>
<td style="text-align:right;">
2052
</td>
<td style="text-align:right;">
1830
</td>
<td style="text-align:right;">
1091
</td>
<td style="text-align:right;">
4613
</td>
<td style="text-align:right;">
23.65055
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
2492
</td>
<td style="text-align:right;">
6.340289
</td>
<td style="text-align:right;">
0.5634
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
611
</td>
<td style="text-align:right;">
34.53355
</td>
<td style="text-align:right;">
0.5845
</td>
<td style="text-align:right;">
672
</td>
<td style="text-align:right;">
1219
</td>
<td style="text-align:right;">
55.12715
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
1830
</td>
<td style="text-align:right;">
48.25137
</td>
<td style="text-align:right;">
0.9577
</td>
<td style="text-align:right;">
447
</td>
<td style="text-align:right;">
3271
</td>
<td style="text-align:right;">
13.665546
</td>
<td style="text-align:right;">
0.8239
</td>
<td style="text-align:right;">
469
</td>
<td style="text-align:right;">
4441
</td>
<td style="text-align:right;">
10.560685
</td>
<td style="text-align:right;">
0.8521
</td>
<td style="text-align:right;">
590
</td>
<td style="text-align:right;">
12.789941
</td>
<td style="text-align:right;">
0.4296
</td>
<td style="text-align:right;">
788
</td>
<td style="text-align:right;">
17.08216
</td>
<td style="text-align:right;">
0.09859
</td>
<td style="text-align:right;">
637
</td>
<td style="text-align:right;">
3631
</td>
<td style="text-align:right;">
17.54338
</td>
<td style="text-align:right;">
0.8028
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
1175
</td>
<td style="text-align:right;">
11.489362
</td>
<td style="text-align:right;">
0.6761
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
4357
</td>
<td style="text-align:right;">
8.3773238
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
1846
</td>
<td style="text-align:right;">
4613
</td>
<td style="text-align:right;">
40.01734
</td>
<td style="text-align:right;">
0.9718
</td>
<td style="text-align:right;">
2052
</td>
<td style="text-align:right;">
549
</td>
<td style="text-align:right;">
26.754386
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1830
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.2535
</td>
<td style="text-align:right;">
270
</td>
<td style="text-align:right;">
1830
</td>
<td style="text-align:right;">
14.754098
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4613
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3275
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100105
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100105
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3457
</td>
<td style="text-align:right;">
1324
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
3457
</td>
<td style="text-align:right;">
12.84351
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
225
</td>
<td style="text-align:right;">
1719
</td>
<td style="text-align:right;">
13.089005
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
334
</td>
<td style="text-align:right;">
982
</td>
<td style="text-align:right;">
34.01222
</td>
<td style="text-align:right;">
0.5352
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
260
</td>
<td style="text-align:right;">
53.46154
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
38.08374
</td>
<td style="text-align:right;">
0.6620
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
2418
</td>
<td style="text-align:right;">
18.693135
</td>
<td style="text-align:right;">
0.9507
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
3593
</td>
<td style="text-align:right;">
10.715280
</td>
<td style="text-align:right;">
0.8732
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
15.273358
</td>
<td style="text-align:right;">
0.6901
</td>
<td style="text-align:right;">
752
</td>
<td style="text-align:right;">
21.75296
</td>
<td style="text-align:right;">
0.42250
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
2896
</td>
<td style="text-align:right;">
16.91989
</td>
<td style="text-align:right;">
0.7606
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
886
</td>
<td style="text-align:right;">
6.433409
</td>
<td style="text-align:right;">
0.3099
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
3288
</td>
<td style="text-align:right;">
4.5620438
</td>
<td style="text-align:right;">
0.9437
</td>
<td style="text-align:right;">
458
</td>
<td style="text-align:right;">
3457
</td>
<td style="text-align:right;">
13.24848
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
1324
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
1.586103
</td>
<td style="text-align:right;">
0.3873
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
4.025765
</td>
<td style="text-align:right;">
0.9718
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
1242
</td>
<td style="text-align:right;">
4.911433
</td>
<td style="text-align:right;">
0.7113
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
3457
</td>
<td style="text-align:right;">
0.9835117
</td>
<td style="text-align:right;">
0.7535
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100201
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100201
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
4127
</td>
<td style="text-align:right;">
1789
</td>
<td style="text-align:right;">
1605
</td>
<td style="text-align:right;">
576
</td>
<td style="text-align:right;">
4127
</td>
<td style="text-align:right;">
13.95687
</td>
<td style="text-align:right;">
0.7394
</td>
<td style="text-align:right;">
159
</td>
<td style="text-align:right;">
2197
</td>
<td style="text-align:right;">
7.237142
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
521
</td>
<td style="text-align:right;">
1376
</td>
<td style="text-align:right;">
37.86337
</td>
<td style="text-align:right;">
0.8169
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
229
</td>
<td style="text-align:right;">
38.86463
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
610
</td>
<td style="text-align:right;">
1605
</td>
<td style="text-align:right;">
38.00623
</td>
<td style="text-align:right;">
0.6479
</td>
<td style="text-align:right;">
457
</td>
<td style="text-align:right;">
2990
</td>
<td style="text-align:right;">
15.284281
</td>
<td style="text-align:right;">
0.8944
</td>
<td style="text-align:right;">
557
</td>
<td style="text-align:right;">
4264
</td>
<td style="text-align:right;">
13.062852
</td>
<td style="text-align:right;">
0.9577
</td>
<td style="text-align:right;">
601
</td>
<td style="text-align:right;">
14.562636
</td>
<td style="text-align:right;">
0.5915
</td>
<td style="text-align:right;">
839
</td>
<td style="text-align:right;">
20.32954
</td>
<td style="text-align:right;">
0.28170
</td>
<td style="text-align:right;">
429
</td>
<td style="text-align:right;">
3380
</td>
<td style="text-align:right;">
12.69231
</td>
<td style="text-align:right;">
0.6197
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
1165
</td>
<td style="text-align:right;">
5.321888
</td>
<td style="text-align:right;">
0.2183
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
3825
</td>
<td style="text-align:right;">
3.5294118
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
887
</td>
<td style="text-align:right;">
4127
</td>
<td style="text-align:right;">
21.49261
</td>
<td style="text-align:right;">
0.8521
</td>
<td style="text-align:right;">
1789
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1444
</td>
<td style="text-align:right;">
244
</td>
<td style="text-align:right;">
13.638904
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
1605
</td>
<td style="text-align:right;">
2.305296
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
1605
</td>
<td style="text-align:right;">
4.735202
</td>
<td style="text-align:right;">
0.6901
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4127
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3275
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100206
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100206
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
2086
</td>
<td style="text-align:right;">
1828
</td>
<td style="text-align:right;">
860
</td>
<td style="text-align:right;">
4786
</td>
<td style="text-align:right;">
17.96908
</td>
<td style="text-align:right;">
0.8944
</td>
<td style="text-align:right;">
194
</td>
<td style="text-align:right;">
2661
</td>
<td style="text-align:right;">
7.290492
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
426
</td>
<td style="text-align:right;">
1103
</td>
<td style="text-align:right;">
38.62194
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
370
</td>
<td style="text-align:right;">
725
</td>
<td style="text-align:right;">
51.03448
</td>
<td style="text-align:right;">
0.6338
</td>
<td style="text-align:right;">
796
</td>
<td style="text-align:right;">
1828
</td>
<td style="text-align:right;">
43.54486
</td>
<td style="text-align:right;">
0.8592
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
3392
</td>
<td style="text-align:right;">
6.987028
</td>
<td style="text-align:right;">
0.5000
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
4765
</td>
<td style="text-align:right;">
9.213012
</td>
<td style="text-align:right;">
0.7887
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
9.387331
</td>
<td style="text-align:right;">
0.1620
</td>
<td style="text-align:right;">
1097
</td>
<td style="text-align:right;">
22.78297
</td>
<td style="text-align:right;">
0.50700
</td>
<td style="text-align:right;">
421
</td>
<td style="text-align:right;">
3746
</td>
<td style="text-align:right;">
11.23865
</td>
<td style="text-align:right;">
0.4507
</td>
<td style="text-align:right;">
180
</td>
<td style="text-align:right;">
1392
</td>
<td style="text-align:right;">
12.931035
</td>
<td style="text-align:right;">
0.7500
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
4570
</td>
<td style="text-align:right;">
1.0940919
</td>
<td style="text-align:right;">
0.5634
</td>
<td style="text-align:right;">
1095
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
22.74143
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
2086
</td>
<td style="text-align:right;">
189
</td>
<td style="text-align:right;">
9.060403
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.198466
</td>
<td style="text-align:right;">
0.7887
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1828
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.2535
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
1828
</td>
<td style="text-align:right;">
2.899344
</td>
<td style="text-align:right;">
0.5563
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
4815
</td>
<td style="text-align:right;">
0.7061267
</td>
<td style="text-align:right;">
0.7113
</td>
</tr>
</tbody>
</table>

</div>

``` r
# County
svi_2020_county <- rank_variables(svi_2020, rank_by = "county", location = county, state = state)
svi_2020_county %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
42017100102
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100102
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2595
</td>
<td style="text-align:right;">
1375
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
2595
</td>
<td style="text-align:right;">
21.078998
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
162
</td>
<td style="text-align:right;">
1515
</td>
<td style="text-align:right;">
10.693069
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
348
</td>
<td style="text-align:right;">
35.91954
</td>
<td style="text-align:right;">
0.9577
</td>
<td style="text-align:right;">
337
</td>
<td style="text-align:right;">
875
</td>
<td style="text-align:right;">
38.51429
</td>
<td style="text-align:right;">
0.3873
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
37.77596
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
179
</td>
<td style="text-align:right;">
2043
</td>
<td style="text-align:right;">
8.761625
</td>
<td style="text-align:right;">
0.8028
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
2595
</td>
<td style="text-align:right;">
5.703276
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
545
</td>
<td style="text-align:right;">
21.001927
</td>
<td style="text-align:right;">
0.6690
</td>
<td style="text-align:right;">
311
</td>
<td style="text-align:right;">
11.98459
</td>
<td style="text-align:right;">
0.05634
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2284
</td>
<td style="text-align:right;">
14.973730
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
104
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
14.627285
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
2493
</td>
<td style="text-align:right;">
1.002808
</td>
<td style="text-align:right;">
0.4648
</td>
<td style="text-align:right;">
480
</td>
<td style="text-align:right;">
2595
</td>
<td style="text-align:right;">
18.49711
</td>
<td style="text-align:right;">
0.6831
</td>
<td style="text-align:right;">
1375
</td>
<td style="text-align:right;">
422
</td>
<td style="text-align:right;">
30.69091
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1.818182
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
4.742437
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
7.031889
</td>
<td style="text-align:right;">
0.7324
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2595
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2042
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100103
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100103
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2375
</td>
<td style="text-align:right;">
1029
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
479
</td>
<td style="text-align:right;">
2375
</td>
<td style="text-align:right;">
20.168421
</td>
<td style="text-align:right;">
0.8803
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
1383
</td>
<td style="text-align:right;">
3.615329
</td>
<td style="text-align:right;">
0.4789
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
449
</td>
<td style="text-align:right;">
16.92650
</td>
<td style="text-align:right;">
0.1479
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
28.42942
</td>
<td style="text-align:right;">
0.2183
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
23.00420
</td>
<td style="text-align:right;">
0.2113
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1688
</td>
<td style="text-align:right;">
8.767772
</td>
<td style="text-align:right;">
0.8099
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
2375
</td>
<td style="text-align:right;">
6.021053
</td>
<td style="text-align:right;">
0.7676
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
9.305263
</td>
<td style="text-align:right;">
0.0493
</td>
<td style="text-align:right;">
561
</td>
<td style="text-align:right;">
23.62105
</td>
<td style="text-align:right;">
0.79580
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
1814
</td>
<td style="text-align:right;">
27.012128
</td>
<td style="text-align:right;">
0.9930
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
612
</td>
<td style="text-align:right;">
32.189543
</td>
<td style="text-align:right;">
0.9789
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
2199
</td>
<td style="text-align:right;">
3.228740
</td>
<td style="text-align:right;">
0.8521
</td>
<td style="text-align:right;">
662
</td>
<td style="text-align:right;">
2375
</td>
<td style="text-align:right;">
27.87368
</td>
<td style="text-align:right;">
0.8592
</td>
<td style="text-align:right;">
1029
</td>
<td style="text-align:right;">
225
</td>
<td style="text-align:right;">
21.86589
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3310
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
7.037815
</td>
<td style="text-align:right;">
0.9718
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
10.399160
</td>
<td style="text-align:right;">
0.8944
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
2375
</td>
<td style="text-align:right;">
0.4210526
</td>
<td style="text-align:right;">
0.6549
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100104
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100104
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5242
</td>
<td style="text-align:right;">
2034
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
1733
</td>
<td style="text-align:right;">
5238
</td>
<td style="text-align:right;">
33.085147
</td>
<td style="text-align:right;">
0.9930
</td>
<td style="text-align:right;">
156
</td>
<td style="text-align:right;">
2950
</td>
<td style="text-align:right;">
5.288136
</td>
<td style="text-align:right;">
0.6972
</td>
<td style="text-align:right;">
130
</td>
<td style="text-align:right;">
611
</td>
<td style="text-align:right;">
21.27660
</td>
<td style="text-align:right;">
0.3239
</td>
<td style="text-align:right;">
721
</td>
<td style="text-align:right;">
1371
</td>
<td style="text-align:right;">
52.58935
</td>
<td style="text-align:right;">
0.7183
</td>
<td style="text-align:right;">
851
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
42.93643
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
610
</td>
<td style="text-align:right;">
3491
</td>
<td style="text-align:right;">
17.473503
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
821
</td>
<td style="text-align:right;">
5238
</td>
<td style="text-align:right;">
15.673921
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
609
</td>
<td style="text-align:right;">
11.617703
</td>
<td style="text-align:right;">
0.1479
</td>
<td style="text-align:right;">
1102
</td>
<td style="text-align:right;">
21.02251
</td>
<td style="text-align:right;">
0.60560
</td>
<td style="text-align:right;">
837
</td>
<td style="text-align:right;">
4138
</td>
<td style="text-align:right;">
20.227163
</td>
<td style="text-align:right;">
0.9296
</td>
<td style="text-align:right;">
236
</td>
<td style="text-align:right;">
1373
</td>
<td style="text-align:right;">
17.188638
</td>
<td style="text-align:right;">
0.7887
</td>
<td style="text-align:right;">
745
</td>
<td style="text-align:right;">
4776
</td>
<td style="text-align:right;">
15.598828
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
3082
</td>
<td style="text-align:right;">
5242
</td>
<td style="text-align:right;">
58.79435
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
2034
</td>
<td style="text-align:right;">
600
</td>
<td style="text-align:right;">
29.49853
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3310
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
8.123108
</td>
<td style="text-align:right;">
0.9930
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
22.401615
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
5242
</td>
<td style="text-align:right;">
0.0763068
</td>
<td style="text-align:right;">
0.4085
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100105
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100105
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
3022
</td>
<td style="text-align:right;">
1259
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
397
</td>
<td style="text-align:right;">
2942
</td>
<td style="text-align:right;">
13.494222
</td>
<td style="text-align:right;">
0.7746
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
1985
</td>
<td style="text-align:right;">
6.901763
</td>
<td style="text-align:right;">
0.8662
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
0.9225
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
30.08130
</td>
<td style="text-align:right;">
0.2606
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
32.19349
</td>
<td style="text-align:right;">
0.6972
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
2276
</td>
<td style="text-align:right;">
4.173990
</td>
<td style="text-align:right;">
0.4507
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
2957
</td>
<td style="text-align:right;">
5.647616
</td>
<td style="text-align:right;">
0.7324
</td>
<td style="text-align:right;">
420
</td>
<td style="text-align:right;">
13.898081
</td>
<td style="text-align:right;">
0.2817
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
15.48643
</td>
<td style="text-align:right;">
0.18310
</td>
<td style="text-align:right;">
241
</td>
<td style="text-align:right;">
2543
</td>
<td style="text-align:right;">
9.476996
</td>
<td style="text-align:right;">
0.2958
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
677
</td>
<td style="text-align:right;">
7.533235
</td>
<td style="text-align:right;">
0.4507
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
2882
</td>
<td style="text-align:right;">
2.081888
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
3022
</td>
<td style="text-align:right;">
11.97882
</td>
<td style="text-align:right;">
0.4366
</td>
<td style="text-align:right;">
1259
</td>
<td style="text-align:right;">
163
</td>
<td style="text-align:right;">
12.94678
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.2254
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
8.840701
</td>
<td style="text-align:right;">
0.8451
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
3022
</td>
<td style="text-align:right;">
5.8239576
</td>
<td style="text-align:right;">
0.9366
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100201
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100201
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5061
</td>
<td style="text-align:right;">
1903
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
4940
</td>
<td style="text-align:right;">
8.987854
</td>
<td style="text-align:right;">
0.5634
</td>
<td style="text-align:right;">
160
</td>
<td style="text-align:right;">
2803
</td>
<td style="text-align:right;">
5.708170
</td>
<td style="text-align:right;">
0.7676
</td>
<td style="text-align:right;">
513
</td>
<td style="text-align:right;">
1683
</td>
<td style="text-align:right;">
30.48128
</td>
<td style="text-align:right;">
0.8732
</td>
<td style="text-align:right;">
75
</td>
<td style="text-align:right;">
153
</td>
<td style="text-align:right;">
49.01961
</td>
<td style="text-align:right;">
0.6408
</td>
<td style="text-align:right;">
588
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
32.02614
</td>
<td style="text-align:right;">
0.6761
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
3602
</td>
<td style="text-align:right;">
12.215436
</td>
<td style="text-align:right;">
0.9437
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
5061
</td>
<td style="text-align:right;">
6.342620
</td>
<td style="text-align:right;">
0.7958
</td>
<td style="text-align:right;">
645
</td>
<td style="text-align:right;">
12.744517
</td>
<td style="text-align:right;">
0.1901
</td>
<td style="text-align:right;">
935
</td>
<td style="text-align:right;">
18.47461
</td>
<td style="text-align:right;">
0.35920
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
4126
</td>
<td style="text-align:right;">
12.190984
</td>
<td style="text-align:right;">
0.5634
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
1277
</td>
<td style="text-align:right;">
13.390760
</td>
<td style="text-align:right;">
0.6690
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
4838
</td>
<td style="text-align:right;">
5.787515
</td>
<td style="text-align:right;">
0.9366
</td>
<td style="text-align:right;">
1638
</td>
<td style="text-align:right;">
5061
</td>
<td style="text-align:right;">
32.36515
</td>
<td style="text-align:right;">
0.9085
</td>
<td style="text-align:right;">
1903
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.1232
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
11.087756
</td>
<td style="text-align:right;">
0.9718
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
1.579521
</td>
<td style="text-align:right;">
0.7465
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
1836
</td>
<td style="text-align:right;">
3.159041
</td>
<td style="text-align:right;">
0.4507
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
5061
</td>
<td style="text-align:right;">
0.0987947
</td>
<td style="text-align:right;">
0.4296
</td>
</tr>
<tr>
<td style="text-align:left;">
42017100206
</td>
<td style="text-align:left;">
42
</td>
<td style="text-align:left;">
017
</td>
<td style="text-align:left;">
100206
</td>
<td style="text-align:left;">
PA
</td>
<td style="text-align:left;">
Pennsylvania
</td>
<td style="text-align:left;">
Bucks County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5333
</td>
<td style="text-align:right;">
2093
</td>
<td style="text-align:right;">
2011
</td>
<td style="text-align:right;">
449
</td>
<td style="text-align:right;">
5323
</td>
<td style="text-align:right;">
8.435093
</td>
<td style="text-align:right;">
0.5070
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
3326
</td>
<td style="text-align:right;">
7.185809
</td>
<td style="text-align:right;">
0.8873
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
1095
</td>
<td style="text-align:right;">
27.76256
</td>
<td style="text-align:right;">
0.7042
</td>
<td style="text-align:right;">
490
</td>
<td style="text-align:right;">
916
</td>
<td style="text-align:right;">
53.49345
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
794
</td>
<td style="text-align:right;">
2011
</td>
<td style="text-align:right;">
39.48284
</td>
<td style="text-align:right;">
0.9085
</td>
<td style="text-align:right;">
499
</td>
<td style="text-align:right;">
3895
</td>
<td style="text-align:right;">
12.811296
</td>
<td style="text-align:right;">
0.9648
</td>
<td style="text-align:right;">
452
</td>
<td style="text-align:right;">
5302
</td>
<td style="text-align:right;">
8.525085
</td>
<td style="text-align:right;">
0.8944
</td>
<td style="text-align:right;">
646
</td>
<td style="text-align:right;">
12.113257
</td>
<td style="text-align:right;">
0.1620
</td>
<td style="text-align:right;">
942
</td>
<td style="text-align:right;">
17.66360
</td>
<td style="text-align:right;">
0.28170
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
4360
</td>
<td style="text-align:right;">
15.642202
</td>
<td style="text-align:right;">
0.7817
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
1549
</td>
<td style="text-align:right;">
13.040671
</td>
<td style="text-align:right;">
0.6620
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
5098
</td>
<td style="text-align:right;">
5.413888
</td>
<td style="text-align:right;">
0.9296
</td>
<td style="text-align:right;">
1970
</td>
<td style="text-align:right;">
5333
</td>
<td style="text-align:right;">
36.93981
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
2093
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
26.51696
</td>
<td style="text-align:right;">
0.8873
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3310
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
2011
</td>
<td style="text-align:right;">
4.525112
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
2011
</td>
<td style="text-align:right;">
6.862258
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5333
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.2042
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_2020_national <- svi_theme_variables(svi_2020_national)
svi_2020_national %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
E_AGE65_20
</th>
<th style="text-align:right;">
EP_AGE65_20
</th>
<th style="text-align:right;">
EPL_AGE65_20
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
E_MOBILE_20
</th>
<th style="text-align:right;">
EP_MOBILE_20
</th>
<th style="text-align:right;">
EPL_MOBILE_20
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
SPL_THEME1
</th>
<th style="text-align:right;">
RPL_THEME1
</th>
<th style="text-align:right;">
SPL_THEME2
</th>
<th style="text-align:right;">
RPL_THEME2
</th>
<th style="text-align:right;">
SPL_THEME3
</th>
<th style="text-align:right;">
RPL_THEME3
</th>
<th style="text-align:right;">
SPL_THEME4
</th>
<th style="text-align:right;">
RPL_THEME4
</th>
<th style="text-align:right;">
SPL_THEMES
</th>
<th style="text-align:right;">
RPL_THEMES
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
01001020100
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020100
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
1941
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
352
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
18.13498
</td>
<td style="text-align:right;">
0.4630
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
852
</td>
<td style="text-align:right;">
2.112676
</td>
<td style="text-align:right;">
0.15070
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
15.976331
</td>
<td style="text-align:right;">
0.26320
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
33.87097
</td>
<td style="text-align:right;">
0.2913
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
20.77922
</td>
<td style="text-align:right;">
0.2230
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1309
</td>
<td style="text-align:right;">
14.285714
</td>
<td style="text-align:right;">
0.6928
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
9.634209
</td>
<td style="text-align:right;">
0.6617
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
15.19835
</td>
<td style="text-align:right;">
0.4601
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
21.38073
</td>
<td style="text-align:right;">
0.4681
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1526
</td>
<td style="text-align:right;">
25.62254
</td>
<td style="text-align:right;">
0.9011
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
555
</td>
<td style="text-align:right;">
10.45045
</td>
<td style="text-align:right;">
0.3451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1843
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
22.51417
</td>
<td style="text-align:right;">
0.3902
</td>
<td style="text-align:right;">
710
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
88
</td>
<td style="text-align:right;">
12.3943662
</td>
<td style="text-align:right;">
0.8263
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
693
</td>
<td style="text-align:right;">
1.443001
</td>
<td style="text-align:right;">
0.1643
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1941
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
2.19120
</td>
<td style="text-align:right;">
0.4084
</td>
<td style="text-align:right;">
2.26919
</td>
<td style="text-align:right;">
0.3503
</td>
<td style="text-align:right;">
0.3902
</td>
<td style="text-align:right;">
0.3869
</td>
<td style="text-align:right;">
1.37956
</td>
<td style="text-align:right;">
0.07216
</td>
<td style="text-align:right;">
6.23015
</td>
<td style="text-align:right;">
0.2314
</td>
</tr>
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
149
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
26.00349
</td>
<td style="text-align:right;">
0.4041
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
284
</td>
<td style="text-align:right;">
16.16392
</td>
<td style="text-align:right;">
0.5169
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
164
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
13.57616
</td>
<td style="text-align:right;">
0.4127
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
359
</td>
<td style="text-align:right;">
11.69916
</td>
<td style="text-align:right;">
0.3998
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
1116
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
63.51736
</td>
<td style="text-align:right;">
0.7591
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
5
</td>
<td style="text-align:right;">
0.6944444
</td>
<td style="text-align:right;">
0.5106
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
57
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
9.947644
</td>
<td style="text-align:right;">
0.7317
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
1757
</td>
<td style="text-align:right;">
12.066022
</td>
<td style="text-align:right;">
0.9549
</td>
<td style="text-align:right;">
2.45440
</td>
<td style="text-align:right;">
0.4888
</td>
<td style="text-align:right;">
1.70929
</td>
<td style="text-align:right;">
0.1025
</td>
<td style="text-align:right;">
0.7591
</td>
<td style="text-align:right;">
0.7527
</td>
<td style="text-align:right;">
2.91300
</td>
<td style="text-align:right;">
0.68620
</td>
<td style="text-align:right;">
7.83579
</td>
<td style="text-align:right;">
0.4802
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020300
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020300
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
3694
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
842
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
22.79372
</td>
<td style="text-align:right;">
0.5833
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
1994
</td>
<td style="text-align:right;">
2.657974
</td>
<td style="text-align:right;">
0.22050
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
967
</td>
<td style="text-align:right;">
12.099276
</td>
<td style="text-align:right;">
0.11370
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
38.28125
</td>
<td style="text-align:right;">
0.3856
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
19.54108
</td>
<td style="text-align:right;">
0.1827
</td>
<td style="text-align:right;">
317
</td>
<td style="text-align:right;">
2477
</td>
<td style="text-align:right;">
12.797739
</td>
<td style="text-align:right;">
0.6460
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
3673
</td>
<td style="text-align:right;">
3.457664
</td>
<td style="text-align:right;">
0.2308
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
12.56091
</td>
<td style="text-align:right;">
0.3088
</td>
<td style="text-align:right;">
929
</td>
<td style="text-align:right;">
25.14889
</td>
<td style="text-align:right;">
0.7080
</td>
<td style="text-align:right;">
473
</td>
<td style="text-align:right;">
2744
</td>
<td style="text-align:right;">
17.23761
</td>
<td style="text-align:right;">
0.6211
</td>
<td style="text-align:right;">
263
</td>
<td style="text-align:right;">
975
</td>
<td style="text-align:right;">
26.97436
</td>
<td style="text-align:right;">
0.8234
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
3586
</td>
<td style="text-align:right;">
3.5694367
</td>
<td style="text-align:right;">
0.70770
</td>
<td style="text-align:right;">
1331
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
36.03140
</td>
<td style="text-align:right;">
0.5515
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
1.7759563
</td>
<td style="text-align:right;">
0.3675
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.9562842
</td>
<td style="text-align:right;">
0.5389
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
2.5906736
</td>
<td style="text-align:right;">
0.60550
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
3.108808
</td>
<td style="text-align:right;">
0.3415
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3694
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
1.86330
</td>
<td style="text-align:right;">
0.3063
</td>
<td style="text-align:right;">
3.16900
</td>
<td style="text-align:right;">
0.8380
</td>
<td style="text-align:right;">
0.5515
</td>
<td style="text-align:right;">
0.5468
</td>
<td style="text-align:right;">
2.03650
</td>
<td style="text-align:right;">
0.26830
</td>
<td style="text-align:right;">
7.62030
</td>
<td style="text-align:right;">
0.4460
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020400
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020400
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
3539
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
14.21305
</td>
<td style="text-align:right;">
0.3472
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
1658
</td>
<td style="text-align:right;">
2.352232
</td>
<td style="text-align:right;">
0.17990
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
1290
</td>
<td style="text-align:right;">
16.976744
</td>
<td style="text-align:right;">
0.30880
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
21.38728
</td>
<td style="text-align:right;">
0.1037
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
17.90954
</td>
<td style="text-align:right;">
0.1333
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
2775
</td>
<td style="text-align:right;">
6.234234
</td>
<td style="text-align:right;">
0.3351
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
3529
</td>
<td style="text-align:right;">
4.788892
</td>
<td style="text-align:right;">
0.3448
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
27.38062
</td>
<td style="text-align:right;">
0.9225
</td>
<td style="text-align:right;">
510
</td>
<td style="text-align:right;">
14.41085
</td>
<td style="text-align:right;">
0.1208
</td>
<td style="text-align:right;">
670
</td>
<td style="text-align:right;">
3019
</td>
<td style="text-align:right;">
22.19278
</td>
<td style="text-align:right;">
0.8194
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
1137
</td>
<td style="text-align:right;">
13.01671
</td>
<td style="text-align:right;">
0.4541
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
3409
</td>
<td style="text-align:right;">
2.6107363
</td>
<td style="text-align:right;">
0.64690
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
12.82848
</td>
<td style="text-align:right;">
0.2364
</td>
<td style="text-align:right;">
1741
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
8.2136703
</td>
<td style="text-align:right;">
0.6028
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
10
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
0.6112469
</td>
<td style="text-align:right;">
0.28340
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
1636
</td>
<td style="text-align:right;">
4.400978
</td>
<td style="text-align:right;">
0.4538
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3539
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
1.34030
</td>
<td style="text-align:right;">
0.1575
</td>
<td style="text-align:right;">
2.96370
</td>
<td style="text-align:right;">
0.7496
</td>
<td style="text-align:right;">
0.2364
</td>
<td style="text-align:right;">
0.2344
</td>
<td style="text-align:right;">
1.74170
</td>
<td style="text-align:right;">
0.16270
</td>
<td style="text-align:right;">
6.28210
</td>
<td style="text-align:right;">
0.2389
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020500
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020500
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
10674
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
1626
</td>
<td style="text-align:right;">
10509
</td>
<td style="text-align:right;">
15.47245
</td>
<td style="text-align:right;">
0.3851
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
5048
</td>
<td style="text-align:right;">
1.604596
</td>
<td style="text-align:right;">
0.09431
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
2299
</td>
<td style="text-align:right;">
13.962592
</td>
<td style="text-align:right;">
0.17970
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
2125
</td>
<td style="text-align:right;">
33.45882
</td>
<td style="text-align:right;">
0.2836
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
23.32731
</td>
<td style="text-align:right;">
0.3109
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
6816
</td>
<td style="text-align:right;">
7.790493
</td>
<td style="text-align:right;">
0.4251
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
10046
</td>
<td style="text-align:right;">
2.996217
</td>
<td style="text-align:right;">
0.1894
</td>
<td style="text-align:right;">
1613
</td>
<td style="text-align:right;">
15.11149
</td>
<td style="text-align:right;">
0.4553
</td>
<td style="text-align:right;">
2765
</td>
<td style="text-align:right;">
25.90407
</td>
<td style="text-align:right;">
0.7494
</td>
<td style="text-align:right;">
1124
</td>
<td style="text-align:right;">
7281
</td>
<td style="text-align:right;">
15.43744
</td>
<td style="text-align:right;">
0.5253
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2912
</td>
<td style="text-align:right;">
11.74451
</td>
<td style="text-align:right;">
0.4019
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
9920
</td>
<td style="text-align:right;">
0.5241935
</td>
<td style="text-align:right;">
0.35230
</td>
<td style="text-align:right;">
2603
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
24.38636
</td>
<td style="text-align:right;">
0.4160
</td>
<td style="text-align:right;">
4504
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
15.6083481
</td>
<td style="text-align:right;">
0.7378
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
0.6438721
</td>
<td style="text-align:right;">
0.5037
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
0.8363472
</td>
<td style="text-align:right;">
0.33420
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
4424
</td>
<td style="text-align:right;">
4.679023
</td>
<td style="text-align:right;">
0.4754
</td>
<td style="text-align:right;">
176
</td>
<td style="text-align:right;">
10674
</td>
<td style="text-align:right;">
1.648866
</td>
<td style="text-align:right;">
0.7598
</td>
<td style="text-align:right;">
1.40481
</td>
<td style="text-align:right;">
0.1743
</td>
<td style="text-align:right;">
2.48420
</td>
<td style="text-align:right;">
0.4802
</td>
<td style="text-align:right;">
0.4160
</td>
<td style="text-align:right;">
0.4125
</td>
<td style="text-align:right;">
2.81090
</td>
<td style="text-align:right;">
0.63730
</td>
<td style="text-align:right;">
7.11591
</td>
<td style="text-align:right;">
0.3654
</td>
</tr>
<tr>
<td style="text-align:left;">
01001020600
</td>
<td style="text-align:left;">
01
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
020600
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
3536
</td>
<td style="text-align:right;">
1464
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1279
</td>
<td style="text-align:right;">
3523
</td>
<td style="text-align:right;">
36.30429
</td>
<td style="text-align:right;">
0.8215
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
1223
</td>
<td style="text-align:right;">
2.780049
</td>
<td style="text-align:right;">
0.23780
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1111
</td>
<td style="text-align:right;">
28.892889
</td>
<td style="text-align:right;">
0.75870
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
219
</td>
<td style="text-align:right;">
30.59361
</td>
<td style="text-align:right;">
0.2305
</td>
<td style="text-align:right;">
388
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
29.17293
</td>
<td style="text-align:right;">
0.5075
</td>
<td style="text-align:right;">
306
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
12.857143
</td>
<td style="text-align:right;">
0.6480
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
3496
</td>
<td style="text-align:right;">
11.870709
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
547
</td>
<td style="text-align:right;">
15.46946
</td>
<td style="text-align:right;">
0.4760
</td>
<td style="text-align:right;">
982
</td>
<td style="text-align:right;">
27.77149
</td>
<td style="text-align:right;">
0.8327
</td>
<td style="text-align:right;">
729
</td>
<td style="text-align:right;">
2514
</td>
<td style="text-align:right;">
28.99761
</td>
<td style="text-align:right;">
0.9488
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
880
</td>
<td style="text-align:right;">
10.79545
</td>
<td style="text-align:right;">
0.3601
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3394
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09479
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
27.85633
</td>
<td style="text-align:right;">
0.4608
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
0.1079
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
24.8633880
</td>
<td style="text-align:right;">
0.9300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09796
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
1.278196
</td>
<td style="text-align:right;">
0.1463
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3536
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1831
</td>
<td style="text-align:right;">
2.96830
</td>
<td style="text-align:right;">
0.6434
</td>
<td style="text-align:right;">
2.71239
</td>
<td style="text-align:right;">
0.6156
</td>
<td style="text-align:right;">
0.4608
</td>
<td style="text-align:right;">
0.4569
</td>
<td style="text-align:right;">
1.46526
</td>
<td style="text-align:right;">
0.08976
</td>
<td style="text-align:right;">
7.60675
</td>
<td style="text-align:right;">
0.4440
</td>
</tr>
</tbody>
</table>

</div>

``` r
svi_2020_national <- svi_theme_flags(svi_2020_national, .90)
svi_2020_national %>% arrange(desc(F_TOTAL)) %>% head() %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
SPL_THEME1
</th>
<th style="text-align:right;">
RPL_THEME1
</th>
<th style="text-align:right;">
F_THEME1
</th>
<th style="text-align:right;">
SPL_THEME2
</th>
<th style="text-align:right;">
RPL_THEME2
</th>
<th style="text-align:right;">
F_THEME2
</th>
<th style="text-align:right;">
SPL_THEME3
</th>
<th style="text-align:right;">
RPL_THEME3
</th>
<th style="text-align:right;">
F_THEME3
</th>
<th style="text-align:right;">
SPL_THEME4
</th>
<th style="text-align:right;">
RPL_THEME4
</th>
<th style="text-align:right;">
F_THEME4
</th>
<th style="text-align:right;">
SPL_THEMES
</th>
<th style="text-align:right;">
RPL_THEMES
</th>
<th style="text-align:right;">
F_TOTAL
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
48141000404
</td>
<td style="text-align:left;">
48
</td>
<td style="text-align:left;">
141
</td>
<td style="text-align:left;">
000404
</td>
<td style="text-align:left;">
TX
</td>
<td style="text-align:left;">
Texas
</td>
<td style="text-align:left;">
El Paso County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
West South Central Division
</td>
<td style="text-align:right;">
3380
</td>
<td style="text-align:right;">
1648
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
2390
</td>
<td style="text-align:right;">
3380
</td>
<td style="text-align:right;">
70.71006
</td>
<td style="text-align:right;">
0.9928
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
210
</td>
<td style="text-align:right;">
1268
</td>
<td style="text-align:right;">
16.56151
</td>
<td style="text-align:right;">
0.9697
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
154
</td>
<td style="text-align:right;">
7.792208
</td>
<td style="text-align:right;">
0.02796
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
705
</td>
<td style="text-align:right;">
1067
</td>
<td style="text-align:right;">
66.07310
</td>
<td style="text-align:right;">
0.9281
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
717
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
58.72236
</td>
<td style="text-align:right;">
0.9772
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
745
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
38.10742
</td>
<td style="text-align:right;">
0.9703
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1234
</td>
<td style="text-align:right;">
3370
</td>
<td style="text-align:right;">
36.61721
</td>
<td style="text-align:right;">
0.9940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
10.917160
</td>
<td style="text-align:right;">
0.22390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1070
</td>
<td style="text-align:right;">
31.65680
</td>
<td style="text-align:right;">
0.9356
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
664
</td>
<td style="text-align:right;">
2300
</td>
<td style="text-align:right;">
28.86957
</td>
<td style="text-align:right;">
0.9477
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
47.96321
</td>
<td style="text-align:right;">
0.9741
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
649
</td>
<td style="text-align:right;">
3025
</td>
<td style="text-align:right;">
21.45455
</td>
<td style="text-align:right;">
0.9659
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3222
</td>
<td style="text-align:right;">
3380
</td>
<td style="text-align:right;">
95.32544
</td>
<td style="text-align:right;">
0.9478
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1648
</td>
<td style="text-align:right;">
701
</td>
<td style="text-align:right;">
42.53641
</td>
<td style="text-align:right;">
0.9214
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
130
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
10.647011
</td>
<td style="text-align:right;">
0.9224
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
344
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
28.17363
</td>
<td style="text-align:right;">
0.9344
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3380
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
4.9040
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
4.04720
</td>
<td style="text-align:right;">
0.9848
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.9478
</td>
<td style="text-align:right;">
0.9398
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.1799
</td>
<td style="text-align:right;">
0.8000
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
13.07890
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
13
</td>
</tr>
<tr>
<td style="text-align:left;">
06037224420
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
037
</td>
<td style="text-align:left;">
224420
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Los Angeles County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
943
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
1562
</td>
<td style="text-align:right;">
2389
</td>
<td style="text-align:right;">
65.38301
</td>
<td style="text-align:right;">
0.9868
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
232
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
16.22378
</td>
<td style="text-align:right;">
0.9672
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
22.807018
</td>
<td style="text-align:right;">
0.56500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
826
</td>
<td style="text-align:right;">
70.70218
</td>
<td style="text-align:right;">
0.9614
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
67.61042
</td>
<td style="text-align:right;">
0.9949
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
894
</td>
<td style="text-align:right;">
1588
</td>
<td style="text-align:right;">
56.29723
</td>
<td style="text-align:right;">
0.9975
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
605
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
22.82158
</td>
<td style="text-align:right;">
0.9514
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
9.166352
</td>
<td style="text-align:right;">
0.14720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
543
</td>
<td style="text-align:right;">
20.48284
</td>
<td style="text-align:right;">
0.4073
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
1889
</td>
<td style="text-align:right;">
11.16993
</td>
<td style="text-align:right;">
0.2666
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
36.25219
</td>
<td style="text-align:right;">
0.9217
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
870
</td>
<td style="text-align:right;">
2539
</td>
<td style="text-align:right;">
34.26546
</td>
<td style="text-align:right;">
0.9937
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2523
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
95.17163
</td>
<td style="text-align:right;">
0.9465
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
943
</td>
<td style="text-align:right;">
540
</td>
<td style="text-align:right;">
57.26405
</td>
<td style="text-align:right;">
0.9549
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
344
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
38.958097
</td>
<td style="text-align:right;">
0.9984
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
302
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
34.20159
</td>
<td style="text-align:right;">
0.9522
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
253
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
9.5435685
</td>
<td style="text-align:right;">
0.9459
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.8978
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2.73650
</td>
<td style="text-align:right;">
0.6297
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9465
</td>
<td style="text-align:right;">
0.9385
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.0700
</td>
<td style="text-align:right;">
0.9818
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
12.65080
</td>
<td style="text-align:right;">
0.9801
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
12086001401
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
086
</td>
<td style="text-align:left;">
001401
</td>
<td style="text-align:left;">
FL
</td>
<td style="text-align:left;">
Florida
</td>
<td style="text-align:left;">
Miami-Dade County
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
6606
</td>
<td style="text-align:right;">
2427
</td>
<td style="text-align:right;">
2203
</td>
<td style="text-align:right;">
4080
</td>
<td style="text-align:right;">
6606
</td>
<td style="text-align:right;">
61.76203
</td>
<td style="text-align:right;">
0.9802
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
314
</td>
<td style="text-align:right;">
2673
</td>
<td style="text-align:right;">
11.74710
</td>
<td style="text-align:right;">
0.9138
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
134
</td>
<td style="text-align:right;">
300
</td>
<td style="text-align:right;">
44.666667
</td>
<td style="text-align:right;">
0.95870
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1111
</td>
<td style="text-align:right;">
1903
</td>
<td style="text-align:right;">
58.38150
</td>
<td style="text-align:right;">
0.8314
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1245
</td>
<td style="text-align:right;">
2203
</td>
<td style="text-align:right;">
56.51384
</td>
<td style="text-align:right;">
0.9682
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1363
</td>
<td style="text-align:right;">
4012
</td>
<td style="text-align:right;">
33.97308
</td>
<td style="text-align:right;">
0.9551
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1313
</td>
<td style="text-align:right;">
6606
</td>
<td style="text-align:right;">
19.87587
</td>
<td style="text-align:right;">
0.9252
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
732
</td>
<td style="text-align:right;">
11.080836
</td>
<td style="text-align:right;">
0.23160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1985
</td>
<td style="text-align:right;">
30.04844
</td>
<td style="text-align:right;">
0.9023
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
670
</td>
<td style="text-align:right;">
4621
</td>
<td style="text-align:right;">
14.49903
</td>
<td style="text-align:right;">
0.4697
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
606
</td>
<td style="text-align:right;">
1267
</td>
<td style="text-align:right;">
47.82952
</td>
<td style="text-align:right;">
0.9736
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
854
</td>
<td style="text-align:right;">
5756
</td>
<td style="text-align:right;">
14.83669
</td>
<td style="text-align:right;">
0.9273
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6592
</td>
<td style="text-align:right;">
6606
</td>
<td style="text-align:right;">
99.78807
</td>
<td style="text-align:right;">
0.9954
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2427
</td>
<td style="text-align:right;">
965
</td>
<td style="text-align:right;">
39.76102
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
378
</td>
<td style="text-align:right;">
2203
</td>
<td style="text-align:right;">
17.158420
</td>
<td style="text-align:right;">
0.9692
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
2203
</td>
<td style="text-align:right;">
35.27009
</td>
<td style="text-align:right;">
0.9546
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
6606
</td>
<td style="text-align:right;">
0.6055101
</td>
<td style="text-align:right;">
0.6241
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.7425
</td>
<td style="text-align:right;">
0.9867
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.50450
</td>
<td style="text-align:right;">
0.9317
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9954
</td>
<td style="text-align:right;">
0.9870
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6790
</td>
<td style="text-align:right;">
0.9403
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
12.92140
</td>
<td style="text-align:right;">
0.9845
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
27053005902
</td>
<td style="text-align:left;">
27
</td>
<td style="text-align:left;">
053
</td>
<td style="text-align:left;">
005902
</td>
<td style="text-align:left;">
MN
</td>
<td style="text-align:left;">
Minnesota
</td>
<td style="text-align:left;">
Hennepin County
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Midwest Region
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West North Central Division
</td>
<td style="text-align:right;">
3896
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
1087
</td>
<td style="text-align:right;">
2343
</td>
<td style="text-align:right;">
3739
</td>
<td style="text-align:right;">
62.66381
</td>
<td style="text-align:right;">
0.9824
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
1842
</td>
<td style="text-align:right;">
12.26927
</td>
<td style="text-align:right;">
0.9232
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
29.577465
</td>
<td style="text-align:right;">
0.77560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
521
</td>
<td style="text-align:right;">
1016
</td>
<td style="text-align:right;">
51.27953
</td>
<td style="text-align:right;">
0.6904
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
542
</td>
<td style="text-align:right;">
1087
</td>
<td style="text-align:right;">
49.86201
</td>
<td style="text-align:right;">
0.9223
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
1932
</td>
<td style="text-align:right;">
37.21532
</td>
<td style="text-align:right;">
0.9675
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
608
</td>
<td style="text-align:right;">
3896
</td>
<td style="text-align:right;">
15.60575
</td>
<td style="text-align:right;">
0.8581
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
87
</td>
<td style="text-align:right;">
2.233059
</td>
<td style="text-align:right;">
0.01142
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1442
</td>
<td style="text-align:right;">
37.01232
</td>
<td style="text-align:right;">
0.9852
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
640
</td>
<td style="text-align:right;">
2440
</td>
<td style="text-align:right;">
26.22951
</td>
<td style="text-align:right;">
0.9114
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
583
</td>
<td style="text-align:right;">
46.99828
</td>
<td style="text-align:right;">
0.9714
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
444
</td>
<td style="text-align:right;">
3462
</td>
<td style="text-align:right;">
12.82496
</td>
<td style="text-align:right;">
0.9096
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2911
</td>
<td style="text-align:right;">
3896
</td>
<td style="text-align:right;">
74.71766
</td>
<td style="text-align:right;">
0.8205
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
721
</td>
<td style="text-align:right;">
61.46633
</td>
<td style="text-align:right;">
0.9616
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
226
</td>
<td style="text-align:right;">
1087
</td>
<td style="text-align:right;">
20.791168
</td>
<td style="text-align:right;">
0.9809
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
1087
</td>
<td style="text-align:right;">
29.71481
</td>
<td style="text-align:right;">
0.9398
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
579
</td>
<td style="text-align:right;">
3896
</td>
<td style="text-align:right;">
14.8613963
</td>
<td style="text-align:right;">
0.9619
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.6535
</td>
<td style="text-align:right;">
0.9834
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.78902
</td>
<td style="text-align:right;">
0.9713
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
0.8205
</td>
<td style="text-align:right;">
0.8136
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.0628
</td>
<td style="text-align:right;">
0.9815
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
13.32582
</td>
<td style="text-align:right;">
0.9873
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
34001002400
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
001
</td>
<td style="text-align:left;">
002400
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Atlantic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
1726
</td>
<td style="text-align:right;">
1217
</td>
<td style="text-align:right;">
1579
</td>
<td style="text-align:right;">
2612
</td>
<td style="text-align:right;">
60.45176
</td>
<td style="text-align:right;">
0.9773
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
1171
</td>
<td style="text-align:right;">
24.76516
</td>
<td style="text-align:right;">
0.9931
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
54.330709
</td>
<td style="text-align:right;">
0.98500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
538
</td>
<td style="text-align:right;">
1090
</td>
<td style="text-align:right;">
49.35780
</td>
<td style="text-align:right;">
0.6469
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
1217
</td>
<td style="text-align:right;">
49.87675
</td>
<td style="text-align:right;">
0.9224
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
697
</td>
<td style="text-align:right;">
1998
</td>
<td style="text-align:right;">
34.88488
</td>
<td style="text-align:right;">
0.9590
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
551
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
21.07881
</td>
<td style="text-align:right;">
0.9374
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
516
</td>
<td style="text-align:right;">
19.739862
</td>
<td style="text-align:right;">
0.70560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
503
</td>
<td style="text-align:right;">
19.24254
</td>
<td style="text-align:right;">
0.3280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
576
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
27.28565
</td>
<td style="text-align:right;">
0.9280
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
257
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
45.32628
</td>
<td style="text-align:right;">
0.9667
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
556
</td>
<td style="text-align:right;">
2368
</td>
<td style="text-align:right;">
23.47973
</td>
<td style="text-align:right;">
0.9732
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2029
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
77.62050
</td>
<td style="text-align:right;">
0.8359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1726
</td>
<td style="text-align:right;">
1166
</td>
<td style="text-align:right;">
67.55504
</td>
<td style="text-align:right;">
0.9693
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
1217
</td>
<td style="text-align:right;">
9.449466
</td>
<td style="text-align:right;">
0.9062
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
673
</td>
<td style="text-align:right;">
1217
</td>
<td style="text-align:right;">
55.29992
</td>
<td style="text-align:right;">
0.9828
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
223
</td>
<td style="text-align:right;">
2614
</td>
<td style="text-align:right;">
8.5309870
</td>
<td style="text-align:right;">
0.9407
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.7892
</td>
<td style="text-align:right;">
0.9877
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.90150
</td>
<td style="text-align:right;">
0.9792
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.8359
</td>
<td style="text-align:right;">
0.8288
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.0176
</td>
<td style="text-align:right;">
0.9793
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
13.54420
</td>
<td style="text-align:right;">
0.9879
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
34039039300
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
039
</td>
<td style="text-align:left;">
039300
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Union County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
6145
</td>
<td style="text-align:right;">
1835
</td>
<td style="text-align:right;">
1727
</td>
<td style="text-align:right;">
3492
</td>
<td style="text-align:right;">
6096
</td>
<td style="text-align:right;">
57.28346
</td>
<td style="text-align:right;">
0.9684
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
350
</td>
<td style="text-align:right;">
3006
</td>
<td style="text-align:right;">
11.64338
</td>
<td style="text-align:right;">
0.9114
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
140
</td>
<td style="text-align:right;">
41.428571
</td>
<td style="text-align:right;">
0.94020
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
829
</td>
<td style="text-align:right;">
1587
</td>
<td style="text-align:right;">
52.23692
</td>
<td style="text-align:right;">
0.7127
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
887
</td>
<td style="text-align:right;">
1727
</td>
<td style="text-align:right;">
51.36074
</td>
<td style="text-align:right;">
0.9352
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1367
</td>
<td style="text-align:right;">
3639
</td>
<td style="text-align:right;">
37.56527
</td>
<td style="text-align:right;">
0.9686
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2771
</td>
<td style="text-align:right;">
6145
</td>
<td style="text-align:right;">
45.09357
</td>
<td style="text-align:right;">
0.9987
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
6.509357
</td>
<td style="text-align:right;">
0.06257
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2006
</td>
<td style="text-align:right;">
32.64443
</td>
<td style="text-align:right;">
0.9503
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
443
</td>
<td style="text-align:right;">
4139
</td>
<td style="text-align:right;">
10.70307
</td>
<td style="text-align:right;">
0.2400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
476
</td>
<td style="text-align:right;">
1178
</td>
<td style="text-align:right;">
40.40747
</td>
<td style="text-align:right;">
0.9470
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
5714
</td>
<td style="text-align:right;">
34.63423
</td>
<td style="text-align:right;">
0.9941
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5955
</td>
<td style="text-align:right;">
6145
</td>
<td style="text-align:right;">
96.90806
</td>
<td style="text-align:right;">
0.9624
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1835
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
44.41417
</td>
<td style="text-align:right;">
0.9271
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
391
</td>
<td style="text-align:right;">
1727
</td>
<td style="text-align:right;">
22.640417
</td>
<td style="text-align:right;">
0.9849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
1727
</td>
<td style="text-align:right;">
43.31210
</td>
<td style="text-align:right;">
0.9692
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
6145
</td>
<td style="text-align:right;">
1.8551668
</td>
<td style="text-align:right;">
0.7766
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.7823
</td>
<td style="text-align:right;">
0.9877
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.19397
</td>
<td style="text-align:right;">
0.8468
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9624
</td>
<td style="text-align:right;">
0.9543
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.8764
</td>
<td style="text-align:right;">
0.9680
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
12.81507
</td>
<td style="text-align:right;">
0.9830
</td>
<td style="text-align:right;">
12
</td>
</tr>
</tbody>
</table>

</div>

# Analysis: CDC SVI Index

As we previously discussed in the introduction, the CDC Social Vulnerability Index is a measure that allows us to identify areas of the United States that are particularly susceptible to difficulties during national disasters due to a lack of community resources and large amounts of disparities across social, physical, and economic factors:

-  Theme 1 is Socioeconomic Status 
-  Theme 2 is Household Characteristics
-  Theme 3 is Racial & Ethnic Minority Status 
-  Theme 4 is Housing Type & Transportation

Cupcake ipsum dolor sit amet cotton candy. Lollipop tiramisu cotton
candy topping biscuit wafer jelly gingerbread danish. Pastry tart powder
fruitcake brownie sweet shortbread. Muffin shortbread soufflé brownie
liquorice topping gummies.

Tart cupcake cheesecake tart toffee cake jelly beans sweet roll. Sweet
chocolate toffee dragée fruitcake gummies marshmallow lemon drops. Gummi
bears sweet roll lemon drops jelly-o gummi bears halvah tiramisu
gingerbread croissant. Caramels liquorice jujubes pastry sesame snaps
cotton candy jelly-o icing.


## National Analysis

Nationally, we find that the most & least vulnerable tracts by THEME1, THEME2, THEME3, THEME4, OVERALL for 2020 and 2010 are the following:

***EXAMPLE RESPONSE:***

``` r
# Calculate national SVI variables and flags for 2010
svi_2010_national <- svi_theme_variables(svi_2010_national)
svi_2010_national <- svi_theme_flags(svi_2010_national, .90)
```

``` r
# Find most vulnerable tracts in 2010 for THEME 1 - SES
svi_2010_national %>% filter(!is.na(F_THEME1)) %>% filter(E_TOTPOP_10 > 100) %>% arrange(desc(RPL_THEME1)) %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
SPL_THEME1
</th>
<th style="text-align:right;">
RPL_THEME1
</th>
<th style="text-align:right;">
F_THEME1
</th>
<th style="text-align:right;">
SPL_THEME2
</th>
<th style="text-align:right;">
RPL_THEME2
</th>
<th style="text-align:right;">
F_THEME2
</th>
<th style="text-align:right;">
SPL_THEME3
</th>
<th style="text-align:right;">
RPL_THEME3
</th>
<th style="text-align:right;">
F_THEME3
</th>
<th style="text-align:right;">
SPL_THEME4
</th>
<th style="text-align:right;">
RPL_THEME4
</th>
<th style="text-align:right;">
F_THEME4
</th>
<th style="text-align:right;">
SPL_THEMES
</th>
<th style="text-align:right;">
RPL_THEMES
</th>
<th style="text-align:right;">
F_TOTAL
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
06065042505
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
065
</td>
<td style="text-align:left;">
042505
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Riverside County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
3860
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
2783
</td>
<td style="text-align:right;">
3845
</td>
<td style="text-align:right;">
72.37971
</td>
<td style="text-align:right;">
0.9905
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
1320
</td>
<td style="text-align:right;">
22.04545
</td>
<td style="text-align:right;">
0.9695
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
347
</td>
<td style="text-align:right;">
72.33429
</td>
<td style="text-align:right;">
0.9912
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
278
</td>
<td style="text-align:right;">
470
</td>
<td style="text-align:right;">
59.14894
</td>
<td style="text-align:right;">
0.8153
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
529
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
64.74908
</td>
<td style="text-align:right;">
0.9836
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
948
</td>
<td style="text-align:right;">
1634
</td>
<td style="text-align:right;">
58.01714
</td>
<td style="text-align:right;">
0.9922
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1481
</td>
<td style="text-align:right;">
4073
</td>
<td style="text-align:right;">
36.36140
</td>
<td style="text-align:right;">
0.9668
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
2.564767
</td>
<td style="text-align:right;">
0.023850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1663
</td>
<td style="text-align:right;">
43.0829016
</td>
<td style="text-align:right;">
0.995100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
280
</td>
<td style="text-align:right;">
2391
</td>
<td style="text-align:right;">
11.710581
</td>
<td style="text-align:right;">
0.3347
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
212
</td>
<td style="text-align:right;">
736
</td>
<td style="text-align:right;">
28.80435
</td>
<td style="text-align:right;">
0.833100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
860
</td>
<td style="text-align:right;">
3317
</td>
<td style="text-align:right;">
25.927042
</td>
<td style="text-align:right;">
0.9676
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3648
</td>
<td style="text-align:right;">
3860
</td>
<td style="text-align:right;">
94.50777
</td>
<td style="text-align:right;">
0.9391
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
5.753138
</td>
<td style="text-align:right;">
0.5628
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
3.451883
</td>
<td style="text-align:right;">
0.6480
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
302
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
36.964504
</td>
<td style="text-align:right;">
0.9965
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
817
</td>
<td style="text-align:right;">
6.364749
</td>
<td style="text-align:right;">
0.57210
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3860
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9026
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.154350
</td>
<td style="text-align:right;">
0.81900
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9391
</td>
<td style="text-align:right;">
0.9304
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.14340
</td>
<td style="text-align:right;">
0.7960
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12.13945
</td>
<td style="text-align:right;">
0.9581
</td>
<td style="text-align:right;">
9
</td>
</tr>
<tr>
<td style="text-align:left;">
06079012800
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
079
</td>
<td style="text-align:left;">
012800
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
San Luis Obispo County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2407
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
252
</td>
<td style="text-align:right;">
319
</td>
<td style="text-align:right;">
78.99687
</td>
<td style="text-align:right;">
0.9956
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
59.18367
</td>
<td style="text-align:right;">
0.9997
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
NaN
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.9973
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.9997
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1010
</td>
<td style="text-align:right;">
2255
</td>
<td style="text-align:right;">
44.78936
</td>
<td style="text-align:right;">
0.9675
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
32.38095
</td>
<td style="text-align:right;">
0.9436
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
2.825093
</td>
<td style="text-align:right;">
0.027780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
0.6647279
</td>
<td style="text-align:right;">
0.006176
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
11.363636
</td>
<td style="text-align:right;">
0.3128
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.007664
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
2391
</td>
<td style="text-align:right;">
5.144291
</td>
<td style="text-align:right;">
0.7574
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1180
</td>
<td style="text-align:right;">
2407
</td>
<td style="text-align:right;">
49.02368
</td>
<td style="text-align:right;">
0.7095
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
25.490196
</td>
<td style="text-align:right;">
0.8515
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
51
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
0
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.02586
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2327
</td>
<td style="text-align:right;">
2407
</td>
<td style="text-align:right;">
96.676361
</td>
<td style="text-align:right;">
0.9969
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.9061
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
1.111820
</td>
<td style="text-align:right;">
0.01755
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.7095
</td>
<td style="text-align:right;">
0.7029
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.21786
</td>
<td style="text-align:right;">
0.3426
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.94528
</td>
<td style="text-align:right;">
0.6405
</td>
<td style="text-align:right;">
6
</td>
</tr>
<tr>
<td style="text-align:left;">
12086001402
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
086
</td>
<td style="text-align:left;">
001402
</td>
<td style="text-align:left;">
FL
</td>
<td style="text-align:left;">
Florida
</td>
<td style="text-align:left;">
Miami-Dade County
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
4698
</td>
<td style="text-align:right;">
1821
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
3601
</td>
<td style="text-align:right;">
4655
</td>
<td style="text-align:right;">
77.35768
</td>
<td style="text-align:right;">
0.9946
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
424
</td>
<td style="text-align:right;">
1492
</td>
<td style="text-align:right;">
28.41823
</td>
<td style="text-align:right;">
0.9891
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
192
</td>
<td style="text-align:right;">
319
</td>
<td style="text-align:right;">
60.18809
</td>
<td style="text-align:right;">
0.9699
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
981
</td>
<td style="text-align:right;">
1239
</td>
<td style="text-align:right;">
79.17676
</td>
<td style="text-align:right;">
0.9788
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
75.28883
</td>
<td style="text-align:right;">
0.9972
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1391
</td>
<td style="text-align:right;">
2527
</td>
<td style="text-align:right;">
55.04551
</td>
<td style="text-align:right;">
0.9887
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1867
</td>
<td style="text-align:right;">
5070
</td>
<td style="text-align:right;">
36.82446
</td>
<td style="text-align:right;">
0.9688
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
660
</td>
<td style="text-align:right;">
14.048531
</td>
<td style="text-align:right;">
0.606600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1630
</td>
<td style="text-align:right;">
34.6956152
</td>
<td style="text-align:right;">
0.945600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
653
</td>
<td style="text-align:right;">
3270
</td>
<td style="text-align:right;">
19.969419
</td>
<td style="text-align:right;">
0.7702
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
315
</td>
<td style="text-align:right;">
875
</td>
<td style="text-align:right;">
36.00000
</td>
<td style="text-align:right;">
0.907000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1312
</td>
<td style="text-align:right;">
4372
</td>
<td style="text-align:right;">
30.009149
</td>
<td style="text-align:right;">
0.9787
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4486
</td>
<td style="text-align:right;">
4698
</td>
<td style="text-align:right;">
95.48744
</td>
<td style="text-align:right;">
0.9459
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1821
</td>
<td style="text-align:right;">
520
</td>
<td style="text-align:right;">
28.555739
</td>
<td style="text-align:right;">
0.8714
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
12.195122
</td>
<td style="text-align:right;">
0.9391
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
1558
</td>
<td style="text-align:right;">
35.943517
</td>
<td style="text-align:right;">
0.95170
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4698
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9384
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
4.208100
</td>
<td style="text-align:right;">
0.98550
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9459
</td>
<td style="text-align:right;">
0.9371
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.34600
</td>
<td style="text-align:right;">
0.8704
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
13.43840
</td>
<td style="text-align:right;">
0.9864
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
12086980700
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
086
</td>
<td style="text-align:left;">
980700
</td>
<td style="text-align:left;">
FL
</td>
<td style="text-align:left;">
Florida
</td>
<td style="text-align:left;">
Miami-Dade County
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
748
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
91.17647
</td>
<td style="text-align:right;">
0.9989
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
203
</td>
<td style="text-align:right;">
56.15764
</td>
<td style="text-align:right;">
0.9996
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
NaN
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.9973
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.9997
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
272
</td>
<td style="text-align:right;">
480
</td>
<td style="text-align:right;">
56.66667
</td>
<td style="text-align:right;">
0.9907
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
917
</td>
<td style="text-align:right;">
61.06870
</td>
<td style="text-align:right;">
0.9992
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
0.003233
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
130
</td>
<td style="text-align:right;">
17.3796791
</td>
<td style="text-align:right;">
0.150500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
723
</td>
<td style="text-align:right;">
23.928078
</td>
<td style="text-align:right;">
0.8840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.999800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
11.436950
</td>
<td style="text-align:right;">
0.8771
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
621
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
83.02139
</td>
<td style="text-align:right;">
0.8779
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
100.000000
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
100.000000
</td>
<td style="text-align:right;">
1.0000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.02586
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
528
</td>
<td style="text-align:right;">
748
</td>
<td style="text-align:right;">
70.588235
</td>
<td style="text-align:right;">
0.9937
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.9881
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2.914633
</td>
<td style="text-align:right;">
0.71540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.8779
</td>
<td style="text-align:right;">
0.8697
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.14196
</td>
<td style="text-align:right;">
0.7955
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.92259
</td>
<td style="text-align:right;">
0.9453
</td>
<td style="text-align:right;">
9
</td>
</tr>
<tr>
<td style="text-align:left;">
32003004301
</td>
<td style="text-align:left;">
32
</td>
<td style="text-align:left;">
003
</td>
<td style="text-align:left;">
004301
</td>
<td style="text-align:left;">
NV
</td>
<td style="text-align:left;">
Nevada
</td>
<td style="text-align:left;">
Clark County
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
South Atlantic Division
</td>
<td style="text-align:right;">
2029
</td>
<td style="text-align:right;">
631
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
1797
</td>
<td style="text-align:right;">
2029
</td>
<td style="text-align:right;">
88.56580
</td>
<td style="text-align:right;">
0.9983
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
721
</td>
<td style="text-align:right;">
23.02358
</td>
<td style="text-align:right;">
0.9740
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
63.63636
</td>
<td style="text-align:right;">
0.9790
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
332
</td>
<td style="text-align:right;">
485
</td>
<td style="text-align:right;">
68.45361
</td>
<td style="text-align:right;">
0.9280
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
68.24458
</td>
<td style="text-align:right;">
0.9909
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
893
</td>
<td style="text-align:right;">
79.61926
</td>
<td style="text-align:right;">
0.9998
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1133
</td>
<td style="text-align:right;">
1908
</td>
<td style="text-align:right;">
59.38155
</td>
<td style="text-align:right;">
0.9990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
3.104978
</td>
<td style="text-align:right;">
0.032440
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
925
</td>
<td style="text-align:right;">
45.5889601
</td>
<td style="text-align:right;">
0.997400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
1096
</td>
<td style="text-align:right;">
7.846715
</td>
<td style="text-align:right;">
0.1199
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
181
</td>
<td style="text-align:right;">
436
</td>
<td style="text-align:right;">
41.51376
</td>
<td style="text-align:right;">
0.942300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
606
</td>
<td style="text-align:right;">
1677
</td>
<td style="text-align:right;">
36.135957
</td>
<td style="text-align:right;">
0.9899
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1834
</td>
<td style="text-align:right;">
2029
</td>
<td style="text-align:right;">
90.38935
</td>
<td style="text-align:right;">
0.9142
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
631
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.1224
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
206
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
40.631164
</td>
<td style="text-align:right;">
0.9978
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
27.416174
</td>
<td style="text-align:right;">
0.92590
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2029
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9620
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.081940
</td>
<td style="text-align:right;">
0.79010
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9142
</td>
<td style="text-align:right;">
0.9057
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.62990
</td>
<td style="text-align:right;">
0.5570
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.58804
</td>
<td style="text-align:right;">
0.9202
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
32003004602
</td>
<td style="text-align:left;">
32
</td>
<td style="text-align:left;">
003
</td>
<td style="text-align:left;">
004602
</td>
<td style="text-align:left;">
NV
</td>
<td style="text-align:left;">
Nevada
</td>
<td style="text-align:left;">
Clark County
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
South Atlantic Division
</td>
<td style="text-align:right;">
3326
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
2068
</td>
<td style="text-align:right;">
3068
</td>
<td style="text-align:right;">
67.40548
</td>
<td style="text-align:right;">
0.9834
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
272
</td>
<td style="text-align:right;">
1370
</td>
<td style="text-align:right;">
19.85401
</td>
<td style="text-align:right;">
0.9555
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
240
</td>
<td style="text-align:right;">
47.08333
</td>
<td style="text-align:right;">
0.8806
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
449
</td>
<td style="text-align:right;">
575
</td>
<td style="text-align:right;">
78.08696
</td>
<td style="text-align:right;">
0.9761
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
562
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
68.95706
</td>
<td style="text-align:right;">
0.9920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1012
</td>
<td style="text-align:right;">
1577
</td>
<td style="text-align:right;">
64.17248
</td>
<td style="text-align:right;">
0.9972
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1718
</td>
<td style="text-align:right;">
3259
</td>
<td style="text-align:right;">
52.71556
</td>
<td style="text-align:right;">
0.9978
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
247
</td>
<td style="text-align:right;">
7.426338
</td>
<td style="text-align:right;">
0.187900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1332
</td>
<td style="text-align:right;">
40.0481058
</td>
<td style="text-align:right;">
0.987800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
241
</td>
<td style="text-align:right;">
1726
</td>
<td style="text-align:right;">
13.962920
</td>
<td style="text-align:right;">
0.4727
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
110
</td>
<td style="text-align:right;">
642
</td>
<td style="text-align:right;">
17.13396
</td>
<td style="text-align:right;">
0.584500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
840
</td>
<td style="text-align:right;">
2903
</td>
<td style="text-align:right;">
28.935584
</td>
<td style="text-align:right;">
0.9763
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2909
</td>
<td style="text-align:right;">
3326
</td>
<td style="text-align:right;">
87.46242
</td>
<td style="text-align:right;">
0.8990
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
8.580858
</td>
<td style="text-align:right;">
0.6358
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
7.590759
</td>
<td style="text-align:right;">
0.7359
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
222
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
27.239264
</td>
<td style="text-align:right;">
0.9895
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
815
</td>
<td style="text-align:right;">
11.165644
</td>
<td style="text-align:right;">
0.75250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
3326
</td>
<td style="text-align:right;">
4.840649
</td>
<td style="text-align:right;">
0.8850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9259
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.209200
</td>
<td style="text-align:right;">
0.83930
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8990
</td>
<td style="text-align:right;">
0.8906
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.99870
</td>
<td style="text-align:right;">
0.9798
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
13.03280
</td>
<td style="text-align:right;">
0.9838
</td>
<td style="text-align:right;">
8
</td>
</tr>
<tr>
<td style="text-align:left;">
48113002701
</td>
<td style="text-align:left;">
48
</td>
<td style="text-align:left;">
113
</td>
<td style="text-align:left;">
002701
</td>
<td style="text-align:left;">
TX
</td>
<td style="text-align:left;">
Texas
</td>
<td style="text-align:left;">
Dallas County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
West South Central Division
</td>
<td style="text-align:right;">
2205
</td>
<td style="text-align:right;">
1212
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
1848
</td>
<td style="text-align:right;">
2165
</td>
<td style="text-align:right;">
85.35797
</td>
<td style="text-align:right;">
0.9978
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
153
</td>
<td style="text-align:right;">
653
</td>
<td style="text-align:right;">
23.43032
</td>
<td style="text-align:right;">
0.9757
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
217
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
66.15854
</td>
<td style="text-align:right;">
0.9838
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
468
</td>
<td style="text-align:right;">
624
</td>
<td style="text-align:right;">
75.00000
</td>
<td style="text-align:right;">
0.9661
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
685
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
71.95378
</td>
<td style="text-align:right;">
0.9953
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
700
</td>
<td style="text-align:right;">
1532
</td>
<td style="text-align:right;">
45.69191
</td>
<td style="text-align:right;">
0.9703
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1007
</td>
<td style="text-align:right;">
2578
</td>
<td style="text-align:right;">
39.06129
</td>
<td style="text-align:right;">
0.9773
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
339
</td>
<td style="text-align:right;">
15.374150
</td>
<td style="text-align:right;">
0.686200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
541
</td>
<td style="text-align:right;">
24.5351474
</td>
<td style="text-align:right;">
0.542900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
592
</td>
<td style="text-align:right;">
1839
</td>
<td style="text-align:right;">
32.191408
</td>
<td style="text-align:right;">
0.9785
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
448
</td>
<td style="text-align:right;">
35.93750
</td>
<td style="text-align:right;">
0.906500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
2062
</td>
<td style="text-align:right;">
8.341416
</td>
<td style="text-align:right;">
0.8331
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2158
</td>
<td style="text-align:right;">
2205
</td>
<td style="text-align:right;">
97.86848
</td>
<td style="text-align:right;">
0.9670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1212
</td>
<td style="text-align:right;">
195
</td>
<td style="text-align:right;">
16.089109
</td>
<td style="text-align:right;">
0.7619
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
2.415966
</td>
<td style="text-align:right;">
0.6206
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
402
</td>
<td style="text-align:right;">
952
</td>
<td style="text-align:right;">
42.226891
</td>
<td style="text-align:right;">
0.96400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2205
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9164
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.947200
</td>
<td style="text-align:right;">
0.97840
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9670
</td>
<td style="text-align:right;">
0.9580
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.93030
</td>
<td style="text-align:right;">
0.7040
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12.76090
</td>
<td style="text-align:right;">
0.9795
</td>
<td style="text-align:right;">
9
</td>
</tr>
<tr>
<td style="text-align:left;">
04013113900
</td>
<td style="text-align:left;">
04
</td>
<td style="text-align:left;">
013
</td>
<td style="text-align:left;">
113900
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
South Atlantic Division
</td>
<td style="text-align:right;">
1092
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
947
</td>
<td style="text-align:right;">
1092
</td>
<td style="text-align:right;">
86.72161
</td>
<td style="text-align:right;">
0.9980
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:right;">
218
</td>
<td style="text-align:right;">
21.55963
</td>
<td style="text-align:right;">
0.9667
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
72.60274
</td>
<td style="text-align:right;">
0.9915
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
208
</td>
<td style="text-align:right;">
310
</td>
<td style="text-align:right;">
67.09677
</td>
<td style="text-align:right;">
0.9164
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
261
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
68.14621
</td>
<td style="text-align:right;">
0.9907
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
290
</td>
<td style="text-align:right;">
413
</td>
<td style="text-align:right;">
70.21792
</td>
<td style="text-align:right;">
0.9990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
371
</td>
<td style="text-align:right;">
1128
</td>
<td style="text-align:right;">
32.89007
</td>
<td style="text-align:right;">
0.9471
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
2.930403
</td>
<td style="text-align:right;">
0.029400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
548
</td>
<td style="text-align:right;">
50.1831502
</td>
<td style="text-align:right;">
0.999100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
596
</td>
<td style="text-align:right;">
8.221476
</td>
<td style="text-align:right;">
0.1367
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
154
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
84.15301
</td>
<td style="text-align:right;">
0.999200
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
888
</td>
<td style="text-align:right;">
18.806306
</td>
<td style="text-align:right;">
0.9361
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1066
</td>
<td style="text-align:right;">
1092
</td>
<td style="text-align:right;">
97.61905
</td>
<td style="text-align:right;">
0.9643
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
28.728070
</td>
<td style="text-align:right;">
0.8722
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
17.493473
</td>
<td style="text-align:right;">
0.9678
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
203
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
53.002611
</td>
<td style="text-align:right;">
0.97910
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1092
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.9015
</td>
<td style="text-align:right;">
0.9879
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.100500
</td>
<td style="text-align:right;">
0.79780
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9643
</td>
<td style="text-align:right;">
0.9553
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.40290
</td>
<td style="text-align:right;">
0.8876
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
12.36920
</td>
<td style="text-align:right;">
0.9683
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
06037224310
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
037
</td>
<td style="text-align:left;">
224310
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Los Angeles County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2459
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
1433
</td>
<td style="text-align:right;">
2459
</td>
<td style="text-align:right;">
58.27572
</td>
<td style="text-align:right;">
0.9585
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
1466
</td>
<td style="text-align:right;">
22.37381
</td>
<td style="text-align:right;">
0.9710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.9987
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
591
</td>
<td style="text-align:right;">
61.75973
</td>
<td style="text-align:right;">
0.8554
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
408
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
64.35331
</td>
<td style="text-align:right;">
0.9825
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
827
</td>
<td style="text-align:right;">
1456
</td>
<td style="text-align:right;">
56.79945
</td>
<td style="text-align:right;">
0.9908
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
2282
</td>
<td style="text-align:right;">
49.12358
</td>
<td style="text-align:right;">
0.9957
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
170
</td>
<td style="text-align:right;">
6.913379
</td>
<td style="text-align:right;">
0.162400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
537
</td>
<td style="text-align:right;">
21.8381456
</td>
<td style="text-align:right;">
0.358900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
169
</td>
<td style="text-align:right;">
1739
</td>
<td style="text-align:right;">
9.718229
</td>
<td style="text-align:right;">
0.2138
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
140
</td>
<td style="text-align:right;">
397
</td>
<td style="text-align:right;">
35.26448
</td>
<td style="text-align:right;">
0.901400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1043
</td>
<td style="text-align:right;">
2291
</td>
<td style="text-align:right;">
45.525971
</td>
<td style="text-align:right;">
0.9973
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2317
</td>
<td style="text-align:right;">
2459
</td>
<td style="text-align:right;">
94.22529
</td>
<td style="text-align:right;">
0.9371
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
312
</td>
<td style="text-align:right;">
45.747801
</td>
<td style="text-align:right;">
0.9365
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
0.2198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
330
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
52.050473
</td>
<td style="text-align:right;">
0.9995
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
259
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
40.851735
</td>
<td style="text-align:right;">
0.96150
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
191
</td>
<td style="text-align:right;">
2459
</td>
<td style="text-align:right;">
7.767385
</td>
<td style="text-align:right;">
0.9226
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.8985
</td>
<td style="text-align:right;">
0.9879
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2.633800
</td>
<td style="text-align:right;">
0.56870
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9371
</td>
<td style="text-align:right;">
0.9284
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.03990
</td>
<td style="text-align:right;">
0.9819
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
12.50930
</td>
<td style="text-align:right;">
0.9733
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
06037231220
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
037
</td>
<td style="text-align:left;">
231220
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Los Angeles County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
3750
</td>
<td style="text-align:right;">
1146
</td>
<td style="text-align:right;">
1084
</td>
<td style="text-align:right;">
2227
</td>
<td style="text-align:right;">
3725
</td>
<td style="text-align:right;">
59.78523
</td>
<td style="text-align:right;">
0.9637
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
360
</td>
<td style="text-align:right;">
1612
</td>
<td style="text-align:right;">
22.33251
</td>
<td style="text-align:right;">
0.9708
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
128
</td>
<td style="text-align:right;">
57.81250
</td>
<td style="text-align:right;">
0.9612
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
623
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
65.16736
</td>
<td style="text-align:right;">
0.8975
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
697
</td>
<td style="text-align:right;">
1084
</td>
<td style="text-align:right;">
64.29889
</td>
<td style="text-align:right;">
0.9823
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
962
</td>
<td style="text-align:right;">
1705
</td>
<td style="text-align:right;">
56.42229
</td>
<td style="text-align:right;">
0.9904
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1529
</td>
<td style="text-align:right;">
3597
</td>
<td style="text-align:right;">
42.50765
</td>
<td style="text-align:right;">
0.9868
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
3.306667
</td>
<td style="text-align:right;">
0.036420
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1165
</td>
<td style="text-align:right;">
31.0666667
</td>
<td style="text-align:right;">
0.870300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
2514
</td>
<td style="text-align:right;">
11.972952
</td>
<td style="text-align:right;">
0.3503
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
392
</td>
<td style="text-align:right;">
818
</td>
<td style="text-align:right;">
47.92176
</td>
<td style="text-align:right;">
0.967700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
977
</td>
<td style="text-align:right;">
3419
</td>
<td style="text-align:right;">
28.575607
</td>
<td style="text-align:right;">
0.9754
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3677
</td>
<td style="text-align:right;">
3750
</td>
<td style="text-align:right;">
98.05333
</td>
<td style="text-align:right;">
0.9690
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1146
</td>
<td style="text-align:right;">
378
</td>
<td style="text-align:right;">
32.984293
</td>
<td style="text-align:right;">
0.8941
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
2.792321
</td>
<td style="text-align:right;">
0.6272
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
1084
</td>
<td style="text-align:right;">
30.350554
</td>
<td style="text-align:right;">
0.9926
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
1084
</td>
<td style="text-align:right;">
32.380074
</td>
<td style="text-align:right;">
0.94240
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3750
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.8940
</td>
<td style="text-align:right;">
0.9879
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.200120
</td>
<td style="text-align:right;">
0.83610
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9690
</td>
<td style="text-align:right;">
0.9600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.82030
</td>
<td style="text-align:right;">
0.9654
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
12.88342
</td>
<td style="text-align:right;">
0.9816
</td>
<td style="text-align:right;">
10
</td>
</tr>
</tbody>
</table>

</div>

In 2010 the census tracts with a population greater than 100 that had
the highest SVI vulnerabilities for THEME 1/SES were in California,
Florida, Nevada, Texas, and Arizona.

``` r
# INSERT 2010 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 2

``` r
# INSERT 2010 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 3

``` r
# INSERT 2010 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 4

``` r
# INSERT 2010 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2010 CODE OVERALL

***EXAMPLE RESPONSE:***

``` r
# Find most vulnerable national tracts in 2020 for THEME 1 - SES
svi_2020_national %>% filter(!is.na(F_THEME1)) %>% filter(E_TOTPOP_20 > 100) %>% arrange(desc(RPL_THEME1)) %>% head(10) %>% kbl() %>% kable_styling() %>% scroll_box(width = "100%")
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
SPL_THEME1
</th>
<th style="text-align:right;">
RPL_THEME1
</th>
<th style="text-align:right;">
F_THEME1
</th>
<th style="text-align:right;">
SPL_THEME2
</th>
<th style="text-align:right;">
RPL_THEME2
</th>
<th style="text-align:right;">
F_THEME2
</th>
<th style="text-align:right;">
SPL_THEME3
</th>
<th style="text-align:right;">
RPL_THEME3
</th>
<th style="text-align:right;">
F_THEME3
</th>
<th style="text-align:right;">
SPL_THEME4
</th>
<th style="text-align:right;">
RPL_THEME4
</th>
<th style="text-align:right;">
F_THEME4
</th>
<th style="text-align:right;">
SPL_THEMES
</th>
<th style="text-align:right;">
RPL_THEMES
</th>
<th style="text-align:right;">
F_TOTAL
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
12099008001
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
099
</td>
<td style="text-align:left;">
008001
</td>
<td style="text-align:left;">
FL
</td>
<td style="text-align:left;">
Florida
</td>
<td style="text-align:left;">
Palm Beach County
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
4004
</td>
<td style="text-align:right;">
1149
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
2404
</td>
<td style="text-align:right;">
3625
</td>
<td style="text-align:right;">
66.31724
</td>
<td style="text-align:right;">
0.9883
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
520
</td>
<td style="text-align:right;">
1501
</td>
<td style="text-align:right;">
34.64357
</td>
<td style="text-align:right;">
0.9986
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
34.15493
</td>
<td style="text-align:right;">
0.862900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
575
</td>
<td style="text-align:right;">
714
</td>
<td style="text-align:right;">
80.53221
</td>
<td style="text-align:right;">
0.9907
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
672
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
67.33467
</td>
<td style="text-align:right;">
0.9947
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
991
</td>
<td style="text-align:right;">
2296
</td>
<td style="text-align:right;">
43.16202
</td>
<td style="text-align:right;">
0.9832
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
776
</td>
<td style="text-align:right;">
3625
</td>
<td style="text-align:right;">
21.40690
</td>
<td style="text-align:right;">
0.9404
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
4.670330
</td>
<td style="text-align:right;">
0.02935
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1116
</td>
<td style="text-align:right;">
27.87213
</td>
<td style="text-align:right;">
0.8363
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
2509
</td>
<td style="text-align:right;">
28.537266
</td>
<td style="text-align:right;">
0.94440
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
682
</td>
<td style="text-align:right;">
35.63050
</td>
<td style="text-align:right;">
0.9173
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
258
</td>
<td style="text-align:right;">
3780
</td>
<td style="text-align:right;">
6.825397
</td>
<td style="text-align:right;">
0.8189
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3666
</td>
<td style="text-align:right;">
4004
</td>
<td style="text-align:right;">
91.55844
</td>
<td style="text-align:right;">
0.9188
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1149
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
7.223673
</td>
<td style="text-align:right;">
0.5781
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
174
</td>
<td style="text-align:right;">
15.1436031
</td>
<td style="text-align:right;">
0.8566
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
72
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
7.214429
</td>
<td style="text-align:right;">
0.8624
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
275
</td>
<td style="text-align:right;">
998
</td>
<td style="text-align:right;">
27.55511
</td>
<td style="text-align:right;">
0.9321
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
4004
</td>
<td style="text-align:right;">
11.1138861
</td>
<td style="text-align:right;">
0.9517
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.9052
</td>
<td style="text-align:right;">
0.9887
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.54625
</td>
<td style="text-align:right;">
0.9392
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9188
</td>
<td style="text-align:right;">
0.9110
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.1809
</td>
<td style="text-align:right;">
0.9856
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
13.55115
</td>
<td style="text-align:right;">
0.9879
</td>
<td style="text-align:right;">
10
</td>
</tr>
<tr>
<td style="text-align:left;">
12099008202
</td>
<td style="text-align:left;">
12
</td>
<td style="text-align:left;">
099
</td>
<td style="text-align:left;">
008202
</td>
<td style="text-align:left;">
FL
</td>
<td style="text-align:left;">
Florida
</td>
<td style="text-align:left;">
Palm Beach County
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
4125
</td>
<td style="text-align:right;">
1392
</td>
<td style="text-align:right;">
1236
</td>
<td style="text-align:right;">
2893
</td>
<td style="text-align:right;">
4103
</td>
<td style="text-align:right;">
70.50938
</td>
<td style="text-align:right;">
0.9925
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
1592
</td>
<td style="text-align:right;">
27.63819
</td>
<td style="text-align:right;">
0.9958
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
13.50000
</td>
<td style="text-align:right;">
0.162300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
774
</td>
<td style="text-align:right;">
1036
</td>
<td style="text-align:right;">
74.71042
</td>
<td style="text-align:right;">
0.9783
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
801
</td>
<td style="text-align:right;">
1236
</td>
<td style="text-align:right;">
64.80583
</td>
<td style="text-align:right;">
0.9918
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1024
</td>
<td style="text-align:right;">
2406
</td>
<td style="text-align:right;">
42.56027
</td>
<td style="text-align:right;">
0.9821
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
936
</td>
<td style="text-align:right;">
4125
</td>
<td style="text-align:right;">
22.69091
</td>
<td style="text-align:right;">
0.9506
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
406
</td>
<td style="text-align:right;">
9.842424
</td>
<td style="text-align:right;">
0.17460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1286
</td>
<td style="text-align:right;">
31.17576
</td>
<td style="text-align:right;">
0.9265
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
628
</td>
<td style="text-align:right;">
2839
</td>
<td style="text-align:right;">
22.120465
</td>
<td style="text-align:right;">
0.81710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
781
</td>
<td style="text-align:right;">
49.29577
</td>
<td style="text-align:right;">
0.9774
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
488
</td>
<td style="text-align:right;">
3703
</td>
<td style="text-align:right;">
13.178504
</td>
<td style="text-align:right;">
0.9127
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4061
</td>
<td style="text-align:right;">
4125
</td>
<td style="text-align:right;">
98.44848
</td>
<td style="text-align:right;">
0.9792
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1392
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:right;">
12.284483
</td>
<td style="text-align:right;">
0.6856
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1.7241379
</td>
<td style="text-align:right;">
0.5976
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
1236
</td>
<td style="text-align:right;">
18.446602
</td>
<td style="text-align:right;">
0.9743
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
374
</td>
<td style="text-align:right;">
1236
</td>
<td style="text-align:right;">
30.25890
</td>
<td style="text-align:right;">
0.9414
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4125
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
4.9128
</td>
<td style="text-align:right;">
0.9887
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.80830
</td>
<td style="text-align:right;">
0.9729
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9792
</td>
<td style="text-align:right;">
0.9709
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.3820
</td>
<td style="text-align:right;">
0.8716
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
13.08230
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
48141001900
</td>
<td style="text-align:left;">
48
</td>
<td style="text-align:left;">
141
</td>
<td style="text-align:left;">
001900
</td>
<td style="text-align:left;">
TX
</td>
<td style="text-align:left;">
Texas
</td>
<td style="text-align:left;">
El Paso County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
West South Central Division
</td>
<td style="text-align:right;">
1881
</td>
<td style="text-align:right;">
1026
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
1666
</td>
<td style="text-align:right;">
1881
</td>
<td style="text-align:right;">
88.56991
</td>
<td style="text-align:right;">
0.9991
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
107
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
20.34221
</td>
<td style="text-align:right;">
0.9852
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.003312
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
506
</td>
<td style="text-align:right;">
802
</td>
<td style="text-align:right;">
63.09227
</td>
<td style="text-align:right;">
0.8967
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
506
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
61.33333
</td>
<td style="text-align:right;">
0.9849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
711
</td>
<td style="text-align:right;">
1205
</td>
<td style="text-align:right;">
59.00415
</td>
<td style="text-align:right;">
0.9986
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
704
</td>
<td style="text-align:right;">
1881
</td>
<td style="text-align:right;">
37.42690
</td>
<td style="text-align:right;">
0.9948
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
484
</td>
<td style="text-align:right;">
25.730994
</td>
<td style="text-align:right;">
0.89730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
24.13610
</td>
<td style="text-align:right;">
0.6499
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
603
</td>
<td style="text-align:right;">
1427
</td>
<td style="text-align:right;">
42.256482
</td>
<td style="text-align:right;">
0.99680
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
26.16580
</td>
<td style="text-align:right;">
0.8113
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
937
</td>
<td style="text-align:right;">
1788
</td>
<td style="text-align:right;">
52.404922
</td>
<td style="text-align:right;">
0.9995
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1841
</td>
<td style="text-align:right;">
1881
</td>
<td style="text-align:right;">
97.87347
</td>
<td style="text-align:right;">
0.9724
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1026
</td>
<td style="text-align:right;">
572
</td>
<td style="text-align:right;">
55.750487
</td>
<td style="text-align:right;">
0.9527
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0.5847953
</td>
<td style="text-align:right;">
0.4944
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
9.333333
</td>
<td style="text-align:right;">
0.9045
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
406
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
49.21212
</td>
<td style="text-align:right;">
0.9769
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1881
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
4.9626
</td>
<td style="text-align:right;">
0.9887
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
4.35480
</td>
<td style="text-align:right;">
0.9881
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9724
</td>
<td style="text-align:right;">
0.9642
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.5116
</td>
<td style="text-align:right;">
0.9058
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
13.80140
</td>
<td style="text-align:right;">
0.9882
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
48141002100
</td>
<td style="text-align:left;">
48
</td>
<td style="text-align:left;">
141
</td>
<td style="text-align:left;">
002100
</td>
<td style="text-align:left;">
TX
</td>
<td style="text-align:left;">
Texas
</td>
<td style="text-align:left;">
El Paso County
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
West South Central Division
</td>
<td style="text-align:right;">
2008
</td>
<td style="text-align:right;">
1272
</td>
<td style="text-align:right;">
831
</td>
<td style="text-align:right;">
1506
</td>
<td style="text-align:right;">
1997
</td>
<td style="text-align:right;">
75.41312
</td>
<td style="text-align:right;">
0.9959
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
739
</td>
<td style="text-align:right;">
15.96752
</td>
<td style="text-align:right;">
0.9653
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
12.50000
</td>
<td style="text-align:right;">
0.126800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
61.37281
</td>
<td style="text-align:right;">
0.8754
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
467
</td>
<td style="text-align:right;">
831
</td>
<td style="text-align:right;">
56.19735
</td>
<td style="text-align:right;">
0.9668
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
795
</td>
<td style="text-align:right;">
1595
</td>
<td style="text-align:right;">
49.84326
</td>
<td style="text-align:right;">
0.9935
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
2001
</td>
<td style="text-align:right;">
38.03098
</td>
<td style="text-align:right;">
0.9954
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
18.177291
</td>
<td style="text-align:right;">
0.62790
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
311
</td>
<td style="text-align:right;">
15.48805
</td>
<td style="text-align:right;">
0.1536
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
702
</td>
<td style="text-align:right;">
1690
</td>
<td style="text-align:right;">
41.538461
</td>
<td style="text-align:right;">
0.99630
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
12.37113
</td>
<td style="text-align:right;">
0.4275
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
764
</td>
<td style="text-align:right;">
1974
</td>
<td style="text-align:right;">
38.703141
</td>
<td style="text-align:right;">
0.9966
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1922
</td>
<td style="text-align:right;">
2008
</td>
<td style="text-align:right;">
95.71713
</td>
<td style="text-align:right;">
0.9509
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1272
</td>
<td style="text-align:right;">
570
</td>
<td style="text-align:right;">
44.811321
</td>
<td style="text-align:right;">
0.9283
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
831
</td>
<td style="text-align:right;">
2.166065
</td>
<td style="text-align:right;">
0.5543
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
831
</td>
<td style="text-align:right;">
42.47894
</td>
<td style="text-align:right;">
0.9677
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
338
</td>
<td style="text-align:right;">
2008
</td>
<td style="text-align:right;">
16.8326693
</td>
<td style="text-align:right;">
0.9654
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.9169
</td>
<td style="text-align:right;">
0.9887
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.20190
</td>
<td style="text-align:right;">
0.8496
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9509
</td>
<td style="text-align:right;">
0.9429
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6343
</td>
<td style="text-align:right;">
0.9323
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
12.70400
</td>
<td style="text-align:right;">
0.9811
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
06037224420
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
037
</td>
<td style="text-align:left;">
224420
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Los Angeles County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
943
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
1562
</td>
<td style="text-align:right;">
2389
</td>
<td style="text-align:right;">
65.38301
</td>
<td style="text-align:right;">
0.9868
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
232
</td>
<td style="text-align:right;">
1430
</td>
<td style="text-align:right;">
16.22378
</td>
<td style="text-align:right;">
0.9672
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
22.80702
</td>
<td style="text-align:right;">
0.565000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
826
</td>
<td style="text-align:right;">
70.70218
</td>
<td style="text-align:right;">
0.9614
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
67.61042
</td>
<td style="text-align:right;">
0.9949
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
894
</td>
<td style="text-align:right;">
1588
</td>
<td style="text-align:right;">
56.29723
</td>
<td style="text-align:right;">
0.9975
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
605
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
22.82158
</td>
<td style="text-align:right;">
0.9514
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
243
</td>
<td style="text-align:right;">
9.166352
</td>
<td style="text-align:right;">
0.14720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
543
</td>
<td style="text-align:right;">
20.48284
</td>
<td style="text-align:right;">
0.4073
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
211
</td>
<td style="text-align:right;">
1889
</td>
<td style="text-align:right;">
11.169931
</td>
<td style="text-align:right;">
0.26660
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
36.25219
</td>
<td style="text-align:right;">
0.9217
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
870
</td>
<td style="text-align:right;">
2539
</td>
<td style="text-align:right;">
34.265459
</td>
<td style="text-align:right;">
0.9937
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2523
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
95.17163
</td>
<td style="text-align:right;">
0.9465
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
943
</td>
<td style="text-align:right;">
540
</td>
<td style="text-align:right;">
57.264051
</td>
<td style="text-align:right;">
0.9549
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
344
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
38.958097
</td>
<td style="text-align:right;">
0.9984
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
302
</td>
<td style="text-align:right;">
883
</td>
<td style="text-align:right;">
34.20159
</td>
<td style="text-align:right;">
0.9522
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
253
</td>
<td style="text-align:right;">
2651
</td>
<td style="text-align:right;">
9.5435685
</td>
<td style="text-align:right;">
0.9459
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.8978
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2.73650
</td>
<td style="text-align:right;">
0.6297
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9465
</td>
<td style="text-align:right;">
0.9385
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.0700
</td>
<td style="text-align:right;">
0.9818
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
12.65080
</td>
<td style="text-align:right;">
0.9801
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
06037540600
</td>
<td style="text-align:left;">
06
</td>
<td style="text-align:left;">
037
</td>
<td style="text-align:left;">
540600
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Los Angeles County
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
West Region
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
5102
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
2828
</td>
<td style="text-align:right;">
5030
</td>
<td style="text-align:right;">
56.22266
</td>
<td style="text-align:right;">
0.9650
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
507
</td>
<td style="text-align:right;">
2053
</td>
<td style="text-align:right;">
24.69557
</td>
<td style="text-align:right;">
0.9930
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
165
</td>
<td style="text-align:right;">
409
</td>
<td style="text-align:right;">
40.34230
</td>
<td style="text-align:right;">
0.932100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
551
</td>
<td style="text-align:right;">
710
</td>
<td style="text-align:right;">
77.60563
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
63.98570
</td>
<td style="text-align:right;">
0.9906
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1148
</td>
<td style="text-align:right;">
2537
</td>
<td style="text-align:right;">
45.25030
</td>
<td style="text-align:right;">
0.9876
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1195
</td>
<td style="text-align:right;">
5102
</td>
<td style="text-align:right;">
23.42219
</td>
<td style="text-align:right;">
0.9557
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
350
</td>
<td style="text-align:right;">
6.860055
</td>
<td style="text-align:right;">
0.07166
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2038
</td>
<td style="text-align:right;">
39.94512
</td>
<td style="text-align:right;">
0.9938
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
268
</td>
<td style="text-align:right;">
3064
</td>
<td style="text-align:right;">
8.746736
</td>
<td style="text-align:right;">
0.13740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
399
</td>
<td style="text-align:right;">
882
</td>
<td style="text-align:right;">
45.23810
</td>
<td style="text-align:right;">
0.9664
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
960
</td>
<td style="text-align:right;">
4291
</td>
<td style="text-align:right;">
22.372407
</td>
<td style="text-align:right;">
0.9698
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5072
</td>
<td style="text-align:right;">
5102
</td>
<td style="text-align:right;">
99.41200
</td>
<td style="text-align:right;">
0.9911
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
124
</td>
<td style="text-align:right;">
11.081323
</td>
<td style="text-align:right;">
0.6642
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
2.8596962
</td>
<td style="text-align:right;">
0.6499
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
20.554066
</td>
<td style="text-align:right;">
0.9803
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
137
</td>
<td style="text-align:right;">
1119
</td>
<td style="text-align:right;">
12.24307
</td>
<td style="text-align:right;">
0.7892
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
5102
</td>
<td style="text-align:right;">
0.8232066
</td>
<td style="text-align:right;">
0.6652
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.8919
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.13906
</td>
<td style="text-align:right;">
0.8270
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9911
</td>
<td style="text-align:right;">
0.9827
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.7488
</td>
<td style="text-align:right;">
0.9523
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12.77086
</td>
<td style="text-align:right;">
0.9823
</td>
<td style="text-align:right;">
10
</td>
</tr>
<tr>
<td style="text-align:left;">
13059140500
</td>
<td style="text-align:left;">
13
</td>
<td style="text-align:left;">
059
</td>
<td style="text-align:left;">
140500
</td>
<td style="text-align:left;">
GA
</td>
<td style="text-align:left;">
Georgia
</td>
<td style="text-align:left;">
Clarke County
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
1909
</td>
<td style="text-align:right;">
934
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
1053
</td>
<td style="text-align:right;">
1670
</td>
<td style="text-align:right;">
63.05389
</td>
<td style="text-align:right;">
0.9830
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
191
</td>
<td style="text-align:right;">
860
</td>
<td style="text-align:right;">
22.20930
</td>
<td style="text-align:right;">
0.9895
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
38.72549
</td>
<td style="text-align:right;">
0.918400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
509
</td>
<td style="text-align:right;">
705
</td>
<td style="text-align:right;">
72.19858
</td>
<td style="text-align:right;">
0.9684
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
588
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
64.68647
</td>
<td style="text-align:right;">
0.9916
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
482
</td>
<td style="text-align:right;">
1378
</td>
<td style="text-align:right;">
34.97823
</td>
<td style="text-align:right;">
0.9593
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
436
</td>
<td style="text-align:right;">
1670
</td>
<td style="text-align:right;">
26.10778
</td>
<td style="text-align:right;">
0.9704
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
334
</td>
<td style="text-align:right;">
17.496071
</td>
<td style="text-align:right;">
0.59130
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
276
</td>
<td style="text-align:right;">
14.45783
</td>
<td style="text-align:right;">
0.1223
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
1394
</td>
<td style="text-align:right;">
25.322812
</td>
<td style="text-align:right;">
0.89540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
361
</td>
<td style="text-align:right;">
31.85596
</td>
<td style="text-align:right;">
0.8843
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
1819
</td>
<td style="text-align:right;">
4.947774
</td>
<td style="text-align:right;">
0.7658
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1313
</td>
<td style="text-align:right;">
1909
</td>
<td style="text-align:right;">
68.77947
</td>
<td style="text-align:right;">
0.7885
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
934
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
1.713062
</td>
<td style="text-align:right;">
0.3633
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
39.1862955
</td>
<td style="text-align:right;">
0.9789
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
3.190319
</td>
<td style="text-align:right;">
0.6643
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
150
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
16.50165
</td>
<td style="text-align:right;">
0.8570
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
239
</td>
<td style="text-align:right;">
1909
</td>
<td style="text-align:right;">
12.5196438
</td>
<td style="text-align:right;">
0.9560
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.8938
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.25910
</td>
<td style="text-align:right;">
0.8687
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.7885
</td>
<td style="text-align:right;">
0.7818
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.8195
</td>
<td style="text-align:right;">
0.9616
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
12.76090
</td>
<td style="text-align:right;">
0.9821
</td>
<td style="text-align:right;">
7
</td>
</tr>
<tr>
<td style="text-align:left;">
22033001104
</td>
<td style="text-align:left;">
22
</td>
<td style="text-align:left;">
033
</td>
<td style="text-align:left;">
001104
</td>
<td style="text-align:left;">
LA
</td>
<td style="text-align:left;">
Louisiana
</td>
<td style="text-align:left;">
East Baton Rouge Parish
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
South Region
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
West South Central Division
</td>
<td style="text-align:right;">
4068
</td>
<td style="text-align:right;">
2022
</td>
<td style="text-align:right;">
1504
</td>
<td style="text-align:right;">
3051
</td>
<td style="text-align:right;">
4022
</td>
<td style="text-align:right;">
75.85778
</td>
<td style="text-align:right;">
0.9961
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
1640
</td>
<td style="text-align:right;">
19.75610
</td>
<td style="text-align:right;">
0.9830
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
0.00000
</td>
<td style="text-align:right;">
0.003312
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
958
</td>
<td style="text-align:right;">
1503
</td>
<td style="text-align:right;">
63.73919
</td>
<td style="text-align:right;">
0.9048
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
958
</td>
<td style="text-align:right;">
1504
</td>
<td style="text-align:right;">
63.69681
</td>
<td style="text-align:right;">
0.9903
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
743
</td>
<td style="text-align:right;">
2113
</td>
<td style="text-align:right;">
35.16327
</td>
<td style="text-align:right;">
0.9601
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1043
</td>
<td style="text-align:right;">
4044
</td>
<td style="text-align:right;">
25.79130
</td>
<td style="text-align:right;">
0.9690
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
195
</td>
<td style="text-align:right;">
4.793510
</td>
<td style="text-align:right;">
0.03071
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1474
</td>
<td style="text-align:right;">
36.23402
</td>
<td style="text-align:right;">
0.9817
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1046
</td>
<td style="text-align:right;">
2570
</td>
<td style="text-align:right;">
40.700389
</td>
<td style="text-align:right;">
0.99550
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
482
</td>
<td style="text-align:right;">
788
</td>
<td style="text-align:right;">
61.16751
</td>
<td style="text-align:right;">
0.9940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
3420
</td>
<td style="text-align:right;">
4.444444
</td>
<td style="text-align:right;">
0.7474
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3761
</td>
<td style="text-align:right;">
4068
</td>
<td style="text-align:right;">
92.45329
</td>
<td style="text-align:right;">
0.9253
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2022
</td>
<td style="text-align:right;">
1420
</td>
<td style="text-align:right;">
70.227497
</td>
<td style="text-align:right;">
0.9722
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
0.2186
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
105
</td>
<td style="text-align:right;">
1504
</td>
<td style="text-align:right;">
6.981383
</td>
<td style="text-align:right;">
0.8561
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
524
</td>
<td style="text-align:right;">
1504
</td>
<td style="text-align:right;">
34.84043
</td>
<td style="text-align:right;">
0.9536
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
4068
</td>
<td style="text-align:right;">
0.6391347
</td>
<td style="text-align:right;">
0.6312
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.8985
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.74931
</td>
<td style="text-align:right;">
0.9673
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9253
</td>
<td style="text-align:right;">
0.9175
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.6317
</td>
<td style="text-align:right;">
0.9318
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
13.20481
</td>
<td style="text-align:right;">
0.9868
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
34031175200
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
031
</td>
<td style="text-align:left;">
175200
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Passaic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
5403
</td>
<td style="text-align:right;">
1557
</td>
<td style="text-align:right;">
1495
</td>
<td style="text-align:right;">
3743
</td>
<td style="text-align:right;">
5402
</td>
<td style="text-align:right;">
69.28915
</td>
<td style="text-align:right;">
0.9915
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
2361
</td>
<td style="text-align:right;">
12.02880
</td>
<td style="text-align:right;">
0.9188
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.999200
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
880
</td>
<td style="text-align:right;">
1466
</td>
<td style="text-align:right;">
60.02729
</td>
<td style="text-align:right;">
0.8566
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
909
</td>
<td style="text-align:right;">
1495
</td>
<td style="text-align:right;">
60.80268
</td>
<td style="text-align:right;">
0.9837
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1351
</td>
<td style="text-align:right;">
2762
</td>
<td style="text-align:right;">
48.91383
</td>
<td style="text-align:right;">
0.9925
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1913
</td>
<td style="text-align:right;">
5403
</td>
<td style="text-align:right;">
35.40626
</td>
<td style="text-align:right;">
0.9927
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
3.387007
</td>
<td style="text-align:right;">
0.01697
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2288
</td>
<td style="text-align:right;">
42.34684
</td>
<td style="text-align:right;">
0.9967
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
244
</td>
<td style="text-align:right;">
3115
</td>
<td style="text-align:right;">
7.833066
</td>
<td style="text-align:right;">
0.09813
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
602
</td>
<td style="text-align:right;">
1172
</td>
<td style="text-align:right;">
51.36519
</td>
<td style="text-align:right;">
0.9819
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1872
</td>
<td style="text-align:right;">
4877
</td>
<td style="text-align:right;">
38.384253
</td>
<td style="text-align:right;">
0.9964
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5381
</td>
<td style="text-align:right;">
5403
</td>
<td style="text-align:right;">
99.59282
</td>
<td style="text-align:right;">
0.9934
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1557
</td>
<td style="text-align:right;">
493
</td>
<td style="text-align:right;">
31.663455
</td>
<td style="text-align:right;">
0.8781
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
573
</td>
<td style="text-align:right;">
1495
</td>
<td style="text-align:right;">
38.327759
</td>
<td style="text-align:right;">
0.9983
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
795
</td>
<td style="text-align:right;">
1495
</td>
<td style="text-align:right;">
53.17726
</td>
<td style="text-align:right;">
0.9812
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
5403
</td>
<td style="text-align:right;">
0.0925412
</td>
<td style="text-align:right;">
0.3945
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4.8792
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
3.09010
</td>
<td style="text-align:right;">
0.8076
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9934
</td>
<td style="text-align:right;">
0.9850
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.4707
</td>
<td style="text-align:right;">
0.8956
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
12.43340
</td>
<td style="text-align:right;">
0.9753
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
34031175802
</td>
<td style="text-align:left;">
34
</td>
<td style="text-align:left;">
031
</td>
<td style="text-align:left;">
175802
</td>
<td style="text-align:left;">
NJ
</td>
<td style="text-align:left;">
New Jersey
</td>
<td style="text-align:left;">
Passaic County
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Northeast Region
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
Middle Atlantic Division
</td>
<td style="text-align:right;">
7136
</td>
<td style="text-align:right;">
1807
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
4060
</td>
<td style="text-align:right;">
7081
</td>
<td style="text-align:right;">
57.33653
</td>
<td style="text-align:right;">
0.9685
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:right;">
3490
</td>
<td style="text-align:right;">
16.56160
</td>
<td style="text-align:right;">
0.9697
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.003312
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
960
</td>
<td style="text-align:right;">
1646
</td>
<td style="text-align:right;">
58.32321
</td>
<td style="text-align:right;">
0.8304
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
960
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
56.07477
</td>
<td style="text-align:right;">
0.9662
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1992
</td>
<td style="text-align:right;">
3853
</td>
<td style="text-align:right;">
51.69997
</td>
<td style="text-align:right;">
0.9951
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2600
</td>
<td style="text-align:right;">
7136
</td>
<td style="text-align:right;">
36.43498
</td>
<td style="text-align:right;">
0.9939
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
5.283072
</td>
<td style="text-align:right;">
0.03808
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2262
</td>
<td style="text-align:right;">
31.69843
</td>
<td style="text-align:right;">
0.9363
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
4874
</td>
<td style="text-align:right;">
6.011489
</td>
<td style="text-align:right;">
0.04125
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
566
</td>
<td style="text-align:right;">
1286
</td>
<td style="text-align:right;">
44.01244
</td>
<td style="text-align:right;">
0.9623
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2748
</td>
<td style="text-align:right;">
6597
</td>
<td style="text-align:right;">
41.655298
</td>
<td style="text-align:right;">
0.9976
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7093
</td>
<td style="text-align:right;">
7136
</td>
<td style="text-align:right;">
99.39742
</td>
<td style="text-align:right;">
0.9908
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1807
</td>
<td style="text-align:right;">
556
</td>
<td style="text-align:right;">
30.769231
</td>
<td style="text-align:right;">
0.8733
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
573
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
33.469626
</td>
<td style="text-align:right;">
0.9965
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
806
</td>
<td style="text-align:right;">
1712
</td>
<td style="text-align:right;">
47.07944
</td>
<td style="text-align:right;">
0.9744
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7136
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
4.8934
</td>
<td style="text-align:right;">
0.9886
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
2.97553
</td>
<td style="text-align:right;">
0.7555
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9908
</td>
<td style="text-align:right;">
0.9824
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.2459
</td>
<td style="text-align:right;">
0.8257
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
12.10563
</td>
<td style="text-align:right;">
0.9638
</td>
<td style="text-align:right;">
11
</td>
</tr>
</tbody>
</table>

</div>

In 2020 the census tracts with a population greater than 100 that had
the highest SVI vulnerabilities for THEME 1/SES were in Florida, Texas,
California, Georgia, Louisiana, and New Jersey.

``` r
# INSERT 2020 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 2

``` r
# INSERT 2020 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 3

``` r
# INSERT 2020 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 4

``` r
# INSERT 2020 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2020 CODE OVERALL

## South Atlantic Division Analysis

In the South Atlantic Division, the most & least vulnerable tracts by THEME1, THEME2, THEME3, THEME4, OVERALL are below. They are particularly concentrated in [STATE]:

``` r
# INSERT 2010 CODE THEME 1
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 1

``` r
# INSERT 2010 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 2

``` r
# INSERT 2010 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 3

``` r
# INSERT 2010 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 4

``` r
# INSERT 2010 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2010 CODE OVERALL

``` r
# INSERT 2020 CODE THEME 1
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 1

``` r
# INSERT 2020 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 2

``` r
# INSERT 2020 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 3

``` r
# INSERT 2020 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 4

``` r
# INSERT 2020 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2020 CODE OVERALL

## [Most Vulnerable State Analysis]

The most vulnerable state in the South Atlantic Division is [State]. The most and least vulnerable tracts by THEME1, THEME2, THEME3, THEME4, OVERALL are listed below and concentrated in [Counties]:

``` r
# INSERT 2010 CODE THEME 1
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 1

``` r
# INSERT 2010 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 2

``` r
# INSERT 2010 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 3

``` r
# INSERT 2010 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2010 CODE THEME 4

``` r
# INSERT 2010 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2010 CODE OVERALL

``` r
# INSERT 2020 CODE THEME 1
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 1

``` r
# INSERT 2020 CODE THEME 2
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 2

``` r
# INSERT 2020 CODE THEME 3
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 3

``` r
# INSERT 2020 CODE THEME 4
```

DESCRIBE OUTPUT DATA 2020 CODE THEME 4

``` r
# INSERT 2020 CODE OVERALL
```

DESCRIBE OUTPUT DATA 2020 CODE OVERALL

