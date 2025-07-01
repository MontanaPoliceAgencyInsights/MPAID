---
title: "lab05-radovich"
author: "Drew Radovich"
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

lab05-radovich
================
Drew Radovich

- [Library](#library)
- [Import Functions](#import-functions)
- [Data](#data)
  - [Housing Price Index Data](#housing-price-index-data)
- [CBSA Crosswalk](#cbsa-crosswalk)
  - [Census Data](#census-data)
- [NMTC Data](#nmtc-data)
- [LIHTC Data](#lihtc-data)
- [Log NMTC and LIHTC Variables](#log-nmtc-and-lihtc-variables)
- [Diff-in-diff Models](#diff-in-diff-models)
- [Dependent Variables: SVI Variables, House Price Index, Median Home
  Values, and Median
  Income](#dependent-variables-svi-variables-house-price-index-median-home-values-and-median-income)
- [Independent Variables: NMTC and LIHTC
  Data](#independent-variables-nmtc-and-lihtc-data)
  - [NMTC Evaluation](#nmtc-evaluation)
- [NMTC Divisional Diff-in-Diff
  Model](#nmtc-divisional-diff-in-diff-model)
  - [LIHTC Evaluation](#lihtc-evaluation)
  - [LIHTC Divisional Model](#lihtc-divisional-model)

## Library

## Import Functions

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

## Data

### Housing Price Index Data

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

## CBSA Crosswalk

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

### Census Data

    ## [[1]]
    ##  [1] "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "DC" "FL" "GA" "HI" "ID" "IL" "IN"
    ## [16] "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH"
    ## [31] "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT"
    ## [46] "VT" "VA" "WA" "WV" "WI" "WY"

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

## NMTC Data

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
02013000100
</td>
<td style="text-align:left;">
02013
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Aleutians East Borough
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
3703
</td>
<td style="text-align:right;">
474
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
1212
</td>
<td style="text-align:right;">
3695
</td>
<td style="text-align:right;">
32.80108
</td>
<td style="text-align:right;">
0.7570
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
3163
</td>
<td style="text-align:right;">
3.509327
</td>
<td style="text-align:right;">
0.08691
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
15.82278
</td>
<td style="text-align:right;">
0.01337
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
15.59633
</td>
<td style="text-align:right;">
0.02605
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
15.73034
</td>
<td style="text-align:right;">
0.004754
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1082
</td>
<td style="text-align:right;">
3017
</td>
<td style="text-align:right;">
35.863441
</td>
<td style="text-align:right;">
0.85420
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2060
</td>
<td style="text-align:right;">
3112
</td>
<td style="text-align:right;">
66.195373
</td>
<td style="text-align:right;">
0.99990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
3.429652
</td>
<td style="text-align:right;">
0.042400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
315
</td>
<td style="text-align:right;">
8.506616
</td>
<td style="text-align:right;">
0.03961
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
182
</td>
<td style="text-align:right;">
2849
</td>
<td style="text-align:right;">
6.388206
</td>
<td style="text-align:right;">
0.077750
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
165
</td>
<td style="text-align:right;">
30.30303
</td>
<td style="text-align:right;">
0.8835
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1070
</td>
<td style="text-align:right;">
3617
</td>
<td style="text-align:right;">
29.5825270
</td>
<td style="text-align:right;">
0.93700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3492
</td>
<td style="text-align:right;">
3703
</td>
<td style="text-align:right;">
94.30192
</td>
<td style="text-align:right;">
0.9141
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
474
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1.687764
</td>
<td style="text-align:right;">
0.29250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
8.8607595
</td>
<td style="text-align:right;">
0.8128
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
2.6217228
</td>
<td style="text-align:right;">
0.4003
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
28.8389513
</td>
<td style="text-align:right;">
0.96850
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2969
</td>
<td style="text-align:right;">
3703
</td>
<td style="text-align:right;">
80.1782339
</td>
<td style="text-align:right;">
0.9940
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.702764
</td>
<td style="text-align:right;">
0.5611
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1.980260
</td>
<td style="text-align:right;">
0.23800
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9141
</td>
<td style="text-align:right;">
0.9047
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.46810
</td>
<td style="text-align:right;">
0.8902
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.065224
</td>
<td style="text-align:right;">
0.6397
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
3389
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
988
</td>
<td style="text-align:right;">
698
</td>
<td style="text-align:right;">
3379
</td>
<td style="text-align:right;">
20.65700
</td>
<td style="text-align:right;">
0.5925
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
2414
</td>
<td style="text-align:right;">
3.562552
</td>
<td style="text-align:right;">
0.2665
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
11.037891
</td>
<td style="text-align:right;">
0.01803
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
381
</td>
<td style="text-align:right;">
19.42257
</td>
<td style="text-align:right;">
0.04067
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
141
</td>
<td style="text-align:right;">
988
</td>
<td style="text-align:right;">
14.27126
</td>
<td style="text-align:right;">
0.006988
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
354
</td>
<td style="text-align:right;">
2646
</td>
<td style="text-align:right;">
13.378685
</td>
<td style="text-align:right;">
0.61070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1345
</td>
<td style="text-align:right;">
3384
</td>
<td style="text-align:right;">
39.745863
</td>
<td style="text-align:right;">
0.99970
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
381
</td>
<td style="text-align:right;">
11.2422544
</td>
<td style="text-align:right;">
0.31390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
443
</td>
<td style="text-align:right;">
13.07170
</td>
<td style="text-align:right;">
0.0988
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
339
</td>
<td style="text-align:right;">
2941.000
</td>
<td style="text-align:right;">
11.526692
</td>
<td style="text-align:right;">
0.386000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
135
</td>
<td style="text-align:right;">
593.000
</td>
<td style="text-align:right;">
22.765599
</td>
<td style="text-align:right;">
0.7920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
334
</td>
<td style="text-align:right;">
3276
</td>
<td style="text-align:right;">
10.1953602
</td>
<td style="text-align:right;">
0.72620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2939
</td>
<td style="text-align:right;">
3389.000
</td>
<td style="text-align:right;">
86.72175
</td>
<td style="text-align:right;">
0.8110
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1199
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
3.169308
</td>
<td style="text-align:right;">
0.3474
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
5.754796
</td>
<td style="text-align:right;">
0.7806
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
988
</td>
<td style="text-align:right;">
3.0364372
</td>
<td style="text-align:right;">
0.36010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
220
</td>
<td style="text-align:right;">
988.000
</td>
<td style="text-align:right;">
22.267207
</td>
<td style="text-align:right;">
0.9527
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1035
</td>
<td style="text-align:right;">
3389
</td>
<td style="text-align:right;">
30.5399823
</td>
<td style="text-align:right;">
0.9843
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.476388
</td>
<td style="text-align:right;">
0.4947
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.316900
</td>
<td style="text-align:right;">
0.37850
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.8110
</td>
<td style="text-align:right;">
0.8038
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.42510
</td>
<td style="text-align:right;">
0.8683
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.029388
</td>
<td style="text-align:right;">
0.6419
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
1
</td>
<td style="text-align:right;">
15762500
</td>
<td style="text-align:left;">
\$15,762,500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Census Tract 1, Aleutians East Borough, Alaska
</td>
<td style="text-align:right;">
21138
</td>
<td style="text-align:right;">
121600
</td>
<td style="text-align:right;">
29177
</td>
<td style="text-align:right;">
119900
</td>
<td style="text-align:right;">
24520.08
</td>
<td style="text-align:right;">
141056
</td>
<td style="text-align:right;">
4656.92
</td>
<td style="text-align:right;">
0.1899227
</td>
<td style="text-align:right;">
-21156
</td>
<td style="text-align:right;">
-0.1499830
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
02016000100
</td>
<td style="text-align:left;">
02016
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Aleutians West Census Area
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
1774
</td>
<td style="text-align:right;">
1056
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
1231
</td>
<td style="text-align:right;">
26.64500
</td>
<td style="text-align:right;">
0.6553
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
1370
</td>
<td style="text-align:right;">
1.094890
</td>
<td style="text-align:right;">
0.01369
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
26.31579
</td>
<td style="text-align:right;">
0.09653
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
22.53521
</td>
<td style="text-align:right;">
0.05099
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
24.69880
</td>
<td style="text-align:right;">
0.029080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
207
</td>
<td style="text-align:right;">
1330
</td>
<td style="text-align:right;">
15.563910
</td>
<td style="text-align:right;">
0.58390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
484
</td>
<td style="text-align:right;">
973
</td>
<td style="text-align:right;">
49.743063
</td>
<td style="text-align:right;">
0.99520
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
2.987599
</td>
<td style="text-align:right;">
0.031800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
182
</td>
<td style="text-align:right;">
10.259301
</td>
<td style="text-align:right;">
0.05188
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
747
</td>
<td style="text-align:right;">
19.678715
</td>
<td style="text-align:right;">
0.864200
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
19.79167
</td>
<td style="text-align:right;">
0.6606
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
1718
</td>
<td style="text-align:right;">
4.5983702
</td>
<td style="text-align:right;">
0.46890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1154
</td>
<td style="text-align:right;">
1774
</td>
<td style="text-align:right;">
65.05073
</td>
<td style="text-align:right;">
0.6522
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1056
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
2.083333
</td>
<td style="text-align:right;">
0.31610
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
6.0240964
</td>
<td style="text-align:right;">
0.6154
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
50.6024096
</td>
<td style="text-align:right;">
0.99320
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1324
</td>
<td style="text-align:right;">
1774
</td>
<td style="text-align:right;">
74.6335964
</td>
<td style="text-align:right;">
0.9935
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.277170
</td>
<td style="text-align:right;">
0.4443
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.077380
</td>
<td style="text-align:right;">
0.27780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.6522
</td>
<td style="text-align:right;">
0.6454
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.16790
</td>
<td style="text-align:right;">
0.7874
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.174650
</td>
<td style="text-align:right;">
0.5311
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
950
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
218
</td>
<td style="text-align:right;">
719
</td>
<td style="text-align:right;">
30.31989
</td>
<td style="text-align:right;">
0.7848
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
560
</td>
<td style="text-align:right;">
2.678571
</td>
<td style="text-align:right;">
0.1560
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
9.401709
</td>
<td style="text-align:right;">
0.01305
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
17.07317
</td>
<td style="text-align:right;">
0.03088
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
12.56281
</td>
<td style="text-align:right;">
0.003541
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
681
</td>
<td style="text-align:right;">
7.048458
</td>
<td style="text-align:right;">
0.37250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
238
</td>
<td style="text-align:right;">
721
</td>
<td style="text-align:right;">
33.009709
</td>
<td style="text-align:right;">
0.99890
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
12.2105263
</td>
<td style="text-align:right;">
0.37310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
195
</td>
<td style="text-align:right;">
20.52632
</td>
<td style="text-align:right;">
0.4153
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
113
</td>
<td style="text-align:right;">
526.000
</td>
<td style="text-align:right;">
21.482890
</td>
<td style="text-align:right;">
0.893100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
98.000
</td>
<td style="text-align:right;">
31.632653
</td>
<td style="text-align:right;">
0.9318
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
900
</td>
<td style="text-align:right;">
1.8888889
</td>
<td style="text-align:right;">
0.29830
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
713
</td>
<td style="text-align:right;">
950.000
</td>
<td style="text-align:right;">
75.05263
</td>
<td style="text-align:right;">
0.6900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
694
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
2.449568
</td>
<td style="text-align:right;">
0.3163
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
3.5175879
</td>
<td style="text-align:right;">
0.39980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
199.000
</td>
<td style="text-align:right;">
34.170854
</td>
<td style="text-align:right;">
0.9826
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
950
</td>
<td style="text-align:right;">
28.8421053
</td>
<td style="text-align:right;">
0.9832
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.315741
</td>
<td style="text-align:right;">
0.4476
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.911600
</td>
<td style="text-align:right;">
0.70420
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6900
</td>
<td style="text-align:right;">
0.6839
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.92850
</td>
<td style="text-align:right;">
0.6794
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.845841
</td>
<td style="text-align:right;">
0.6188
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
Census Tract 1, Aleutians West Census Area, Alaska
</td>
<td style="text-align:right;">
26600
</td>
<td style="text-align:right;">
103800
</td>
<td style="text-align:right;">
33125
</td>
<td style="text-align:right;">
71500
</td>
<td style="text-align:right;">
30856.00
</td>
<td style="text-align:right;">
120408
</td>
<td style="text-align:right;">
2269.00
</td>
<td style="text-align:right;">
0.0735351
</td>
<td style="text-align:right;">
-48908
</td>
<td style="text-align:right;">
-0.4061856
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
02020000300
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000300
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
6308
</td>
<td style="text-align:right;">
1834
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
1137
</td>
<td style="text-align:right;">
5839
</td>
<td style="text-align:right;">
19.47251
</td>
<td style="text-align:right;">
0.4988
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
1024
</td>
<td style="text-align:right;">
5.761719
</td>
<td style="text-align:right;">
0.26830
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
100.00000
</td>
<td style="text-align:right;">
0.99780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
609
</td>
<td style="text-align:right;">
1696
</td>
<td style="text-align:right;">
35.90802
</td>
<td style="text-align:right;">
0.17490
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
620
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
36.32103
</td>
<td style="text-align:right;">
0.215100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
2458
</td>
<td style="text-align:right;">
3.458096
</td>
<td style="text-align:right;">
0.12670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
4961
</td>
<td style="text-align:right;">
2.519653
</td>
<td style="text-align:right;">
0.02643
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
0.003301
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2744
</td>
<td style="text-align:right;">
43.500317
</td>
<td style="text-align:right;">
0.99640
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
2007
</td>
<td style="text-align:right;">
2.690583
</td>
<td style="text-align:right;">
0.007821
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
301
</td>
<td style="text-align:right;">
1635
</td>
<td style="text-align:right;">
18.40979
</td>
<td style="text-align:right;">
0.6168
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
5308
</td>
<td style="text-align:right;">
0.2072344
</td>
<td style="text-align:right;">
0.06620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2167
</td>
<td style="text-align:right;">
6308
</td>
<td style="text-align:right;">
34.35320
</td>
<td style="text-align:right;">
0.3715
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1834
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1.308615
</td>
<td style="text-align:right;">
0.27080
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
0.5858231
</td>
<td style="text-align:right;">
0.1573
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
0.5858231
</td>
<td style="text-align:right;">
0.07765
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
469
</td>
<td style="text-align:right;">
6308
</td>
<td style="text-align:right;">
7.4350032
</td>
<td style="text-align:right;">
0.9359
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.135330
</td>
<td style="text-align:right;">
0.1355
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.690522
</td>
<td style="text-align:right;">
0.13070
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.3715
</td>
<td style="text-align:right;">
0.3677
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.69135
</td>
<td style="text-align:right;">
0.1520
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4.888702
</td>
<td style="text-align:right;">
0.1113
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8256
</td>
<td style="text-align:right;">
1834
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
1603
</td>
<td style="text-align:right;">
6583
</td>
<td style="text-align:right;">
24.35060
</td>
<td style="text-align:right;">
0.6772
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
1105
</td>
<td style="text-align:right;">
8.597285
</td>
<td style="text-align:right;">
0.8029
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
43.750000
</td>
<td style="text-align:right;">
0.91050
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1127
</td>
<td style="text-align:right;">
1715
</td>
<td style="text-align:right;">
65.71429
</td>
<td style="text-align:right;">
0.88900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1134
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
65.51127
</td>
<td style="text-align:right;">
0.985700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
148
</td>
<td style="text-align:right;">
3181
</td>
<td style="text-align:right;">
4.652625
</td>
<td style="text-align:right;">
0.23830
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
5243
</td>
<td style="text-align:right;">
1.525844
</td>
<td style="text-align:right;">
0.08775
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
119
</td>
<td style="text-align:right;">
1.4413760
</td>
<td style="text-align:right;">
0.00975
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3086
</td>
<td style="text-align:right;">
37.37888
</td>
<td style="text-align:right;">
0.9880
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
2171.088
</td>
<td style="text-align:right;">
8.889551
</td>
<td style="text-align:right;">
0.188800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
136
</td>
<td style="text-align:right;">
1429.970
</td>
<td style="text-align:right;">
9.510687
</td>
<td style="text-align:right;">
0.3216
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7040
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02391
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3808
</td>
<td style="text-align:right;">
8256.294
</td>
<td style="text-align:right;">
46.12239
</td>
<td style="text-align:right;">
0.4209
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1834
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
6.924755
</td>
<td style="text-align:right;">
0.4701
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1731
</td>
<td style="text-align:right;">
0.7510110
</td>
<td style="text-align:right;">
0.12710
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
179
</td>
<td style="text-align:right;">
1731.395
</td>
<td style="text-align:right;">
10.338487
</td>
<td style="text-align:right;">
0.7913
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1673
</td>
<td style="text-align:right;">
8256
</td>
<td style="text-align:right;">
20.2640504
</td>
<td style="text-align:right;">
0.9768
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.791850
</td>
<td style="text-align:right;">
0.5891
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
1.532060
</td>
<td style="text-align:right;">
0.07776
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4209
</td>
<td style="text-align:right;">
0.4172
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.61190
</td>
<td style="text-align:right;">
0.5330
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
7.356710
</td>
<td style="text-align:right;">
0.4139
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
Census Tract 3, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
32404
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
31620
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
37588.64
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
-5968.64
</td>
<td style="text-align:right;">
-0.1587884
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
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000400
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000400
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
5991
</td>
<td style="text-align:right;">
1360
</td>
<td style="text-align:right;">
1246
</td>
<td style="text-align:right;">
628
</td>
<td style="text-align:right;">
4602
</td>
<td style="text-align:right;">
13.64624
</td>
<td style="text-align:right;">
0.3404
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
117
</td>
<td style="text-align:right;">
924
</td>
<td style="text-align:right;">
12.662338
</td>
<td style="text-align:right;">
0.81630
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
0.00000
</td>
<td style="text-align:right;">
0.00240
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
1234
</td>
<td style="text-align:right;">
61.66937
</td>
<td style="text-align:right;">
0.78730
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
761
</td>
<td style="text-align:right;">
1246
</td>
<td style="text-align:right;">
61.07544
</td>
<td style="text-align:right;">
0.929600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1995
</td>
<td style="text-align:right;">
1.203008
</td>
<td style="text-align:right;">
0.03078
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
4075
</td>
<td style="text-align:right;">
1.349693
</td>
<td style="text-align:right;">
0.01061
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
0.003301
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2117
</td>
<td style="text-align:right;">
35.336338
</td>
<td style="text-align:right;">
0.93430
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
1820
</td>
<td style="text-align:right;">
4.725275
</td>
<td style="text-align:right;">
0.029420
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
1246
</td>
<td style="text-align:right;">
11.07544
</td>
<td style="text-align:right;">
0.3314
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
5099
</td>
<td style="text-align:right;">
0.2745636
</td>
<td style="text-align:right;">
0.07606
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1539
</td>
<td style="text-align:right;">
5991
</td>
<td style="text-align:right;">
25.68853
</td>
<td style="text-align:right;">
0.2688
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.7352941
</td>
<td style="text-align:right;">
0.5653
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
1246
</td>
<td style="text-align:right;">
3.0497592
</td>
<td style="text-align:right;">
0.4365
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
1246
</td>
<td style="text-align:right;">
1.6853933
</td>
<td style="text-align:right;">
0.19700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1389
</td>
<td style="text-align:right;">
5991
</td>
<td style="text-align:right;">
23.1847772
</td>
<td style="text-align:right;">
0.9762
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.127690
</td>
<td style="text-align:right;">
0.4021
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
1.374481
</td>
<td style="text-align:right;">
0.05613
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.2688
</td>
<td style="text-align:right;">
0.2660
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.26895
</td>
<td style="text-align:right;">
0.3836
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6.039921
</td>
<td style="text-align:right;">
0.2480
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
5090
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
1377
</td>
<td style="text-align:right;">
657
</td>
<td style="text-align:right;">
4243
</td>
<td style="text-align:right;">
15.48433
</td>
<td style="text-align:right;">
0.4416
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
1435
</td>
<td style="text-align:right;">
5.714286
</td>
<td style="text-align:right;">
0.5455
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
NaN
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
912
</td>
<td style="text-align:right;">
1377
</td>
<td style="text-align:right;">
66.23094
</td>
<td style="text-align:right;">
0.89700
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
912
</td>
<td style="text-align:right;">
1377
</td>
<td style="text-align:right;">
66.23094
</td>
<td style="text-align:right;">
0.987300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
1928
</td>
<td style="text-align:right;">
1.452282
</td>
<td style="text-align:right;">
0.05471
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
3349
</td>
<td style="text-align:right;">
2.448492
</td>
<td style="text-align:right;">
0.16300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
0.2357564
</td>
<td style="text-align:right;">
0.00585
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1446
</td>
<td style="text-align:right;">
28.40864
</td>
<td style="text-align:right;">
0.8460
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
1902.717
</td>
<td style="text-align:right;">
3.573837
</td>
<td style="text-align:right;">
0.008563
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
1032.000
</td>
<td style="text-align:right;">
5.426357
</td>
<td style="text-align:right;">
0.1342
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
4411
</td>
<td style="text-align:right;">
0.2040354
</td>
<td style="text-align:right;">
0.06983
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2444
</td>
<td style="text-align:right;">
5089.955
</td>
<td style="text-align:right;">
48.01614
</td>
<td style="text-align:right;">
0.4425
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1440
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
2.638889
</td>
<td style="text-align:right;">
0.3255
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
1377
</td>
<td style="text-align:right;">
0.5083515
</td>
<td style="text-align:right;">
0.09514
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
1377.000
</td>
<td style="text-align:right;">
6.681191
</td>
<td style="text-align:right;">
0.6436
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
820
</td>
<td style="text-align:right;">
5090
</td>
<td style="text-align:right;">
16.1100196
</td>
<td style="text-align:right;">
0.9730
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.192110
</td>
<td style="text-align:right;">
0.4140
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.064443
</td>
<td style="text-align:right;">
0.02264
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4425
</td>
<td style="text-align:right;">
0.4386
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.28384
</td>
<td style="text-align:right;">
0.3878
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
5.982893
</td>
<td style="text-align:right;">
0.2198
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
Census Tract 4, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
23868
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
30710
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
27686.88
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
3023.12
</td>
<td style="text-align:right;">
0.1091896
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
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000500
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000500
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
1872
</td>
<td style="text-align:right;">
979
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
1872
</td>
<td style="text-align:right;">
20.51282
</td>
<td style="text-align:right;">
0.5238
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
3.134796
</td>
<td style="text-align:right;">
0.06633
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
37.58389
</td>
<td style="text-align:right;">
0.39630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
807
</td>
<td style="text-align:right;">
39.77695
</td>
<td style="text-align:right;">
0.23920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
39.43515
</td>
<td style="text-align:right;">
0.311800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
190
</td>
<td style="text-align:right;">
1139
</td>
<td style="text-align:right;">
16.681299
</td>
<td style="text-align:right;">
0.60890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
314
</td>
<td style="text-align:right;">
2109
</td>
<td style="text-align:right;">
14.888573
</td>
<td style="text-align:right;">
0.48950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
221
</td>
<td style="text-align:right;">
11.805556
</td>
<td style="text-align:right;">
0.574800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
434
</td>
<td style="text-align:right;">
23.183761
</td>
<td style="text-align:right;">
0.43040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
307
</td>
<td style="text-align:right;">
1475
</td>
<td style="text-align:right;">
20.813559
</td>
<td style="text-align:right;">
0.894900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
385
</td>
<td style="text-align:right;">
23.63636
</td>
<td style="text-align:right;">
0.7603
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
1793
</td>
<td style="text-align:right;">
7.1946458
</td>
<td style="text-align:right;">
0.58420
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1048
</td>
<td style="text-align:right;">
1872
</td>
<td style="text-align:right;">
55.98291
</td>
<td style="text-align:right;">
0.5787
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
979
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:right;">
59.039837
</td>
<td style="text-align:right;">
0.95260
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
2.3012552
</td>
<td style="text-align:right;">
0.3729
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
8.1589958
</td>
<td style="text-align:right;">
0.68640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1872
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.000330
</td>
<td style="text-align:right;">
0.3676
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.244600
</td>
<td style="text-align:right;">
0.82880
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.5787
</td>
<td style="text-align:right;">
0.5727
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.63590
</td>
<td style="text-align:right;">
0.5502
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.459530
</td>
<td style="text-align:right;">
0.5669
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2039
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
624
</td>
<td style="text-align:right;">
2039
</td>
<td style="text-align:right;">
30.60324
</td>
<td style="text-align:right;">
0.7906
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
119
</td>
<td style="text-align:right;">
1125
</td>
<td style="text-align:right;">
10.577778
</td>
<td style="text-align:right;">
0.8901
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
30.434783
</td>
<td style="text-align:right;">
0.56020
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
361
</td>
<td style="text-align:right;">
847
</td>
<td style="text-align:right;">
42.62102
</td>
<td style="text-align:right;">
0.32940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
403
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
40.91371
</td>
<td style="text-align:right;">
0.614800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
1468
</td>
<td style="text-align:right;">
4.155313
</td>
<td style="text-align:right;">
0.20970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
350
</td>
<td style="text-align:right;">
1966
</td>
<td style="text-align:right;">
17.802645
</td>
<td style="text-align:right;">
0.95510
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
9.8087298
</td>
<td style="text-align:right;">
0.22920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
322
</td>
<td style="text-align:right;">
15.79205
</td>
<td style="text-align:right;">
0.1707
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
1644.283
</td>
<td style="text-align:right;">
14.170309
</td>
<td style="text-align:right;">
0.581400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
143
</td>
<td style="text-align:right;">
338.000
</td>
<td style="text-align:right;">
42.307692
</td>
<td style="text-align:right;">
0.9859
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
1920
</td>
<td style="text-align:right;">
2.5000000
</td>
<td style="text-align:right;">
0.35480
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1060
</td>
<td style="text-align:right;">
2039.045
</td>
<td style="text-align:right;">
51.98512
</td>
<td style="text-align:right;">
0.4840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1074
</td>
<td style="text-align:right;">
642
</td>
<td style="text-align:right;">
59.776536
</td>
<td style="text-align:right;">
0.9485
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
985
</td>
<td style="text-align:right;">
3.9593909
</td>
<td style="text-align:right;">
0.43720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
985.000
</td>
<td style="text-align:right;">
23.350254
</td>
<td style="text-align:right;">
0.9573
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2039
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1370
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.460300
</td>
<td style="text-align:right;">
0.7607
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.322000
</td>
<td style="text-align:right;">
0.38140
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4840
</td>
<td style="text-align:right;">
0.4797
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.72660
</td>
<td style="text-align:right;">
0.5866
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.992900
</td>
<td style="text-align:right;">
0.6375
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
Census Tract 5, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
28705
</td>
<td style="text-align:right;">
325000
</td>
<td style="text-align:right;">
29432
</td>
<td style="text-align:right;">
378600
</td>
<td style="text-align:right;">
33297.80
</td>
<td style="text-align:right;">
377000
</td>
<td style="text-align:right;">
-3865.80
</td>
<td style="text-align:right;">
-0.1160978
</td>
<td style="text-align:right;">
1600
</td>
<td style="text-align:right;">
0.0042440
</td>
<td style="text-align:right;">
149.51
</td>
<td style="text-align:right;">
185.49
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000701
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000701
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
5432
</td>
<td style="text-align:right;">
2076
</td>
<td style="text-align:right;">
1969
</td>
<td style="text-align:right;">
1206
</td>
<td style="text-align:right;">
5418
</td>
<td style="text-align:right;">
22.25914
</td>
<td style="text-align:right;">
0.5643
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
2765
</td>
<td style="text-align:right;">
9.547920
</td>
<td style="text-align:right;">
0.62650
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
354
</td>
<td style="text-align:right;">
1051
</td>
<td style="text-align:right;">
33.68221
</td>
<td style="text-align:right;">
0.26640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
918
</td>
<td style="text-align:right;">
39.43355
</td>
<td style="text-align:right;">
0.23330
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
1969
</td>
<td style="text-align:right;">
36.36364
</td>
<td style="text-align:right;">
0.216100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
411
</td>
<td style="text-align:right;">
3280
</td>
<td style="text-align:right;">
12.530488
</td>
<td style="text-align:right;">
0.50270
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1108
</td>
<td style="text-align:right;">
5795
</td>
<td style="text-align:right;">
19.119931
</td>
<td style="text-align:right;">
0.64920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
354
</td>
<td style="text-align:right;">
6.516937
</td>
<td style="text-align:right;">
0.200300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1479
</td>
<td style="text-align:right;">
27.227540
</td>
<td style="text-align:right;">
0.65230
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
4056
</td>
<td style="text-align:right;">
13.979290
</td>
<td style="text-align:right;">
0.607400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
1255
</td>
<td style="text-align:right;">
33.06773
</td>
<td style="text-align:right;">
0.9178
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
4960
</td>
<td style="text-align:right;">
1.4717742
</td>
<td style="text-align:right;">
0.22780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3080
</td>
<td style="text-align:right;">
5432
</td>
<td style="text-align:right;">
56.70103
</td>
<td style="text-align:right;">
0.5848
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2076
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
13.150289
</td>
<td style="text-align:right;">
0.63880
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
335
</td>
<td style="text-align:right;">
16.1368015
</td>
<td style="text-align:right;">
0.8980
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
166
</td>
<td style="text-align:right;">
1969
</td>
<td style="text-align:right;">
8.4306755
</td>
<td style="text-align:right;">
0.7014
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
1969
</td>
<td style="text-align:right;">
10.2590147
</td>
<td style="text-align:right;">
0.76450
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5432
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.558800
</td>
<td style="text-align:right;">
0.5224
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.605600
</td>
<td style="text-align:right;">
0.53860
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5848
</td>
<td style="text-align:right;">
0.5788
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.37700
</td>
<td style="text-align:right;">
0.8627
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.126200
</td>
<td style="text-align:right;">
0.6476
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
6784
</td>
<td style="text-align:right;">
2585
</td>
<td style="text-align:right;">
2265
</td>
<td style="text-align:right;">
1300
</td>
<td style="text-align:right;">
6719
</td>
<td style="text-align:right;">
19.34812
</td>
<td style="text-align:right;">
0.5567
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
196
</td>
<td style="text-align:right;">
3597
</td>
<td style="text-align:right;">
5.448985
</td>
<td style="text-align:right;">
0.5123
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
356
</td>
<td style="text-align:right;">
1275
</td>
<td style="text-align:right;">
27.921569
</td>
<td style="text-align:right;">
0.45790
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
443
</td>
<td style="text-align:right;">
990
</td>
<td style="text-align:right;">
44.74747
</td>
<td style="text-align:right;">
0.37870
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
799
</td>
<td style="text-align:right;">
2265
</td>
<td style="text-align:right;">
35.27594
</td>
<td style="text-align:right;">
0.419800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
363
</td>
<td style="text-align:right;">
3964
</td>
<td style="text-align:right;">
9.157417
</td>
<td style="text-align:right;">
0.46990
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
651
</td>
<td style="text-align:right;">
6607
</td>
<td style="text-align:right;">
9.853186
</td>
<td style="text-align:right;">
0.76060
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
6.4416274
</td>
<td style="text-align:right;">
0.06927
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2252
</td>
<td style="text-align:right;">
33.19575
</td>
<td style="text-align:right;">
0.9548
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
945
</td>
<td style="text-align:right;">
4355.000
</td>
<td style="text-align:right;">
21.699196
</td>
<td style="text-align:right;">
0.897900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
179
</td>
<td style="text-align:right;">
1612.000
</td>
<td style="text-align:right;">
11.104218
</td>
<td style="text-align:right;">
0.3936
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
6172
</td>
<td style="text-align:right;">
7.7932599
</td>
<td style="text-align:right;">
0.65010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4356
</td>
<td style="text-align:right;">
6784.000
</td>
<td style="text-align:right;">
64.20991
</td>
<td style="text-align:right;">
0.5963
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2585
</td>
<td style="text-align:right;">
356
</td>
<td style="text-align:right;">
13.771760
</td>
<td style="text-align:right;">
0.6278
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
424
</td>
<td style="text-align:right;">
16.402321
</td>
<td style="text-align:right;">
0.9130
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
195
</td>
<td style="text-align:right;">
2265
</td>
<td style="text-align:right;">
8.6092715
</td>
<td style="text-align:right;">
0.68030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
2265.000
</td>
<td style="text-align:right;">
11.037528
</td>
<td style="text-align:right;">
0.8145
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
6784
</td>
<td style="text-align:right;">
0.1031840
</td>
<td style="text-align:right;">
0.3090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.719300
</td>
<td style="text-align:right;">
0.5684
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.965670
</td>
<td style="text-align:right;">
0.73150
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.5963
</td>
<td style="text-align:right;">
0.5911
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.34460
</td>
<td style="text-align:right;">
0.8443
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.625870
</td>
<td style="text-align:right;">
0.7156
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
Census Tract 7.01, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
30261
</td>
<td style="text-align:right;">
212800
</td>
<td style="text-align:right;">
35306
</td>
<td style="text-align:right;">
230800
</td>
<td style="text-align:right;">
35102.76
</td>
<td style="text-align:right;">
246848
</td>
<td style="text-align:right;">
203.24
</td>
<td style="text-align:right;">
0.0057899
</td>
<td style="text-align:right;">
-16048
</td>
<td style="text-align:right;">
-0.0650117
</td>
<td style="text-align:right;">
196.20
</td>
<td style="text-align:right;">
222.97
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000702
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000702
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
5312
</td>
<td style="text-align:right;">
1972
</td>
<td style="text-align:right;">
1853
</td>
<td style="text-align:right;">
1154
</td>
<td style="text-align:right;">
5242
</td>
<td style="text-align:right;">
22.01450
</td>
<td style="text-align:right;">
0.5594
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
121
</td>
<td style="text-align:right;">
2647
</td>
<td style="text-align:right;">
4.571213
</td>
<td style="text-align:right;">
0.16150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
229
</td>
<td style="text-align:right;">
784
</td>
<td style="text-align:right;">
29.20918
</td>
<td style="text-align:right;">
0.15100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
418
</td>
<td style="text-align:right;">
1069
</td>
<td style="text-align:right;">
39.10196
</td>
<td style="text-align:right;">
0.22630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
647
</td>
<td style="text-align:right;">
1853
</td>
<td style="text-align:right;">
34.91635
</td>
<td style="text-align:right;">
0.176500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
172
</td>
<td style="text-align:right;">
2799
</td>
<td style="text-align:right;">
6.145052
</td>
<td style="text-align:right;">
0.25580
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
941
</td>
<td style="text-align:right;">
5126
</td>
<td style="text-align:right;">
18.357394
</td>
<td style="text-align:right;">
0.62460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
3.802711
</td>
<td style="text-align:right;">
0.053090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1602
</td>
<td style="text-align:right;">
30.158133
</td>
<td style="text-align:right;">
0.78390
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
390
</td>
<td style="text-align:right;">
3602
</td>
<td style="text-align:right;">
10.827318
</td>
<td style="text-align:right;">
0.374000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
279
</td>
<td style="text-align:right;">
1344
</td>
<td style="text-align:right;">
20.75893
</td>
<td style="text-align:right;">
0.6878
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
4700
</td>
<td style="text-align:right;">
1.7872340
</td>
<td style="text-align:right;">
0.26170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2129
</td>
<td style="text-align:right;">
5312
</td>
<td style="text-align:right;">
40.07907
</td>
<td style="text-align:right;">
0.4352
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1972
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
12.677485
</td>
<td style="text-align:right;">
0.62970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
2.4340771
</td>
<td style="text-align:right;">
0.6783
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
142
</td>
<td style="text-align:right;">
1853
</td>
<td style="text-align:right;">
7.6632488
</td>
<td style="text-align:right;">
0.6768
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
1853
</td>
<td style="text-align:right;">
4.3173233
</td>
<td style="text-align:right;">
0.45840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
5312
</td>
<td style="text-align:right;">
0.5459337
</td>
<td style="text-align:right;">
0.7587
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.777800
</td>
<td style="text-align:right;">
0.3048
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.160490
</td>
<td style="text-align:right;">
0.31610
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4352
</td>
<td style="text-align:right;">
0.4308
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.20190
</td>
<td style="text-align:right;">
0.8004
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.575390
</td>
<td style="text-align:right;">
0.4514
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
6391
</td>
<td style="text-align:right;">
2512
</td>
<td style="text-align:right;">
2317
</td>
<td style="text-align:right;">
1253
</td>
<td style="text-align:right;">
6298
</td>
<td style="text-align:right;">
19.89520
</td>
<td style="text-align:right;">
0.5724
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
2893
</td>
<td style="text-align:right;">
3.491186
</td>
<td style="text-align:right;">
0.2572
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
404
</td>
<td style="text-align:right;">
1230
</td>
<td style="text-align:right;">
32.845529
</td>
<td style="text-align:right;">
0.65310
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
524
</td>
<td style="text-align:right;">
1087
</td>
<td style="text-align:right;">
48.20607
</td>
<td style="text-align:right;">
0.46800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
928
</td>
<td style="text-align:right;">
2317
</td>
<td style="text-align:right;">
40.05179
</td>
<td style="text-align:right;">
0.586300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
431
</td>
<td style="text-align:right;">
3563
</td>
<td style="text-align:right;">
12.096548
</td>
<td style="text-align:right;">
0.57540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
433
</td>
<td style="text-align:right;">
6087
</td>
<td style="text-align:right;">
7.113521
</td>
<td style="text-align:right;">
0.60170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
634
</td>
<td style="text-align:right;">
9.9202003
</td>
<td style="text-align:right;">
0.23630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1892
</td>
<td style="text-align:right;">
29.60413
</td>
<td style="text-align:right;">
0.8823
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
4195.000
</td>
<td style="text-align:right;">
23.933254
</td>
<td style="text-align:right;">
0.936100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
1366.000
</td>
<td style="text-align:right;">
25.695461
</td>
<td style="text-align:right;">
0.8500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
5974
</td>
<td style="text-align:right;">
2.1593572
</td>
<td style="text-align:right;">
0.32410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3992
</td>
<td style="text-align:right;">
6391.000
</td>
<td style="text-align:right;">
62.46284
</td>
<td style="text-align:right;">
0.5804
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2512
</td>
<td style="text-align:right;">
548
</td>
<td style="text-align:right;">
21.815287
</td>
<td style="text-align:right;">
0.7513
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
7.961783
</td>
<td style="text-align:right;">
0.8180
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
220
</td>
<td style="text-align:right;">
2317
</td>
<td style="text-align:right;">
9.4950367
</td>
<td style="text-align:right;">
0.71030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
120
</td>
<td style="text-align:right;">
2317.000
</td>
<td style="text-align:right;">
5.179111
</td>
<td style="text-align:right;">
0.5520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
6391
</td>
<td style="text-align:right;">
0.7510562
</td>
<td style="text-align:right;">
0.6479
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.593000
</td>
<td style="text-align:right;">
0.5336
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.228800
</td>
<td style="text-align:right;">
0.84110
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.5804
</td>
<td style="text-align:right;">
0.5753
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.47950
</td>
<td style="text-align:right;">
0.8832
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.881700
</td>
<td style="text-align:right;">
0.7464
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
Census Tract 7.02, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
30132
</td>
<td style="text-align:right;">
265800
</td>
<td style="text-align:right;">
27486
</td>
<td style="text-align:right;">
280300
</td>
<td style="text-align:right;">
34953.12
</td>
<td style="text-align:right;">
308328
</td>
<td style="text-align:right;">
-7467.12
</td>
<td style="text-align:right;">
-0.2136324
</td>
<td style="text-align:right;">
-28028
</td>
<td style="text-align:right;">
-0.0909032
</td>
<td style="text-align:right;">
192.20
</td>
<td style="text-align:right;">
212.03
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000703
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000703
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
5309
</td>
<td style="text-align:right;">
2312
</td>
<td style="text-align:right;">
2051
</td>
<td style="text-align:right;">
1208
</td>
<td style="text-align:right;">
5217
</td>
<td style="text-align:right;">
23.15507
</td>
<td style="text-align:right;">
0.5826
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
440
</td>
<td style="text-align:right;">
2750
</td>
<td style="text-align:right;">
16.000000
</td>
<td style="text-align:right;">
0.91910
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
269
</td>
<td style="text-align:right;">
929
</td>
<td style="text-align:right;">
28.95587
</td>
<td style="text-align:right;">
0.14470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
613
</td>
<td style="text-align:right;">
1122
</td>
<td style="text-align:right;">
54.63458
</td>
<td style="text-align:right;">
0.61220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
882
</td>
<td style="text-align:right;">
2051
</td>
<td style="text-align:right;">
43.00341
</td>
<td style="text-align:right;">
0.440600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
480
</td>
<td style="text-align:right;">
3244
</td>
<td style="text-align:right;">
14.796548
</td>
<td style="text-align:right;">
0.56470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1399
</td>
<td style="text-align:right;">
5075
</td>
<td style="text-align:right;">
27.566502
</td>
<td style="text-align:right;">
0.85540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
9.907704
</td>
<td style="text-align:right;">
0.446600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1355
</td>
<td style="text-align:right;">
25.522697
</td>
<td style="text-align:right;">
0.56000
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1039
</td>
<td style="text-align:right;">
3732
</td>
<td style="text-align:right;">
27.840300
</td>
<td style="text-align:right;">
0.976800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
304
</td>
<td style="text-align:right;">
1256
</td>
<td style="text-align:right;">
24.20382
</td>
<td style="text-align:right;">
0.7732
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
292
</td>
<td style="text-align:right;">
4943
</td>
<td style="text-align:right;">
5.9073437
</td>
<td style="text-align:right;">
0.53390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3146
</td>
<td style="text-align:right;">
5309
</td>
<td style="text-align:right;">
59.25786
</td>
<td style="text-align:right;">
0.6070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2312
</td>
<td style="text-align:right;">
514
</td>
<td style="text-align:right;">
22.231834
</td>
<td style="text-align:right;">
0.77020
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
235
</td>
<td style="text-align:right;">
10.1643599
</td>
<td style="text-align:right;">
0.8305
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
151
</td>
<td style="text-align:right;">
2051
</td>
<td style="text-align:right;">
7.3622623
</td>
<td style="text-align:right;">
0.6657
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
156
</td>
<td style="text-align:right;">
2051
</td>
<td style="text-align:right;">
7.6060458
</td>
<td style="text-align:right;">
0.66140
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
5309
</td>
<td style="text-align:right;">
0.6027500
</td>
<td style="text-align:right;">
0.7607
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.362400
</td>
<td style="text-align:right;">
0.7239
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
3.290500
</td>
<td style="text-align:right;">
0.84540
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6070
</td>
<td style="text-align:right;">
0.6007
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.68850
</td>
<td style="text-align:right;">
0.9360
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.948400
</td>
<td style="text-align:right;">
0.8380
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
6007
</td>
<td style="text-align:right;">
2397
</td>
<td style="text-align:right;">
2191
</td>
<td style="text-align:right;">
1596
</td>
<td style="text-align:right;">
5859
</td>
<td style="text-align:right;">
27.24014
</td>
<td style="text-align:right;">
0.7337
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
231
</td>
<td style="text-align:right;">
3303
</td>
<td style="text-align:right;">
6.993642
</td>
<td style="text-align:right;">
0.6809
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
321
</td>
<td style="text-align:right;">
1072
</td>
<td style="text-align:right;">
29.944030
</td>
<td style="text-align:right;">
0.54100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
571
</td>
<td style="text-align:right;">
1120
</td>
<td style="text-align:right;">
50.98214
</td>
<td style="text-align:right;">
0.54040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
892
</td>
<td style="text-align:right;">
2192
</td>
<td style="text-align:right;">
40.69343
</td>
<td style="text-align:right;">
0.608200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
3692
</td>
<td style="text-align:right;">
7.936078
</td>
<td style="text-align:right;">
0.41630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
766
</td>
<td style="text-align:right;">
5779
</td>
<td style="text-align:right;">
13.254888
</td>
<td style="text-align:right;">
0.87670
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
739
</td>
<td style="text-align:right;">
12.3023140
</td>
<td style="text-align:right;">
0.37940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1707
</td>
<td style="text-align:right;">
28.41685
</td>
<td style="text-align:right;">
0.8466
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
625
</td>
<td style="text-align:right;">
4057.618
</td>
<td style="text-align:right;">
15.403126
</td>
<td style="text-align:right;">
0.662900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
387
</td>
<td style="text-align:right;">
1378.067
</td>
<td style="text-align:right;">
28.082823
</td>
<td style="text-align:right;">
0.8878
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
126
</td>
<td style="text-align:right;">
5449
</td>
<td style="text-align:right;">
2.3123509
</td>
<td style="text-align:right;">
0.33780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3959
</td>
<td style="text-align:right;">
6006.510
</td>
<td style="text-align:right;">
65.91182
</td>
<td style="text-align:right;">
0.6115
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2397
</td>
<td style="text-align:right;">
315
</td>
<td style="text-align:right;">
13.141427
</td>
<td style="text-align:right;">
0.6161
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
303
</td>
<td style="text-align:right;">
12.640801
</td>
<td style="text-align:right;">
0.8788
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
273
</td>
<td style="text-align:right;">
2191
</td>
<td style="text-align:right;">
12.4600639
</td>
<td style="text-align:right;">
0.78630
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
240
</td>
<td style="text-align:right;">
2191.439
</td>
<td style="text-align:right;">
10.951706
</td>
<td style="text-align:right;">
0.8114
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
201
</td>
<td style="text-align:right;">
6007
</td>
<td style="text-align:right;">
3.3460962
</td>
<td style="text-align:right;">
0.8922
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.315800
</td>
<td style="text-align:right;">
0.7254
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.114500
</td>
<td style="text-align:right;">
0.79680
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6115
</td>
<td style="text-align:right;">
0.6061
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.98480
</td>
<td style="text-align:right;">
0.9711
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
11.026600
</td>
<td style="text-align:right;">
0.8725
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
Census Tract 7.03, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
19589
</td>
<td style="text-align:right;">
147100
</td>
<td style="text-align:right;">
26957
</td>
<td style="text-align:right;">
194200
</td>
<td style="text-align:right;">
22723.24
</td>
<td style="text-align:right;">
170636
</td>
<td style="text-align:right;">
4233.76
</td>
<td style="text-align:right;">
0.1863185
</td>
<td style="text-align:right;">
23564
</td>
<td style="text-align:right;">
0.1380951
</td>
<td style="text-align:right;">
138.68
</td>
<td style="text-align:right;">
150.83
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000801
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000801
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
6878
</td>
<td style="text-align:right;">
2593
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
1901
</td>
<td style="text-align:right;">
6821
</td>
<td style="text-align:right;">
27.86981
</td>
<td style="text-align:right;">
0.6792
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
514
</td>
<td style="text-align:right;">
3678
</td>
<td style="text-align:right;">
13.974986
</td>
<td style="text-align:right;">
0.86730
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
415
</td>
<td style="text-align:right;">
976
</td>
<td style="text-align:right;">
42.52049
</td>
<td style="text-align:right;">
0.57230
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
595
</td>
<td style="text-align:right;">
1404
</td>
<td style="text-align:right;">
42.37892
</td>
<td style="text-align:right;">
0.29620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1010
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
42.43697
</td>
<td style="text-align:right;">
0.418100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
3752
</td>
<td style="text-align:right;">
10.207889
</td>
<td style="text-align:right;">
0.42440
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1608
</td>
<td style="text-align:right;">
7420
</td>
<td style="text-align:right;">
21.671159
</td>
<td style="text-align:right;">
0.72520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
378
</td>
<td style="text-align:right;">
5.495784
</td>
<td style="text-align:right;">
0.132500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2001
</td>
<td style="text-align:right;">
29.092759
</td>
<td style="text-align:right;">
0.74220
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
879
</td>
<td style="text-align:right;">
4943
</td>
<td style="text-align:right;">
17.782723
</td>
<td style="text-align:right;">
0.804800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
535
</td>
<td style="text-align:right;">
1648
</td>
<td style="text-align:right;">
32.46359
</td>
<td style="text-align:right;">
0.9101
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
328
</td>
<td style="text-align:right;">
6158
</td>
<td style="text-align:right;">
5.3264047
</td>
<td style="text-align:right;">
0.50640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4037
</td>
<td style="text-align:right;">
6878
</td>
<td style="text-align:right;">
58.69439
</td>
<td style="text-align:right;">
0.6022
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2593
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
12.456614
</td>
<td style="text-align:right;">
0.62550
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
122
</td>
<td style="text-align:right;">
4.7049749
</td>
<td style="text-align:right;">
0.7403
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
246
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
10.3361345
</td>
<td style="text-align:right;">
0.7506
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
250
</td>
<td style="text-align:right;">
2380
</td>
<td style="text-align:right;">
10.5042017
</td>
<td style="text-align:right;">
0.76960
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
127
</td>
<td style="text-align:right;">
6878
</td>
<td style="text-align:right;">
1.8464670
</td>
<td style="text-align:right;">
0.8242
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.114200
</td>
<td style="text-align:right;">
0.6623
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.096000
</td>
<td style="text-align:right;">
0.76840
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6022
</td>
<td style="text-align:right;">
0.5960
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.71020
</td>
<td style="text-align:right;">
0.9397
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.522600
</td>
<td style="text-align:right;">
0.7937
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
8039
</td>
<td style="text-align:right;">
2575
</td>
<td style="text-align:right;">
2349
</td>
<td style="text-align:right;">
1877
</td>
<td style="text-align:right;">
7913
</td>
<td style="text-align:right;">
23.72046
</td>
<td style="text-align:right;">
0.6629
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
3708
</td>
<td style="text-align:right;">
6.040992
</td>
<td style="text-align:right;">
0.5815
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
364
</td>
<td style="text-align:right;">
1245
</td>
<td style="text-align:right;">
29.236948
</td>
<td style="text-align:right;">
0.51410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
332
</td>
<td style="text-align:right;">
1104
</td>
<td style="text-align:right;">
30.07246
</td>
<td style="text-align:right;">
0.11540
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
2349
</td>
<td style="text-align:right;">
29.62963
</td>
<td style="text-align:right;">
0.234900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
631
</td>
<td style="text-align:right;">
4356
</td>
<td style="text-align:right;">
14.485767
</td>
<td style="text-align:right;">
0.63730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1269
</td>
<td style="text-align:right;">
7749
</td>
<td style="text-align:right;">
16.376307
</td>
<td style="text-align:right;">
0.93800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
569
</td>
<td style="text-align:right;">
7.0779948
</td>
<td style="text-align:right;">
0.09286
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2750
</td>
<td style="text-align:right;">
34.20823
</td>
<td style="text-align:right;">
0.9664
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
925
</td>
<td style="text-align:right;">
5009.000
</td>
<td style="text-align:right;">
18.466760
</td>
<td style="text-align:right;">
0.806400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
1360.000
</td>
<td style="text-align:right;">
25.147059
</td>
<td style="text-align:right;">
0.8398
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
178
</td>
<td style="text-align:right;">
7027
</td>
<td style="text-align:right;">
2.5330867
</td>
<td style="text-align:right;">
0.35840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6353
</td>
<td style="text-align:right;">
8039.000
</td>
<td style="text-align:right;">
79.02724
</td>
<td style="text-align:right;">
0.7276
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2575
</td>
<td style="text-align:right;">
438
</td>
<td style="text-align:right;">
17.009709
</td>
<td style="text-align:right;">
0.6842
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
8.854369
</td>
<td style="text-align:right;">
0.8322
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
342
</td>
<td style="text-align:right;">
2349
</td>
<td style="text-align:right;">
14.5593870
</td>
<td style="text-align:right;">
0.82720
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
262
</td>
<td style="text-align:right;">
2349.000
</td>
<td style="text-align:right;">
11.153682
</td>
<td style="text-align:right;">
0.8169
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
8039
</td>
<td style="text-align:right;">
1.2563752
</td>
<td style="text-align:right;">
0.7476
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.054600
</td>
<td style="text-align:right;">
0.6607
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.063860
</td>
<td style="text-align:right;">
0.77520
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.7276
</td>
<td style="text-align:right;">
0.7212
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.90810
</td>
<td style="text-align:right;">
0.9647
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.754160
</td>
<td style="text-align:right;">
0.8443
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
Census Tract 8.01, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
24433
</td>
<td style="text-align:right;">
214200
</td>
<td style="text-align:right;">
28895
</td>
<td style="text-align:right;">
217000
</td>
<td style="text-align:right;">
28342.28
</td>
<td style="text-align:right;">
248472
</td>
<td style="text-align:right;">
552.72
</td>
<td style="text-align:right;">
0.0195016
</td>
<td style="text-align:right;">
-31472
</td>
<td style="text-align:right;">
-0.1266622
</td>
<td style="text-align:right;">
175.52
</td>
<td style="text-align:right;">
189.05
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
<tr>
<td style="text-align:left;">
02020000802
</td>
<td style="text-align:left;">
02020
</td>
<td style="text-align:left;">
000802
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Anchorage Municipality
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
4412
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
1860
</td>
<td style="text-align:right;">
927
</td>
<td style="text-align:right;">
4412
</td>
<td style="text-align:right;">
21.01088
</td>
<td style="text-align:right;">
0.5341
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
2358
</td>
<td style="text-align:right;">
15.521629
</td>
<td style="text-align:right;">
0.90830
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
993
</td>
<td style="text-align:right;">
33.13192
</td>
<td style="text-align:right;">
0.24940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
427
</td>
<td style="text-align:right;">
867
</td>
<td style="text-align:right;">
49.25029
</td>
<td style="text-align:right;">
0.46580
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
756
</td>
<td style="text-align:right;">
1860
</td>
<td style="text-align:right;">
40.64516
</td>
<td style="text-align:right;">
0.351500
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
284
</td>
<td style="text-align:right;">
2541
</td>
<td style="text-align:right;">
11.176702
</td>
<td style="text-align:right;">
0.45970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
944
</td>
<td style="text-align:right;">
4351
</td>
<td style="text-align:right;">
21.696162
</td>
<td style="text-align:right;">
0.72640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
6.595648
</td>
<td style="text-align:right;">
0.206200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1116
</td>
<td style="text-align:right;">
25.294651
</td>
<td style="text-align:right;">
0.54610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
456
</td>
<td style="text-align:right;">
3183
</td>
<td style="text-align:right;">
14.326107
</td>
<td style="text-align:right;">
0.630400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
365
</td>
<td style="text-align:right;">
1034
</td>
<td style="text-align:right;">
35.29981
</td>
<td style="text-align:right;">
0.9397
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
147
</td>
<td style="text-align:right;">
4065
</td>
<td style="text-align:right;">
3.6162362
</td>
<td style="text-align:right;">
0.41080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2063
</td>
<td style="text-align:right;">
4412
</td>
<td style="text-align:right;">
46.75884
</td>
<td style="text-align:right;">
0.4982
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1955
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
26.905371
</td>
<td style="text-align:right;">
0.81460
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
235
</td>
<td style="text-align:right;">
12.0204604
</td>
<td style="text-align:right;">
0.8530
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1860
</td>
<td style="text-align:right;">
5.4301075
</td>
<td style="text-align:right;">
0.5881
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
144
</td>
<td style="text-align:right;">
1860
</td>
<td style="text-align:right;">
7.7419355
</td>
<td style="text-align:right;">
0.66870
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4412
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.980000
</td>
<td style="text-align:right;">
0.6306
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.733200
</td>
<td style="text-align:right;">
0.60110
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4982
</td>
<td style="text-align:right;">
0.4931
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.29870
</td>
<td style="text-align:right;">
0.8370
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.510100
</td>
<td style="text-align:right;">
0.6929
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4596
</td>
<td style="text-align:right;">
1925
</td>
<td style="text-align:right;">
1698
</td>
<td style="text-align:right;">
1372
</td>
<td style="text-align:right;">
4591
</td>
<td style="text-align:right;">
29.88456
</td>
<td style="text-align:right;">
0.7781
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
244
</td>
<td style="text-align:right;">
2652
</td>
<td style="text-align:right;">
9.200603
</td>
<td style="text-align:right;">
0.8347
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
173
</td>
<td style="text-align:right;">
857
</td>
<td style="text-align:right;">
20.186698
</td>
<td style="text-align:right;">
0.15430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
314
</td>
<td style="text-align:right;">
841
</td>
<td style="text-align:right;">
37.33650
</td>
<td style="text-align:right;">
0.21580
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
487
</td>
<td style="text-align:right;">
1698
</td>
<td style="text-align:right;">
28.68080
</td>
<td style="text-align:right;">
0.205800
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
2968
</td>
<td style="text-align:right;">
11.084906
</td>
<td style="text-align:right;">
0.54380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
851
</td>
<td style="text-align:right;">
4533
</td>
<td style="text-align:right;">
18.773439
</td>
<td style="text-align:right;">
0.96420
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
366
</td>
<td style="text-align:right;">
7.9634465
</td>
<td style="text-align:right;">
0.13400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
22.41079
</td>
<td style="text-align:right;">
0.5367
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
416
</td>
<td style="text-align:right;">
3503.000
</td>
<td style="text-align:right;">
11.875535
</td>
<td style="text-align:right;">
0.412100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
383
</td>
<td style="text-align:right;">
1001.000
</td>
<td style="text-align:right;">
38.261738
</td>
<td style="text-align:right;">
0.9747
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
189
</td>
<td style="text-align:right;">
4158
</td>
<td style="text-align:right;">
4.5454545
</td>
<td style="text-align:right;">
0.50160
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2768
</td>
<td style="text-align:right;">
4596.000
</td>
<td style="text-align:right;">
60.22628
</td>
<td style="text-align:right;">
0.5606
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1925
</td>
<td style="text-align:right;">
621
</td>
<td style="text-align:right;">
32.259740
</td>
<td style="text-align:right;">
0.8439
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
9.090909
</td>
<td style="text-align:right;">
0.8354
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
1698
</td>
<td style="text-align:right;">
7.5971731
</td>
<td style="text-align:right;">
0.64450
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
1698.000
</td>
<td style="text-align:right;">
3.886926
</td>
<td style="text-align:right;">
0.4438
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
4596
</td>
<td style="text-align:right;">
0.7180157
</td>
<td style="text-align:right;">
0.6406
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.326600
</td>
<td style="text-align:right;">
0.7282
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.559100
</td>
<td style="text-align:right;">
0.51470
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5606
</td>
<td style="text-align:right;">
0.5556
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.40820
</td>
<td style="text-align:right;">
0.8630
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
9.854500
</td>
<td style="text-align:right;">
0.7420
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
Census Tract 8.02, Anchorage Municipality, Alaska
</td>
<td style="text-align:right;">
26412
</td>
<td style="text-align:right;">
126100
</td>
<td style="text-align:right;">
30241
</td>
<td style="text-align:right;">
141400
</td>
<td style="text-align:right;">
30637.92
</td>
<td style="text-align:right;">
146276
</td>
<td style="text-align:right;">
-396.92
</td>
<td style="text-align:right;">
-0.0129552
</td>
<td style="text-align:right;">
-4876
</td>
<td style="text-align:right;">
-0.0333342
</td>
<td style="text-align:right;">
153.74
</td>
<td style="text-align:right;">
179.71
</td>
<td style="text-align:left;">
Anchorage Municipality, Alaska
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:left;">
C1126
</td>
</tr>
</tbody>
</table>

</div>

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

## LIHTC Data

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
02050000100
</td>
<td style="text-align:left;">
02050
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Bethel Census Area
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
9481
</td>
<td style="text-align:right;">
2776
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
4499
</td>
<td style="text-align:right;">
9422
</td>
<td style="text-align:right;">
47.74995
</td>
<td style="text-align:right;">
0.9162
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
923
</td>
<td style="text-align:right;">
3537
</td>
<td style="text-align:right;">
26.095561
</td>
<td style="text-align:right;">
0.9936
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
1570
</td>
<td style="text-align:right;">
14.26752
</td>
<td style="text-align:right;">
0.010260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
557
</td>
<td style="text-align:right;">
6.283663
</td>
<td style="text-align:right;">
0.012980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
259
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
12.17677
</td>
<td style="text-align:right;">
0.003169
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1431
</td>
<td style="text-align:right;">
4685
</td>
<td style="text-align:right;">
30.544290
</td>
<td style="text-align:right;">
0.8055
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2901
</td>
<td style="text-align:right;">
9557
</td>
<td style="text-align:right;">
30.354714
</td>
<td style="text-align:right;">
0.89790
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
688
</td>
<td style="text-align:right;">
7.256619
</td>
<td style="text-align:right;">
0.24940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3678
</td>
<td style="text-align:right;">
38.79338
</td>
<td style="text-align:right;">
0.97710
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1085
</td>
<td style="text-align:right;">
5745
</td>
<td style="text-align:right;">
18.88599
</td>
<td style="text-align:right;">
0.8446
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
418
</td>
<td style="text-align:right;">
1677
</td>
<td style="text-align:right;">
24.92546
</td>
<td style="text-align:right;">
0.7894
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
771
</td>
<td style="text-align:right;">
8382
</td>
<td style="text-align:right;">
9.1982820
</td>
<td style="text-align:right;">
0.64930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9146
</td>
<td style="text-align:right;">
9481
</td>
<td style="text-align:right;">
96.46662
</td>
<td style="text-align:right;">
0.9412
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2776
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.1080692
</td>
<td style="text-align:right;">
0.18850
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
0.5043228
</td>
<td style="text-align:right;">
0.5274
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
992
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
46.638458
</td>
<td style="text-align:right;">
0.99440
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1814
</td>
<td style="text-align:right;">
2127
</td>
<td style="text-align:right;">
85.28444
</td>
<td style="text-align:right;">
0.9993
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9481
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.616369
</td>
<td style="text-align:right;">
0.7794
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.50980
</td>
<td style="text-align:right;">
0.9107
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9412
</td>
<td style="text-align:right;">
0.9315
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.08390
</td>
<td style="text-align:right;">
0.7535
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.15127
</td>
<td style="text-align:right;">
0.8587
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
10311
</td>
<td style="text-align:right;">
2692
</td>
<td style="text-align:right;">
2104
</td>
<td style="text-align:right;">
5779
</td>
<td style="text-align:right;">
10267
</td>
<td style="text-align:right;">
56.28713
</td>
<td style="text-align:right;">
0.9839
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
870
</td>
<td style="text-align:right;">
3667
</td>
<td style="text-align:right;">
23.725116
</td>
<td style="text-align:right;">
0.9967
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
232
</td>
<td style="text-align:right;">
1494
</td>
<td style="text-align:right;">
15.52878
</td>
<td style="text-align:right;">
0.05333
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
610
</td>
<td style="text-align:right;">
15.57377
</td>
<td style="text-align:right;">
0.02547
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
327
</td>
<td style="text-align:right;">
2104
</td>
<td style="text-align:right;">
15.54183
</td>
<td style="text-align:right;">
0.009597
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1228
</td>
<td style="text-align:right;">
5181
</td>
<td style="text-align:right;">
23.701988
</td>
<td style="text-align:right;">
0.78920
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1639
</td>
<td style="text-align:right;">
10294
</td>
<td style="text-align:right;">
15.921896
</td>
<td style="text-align:right;">
0.9319
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
812
</td>
<td style="text-align:right;">
7.875085
</td>
<td style="text-align:right;">
0.12960
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4008
</td>
<td style="text-align:right;">
38.87111
</td>
<td style="text-align:right;">
0.99260
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1259
</td>
<td style="text-align:right;">
6286.0000
</td>
<td style="text-align:right;">
20.028635
</td>
<td style="text-align:right;">
0.85600
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
483
</td>
<td style="text-align:right;">
1769.0000
</td>
<td style="text-align:right;">
27.30356
</td>
<td style="text-align:right;">
0.8759
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
9020
</td>
<td style="text-align:right;">
2.0842572
</td>
<td style="text-align:right;">
0.31690
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10181
</td>
<td style="text-align:right;">
10311.000
</td>
<td style="text-align:right;">
98.73921
</td>
<td style="text-align:right;">
0.9760
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2692
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.0371471
</td>
<td style="text-align:right;">
0.16590
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
31
</td>
<td style="text-align:right;">
1.1515602
</td>
<td style="text-align:right;">
0.6200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1024
</td>
<td style="text-align:right;">
2104
</td>
<td style="text-align:right;">
48.669201
</td>
<td style="text-align:right;">
0.9978
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1793
</td>
<td style="text-align:right;">
2104.0000
</td>
<td style="text-align:right;">
85.218631
</td>
<td style="text-align:right;">
0.9993
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
477
</td>
<td style="text-align:right;">
10311
</td>
<td style="text-align:right;">
4.6261274
</td>
<td style="text-align:right;">
0.9233
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.711297
</td>
<td style="text-align:right;">
0.8199
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.17100
</td>
<td style="text-align:right;">
0.82060
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.9760
</td>
<td style="text-align:right;">
0.9674
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.70630
</td>
<td style="text-align:right;">
0.9326
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.56460
</td>
<td style="text-align:right;">
0.9233
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
Census Tract 1, Bethel Census Area, Alaska
</td>
<td style="text-align:right;">
10580
</td>
<td style="text-align:right;">
106600
</td>
<td style="text-align:right;">
10671
</td>
<td style="text-align:right;">
52100
</td>
<td style="text-align:right;">
12272.80
</td>
<td style="text-align:right;">
123656
</td>
<td style="text-align:right;">
-1601.80
</td>
<td style="text-align:right;">
-0.1305163
</td>
<td style="text-align:right;">
-71556
</td>
<td style="text-align:right;">
-0.5786699
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
02050000300
</td>
<td style="text-align:left;">
02050
</td>
<td style="text-align:left;">
000300
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Bethel Census Area
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
1386
</td>
<td style="text-align:right;">
725
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
460
</td>
<td style="text-align:right;">
1383
</td>
<td style="text-align:right;">
33.26103
</td>
<td style="text-align:right;">
0.7628
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
118
</td>
<td style="text-align:right;">
596
</td>
<td style="text-align:right;">
19.798658
</td>
<td style="text-align:right;">
0.9694
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
308
</td>
<td style="text-align:right;">
12.33766
</td>
<td style="text-align:right;">
0.008283
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
7.633588
</td>
<td style="text-align:right;">
0.014190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
10.93394
</td>
<td style="text-align:right;">
0.002703
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
168
</td>
<td style="text-align:right;">
777
</td>
<td style="text-align:right;">
21.621622
</td>
<td style="text-align:right;">
0.7013
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
477
</td>
<td style="text-align:right;">
1475
</td>
<td style="text-align:right;">
32.338983
</td>
<td style="text-align:right;">
0.92130
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
160
</td>
<td style="text-align:right;">
11.544011
</td>
<td style="text-align:right;">
0.55680
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
33.47763
</td>
<td style="text-align:right;">
0.89380
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
122
</td>
<td style="text-align:right;">
955
</td>
<td style="text-align:right;">
12.77487
</td>
<td style="text-align:right;">
0.5244
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
318
</td>
<td style="text-align:right;">
31.13208
</td>
<td style="text-align:right;">
0.8947
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
1284
</td>
<td style="text-align:right;">
0.3115265
</td>
<td style="text-align:right;">
0.08126
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1161
</td>
<td style="text-align:right;">
1386
</td>
<td style="text-align:right;">
83.76623
</td>
<td style="text-align:right;">
0.8084
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
725
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1.1034483
</td>
<td style="text-align:right;">
0.6032
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
20.501139
</td>
<td style="text-align:right;">
0.89560
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
261
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
59.45330
</td>
<td style="text-align:right;">
0.9957
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1386
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.357503
</td>
<td style="text-align:right;">
0.7224
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.95096
</td>
<td style="text-align:right;">
0.7007
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8084
</td>
<td style="text-align:right;">
0.8000
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.96275
</td>
<td style="text-align:right;">
0.7006
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.07961
</td>
<td style="text-align:right;">
0.7498
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1404
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
597
</td>
<td style="text-align:right;">
1379
</td>
<td style="text-align:right;">
43.29224
</td>
<td style="text-align:right;">
0.9267
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
646
</td>
<td style="text-align:right;">
23.529412
</td>
<td style="text-align:right;">
0.9965
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
267
</td>
<td style="text-align:right;">
18.72659
</td>
<td style="text-align:right;">
0.11360
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
26.47059
</td>
<td style="text-align:right;">
0.08218
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
20.86721
</td>
<td style="text-align:right;">
0.046030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
794
</td>
<td style="text-align:right;">
18.765743
</td>
<td style="text-align:right;">
0.71930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
345
</td>
<td style="text-align:right;">
1404
</td>
<td style="text-align:right;">
24.572650
</td>
<td style="text-align:right;">
0.9915
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
115
</td>
<td style="text-align:right;">
8.190883
</td>
<td style="text-align:right;">
0.14420
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
484
</td>
<td style="text-align:right;">
34.47293
</td>
<td style="text-align:right;">
0.96900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
139
</td>
<td style="text-align:right;">
920.0005
</td>
<td style="text-align:right;">
15.108688
</td>
<td style="text-align:right;">
0.64470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
276.0002
</td>
<td style="text-align:right;">
32.24635
</td>
<td style="text-align:right;">
0.9371
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
1243
</td>
<td style="text-align:right;">
0.4827031
</td>
<td style="text-align:right;">
0.11630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1240
</td>
<td style="text-align:right;">
1404.000
</td>
<td style="text-align:right;">
88.31906
</td>
<td style="text-align:right;">
0.8327
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
742
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.08271
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1.2129380
</td>
<td style="text-align:right;">
0.6256
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
112
</td>
<td style="text-align:right;">
369
</td>
<td style="text-align:right;">
30.352304
</td>
<td style="text-align:right;">
0.9725
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
223
</td>
<td style="text-align:right;">
369.0005
</td>
<td style="text-align:right;">
60.433530
</td>
<td style="text-align:right;">
0.9961
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
1404
</td>
<td style="text-align:right;">
6.6951567
</td>
<td style="text-align:right;">
0.9478
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.680030
</td>
<td style="text-align:right;">
0.8126
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.81130
</td>
<td style="text-align:right;">
0.65190
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8327
</td>
<td style="text-align:right;">
0.8253
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.62471
</td>
<td style="text-align:right;">
0.9189
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
10.94874
</td>
<td style="text-align:right;">
0.8637
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
Census Tract 3, Bethel Census Area, Alaska
</td>
<td style="text-align:right;">
14778
</td>
<td style="text-align:right;">
197900
</td>
<td style="text-align:right;">
14646
</td>
<td style="text-align:right;">
160900
</td>
<td style="text-align:right;">
17142.48
</td>
<td style="text-align:right;">
229564
</td>
<td style="text-align:right;">
-2496.48
</td>
<td style="text-align:right;">
-0.1456312
</td>
<td style="text-align:right;">
-68664
</td>
<td style="text-align:right;">
-0.2991061
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
02070000100
</td>
<td style="text-align:left;">
02070
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Dillingham Census Area
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
2569
</td>
<td style="text-align:right;">
1354
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
1037
</td>
<td style="text-align:right;">
2565
</td>
<td style="text-align:right;">
40.42885
</td>
<td style="text-align:right;">
0.8513
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
236
</td>
<td style="text-align:right;">
853
</td>
<td style="text-align:right;">
27.667057
</td>
<td style="text-align:right;">
0.9954
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
398
</td>
<td style="text-align:right;">
17.08543
</td>
<td style="text-align:right;">
0.016280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
18.279570
</td>
<td style="text-align:right;">
0.034550
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
17.46575
</td>
<td style="text-align:right;">
0.006339
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
384
</td>
<td style="text-align:right;">
1303
</td>
<td style="text-align:right;">
29.470453
</td>
<td style="text-align:right;">
0.7955
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1140
</td>
<td style="text-align:right;">
2710
</td>
<td style="text-align:right;">
42.066421
</td>
<td style="text-align:right;">
0.98140
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
217
</td>
<td style="text-align:right;">
8.446867
</td>
<td style="text-align:right;">
0.33900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
940
</td>
<td style="text-align:right;">
36.59011
</td>
<td style="text-align:right;">
0.95310
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
311
</td>
<td style="text-align:right;">
1728
</td>
<td style="text-align:right;">
17.99769
</td>
<td style="text-align:right;">
0.8126
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
21.26697
</td>
<td style="text-align:right;">
0.7005
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
203
</td>
<td style="text-align:right;">
2363
</td>
<td style="text-align:right;">
8.5907744
</td>
<td style="text-align:right;">
0.63010
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2410
</td>
<td style="text-align:right;">
2569
</td>
<td style="text-align:right;">
93.81082
</td>
<td style="text-align:right;">
0.9081
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1354
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
1.0339734
</td>
<td style="text-align:right;">
0.5974
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
31.849315
</td>
<td style="text-align:right;">
0.96500
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
367
</td>
<td style="text-align:right;">
584
</td>
<td style="text-align:right;">
62.84247
</td>
<td style="text-align:right;">
0.9966
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2569
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.629939
</td>
<td style="text-align:right;">
0.7830
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3.43530
</td>
<td style="text-align:right;">
0.8919
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9081
</td>
<td style="text-align:right;">
0.8988
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.02725
</td>
<td style="text-align:right;">
0.7274
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
11.00059
</td>
<td style="text-align:right;">
0.8430
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
2801
</td>
<td style="text-align:right;">
1444
</td>
<td style="text-align:right;">
718
</td>
<td style="text-align:right;">
1191
</td>
<td style="text-align:right;">
2792
</td>
<td style="text-align:right;">
42.65759
</td>
<td style="text-align:right;">
0.9224
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
183
</td>
<td style="text-align:right;">
1059
</td>
<td style="text-align:right;">
17.280453
</td>
<td style="text-align:right;">
0.9849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
487
</td>
<td style="text-align:right;">
19.30185
</td>
<td style="text-align:right;">
0.12840
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
231
</td>
<td style="text-align:right;">
22.07792
</td>
<td style="text-align:right;">
0.05382
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
145
</td>
<td style="text-align:right;">
718
</td>
<td style="text-align:right;">
20.19499
</td>
<td style="text-align:right;">
0.039410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
265
</td>
<td style="text-align:right;">
1619
</td>
<td style="text-align:right;">
16.368129
</td>
<td style="text-align:right;">
0.67640
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
552
</td>
<td style="text-align:right;">
2801
</td>
<td style="text-align:right;">
19.707247
</td>
<td style="text-align:right;">
0.9721
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
353
</td>
<td style="text-align:right;">
12.602642
</td>
<td style="text-align:right;">
0.39670
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
862
</td>
<td style="text-align:right;">
30.77472
</td>
<td style="text-align:right;">
0.91140
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
1939.1327
</td>
<td style="text-align:right;">
15.212986
</td>
<td style="text-align:right;">
0.65170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
579.0000
</td>
<td style="text-align:right;">
34.54231
</td>
<td style="text-align:right;">
0.9555
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
2513
</td>
<td style="text-align:right;">
1.9498607
</td>
<td style="text-align:right;">
0.30380
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2536
</td>
<td style="text-align:right;">
2801.124
</td>
<td style="text-align:right;">
90.53509
</td>
<td style="text-align:right;">
0.8619
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1444
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.0692521
</td>
<td style="text-align:right;">
0.16740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0.6925208
</td>
<td style="text-align:right;">
0.5747
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
255
</td>
<td style="text-align:right;">
718
</td>
<td style="text-align:right;">
35.515320
</td>
<td style="text-align:right;">
0.9868
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
718.0000
</td>
<td style="text-align:right;">
66.991643
</td>
<td style="text-align:right;">
0.9972
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
2801
</td>
<td style="text-align:right;">
8.2113531
</td>
<td style="text-align:right;">
0.9566
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.595210
</td>
<td style="text-align:right;">
0.7924
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.21910
</td>
<td style="text-align:right;">
0.83820
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8619
</td>
<td style="text-align:right;">
0.8543
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.68270
</td>
<td style="text-align:right;">
0.9288
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.35891
</td>
<td style="text-align:right;">
0.9048
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
Census Tract 1, Dillingham Census Area, Alaska
</td>
<td style="text-align:right;">
10750
</td>
<td style="text-align:right;">
113500
</td>
<td style="text-align:right;">
17367
</td>
<td style="text-align:right;">
85900
</td>
<td style="text-align:right;">
12470.00
</td>
<td style="text-align:right;">
131660
</td>
<td style="text-align:right;">
4897.00
</td>
<td style="text-align:right;">
0.3927025
</td>
<td style="text-align:right;">
-45760
</td>
<td style="text-align:right;">
-0.3475619
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
02122000100
</td>
<td style="text-align:left;">
02122
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Kenai Peninsula Borough
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
251
</td>
<td style="text-align:right;">
428
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
35.85657
</td>
<td style="text-align:right;">
0.7982
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
145
</td>
<td style="text-align:right;">
20.000000
</td>
<td style="text-align:right;">
0.9707
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
60.00000
</td>
<td style="text-align:right;">
0.930300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.005509
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
39.13043
</td>
<td style="text-align:right;">
0.301700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
11.290323
</td>
<td style="text-align:right;">
0.4631
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
198
</td>
<td style="text-align:right;">
460
</td>
<td style="text-align:right;">
43.043478
</td>
<td style="text-align:right;">
0.98470
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
2.390438
</td>
<td style="text-align:right;">
0.02129
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
24.30279
</td>
<td style="text-align:right;">
0.49430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
395
</td>
<td style="text-align:right;">
14.17722
</td>
<td style="text-align:right;">
0.6201
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
31.57895
</td>
<td style="text-align:right;">
0.8999
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
233
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02799
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
205
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
81.67331
</td>
<td style="text-align:right;">
0.7907
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
428
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
4.6728972
</td>
<td style="text-align:right;">
0.7396
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
5.072464
</td>
<td style="text-align:right;">
0.57090
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
138
</td>
<td style="text-align:right;">
12.31884
</td>
<td style="text-align:right;">
0.8207
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
251
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.518400
</td>
<td style="text-align:right;">
0.7575
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.06358
</td>
<td style="text-align:right;">
0.2722
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7907
</td>
<td style="text-align:right;">
0.7826
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.59945
</td>
<td style="text-align:right;">
0.5334
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.97213
</td>
<td style="text-align:right;">
0.6292
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
307
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
523
</td>
<td style="text-align:right;">
36.90249
</td>
<td style="text-align:right;">
0.8743
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
74
</td>
<td style="text-align:right;">
324
</td>
<td style="text-align:right;">
22.839506
</td>
<td style="text-align:right;">
0.9958
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
25.00000
</td>
<td style="text-align:right;">
0.32780
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
10.25641
</td>
<td style="text-align:right;">
0.01129
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
131
</td>
<td style="text-align:right;">
20.61069
</td>
<td style="text-align:right;">
0.043330
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
389
</td>
<td style="text-align:right;">
1.542417
</td>
<td style="text-align:right;">
0.05899
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
220
</td>
<td style="text-align:right;">
523
</td>
<td style="text-align:right;">
42.065010
</td>
<td style="text-align:right;">
0.9998
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
2.259887
</td>
<td style="text-align:right;">
0.01198
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
20.90395
</td>
<td style="text-align:right;">
0.43940
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
412.0000
</td>
<td style="text-align:right;">
12.135924
</td>
<td style="text-align:right;">
0.43280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
72.0000
</td>
<td style="text-align:right;">
31.94445
</td>
<td style="text-align:right;">
0.9342
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
512
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02391
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
437
</td>
<td style="text-align:right;">
531.000
</td>
<td style="text-align:right;">
82.29756
</td>
<td style="text-align:right;">
0.7611
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
307
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.08271
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
5.2117264
</td>
<td style="text-align:right;">
0.7700
</td>
<td style="text-align:right;">
1
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
0.6735
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
131.0000
</td>
<td style="text-align:right;">
32.061070
</td>
<td style="text-align:right;">
0.9796
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
20.9039548
</td>
<td style="text-align:right;">
0.9772
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.972220
</td>
<td style="text-align:right;">
0.6420
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
1.84229
</td>
<td style="text-align:right;">
0.16030
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.7611
</td>
<td style="text-align:right;">
0.7544
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.48301
</td>
<td style="text-align:right;">
0.8841
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
9.05862
</td>
<td style="text-align:right;">
0.6447
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
Census Tract 1, Kenai Peninsula Borough, Alaska
</td>
<td style="text-align:right;">
22885
</td>
<td style="text-align:right;">
515600
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
32200
</td>
<td style="text-align:right;">
26546.60
</td>
<td style="text-align:right;">
598096
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
-565896
</td>
<td style="text-align:right;">
-0.9461625
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
02180000100
</td>
<td style="text-align:left;">
02180
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Nome Census Area
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
5766
</td>
<td style="text-align:right;">
2016
</td>
<td style="text-align:right;">
1373
</td>
<td style="text-align:right;">
3052
</td>
<td style="text-align:right;">
5552
</td>
<td style="text-align:right;">
54.97118
</td>
<td style="text-align:right;">
0.9552
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
519
</td>
<td style="text-align:right;">
2134
</td>
<td style="text-align:right;">
24.320525
</td>
<td style="text-align:right;">
0.9899
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
852
</td>
<td style="text-align:right;">
26.29108
</td>
<td style="text-align:right;">
0.095960
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
521
</td>
<td style="text-align:right;">
18.042227
</td>
<td style="text-align:right;">
0.033620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
318
</td>
<td style="text-align:right;">
1373
</td>
<td style="text-align:right;">
23.16096
</td>
<td style="text-align:right;">
0.021070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
580
</td>
<td style="text-align:right;">
2709
</td>
<td style="text-align:right;">
21.410114
</td>
<td style="text-align:right;">
0.6970
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1988
</td>
<td style="text-align:right;">
5811
</td>
<td style="text-align:right;">
34.210979
</td>
<td style="text-align:right;">
0.93800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
299
</td>
<td style="text-align:right;">
5.185571
</td>
<td style="text-align:right;">
0.11630
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2214
</td>
<td style="text-align:right;">
38.39750
</td>
<td style="text-align:right;">
0.97400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
580
</td>
<td style="text-align:right;">
3550
</td>
<td style="text-align:right;">
16.33803
</td>
<td style="text-align:right;">
0.7460
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
1083
</td>
<td style="text-align:right;">
40.53555
</td>
<td style="text-align:right;">
0.9715
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
5090
</td>
<td style="text-align:right;">
1.8664047
</td>
<td style="text-align:right;">
0.26950
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5430
</td>
<td style="text-align:right;">
5766
</td>
<td style="text-align:right;">
94.17274
</td>
<td style="text-align:right;">
0.9125
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2016
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
0.7440476
</td>
<td style="text-align:right;">
0.22730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
1.3392857
</td>
<td style="text-align:right;">
0.6231
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
495
</td>
<td style="text-align:right;">
1373
</td>
<td style="text-align:right;">
36.052440
</td>
<td style="text-align:right;">
0.97870
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1167
</td>
<td style="text-align:right;">
1373
</td>
<td style="text-align:right;">
84.99636
</td>
<td style="text-align:right;">
0.9991
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
187
</td>
<td style="text-align:right;">
5766
</td>
<td style="text-align:right;">
3.243149
</td>
<td style="text-align:right;">
0.8747
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.601170
</td>
<td style="text-align:right;">
0.7768
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.07730
</td>
<td style="text-align:right;">
0.7608
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9125
</td>
<td style="text-align:right;">
0.9031
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.70290
</td>
<td style="text-align:right;">
0.9385
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.29387
</td>
<td style="text-align:right;">
0.8751
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
5901
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
1441
</td>
<td style="text-align:right;">
2939
</td>
<td style="text-align:right;">
5789
</td>
<td style="text-align:right;">
50.76870
</td>
<td style="text-align:right;">
0.9667
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
554
</td>
<td style="text-align:right;">
2224
</td>
<td style="text-align:right;">
24.910072
</td>
<td style="text-align:right;">
0.9980
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
1047
</td>
<td style="text-align:right;">
22.63610
</td>
<td style="text-align:right;">
0.23610
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
394
</td>
<td style="text-align:right;">
14.21320
</td>
<td style="text-align:right;">
0.02099
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
293
</td>
<td style="text-align:right;">
1441
</td>
<td style="text-align:right;">
20.33310
</td>
<td style="text-align:right;">
0.040350
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
586
</td>
<td style="text-align:right;">
2969
</td>
<td style="text-align:right;">
19.737285
</td>
<td style="text-align:right;">
0.73470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1202
</td>
<td style="text-align:right;">
5852
</td>
<td style="text-align:right;">
20.539986
</td>
<td style="text-align:right;">
0.9780
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
469
</td>
<td style="text-align:right;">
7.947806
</td>
<td style="text-align:right;">
0.13320
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2245
</td>
<td style="text-align:right;">
38.04440
</td>
<td style="text-align:right;">
0.99060
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
590
</td>
<td style="text-align:right;">
3606.9999
</td>
<td style="text-align:right;">
16.357084
</td>
<td style="text-align:right;">
0.71430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
532
</td>
<td style="text-align:right;">
1175.0000
</td>
<td style="text-align:right;">
45.27660
</td>
<td style="text-align:right;">
0.9916
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
5296
</td>
<td style="text-align:right;">
3.0400302
</td>
<td style="text-align:right;">
0.39890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5578
</td>
<td style="text-align:right;">
5901.000
</td>
<td style="text-align:right;">
94.52635
</td>
<td style="text-align:right;">
0.9154
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2111
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
0.2842255
</td>
<td style="text-align:right;">
0.17600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
1.0895310
</td>
<td style="text-align:right;">
0.6155
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
602
</td>
<td style="text-align:right;">
1441
</td>
<td style="text-align:right;">
41.776544
</td>
<td style="text-align:right;">
0.9943
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1240
</td>
<td style="text-align:right;">
1441.0000
</td>
<td style="text-align:right;">
86.051353
</td>
<td style="text-align:right;">
0.9993
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
351
</td>
<td style="text-align:right;">
5901
</td>
<td style="text-align:right;">
5.9481444
</td>
<td style="text-align:right;">
0.9413
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.717750
</td>
<td style="text-align:right;">
0.8217
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.22860
</td>
<td style="text-align:right;">
0.84100
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.9154
</td>
<td style="text-align:right;">
0.9073
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.72640
</td>
<td style="text-align:right;">
0.9367
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.58815
</td>
<td style="text-align:right;">
0.9255
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
Census Tract 1, Nome Census Area, Alaska
</td>
<td style="text-align:right;">
11287
</td>
<td style="text-align:right;">
103000
</td>
<td style="text-align:right;">
15051
</td>
<td style="text-align:right;">
88100
</td>
<td style="text-align:right;">
13092.92
</td>
<td style="text-align:right;">
119480
</td>
<td style="text-align:right;">
1958.08
</td>
<td style="text-align:right;">
0.1495526
</td>
<td style="text-align:right;">
-31380
</td>
<td style="text-align:right;">
-0.2626381
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
02290000100
</td>
<td style="text-align:left;">
02290
</td>
<td style="text-align:left;">
000100
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Yukon-Koyukuk Census Area
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
1127
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
482
</td>
<td style="text-align:right;">
1127
</td>
<td style="text-align:right;">
42.76841
</td>
<td style="text-align:right;">
0.8749
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
165
</td>
<td style="text-align:right;">
551
</td>
<td style="text-align:right;">
29.945553
</td>
<td style="text-align:right;">
0.9970
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
104
</td>
<td style="text-align:right;">
386
</td>
<td style="text-align:right;">
26.94301
</td>
<td style="text-align:right;">
0.106600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
129
</td>
<td style="text-align:right;">
12.403101
</td>
<td style="text-align:right;">
0.019980
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
120
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
23.30097
</td>
<td style="text-align:right;">
0.022180
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
216
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
29.711142
</td>
<td style="text-align:right;">
0.7981
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
492
</td>
<td style="text-align:right;">
1121
</td>
<td style="text-align:right;">
43.889384
</td>
<td style="text-align:right;">
0.98650
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
5.767524
</td>
<td style="text-align:right;">
0.14900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
29.19255
</td>
<td style="text-align:right;">
0.74620
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
825
</td>
<td style="text-align:right;">
23.39394
</td>
<td style="text-align:right;">
0.9394
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
247
</td>
<td style="text-align:right;">
34.41296
</td>
<td style="text-align:right;">
0.9316
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
1049
</td>
<td style="text-align:right;">
1.2392755
</td>
<td style="text-align:right;">
0.20170
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
960
</td>
<td style="text-align:right;">
1127
</td>
<td style="text-align:right;">
85.18190
</td>
<td style="text-align:right;">
0.8206
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
969
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
3.0959752
</td>
<td style="text-align:right;">
0.7027
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
16.116505
</td>
<td style="text-align:right;">
0.84800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
333
</td>
<td style="text-align:right;">
515
</td>
<td style="text-align:right;">
64.66019
</td>
<td style="text-align:right;">
0.9969
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1127
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.678680
</td>
<td style="text-align:right;">
0.7918
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2.96790
</td>
<td style="text-align:right;">
0.7088
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8206
</td>
<td style="text-align:right;">
0.8122
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.01585
</td>
<td style="text-align:right;">
0.7215
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.48303
</td>
<td style="text-align:right;">
0.7894
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
1118
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
516
</td>
<td style="text-align:right;">
1097
</td>
<td style="text-align:right;">
47.03737
</td>
<td style="text-align:right;">
0.9495
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
463
</td>
<td style="text-align:right;">
20.302376
</td>
<td style="text-align:right;">
0.9929
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
346
</td>
<td style="text-align:right;">
19.65318
</td>
<td style="text-align:right;">
0.13910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
22.22222
</td>
<td style="text-align:right;">
0.05448
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
20.22472
</td>
<td style="text-align:right;">
0.039600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
125
</td>
<td style="text-align:right;">
703
</td>
<td style="text-align:right;">
17.780939
</td>
<td style="text-align:right;">
0.70070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
161
</td>
<td style="text-align:right;">
1099
</td>
<td style="text-align:right;">
14.649681
</td>
<td style="text-align:right;">
0.9100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
159
</td>
<td style="text-align:right;">
14.221825
</td>
<td style="text-align:right;">
0.49590
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
338
</td>
<td style="text-align:right;">
30.23256
</td>
<td style="text-align:right;">
0.89890
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
158
</td>
<td style="text-align:right;">
761.0000
</td>
<td style="text-align:right;">
20.762155
</td>
<td style="text-align:right;">
0.87640
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
218.0000
</td>
<td style="text-align:right;">
40.36697
</td>
<td style="text-align:right;">
0.9809
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1038
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02391
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
1118.000
</td>
<td style="text-align:right;">
89.53488
</td>
<td style="text-align:right;">
0.8480
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.08271
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
1.6504854
</td>
<td style="text-align:right;">
0.6556
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
445
</td>
<td style="text-align:right;">
17.078652
</td>
<td style="text-align:right;">
0.8684
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
274
</td>
<td style="text-align:right;">
445.0000
</td>
<td style="text-align:right;">
61.573034
</td>
<td style="text-align:right;">
0.9965
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
1118
</td>
<td style="text-align:right;">
5.1878354
</td>
<td style="text-align:right;">
0.9330
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.592700
</td>
<td style="text-align:right;">
0.7918
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.27601
</td>
<td style="text-align:right;">
0.85820
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.8480
</td>
<td style="text-align:right;">
0.8405
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.53621
</td>
<td style="text-align:right;">
0.8979
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
11.25292
</td>
<td style="text-align:right;">
0.8955
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
Census Tract 1, Yukon-Koyukuk Census Area, Alaska
</td>
<td style="text-align:right;">
14127
</td>
<td style="text-align:right;">
91000
</td>
<td style="text-align:right;">
16500
</td>
<td style="text-align:right;">
88100
</td>
<td style="text-align:right;">
16387.32
</td>
<td style="text-align:right;">
105560
</td>
<td style="text-align:right;">
112.68
</td>
<td style="text-align:right;">
0.0068760
</td>
<td style="text-align:right;">
-17460
</td>
<td style="text-align:right;">
-0.1654036
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
02290000400
</td>
<td style="text-align:left;">
02290
</td>
<td style="text-align:left;">
000400
</td>
<td style="text-align:left;">
AK
</td>
<td style="text-align:left;">
Alaska
</td>
<td style="text-align:left;">
Yukon-Koyukuk Census Area
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
1173
</td>
<td style="text-align:right;">
751
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
1156
</td>
<td style="text-align:right;">
49.56747
</td>
<td style="text-align:right;">
0.9275
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
509
</td>
<td style="text-align:right;">
20.825147
</td>
<td style="text-align:right;">
0.9770
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
228
</td>
<td style="text-align:right;">
15.35088
</td>
<td style="text-align:right;">
0.012330
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
149
</td>
<td style="text-align:right;">
17.449664
</td>
<td style="text-align:right;">
0.031190
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
16.18037
</td>
<td style="text-align:right;">
0.005034
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
646
</td>
<td style="text-align:right;">
17.647059
</td>
<td style="text-align:right;">
0.6307
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
419
</td>
<td style="text-align:right;">
1005
</td>
<td style="text-align:right;">
41.691542
</td>
<td style="text-align:right;">
0.97960
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
8.610401
</td>
<td style="text-align:right;">
0.35070
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
362
</td>
<td style="text-align:right;">
30.86104
</td>
<td style="text-align:right;">
0.81090
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
696
</td>
<td style="text-align:right;">
15.66092
</td>
<td style="text-align:right;">
0.7109
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
34.78261
</td>
<td style="text-align:right;">
0.9347
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1039
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02799
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
995
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
84.82523
</td>
<td style="text-align:right;">
0.8172
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
751
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.09395
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
2.3968043
</td>
<td style="text-align:right;">
0.6773
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
14.058355
</td>
<td style="text-align:right;">
0.81990
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
208
</td>
<td style="text-align:right;">
377
</td>
<td style="text-align:right;">
55.17241
</td>
<td style="text-align:right;">
0.9947
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1173
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.519834
</td>
<td style="text-align:right;">
0.7583
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2.83519
</td>
<td style="text-align:right;">
0.6497
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.8172
</td>
<td style="text-align:right;">
0.8088
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.96015
</td>
<td style="text-align:right;">
0.6987
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.13237
</td>
<td style="text-align:right;">
0.7552
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
1035
</td>
<td style="text-align:right;">
823
</td>
<td style="text-align:right;">
394
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
1030
</td>
<td style="text-align:right;">
42.91262
</td>
<td style="text-align:right;">
0.9240
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
76
</td>
<td style="text-align:right;">
481
</td>
<td style="text-align:right;">
15.800416
</td>
<td style="text-align:right;">
0.9754
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
292
</td>
<td style="text-align:right;">
22.60274
</td>
<td style="text-align:right;">
0.23430
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
102
</td>
<td style="text-align:right;">
20.58824
</td>
<td style="text-align:right;">
0.04701
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
87
</td>
<td style="text-align:right;">
394
</td>
<td style="text-align:right;">
22.08122
</td>
<td style="text-align:right;">
0.063080
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
653
</td>
<td style="text-align:right;">
13.476263
</td>
<td style="text-align:right;">
0.61280
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
291
</td>
<td style="text-align:right;">
1032
</td>
<td style="text-align:right;">
28.197674
</td>
<td style="text-align:right;">
0.9971
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
141
</td>
<td style="text-align:right;">
13.623188
</td>
<td style="text-align:right;">
0.45900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
295
</td>
<td style="text-align:right;">
28.50242
</td>
<td style="text-align:right;">
0.84980
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
184
</td>
<td style="text-align:right;">
736.9996
</td>
<td style="text-align:right;">
24.966091
</td>
<td style="text-align:right;">
0.94930
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
214.9998
</td>
<td style="text-align:right;">
33.02329
</td>
<td style="text-align:right;">
0.9430
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
949
</td>
<td style="text-align:right;">
0.2107482
</td>
<td style="text-align:right;">
0.07122
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
904
</td>
<td style="text-align:right;">
1035.000
</td>
<td style="text-align:right;">
87.34303
</td>
<td style="text-align:right;">
0.8185
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
823
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.2430134
</td>
<td style="text-align:right;">
0.17400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.3645200
</td>
<td style="text-align:right;">
0.5127
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
394
</td>
<td style="text-align:right;">
10.406091
</td>
<td style="text-align:right;">
0.7362
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
259
</td>
<td style="text-align:right;">
393.9995
</td>
<td style="text-align:right;">
65.736117
</td>
<td style="text-align:right;">
0.9969
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
1035
</td>
<td style="text-align:right;">
2.3188406
</td>
<td style="text-align:right;">
0.8486
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.572380
</td>
<td style="text-align:right;">
0.7884
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
3.27232
</td>
<td style="text-align:right;">
0.85640
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
0.8185
</td>
<td style="text-align:right;">
0.8113
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
3.26840
</td>
<td style="text-align:right;">
0.8181
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
10.93160
</td>
<td style="text-align:right;">
0.8621
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
Census Tract 4, Yukon-Koyukuk Census Area, Alaska
</td>
<td style="text-align:right;">
14207
</td>
<td style="text-align:right;">
92900
</td>
<td style="text-align:right;">
15492
</td>
<td style="text-align:right;">
55600
</td>
<td style="text-align:right;">
16480.12
</td>
<td style="text-align:right;">
107764
</td>
<td style="text-align:right;">
-988.12
</td>
<td style="text-align:right;">
-0.0599583
</td>
<td style="text-align:right;">
-52164
</td>
<td style="text-align:right;">
-0.4840578
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
06001400700
</td>
<td style="text-align:left;">
06001
</td>
<td style="text-align:left;">
400700
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Alameda County
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
3942
</td>
<td style="text-align:right;">
2009
</td>
<td style="text-align:right;">
1706
</td>
<td style="text-align:right;">
1186
</td>
<td style="text-align:right;">
3942
</td>
<td style="text-align:right;">
30.08625
</td>
<td style="text-align:right;">
0.7161
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
191
</td>
<td style="text-align:right;">
1969
</td>
<td style="text-align:right;">
9.700356
</td>
<td style="text-align:right;">
0.6400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
298
</td>
<td style="text-align:right;">
607
</td>
<td style="text-align:right;">
49.09390
</td>
<td style="text-align:right;">
0.760800
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
658
</td>
<td style="text-align:right;">
1099
</td>
<td style="text-align:right;">
59.872611
</td>
<td style="text-align:right;">
0.748900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
956
</td>
<td style="text-align:right;">
1706
</td>
<td style="text-align:right;">
56.03751
</td>
<td style="text-align:right;">
0.847400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
380
</td>
<td style="text-align:right;">
2787
</td>
<td style="text-align:right;">
13.634733
</td>
<td style="text-align:right;">
0.5333
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
546
</td>
<td style="text-align:right;">
3779
</td>
<td style="text-align:right;">
14.448267
</td>
<td style="text-align:right;">
0.47150
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
451
</td>
<td style="text-align:right;">
11.440893
</td>
<td style="text-align:right;">
0.55060
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
692
</td>
<td style="text-align:right;">
17.55454
</td>
<td style="text-align:right;">
0.17100
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
707
</td>
<td style="text-align:right;">
3177
</td>
<td style="text-align:right;">
22.25370
</td>
<td style="text-align:right;">
0.9237
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
186
</td>
<td style="text-align:right;">
688
</td>
<td style="text-align:right;">
27.03488
</td>
<td style="text-align:right;">
0.8296
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
3664
</td>
<td style="text-align:right;">
2.7292576
</td>
<td style="text-align:right;">
0.34520
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2542
</td>
<td style="text-align:right;">
3942
</td>
<td style="text-align:right;">
64.48503
</td>
<td style="text-align:right;">
0.6485
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2009
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
3.8825286
</td>
<td style="text-align:right;">
0.39170
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
1706
</td>
<td style="text-align:right;">
1.465416
</td>
<td style="text-align:right;">
0.27860
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
1706
</td>
<td style="text-align:right;">
19.28488
</td>
<td style="text-align:right;">
0.9224
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3942
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.208300
</td>
<td style="text-align:right;">
0.6849
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.82010
</td>
<td style="text-align:right;">
0.6426
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6485
</td>
<td style="text-align:right;">
0.6419
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.21670
</td>
<td style="text-align:right;">
0.3596
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.89360
</td>
<td style="text-align:right;">
0.6187
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
5127
</td>
<td style="text-align:right;">
2037
</td>
<td style="text-align:right;">
1926
</td>
<td style="text-align:right;">
1155
</td>
<td style="text-align:right;">
5110
</td>
<td style="text-align:right;">
22.60274
</td>
<td style="text-align:right;">
0.6384
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
209
</td>
<td style="text-align:right;">
3522
</td>
<td style="text-align:right;">
5.934128
</td>
<td style="text-align:right;">
0.5700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
248
</td>
<td style="text-align:right;">
677
</td>
<td style="text-align:right;">
36.63220
</td>
<td style="text-align:right;">
0.77480
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
442
</td>
<td style="text-align:right;">
1248
</td>
<td style="text-align:right;">
35.41667
</td>
<td style="text-align:right;">
0.18340
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
690
</td>
<td style="text-align:right;">
1925
</td>
<td style="text-align:right;">
35.84416
</td>
<td style="text-align:right;">
0.439200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
200
</td>
<td style="text-align:right;">
3980
</td>
<td style="text-align:right;">
5.025126
</td>
<td style="text-align:right;">
0.26040
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
5123
</td>
<td style="text-align:right;">
9.018153
</td>
<td style="text-align:right;">
0.7215
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
478
</td>
<td style="text-align:right;">
9.323191
</td>
<td style="text-align:right;">
0.20110
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
957
</td>
<td style="text-align:right;">
18.66589
</td>
<td style="text-align:right;">
0.30330
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
573
</td>
<td style="text-align:right;">
4166.1857
</td>
<td style="text-align:right;">
13.753588
</td>
<td style="text-align:right;">
0.55250
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
224
</td>
<td style="text-align:right;">
873.8465
</td>
<td style="text-align:right;">
25.63379
</td>
<td style="text-align:right;">
0.8488
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
188
</td>
<td style="text-align:right;">
4819
</td>
<td style="text-align:right;">
3.9012243
</td>
<td style="text-align:right;">
0.46260
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2892
</td>
<td style="text-align:right;">
5126.788
</td>
<td style="text-align:right;">
56.40959
</td>
<td style="text-align:right;">
0.5263
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2037
</td>
<td style="text-align:right;">
177
</td>
<td style="text-align:right;">
8.6892489
</td>
<td style="text-align:right;">
0.51730
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
109
</td>
<td style="text-align:right;">
1926
</td>
<td style="text-align:right;">
5.659398
</td>
<td style="text-align:right;">
0.5535
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
249
</td>
<td style="text-align:right;">
1925.6234
</td>
<td style="text-align:right;">
12.930878
</td>
<td style="text-align:right;">
0.8598
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
5127
</td>
<td style="text-align:right;">
0.4095963
</td>
<td style="text-align:right;">
0.5222
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.629500
</td>
<td style="text-align:right;">
0.5445
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.36830
</td>
<td style="text-align:right;">
0.40540
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.5263
</td>
<td style="text-align:right;">
0.5217
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.69940
</td>
<td style="text-align:right;">
0.5738
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
8.22350
</td>
<td style="text-align:right;">
0.5369
</td>
<td style="text-align:right;">
2
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
Census Tract 4007, Alameda County, California
</td>
<td style="text-align:right;">
25303
</td>
<td style="text-align:right;">
453500
</td>
<td style="text-align:right;">
38235
</td>
<td style="text-align:right;">
702500
</td>
<td style="text-align:right;">
29351.48
</td>
<td style="text-align:right;">
526060
</td>
<td style="text-align:right;">
8883.52
</td>
<td style="text-align:right;">
0.3026600
</td>
<td style="text-align:right;">
176440
</td>
<td style="text-align:right;">
0.3353990
</td>
<td style="text-align:right;">
350.20
</td>
<td style="text-align:right;">
784.95
</td>
<td style="text-align:left;">
Alameda County, California
</td>
<td style="text-align:left;">
San Jose-San Francisco-Oakland, CA CSA
</td>
<td style="text-align:left;">
CS488
</td>
</tr>
<tr>
<td style="text-align:left;">
06001400900
</td>
<td style="text-align:left;">
06001
</td>
<td style="text-align:left;">
400900
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Alameda County
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
2466
</td>
<td style="text-align:right;">
1196
</td>
<td style="text-align:right;">
1123
</td>
<td style="text-align:right;">
405
</td>
<td style="text-align:right;">
2466
</td>
<td style="text-align:right;">
16.42336
</td>
<td style="text-align:right;">
0.4185
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
101
</td>
<td style="text-align:right;">
1484
</td>
<td style="text-align:right;">
6.805930
</td>
<td style="text-align:right;">
0.3730
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
270
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
61.50342
</td>
<td style="text-align:right;">
0.943300
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
323
</td>
<td style="text-align:right;">
684
</td>
<td style="text-align:right;">
47.222222
</td>
<td style="text-align:right;">
0.410700
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
593
</td>
<td style="text-align:right;">
1123
</td>
<td style="text-align:right;">
52.80499
</td>
<td style="text-align:right;">
0.772400
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
240
</td>
<td style="text-align:right;">
1699
</td>
<td style="text-align:right;">
14.125956
</td>
<td style="text-align:right;">
0.5464
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
2275
</td>
<td style="text-align:right;">
4.395604
</td>
<td style="text-align:right;">
0.07064
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
258
</td>
<td style="text-align:right;">
10.462287
</td>
<td style="text-align:right;">
0.48400
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
439
</td>
<td style="text-align:right;">
17.80211
</td>
<td style="text-align:right;">
0.17720
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
409
</td>
<td style="text-align:right;">
1868
</td>
<td style="text-align:right;">
21.89507
</td>
<td style="text-align:right;">
0.9182
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
202
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
50.50000
</td>
<td style="text-align:right;">
0.9951
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2321
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.02799
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1495
</td>
<td style="text-align:right;">
2466
</td>
<td style="text-align:right;">
60.62449
</td>
<td style="text-align:right;">
0.6182
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1196
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
6.6889632
</td>
<td style="text-align:right;">
0.48380
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1123
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.05961
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
204
</td>
<td style="text-align:right;">
1123
</td>
<td style="text-align:right;">
18.16563
</td>
<td style="text-align:right;">
0.9113
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2466
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.180940
</td>
<td style="text-align:right;">
0.4177
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.60249
</td>
<td style="text-align:right;">
0.5376
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
0.6182
</td>
<td style="text-align:right;">
0.6119
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.07871
</td>
<td style="text-align:right;">
0.2993
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
7.48034
</td>
<td style="text-align:right;">
0.4369
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
2854
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
1101
</td>
<td style="text-align:right;">
410
</td>
<td style="text-align:right;">
2854
</td>
<td style="text-align:right;">
14.36580
</td>
<td style="text-align:right;">
0.4046
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
104
</td>
<td style="text-align:right;">
2043
</td>
<td style="text-align:right;">
5.090553
</td>
<td style="text-align:right;">
0.4664
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
404
</td>
<td style="text-align:right;">
38.36634
</td>
<td style="text-align:right;">
0.82100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
309
</td>
<td style="text-align:right;">
697
</td>
<td style="text-align:right;">
44.33286
</td>
<td style="text-align:right;">
0.36900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
464
</td>
<td style="text-align:right;">
1101
</td>
<td style="text-align:right;">
42.14351
</td>
<td style="text-align:right;">
0.653600
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
163
</td>
<td style="text-align:right;">
2053
</td>
<td style="text-align:right;">
7.939601
</td>
<td style="text-align:right;">
0.41660
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
197
</td>
<td style="text-align:right;">
2849
</td>
<td style="text-align:right;">
6.914707
</td>
<td style="text-align:right;">
0.5867
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
203
</td>
<td style="text-align:right;">
7.112824
</td>
<td style="text-align:right;">
0.09481
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
462
</td>
<td style="text-align:right;">
16.18781
</td>
<td style="text-align:right;">
0.18410
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
199
</td>
<td style="text-align:right;">
2387.8971
</td>
<td style="text-align:right;">
8.333693
</td>
<td style="text-align:right;">
0.15390
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
142
</td>
<td style="text-align:right;">
585.5745
</td>
<td style="text-align:right;">
24.24969
</td>
<td style="text-align:right;">
0.8226
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
181
</td>
<td style="text-align:right;">
2663
</td>
<td style="text-align:right;">
6.7968457
</td>
<td style="text-align:right;">
0.60790
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1875
</td>
<td style="text-align:right;">
2854.008
</td>
<td style="text-align:right;">
65.69709
</td>
<td style="text-align:right;">
0.6092
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1221
</td>
<td style="text-align:right;">
152
</td>
<td style="text-align:right;">
12.4488124
</td>
<td style="text-align:right;">
0.60240
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
1101
</td>
<td style="text-align:right;">
4.450500
</td>
<td style="text-align:right;">
0.4765
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
1101.4226
</td>
<td style="text-align:right;">
5.901459
</td>
<td style="text-align:right;">
0.6007
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2854
</td>
<td style="text-align:right;">
0.0000000
</td>
<td style="text-align:right;">
0.1370
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.527900
</td>
<td style="text-align:right;">
0.5132
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1.86331
</td>
<td style="text-align:right;">
0.16880
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.6092
</td>
<td style="text-align:right;">
0.6038
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.06320
</td>
<td style="text-align:right;">
0.2946
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7.06361
</td>
<td style="text-align:right;">
0.3731
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
Census Tract 4009, Alameda County, California
</td>
<td style="text-align:right;">
30185
</td>
<td style="text-align:right;">
470500
</td>
<td style="text-align:right;">
38375
</td>
<td style="text-align:right;">
774700
</td>
<td style="text-align:right;">
35014.60
</td>
<td style="text-align:right;">
545780
</td>
<td style="text-align:right;">
3360.40
</td>
<td style="text-align:right;">
0.0959714
</td>
<td style="text-align:right;">
228920
</td>
<td style="text-align:right;">
0.4194364
</td>
<td style="text-align:right;">
281.27
</td>
<td style="text-align:right;">
777.62
</td>
<td style="text-align:left;">
Alameda County, California
</td>
<td style="text-align:left;">
San Jose-San Francisco-Oakland, CA CSA
</td>
<td style="text-align:left;">
CS488
</td>
</tr>
<tr>
<td style="text-align:left;">
06001401100
</td>
<td style="text-align:left;">
06001
</td>
<td style="text-align:left;">
401100
</td>
<td style="text-align:left;">
CA
</td>
<td style="text-align:left;">
California
</td>
<td style="text-align:left;">
Alameda County
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
3738
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
2014
</td>
<td style="text-align:right;">
1244
</td>
<td style="text-align:right;">
3738
</td>
<td style="text-align:right;">
33.27983
</td>
<td style="text-align:right;">
0.7632
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
193
</td>
<td style="text-align:right;">
2527
</td>
<td style="text-align:right;">
7.637515
</td>
<td style="text-align:right;">
0.4589
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
230
</td>
<td style="text-align:right;">
400
</td>
<td style="text-align:right;">
57.50000
</td>
<td style="text-align:right;">
0.905100
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
927
</td>
<td style="text-align:right;">
1614
</td>
<td style="text-align:right;">
57.434944
</td>
<td style="text-align:right;">
0.685300
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1157
</td>
<td style="text-align:right;">
2014
</td>
<td style="text-align:right;">
57.44786
</td>
<td style="text-align:right;">
0.875900
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
275
</td>
<td style="text-align:right;">
2920
</td>
<td style="text-align:right;">
9.417808
</td>
<td style="text-align:right;">
0.3945
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
716
</td>
<td style="text-align:right;">
4313
</td>
<td style="text-align:right;">
16.600974
</td>
<td style="text-align:right;">
0.55910
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
237
</td>
<td style="text-align:right;">
6.340289
</td>
<td style="text-align:right;">
0.18740
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
420
</td>
<td style="text-align:right;">
11.23596
</td>
<td style="text-align:right;">
0.06016
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
392
</td>
<td style="text-align:right;">
3734
</td>
<td style="text-align:right;">
10.49813
</td>
<td style="text-align:right;">
0.3470
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
535
</td>
<td style="text-align:right;">
22.99065
</td>
<td style="text-align:right;">
0.7451
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
367
</td>
<td style="text-align:right;">
3574
</td>
<td style="text-align:right;">
10.2686066
</td>
<td style="text-align:right;">
0.67930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1979
</td>
<td style="text-align:right;">
3738
</td>
<td style="text-align:right;">
52.94275
</td>
<td style="text-align:right;">
0.5530
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2218
</td>
<td style="text-align:right;">
531
</td>
<td style="text-align:right;">
23.9404869
</td>
<td style="text-align:right;">
0.78650
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
0.2497
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
2014
</td>
<td style="text-align:right;">
0.347567
</td>
<td style="text-align:right;">
0.12930
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
567
</td>
<td style="text-align:right;">
2014
</td>
<td style="text-align:right;">
28.15293
</td>
<td style="text-align:right;">
0.9667
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3738
</td>
<td style="text-align:right;">
0.000000
</td>
<td style="text-align:right;">
0.3743
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.051600
</td>
<td style="text-align:right;">
0.6495
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
2.01896
</td>
<td style="text-align:right;">
0.2542
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0.5530
</td>
<td style="text-align:right;">
0.5473
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2.50650
</td>
<td style="text-align:right;">
0.4877
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
8.13006
</td>
<td style="text-align:right;">
0.5257
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4283
</td>
<td style="text-align:right;">
2222
</td>
<td style="text-align:right;">
2187
</td>
<td style="text-align:right;">
876
</td>
<td style="text-align:right;">
4283
</td>
<td style="text-align:right;">
20.45295
</td>
<td style="text-align:right;">
0.5868
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
194
</td>
<td style="text-align:right;">
3177
</td>
<td style="text-align:right;">
6.106390
</td>
<td style="text-align:right;">
0.5900
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
406
</td>
<td style="text-align:right;">
22.16749
</td>
<td style="text-align:right;">
0.21890
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
755
</td>
<td style="text-align:right;">
1781
</td>
<td style="text-align:right;">
42.39191
</td>
<td style="text-align:right;">
0.32490
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
845
</td>
<td style="text-align:right;">
2187
</td>
<td style="text-align:right;">
38.63740
</td>
<td style="text-align:right;">
0.538200
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
175
</td>
<td style="text-align:right;">
3482
</td>
<td style="text-align:right;">
5.025847
</td>
<td style="text-align:right;">
0.26060
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
454
</td>
<td style="text-align:right;">
4283
</td>
<td style="text-align:right;">
10.600047
</td>
<td style="text-align:right;">
0.7917
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
268
</td>
<td style="text-align:right;">
6.257296
</td>
<td style="text-align:right;">
0.06482
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
526
</td>
<td style="text-align:right;">
12.28111
</td>
<td style="text-align:right;">
0.08534
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
264
</td>
<td style="text-align:right;">
3757.5978
</td>
<td style="text-align:right;">
7.025765
</td>
<td style="text-align:right;">
0.08703
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
155
</td>
<td style="text-align:right;">
591.6622
</td>
<td style="text-align:right;">
26.19738
</td>
<td style="text-align:right;">
0.8596
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
4119
</td>
<td style="text-align:right;">
2.7676621
</td>
<td style="text-align:right;">
0.37920
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2054
</td>
<td style="text-align:right;">
4283.310
</td>
<td style="text-align:right;">
47.95357
</td>
<td style="text-align:right;">
0.4417
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
2222
</td>
<td style="text-align:right;">
991
</td>
<td style="text-align:right;">
44.5994599
</td>
<td style="text-align:right;">
0.90590
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
0.2466
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
2187
</td>
<td style="text-align:right;">
2.743484
</td>
<td style="text-align:right;">
0.3343
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
553
</td>
<td style="text-align:right;">
2186.6359
</td>
<td style="text-align:right;">
25.289990
</td>
<td style="text-align:right;">
0.9637
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
114
</td>
<td style="text-align:right;">
4283
</td>
<td style="text-align:right;">
2.6616857
</td>
<td style="text-align:right;">
0.8651
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2.767300
</td>
<td style="text-align:right;">
0.5836
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
1.47599
</td>
<td style="text-align:right;">
0.06543
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
0.4417
</td>
<td style="text-align:right;">
0.4378
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
3.31560
</td>
<td style="text-align:right;">
0.8335
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
8.00059
</td>
<td style="text-align:right;">
0.5035
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
1
</td>
<td style="text-align:right;">
1590984
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
Yes
</td>
<td style="text-align:left;">
Census Tract 4011, Alameda County, California
</td>
<td style="text-align:right;">
23516
</td>
<td style="text-align:right;">
526800
</td>
<td style="text-align:right;">
48058
</td>
<td style="text-align:right;">
889800
</td>
<td style="text-align:right;">
27278.56
</td>
<td style="text-align:right;">
611088
</td>
<td style="text-align:right;">
20779.44
</td>
<td style="text-align:right;">
0.7617499
</td>
<td style="text-align:right;">
278712
</td>
<td style="text-align:right;">
0.4560914
</td>
<td style="text-align:right;">
530.92
</td>
<td style="text-align:right;">
1038.24
</td>
<td style="text-align:left;">
Alameda County, California
</td>
<td style="text-align:left;">
San Jose-San Francisco-Oakland, CA CSA
</td>
<td style="text-align:left;">
CS488
</td>
</tr>
</tbody>
</table>

</div>

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

## Log NMTC and LIHTC Variables

## Diff-in-diff Models

The diff-in-diff model is useful for examining program impact when you
have observations from two points in time, before program introduction
and after. This type of model compares subsets of the population (i.e.,
those that participate versus those who do not) and measures the
difference in outcomes to assess effectiveness of the program. Since our
data contains two time periods (2010 and 2020) and data on
participation, we will use a diff-in-diff model to evaluate the
effectiveness of the NMTC and LIHTC prgrams.

## Dependent Variables: SVI Variables, House Price Index, Median Home Values, and Median Income

Our dependent variables for this model are the four categories of social
vulnerability according to the CDC’s SVI: socioeconomic status,
household characteristics, racial and ethnic minority status, and
housing type and transportation. Along with these SVI flags, we will
also look at the economic changes in census tracts including: median
home values, median income, and housing price index.

## Independent Variables: NMTC and LIHTC Data

The independent variables for this model are the NMTC and LIHTC
programs. Namely, we will be looking at if participation in these
programs has a statistically significant effect on reducing social
vulnerability.

### NMTC Evaluation

#### Divisional

    ## [1] 4237

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
02013000100
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
2
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
<tr>
<td style="text-align:left;">
02016000100
</td>
<td style="text-align:left;">
NA
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
2
</td>
<td style="text-align:right;">
4
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
02020000300
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:right;">
0
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
2
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
02020000400
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:right;">
2
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
4
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
02020000500
</td>
<td style="text-align:left;">
Anchorage, AK MSA
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
02020000701
</td>
<td style="text-align:left;">
Anchorage, AK MSA
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
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
</tbody>
</table>

</div>

    ## [1] 4237

    ## [1] 8474

#### Divisional Median Income

    ## [1] 4234

    ## [1] 4234

    ## [1] 8468

#### Divisional Median Home Value

    ## [1] 4074

    ## [1] 4074

    ## [1] 8148

#### Divisional House Price Index

    ## [1] 2829

    ## [1] 2829

    ## [1] 5658

## NMTC Divisional Diff-in-Diff Model

<table style="width:96%;">
<caption>Differences-in-Differences Linear Regression Analysis of NMTC
in Pacific Division</caption>
<colgroup>
<col style="width: 8%" />
<col style="width: 5%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 8%" />
<col style="width: 5%" />
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
<td>1.10***</td>
<td>1.88***</td>
<td>0.05</td>
<td>1.15***</td>
<td>4.18***</td>
<td>10.13***</td>
<td>11.89***</td>
<td>5.12***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.31)</td>
<td>(0.23)</td>
<td>(0.09)</td>
<td>(0.23)</td>
<td>(0.62)</td>
<td>(0.06)</td>
<td>(0.09)</td>
<td>(0.10)</td>
</tr>
<tr class="odd">
<td>treat</td>
<td>0.63***</td>
<td>0.24***</td>
<td>0.15***</td>
<td>0.40***</td>
<td>1.43***</td>
<td>-0.14***</td>
<td>-0.00</td>
<td>-0.04</td>
</tr>
<tr class="even">
<td></td>
<td>(0.10)</td>
<td>(0.07)</td>
<td>(0.03)</td>
<td>(0.07)</td>
<td>(0.20)</td>
<td>(0.02)</td>
<td>(0.03)</td>
<td>(0.04)</td>
</tr>
<tr class="odd">
<td>post</td>
<td>-0.06</td>
<td>-0.09***</td>
<td>0.00</td>
<td>-0.03</td>
<td>-0.17**</td>
<td>0.04***</td>
<td>-0.05***</td>
<td>0.65***</td>
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
<td>-0.05</td>
<td>-0.05</td>
<td>-0.01</td>
<td>-0.01</td>
<td>-0.12</td>
<td>0.06*</td>
<td>0.00</td>
<td>-0.02</td>
</tr>
<tr class="even">
<td></td>
<td>(0.14)</td>
<td>(0.10)</td>
<td>(0.04)</td>
<td>(0.10)</td>
<td>(0.28)</td>
<td>(0.03)</td>
<td>(0.04)</td>
<td>(0.05)</td>
</tr>
<tr class="odd">
<td>Num.Obs.</td>
<td>8240</td>
<td>8240</td>
<td>8240</td>
<td>8240</td>
<td>8240</td>
<td>8236</td>
<td>7916</td>
<td>5526</td>
</tr>
<tr class="even">
<td>R2</td>
<td>0.270</td>
<td>0.112</td>
<td>0.301</td>
<td>0.060</td>
<td>0.233</td>
<td>0.182</td>
<td>0.417</td>
<td>0.488</td>
</tr>
<tr class="odd">
<td>R2 Adj.</td>
<td>0.264</td>
<td>0.104</td>
<td>0.295</td>
<td>0.052</td>
<td>0.227</td>
<td>0.175</td>
<td>0.412</td>
<td>0.481</td>
</tr>
<tr class="even">
<td>RMSE</td>
<td>1.36</td>
<td>1.01</td>
<td>0.41</td>
<td>1.04</td>
<td>2.77</td>
<td>0.27</td>
<td>0.40</td>
<td>0.40</td>
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

Differences-in-Differences Linear Regression Analysis of NMTC in Pacific
Division

Examining the Divisional NMTC Model, there is no statistically
significant changes to any of the SVI categories under the NMTC program.
The only statistically significant change from 2010 to 2020 was the
economic outcome of Median Income. We can also see that the Pacific
Division is significantly more vulnerable in every category except for
racial and ethnic minorities.

Looking at the model for Median Income:

- The average number of flags for median income across census tracts who
  were eligible for the NMTC program was 10.12 (intercept) in 2010. This
  increased in 2020 by 0.04 (post) to 10.16.
- For census tracts that received tax credits from the NMTC program, the
  number of flags for median income vulnerability was 9.93 in 2010 and
  increased to 10.03 in 2020.

There are no visuals because none of the models are statistically
significant.

### LIHTC Evaluation

#### Divisional

    ## [1] 584

    ## [1] 584

    ## [1] 1168

#### Divisional Median Income

    ## [1] 583

    ## [1] 583

    ## [1] 1166

#### Divisional Median Home Value

    ## [1] 543

    ## [1] 543

    ## [1] 1086

#### Divisional House Price Index

    ## [1] 310

    ## [1] 310

    ## [1] 620

### LIHTC Divisional Model

<table style="width:96%;">
<caption>Differences-in-Differences Linear Regression Analysis of LIHTC
in Pacific Division</caption>
<colgroup>
<col style="width: 8%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 8%" />
<col style="width: 6%" />
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
<td>1.59</td>
<td>2.50***</td>
<td>-0.02</td>
<td>2.99***</td>
<td>7.05***</td>
<td>9.86***</td>
<td>11.68***</td>
<td>4.83***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.81)</td>
<td>(0.69)</td>
<td>(0.27)</td>
<td>(0.68)</td>
<td>(1.64)</td>
<td>(0.21)</td>
<td>(0.35)</td>
<td>(0.27)</td>
</tr>
<tr class="odd">
<td>treat</td>
<td>0.01</td>
<td>0.13</td>
<td>0.03</td>
<td>0.04</td>
<td>0.21</td>
<td>-0.02</td>
<td>0.02</td>
<td>0.00</td>
</tr>
<tr class="even">
<td></td>
<td>(0.12)</td>
<td>(0.10)</td>
<td>(0.04)</td>
<td>(0.10)</td>
<td>(0.24)</td>
<td>(0.03)</td>
<td>(0.05)</td>
<td>(0.05)</td>
</tr>
<tr class="odd">
<td>post</td>
<td>-0.20**</td>
<td>-0.19**</td>
<td>-0.03</td>
<td>-0.17**</td>
<td>-0.59***</td>
<td>0.07***</td>
<td>-0.06</td>
<td>0.74***</td>
</tr>
<tr class="even">
<td></td>
<td>(0.08)</td>
<td>(0.06)</td>
<td>(0.03)</td>
<td>(0.06)</td>
<td>(0.15)</td>
<td>(0.02)</td>
<td>(0.03)</td>
<td>(0.03)</td>
</tr>
<tr class="odd">
<td>treat × post</td>
<td>0.01</td>
<td>-0.05</td>
<td>0.01</td>
<td>0.10</td>
<td>0.07</td>
<td>0.02</td>
<td>0.00</td>
<td>-0.05</td>
</tr>
<tr class="even">
<td></td>
<td>(0.17)</td>
<td>(0.14)</td>
<td>(0.06)</td>
<td>(0.14)</td>
<td>(0.34)</td>
<td>(0.04)</td>
<td>(0.07)</td>
<td>(0.08)</td>
</tr>
<tr class="odd">
<td>Num.Obs.</td>
<td>1146</td>
<td>1146</td>
<td>1146</td>
<td>1146</td>
<td>1146</td>
<td>1146</td>
<td>1066</td>
<td>618</td>
</tr>
<tr class="even">
<td>R2</td>
<td>0.241</td>
<td>0.213</td>
<td>0.334</td>
<td>0.062</td>
<td>0.266</td>
<td>0.228</td>
<td>0.350</td>
<td>0.547</td>
</tr>
<tr class="odd">
<td>R2 Adj.</td>
<td>0.217</td>
<td>0.188</td>
<td>0.313</td>
<td>0.033</td>
<td>0.243</td>
<td>0.203</td>
<td>0.328</td>
<td>0.523</td>
</tr>
<tr class="even">
<td>RMSE</td>
<td>1.12</td>
<td>0.95</td>
<td>0.38</td>
<td>0.94</td>
<td>2.26</td>
<td>0.30</td>
<td>0.48</td>
<td>0.37</td>
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

Differences-in-Differences Linear Regression Analysis of LIHTC in
Pacific Division

Again, the LIHTC program does not show any statistically significant
changes from 2010 to 2020. There are also no discernable economic
changes, unlike the NMTC program. However, we can conclude that census
tracts in the Pacific Division are statistically more vulnerable in
household characteristics and transportation based on participation in
the LIHTC program.

There are no visuals for since none of the models are statistically
significant.
