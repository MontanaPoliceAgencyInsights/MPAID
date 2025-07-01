---
title: "Pacific Division SVI Infographics and Choropleth Maps"
author: "Drew Radovich"
date: "2025-04-12"
output: 
  github_document:
    toc: true
    toc_depth: 3
    preserve_yaml: true
  rmdformats::downcute:
    toc_depth: 3
    self_contained: false
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

Pacific Division SVI Infographics and Choropleth Maps
================
Drew Radovich
2025-04-12

- [Data](#data)
- [Socieconomic Status Infographics](#socieconomic-status-infographics)
- [Household Characteristics
  Infographics](#household-characteristics-infographics)
- [Racial and Ethnic Minority Status
  Infographics](#racial-and-ethnic-minority-status-infographics)
- [Housing Type and Transportation
  Infographics](#housing-type-and-transportation-infographics)
- [Choropleth Maps](#choropleth-maps)
  - [2010 SVI Flag to Population Ratio
    Map](#2010-svi-flag-to-population-ratio-map)
  - [2020 SVI Flag to Population Ratio
    Map](#2020-svi-flag-to-population-ratio-map)

<style type="text/css">
img {
  border: 50px solid white;
}
</style>

## Data

Here is the summary data for SVI vulnerability in the Pacific Division
compared to nationally for the years 2010 and 2020. The percents of
social vulnerability in the Pacific Division closely match the national
averages with a few key exceptions. For instance, the Pacific division
has a significantly higher percent of limited English speakers than the
national average as well as a higher percent minority race/ethnicity.
The Pacific Division also has a slightly lower percent population with
high school diplomas. For both 2010 and 2020, the Pacific Division had
nearly double the percent of population living in crowded living spaces
than the national average. For healthcare, the percent of population
covered increased 10% from 2010, following the national trend.

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
division
</th>
<th style="text-align:right;">
year
</th>
<th style="text-align:right;">
pct in poverty
</th>
<th style="text-align:right;">
pct not in poverty
</th>
<th style="text-align:right;">
pct unemployed
</th>
<th style="text-align:right;">
pct employed
</th>
<th style="text-align:right;">
pct housing cost-burdened
</th>
<th style="text-align:right;">
pct not housing cost-burdened
</th>
<th style="text-align:right;">
pct adults without high school diploma
</th>
<th style="text-align:right;">
pct adults with high school diploma
</th>
<th style="text-align:right;">
pct age 17 & under
</th>
<th style="text-align:right;">
pct age 18-64
</th>
<th style="text-align:right;">
pct age 65+
</th>
<th style="text-align:right;">
pct single parent families
</th>
<th style="text-align:right;">
pct other families
</th>
<th style="text-align:right;">
pct limited English speakers
</th>
<th style="text-align:right;">
pct proficient English speakers
</th>
<th style="text-align:right;">
pct Minority race/ethnicity
</th>
<th style="text-align:right;">
pct Non-Hispanic White race/ethnicity
</th>
<th style="text-align:right;">
pct in multi-unit housing
</th>
<th style="text-align:right;">
pct in mobile housing
</th>
<th style="text-align:right;">
pct in other housing
</th>
<th style="text-align:right;">
pct in crowded living spaces
</th>
<th style="text-align:right;">
pct in non-crowded living spaces
</th>
<th style="text-align:right;">
pct with no vehicle access
</th>
<th style="text-align:right;">
pct with vehicle access
</th>
<th style="text-align:right;">
pct in group living quarters
</th>
<th style="text-align:right;">
pct not in group living quarters
</th>
<th style="text-align:right;">
pct without health insurance
</th>
<th style="text-align:right;">
pct with health insurance
</th>
<th style="text-align:right;">
pct disabled civilians
</th>
<th style="text-align:right;">
pct not disabled civilians
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
United States
</td>
<td style="text-align:right;">
2010
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2010
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
77
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
55
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
48
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
87
</td>
</tr>
<tr>
<td style="text-align:left;">
United States
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:left;">
Pacific Division
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
56
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
86
</td>
</tr>
</tbody>
</table>

</div>

## Socieconomic Status Infographics

The following waffle charts show information on the Socioeconomic status
of the Pacific Division. Each icon represents 1% of the population. The
demographics that are included in socioeconomic status are poverty,
unemployment rates, housing cost-burdened, high school education, and
health insurance coverage. The most notable differences in the Pacific
Division and nation are the percent of population experiencing housing
cost-burdens and the percent of high school diplomas.

<figure>
<img src="./imgs/infographic_SES_Pacific_Division.png"
alt="Alt-text: Socioeconomic Status Infographic" />
<figcaption aria-hidden="true">Alt-text: Socioeconomic Status
Infographic</figcaption>
</figure>

## Household Characteristics Infographics

These infographics look at age, disability status, family types, and
language, the characteristics that make up the Housing category of the
SVI. For the Pacific Division, age categories closely mirror the
national averages, while there is a significantly higher percentage of
non-English speakers compared to the national population.

<figure>
<img src="./imgs/infographic_HHChar_Pacific_Division.png"
alt="Alt-text: Household Characteristics Infographic" />
<figcaption aria-hidden="true">Alt-text: Household Characteristics
Infographic</figcaption>
</figure>

## Racial and Ethnic Minority Status Infographics

For racial and ethnic minority groups, there is a significantly higher
(17% in 2010 and 15% in 2020) percent population in the Pacific Division
when compared to the national average. This makes sense with the higher
amount of non-English speakers that were observed in the previous
category.

<figure>
<img src="./imgs/infographic_REM_Pacific_Division.png"
alt="Alt-text: Racial and Ethnic Minority Infographic" />
<figcaption aria-hidden="true">Alt-text: Racial and Ethnic Minority
Infographic</figcaption>
</figure>

## Housing Type and Transportation Infographics

The last category of the SVI is housing type and transportation which
takes into account group living quarters, crowded living spaces,
multi-unit housing, and vehicle access. The Pacific Division has
slightly less percent population living in mobile housing for 2010 and
2020, with those numbers choosing multi-unit housing instead. This is
also reflected in the slightly higher percent population living in
crowded spaces compared to the rest of the nation. Vehicle access for
the Pacific Division is only a few percentage points higher than the
national average.

<figure>
<img src="./imgs/infographic_HAT_Pacific_Division.png"
alt="Alt-text: Housing and Transportation Infographic" />
<figcaption aria-hidden="true">Alt-text: Housing and Transportation
Infographic</figcaption>
</figure>

## Choropleth Maps

### 2010 SVI Flag to Population Ratio Map

The following maps look at Social Vulnerabilty per 1000 people at the
county level for the Pacific Division in 2010. The index is a flag count
to population ratio to account for size and population differences
withing counties. Naturally, larger counties will produce more flags,
using the ratio creates an equitable comparison. On the map, we can see
that Alaska is at a high percent of social vulnerability as a whole,
most likely due to the lower population and geographic difficulties. The
Los Angeles area and surrounding counties are also at a higher risk when
compared to major metropolitan areas in Washington and Oregon (i.e,
Seattle and Portland.)

<iframe align="center" width="1000" height="1000" src="./imgs/flag_pop_quantile2010_Pacific_Divisionmap.html">
</iframe>

### 2020 SVI Flag to Population Ratio Map

Here is the same map for 2020 data. Again, a ratio of flags to
population was used to account for differences in county size. The
results are mostly similar with a couple counties crossing into the next
percentile of social vulnerability, noticeably in Eastern Washington and
Oregon, as well as Northern California. Major metropolitan areas did not
change drastically in their risk of social vulnerability.

<iframe align="center" width="1000" height="1000" src="./imgs/flag_pop_quantile2020_Pacific_Divisionmap.html">
</iframe>
