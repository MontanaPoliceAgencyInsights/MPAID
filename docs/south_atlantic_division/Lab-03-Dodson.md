---
title: "South Atlantic Devision SVI Infographics and Chorepleth Map"
author: "Kenaniah Dodson"
#date: "2025-14-12"
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

# Import Functions

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
South Atlantic Division
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
23
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
77
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
3
</td>
<td style="text-align:right;">
97
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
83
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
South Atlantic Division
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
78
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
61
</td>
<td style="text-align:right;">
17
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
43
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
77
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
2
</td>
<td style="text-align:right;">
98
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
84
</td>
</tr>
</tbody>
</table>

</div>

# Socieconomic Status Infographics

#### Display socieconomic variables in a waffle chart, colorized to emphasize proportions of the population

<figure>
<img src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/infographic_SES_South_Atlantic_Division.png"
alt="Alt-text: Socioeconomic Status Infographic" />
<figcaption aria-hidden="true">Alt-text: Socioeconomic Status
Infographic</figcaption>
</figure>

# Household Characteristics Infographics

<figure>
<img src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/infographic_HHChar_South_Atlantic_Division.png"
alt="Alt-text: Household Characteristics Infographic" />
<figcaption aria-hidden="true">Alt-text: Household Characteristics
Infographic</figcaption>
</figure>

# Racial and Ethnic Minority Status Infographics

<figure>
<img src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/infographic_REM_South_Atlantic_Division.png"
alt="Alt-text: Racial and Ethnic Minority Infographic" />
<figcaption aria-hidden="true">Alt-text: Racial and Ethnic Minority
Infographic</figcaption>
</figure>

# Housing Type and Transportation Infographics

<figure>
<img src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/infographic_HAT_South_Atlantic_Division.png"
alt="Alt-text: Housing and Transportation Infographic" />
<figcaption aria-hidden="true">Alt-text: Housing and Transportation
Infographic</figcaption>
</figure>

# 2010 SVI Flag to Population Ration Map

<iframe align="center" width="100%" height="500px" src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/flag_pop_quantile2010_South_Atlantic_Divisionmap.html"></iframe>

# 2020 SVI Flag to Population Ration Map

<iframe align="center" width="100%" height="500px" src="https://watts-college.github.io/project-paf-515-2025s-team-04/docs/south_atlantic_division/imgs/flag_pop_quantile2020_South_Atlantic_Divisionmap.html"></iframe>
