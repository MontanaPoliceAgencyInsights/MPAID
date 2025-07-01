---
title: "SVI Infographics and Choropleth Map"
author: "Courtney Stowers"
#date: "03/17/2024"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

<style type="text/css">
img {
  border: 50px solid white;
}
</style>

# Introduction

Rates of social vulnerability in the Middle Atlantic Division closely mirror national rates. A few notable exceptions are the increased rates of individuals who live in multi-unit housing and lack access to transportation. This is likely due to the existence of several major cities in the division including New York City and Philadelphia. In contrast, the division has a higher rate of individuals with health insurance indicating a diversion in local trends from national rates. 

From 2010 to 2020 most rates remained fairly steady in the division, with the exception of individuals who were classified as housing-cost burdened which decreased by 5%, adults without a high school diploma decreased by 3% and in accordance with the passing of the Affordable Care Act in March 2010 (HealthCare.gov, n.d.), individuals with a lack of health insurance decreased by 5%.

# Data

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
Middle Atlantic Division
</td>
<td style="text-align:right;">
2010
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
80
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
86
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
Middle Atlantic Division
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
85
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
61
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
94
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

# Socieconomic Status Infographics

Poverty in the Middle Atantic Division is 3% less than national trends in 2010 and drops slightly to a rate of 2% less in 2020. 

Unemployment rates are identical to national trends in 2010 and follow the drop in 2020. NY, NJ, and PA maintain higher rates of housing cost burdens over the decade. 

While the division has slightly less adults without a high school diploma in 2010, there is no diversion from national trends in 2020.

Better-than-national health insurance coverage trends persist across the decade.

<figure>
<img src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/infographic_SES_Middle_Atlantic_Division.png"
alt="Alt-text: Socioeconomic Status Infographic" />
<figcaption aria-hidden="true">Alt-text: Socioeconomic Status
Infographic</figcaption>
</figure>

# Household Characteristics Infographics

The Middle Atlantic Division has an older population compared to national trends in 2010 and 2020. Across the decade the population continues to age in accordance with similar national population shifts. 

Nationally and divisionally, the disabled population remains stable. Family types also remain similar across the decade per Census definitions.

While English language proficiency increased by 1% nationally, the Middle Atlantic Division did not experience any changes.


<figure>
<img src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/infographic_HHChar_Middle_Atlantic_Division.png"
alt="Alt-text: Household Characteristics Infographic" />
<figcaption aria-hidden="true">Alt-text: Household Characteristics
Infographic</figcaption>
</figure>

# Racial and Ethnic Minority Status Infographics

Racial and Ethnic diversity increased in the Middle Atlantic Division from 2010 to 2020 at similar rates to the national trends. This is likely influenced by the large cultural diversity within the cities in the division and their impact on national diversity.

<figure>
<img src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/infographic_REM_Middle_Atlantic_Division.png"
alt="Alt-text: Racial and Ethnic Minority Infographic" />
<figcaption aria-hidden="true">Alt-text: Racial and Ethnic Minority
Infographic</figcaption>
</figure>

# Housing Type and Transportation Infographics

Mobile Housing rates decreased in the Middle Atlantic Division from 2010 to 2020 while Multi-Unit Housing increased. Mobile housing rates remained far below national percentage trends while Multi-Unit Housing rates remained above the national trends.

<figure>
<img src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/infographic_HAT_Middle_Atlantic_Division.png"
alt="Alt-text: Housing and Transportation Infographic" />
<figcaption aria-hidden="true">Alt-text: Housing and Transportation
Infographic</figcaption>
</figure>

# 2010 SVI Flag to Population Ratio Map

In 2010, the Middle Atlantic Division's social vulnerability index (SVI) flag counts relative to population sizes of 1,000 indicated high rates of vulnerability in urban Philadelphia County, PA, rural Northwestern  PA, former factory and coal country in Luzerne County, PA, Southern NJ, the greater New York City area, and rural counties around the Adirondack Mountains in New York, including Hamilton County which lacks traffic lights throughout the entire county and has very limited cell phone service (New York State, n.d.; Russell, 2022; Wikipedia, n.d.).

<iframe align="center" width="100%" height="500px" src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/flag_pop_quantile2010_Middle_Atlantic_Divisionmap.html"></iframe>

# 2020 SVI Flag to Population Ratio Map

In 2020 there are some shifts in SVI with some counties such as Union County, NJ, Crawford County, PA, and Monroe County, NY experiencing lower levels of vulnerability compared to 2020. However the general spatial trends of areas of vulnerability persists.


<iframe align="center" width="100%" height="500px" src="https://watts-college.github.io/paf-515-example-website/docs/middle_atlantic_division/imgs/flag_pop_quantile2020_Middle_Atlantic_Divisionmap.html"></iframe>
