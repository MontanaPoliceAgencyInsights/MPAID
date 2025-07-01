---
title: "Results and Conclusions"
author: "Michelle Knopp"
#date: "2025-05-05"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

# Introduction

For this project, we examined the impact of two federally funded tax
programs, the New Markets Tax Program (NMTC) and the Low Income Housing
Tax Credit program (LIHTC) on qualifying neighborhoods. In order to
evaluate the change in neighborhoods,we will be looked at Social
Variability Index (SVI) Census variables which are defined by U.S.
Centers for Disease Control and Prevention(CDC)’s to measure
neighborhood vulnerability. In addition, we will also looked at economic
outcomes variables to include: median home values and median income from
Census data, and the Federal Housing Finance Agency’s house price index.

We included 2010 and 2020 data from the census bureau, utilized funding
and eligibility data for the NMTC and LITC, and included data from the
Federal Housing Finance Agency for the housing price index. The data was
wrangled to include eligible tracts for the Mountain Division.

To analyze our data, we used both visual and statistical tools to
include; waffle charts, chloropleth maps, bivariate mapping, k-means
clustering, Pearson’s R correlation, and diff-in-diff regression.

# Data

In order to flag social vulnerabilities for our census tracts within the
Mountain Division, we pulled US Census Data. The US Centers for Disease
Control and Prevention (CDC) defined appropriate variables to measure
social vulnerability indices (SVI). The CDC’s SVI measures how
vulnerable a neighborhood is in the event of an emergency situation,
such as a natural disaster or health outbreak. These variables are
organized into four categories, and include the following variables:

- Socioeconomic Status: percent living below 150% poverty, percent
  unemployed, population housing cost-burned, percent adults without
  high school diploma, percent without health insurance.
- Household Characteristics: percent age 17 and under, percent age 65
  and over, percent disabled civilians, percent single parent families,
  percent limited English speakers. -Racial & Ethnic Minority Status:
  percent minority race/ethnicity. -Housing Type & Transportation:
  percent in multi-unit housing, percent in mobile housing, percent in
  crowded living spaces, percent with no vehicle access, percent living
  in group quarters.

We obtained data for all these categories from the US Census API for
2010 and 2020, and only used variables that were available in both
decades. To account for geographic changes between the decades, we
pulled census tract data from 2010 and then crosswalked it with the
census block group data from 2020.

Our National data included 73,057 tracts for 2010 and 2020. The Mountain
Division had a 2020 population of 24, 534, 951 living in 5,250 tracts.
In 2010, the tracts with the most vulnerable (Total SVI) flags were in
order, Laramie County, WY, Utah County, UT, Tooele County, UT, and 2
tracts in Salt Lake County, UT. In 2020, the most vulnerable tracts (SVI
flags) included the same tracts, and did not change. The least
vulnerable tracts in the Mountain Division experienced change. In 2010
the least vulnerable tracts were Summit County, UT, Glacier County, MT,
and Douglas County, CO in 2010. They switched completely in 2020 to Weld
County, CO, Clark County, NV, and Salt Lake County, UT. It was worth
noting that Salt Lake County included tracts that were the most
vulnerable and tracts that were the least vulnerable in the Mountain
Division.

Next, we identified tracts that were eligible for our two tax programs;
the New Markets Tax Credit (NMTC), and the Low Income Housing Tax Credit
(LIHTC). Markets Tax Credits are awarded to community development
entities for the purpose of investing in low income communities and
recipients must meet strict criteria to be eligible, but the credits are
intended to for areas with low median income and high poverty rates. Low
Income Housing Tax Credits are awarded to investors with the purpose of
investing in affordable housing for renters. Again, this program is
designed to improve neighborhood with low gross incomes and high poverty
rates. We wrangled our data to determine tracts that were deemed
eligible for these tax credits, but excluded tracts that received
funding prior to 2010, to insure that we are measuring the impact of the
programs.

For the Mountain Division, there were 2075 tracts eligible for the NMTC
program, with 56 counties receiving funding. There is a large spread
within tracts receiving NMTC in the Mountain division with SVI flag
counts ranging from 5 - 2558, and the NMTC dollars ranging from
\$800,000 to \$225,215,967. Montana, Idaho, and Wyoming received high
dollars compared to low flag counts. Nevada received the most dollars in
the highest need counties.

For the Mountain Division, there were 57 tracts eligible for the LIHTC
program, with 14 counties receiving funding. The Mountain division
counties receiving LIHTC project funding between 2011-2020, had a range
of 9 to 487 SVI flags in 2010. The funding ranged from \$270,127 and
\$15,437,500. There is a large range between counties in the number of
SVI flags in 2010 and funding dollars spent between 2011 and 2020.
Arizona had the tracts with the highest need and the highest amount of
LIHTC funding. Again, Montana and Colorado received high funding dollars
for a low amount of need.

In addition to the Social Vulnerability variables, we also included 3
additional economic variables: house price index (HPI), median home
value, and median income. HPI is determined by analyzing mortgage
transactions. The HPI was pulled from the Federal Housing Finance Agency
API. The median home value and median incomes were collected using
census data.

# Analysis

We used several tools to analyze our data, both visually and
statistically.

First, we used waffle charts, pictorial infographics, to look at our SVI
variable categories. For each category we used 100 icons to visually
show proportions of the percent of population who were vulnerable for
each SVI variable, and included overall SVI for each category of
variable.

We also looked at Chloropleth maps, to look at SVI Flags to Population
Ratios. In order to accomplish this, shapefiles were downloaded and SVI
flags were mapped to their respective geographical county location. We
included interactive tooltips so the user can get SVI information by
hovering over a county.The Chloropleth maps were colored coded to
visually see areas of least vulnerability (lighter color) and high
vulnerablility (darker color).

BiVariate Mapping was also another visual tool to analyze the data. For
our bivariate maps, we included SVI flags and the amount of funding each
county received. This provided a visualization of the areas of high
versus low need, and those areas who received little or high funding
from our tax programs.

We also examined the correlations between funding received (tax credits)
and need (SVI flags), calculating the Pearson’s R. correlation
coefficient. A Pearson’s R calculation of 0.62 suggests that there is a
strong positive association between the dollar amount spent in NMTC from
2011-2020 and the flag count within the Mountain Division counties in
2010. Overall, within all the counties in the Mountain Division, there
is a moderate positive correlation between SVI flags from 2010 and
dollars spent on LIHTC in 2011-2020, with a Pearson’s score of 0.57.

To check to see if our correlations were not reflecting any major
outliers, we used K-Means Clustering to separate our data points into
meaningful groups. We then recalculated our Pearson’s R for each group.

We utilized diff-in-diff models to analyze the impacts of the New
Markets Tax Credit (NMTC) and the Low Income Housing Tax Credit (LIHTC)
programs as they relate to social vulnerability and economic changes in
Mountain Division tracts.Diff-In-Diff models are useful as a statistical
tool to analyze the effects of a program when there is a treatment group
and a group who did not receive the treatment (control group). It can be
used when there are two periods, before intervention and after
intervention. Since we have tracts who were eligible and did receive
NMTC and LIHTC dollars and tracts who did not, we analyzed the impact of
these programs before and after intervention.

# Results

## NMTC Diff-In-Diff Models

### Socioeconomic SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_SES with treat, post and cbsa (formula:
SVI_FLAG_COUNT_SES ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.18, F(75, 3360) = 10.16, p \< .001, adj. R2 = 0.17)

The effect of treat × post is statistically non-significant and positive
(beta = 0.02, 95% CI \[-0.35, 0.39\], t(3360) = 0.11, p = 0.914; Std.
beta = 1.68e-03, 95% CI \[-0.03, 0.03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

### Household Characteristics

Show in New Window We fitted a linear model (estimated using OLS) to
predict SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.19, F(75, 3360) = 10.28, p \< .001, adj. R2 = 0.17)

The effect of treat × post is statistically non-significant and positive
(beta = 4.92e-03, 95% CI \[-0.25, 0.26\], t(3360) = 0.04, p = 0.970;
Std. beta = 5.86e-04, 95% CI \[-0.03, 0.03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
household characteristics-related social vulnerability and economic
outcomes.

### Racial & Ethnic Minority SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_REM with treat, post and cbsa (formula:
SVI_FLAG_COUNT_REM ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.34, F(75, 3360) = 23.24, p \< .001, adj.
R2 = 0.33)

The effect of treat × post is statistically non-significant and negative
(beta = -4.57e-03, 95% CI \[-0.11, 0.10\], t(3360) = -0.09, p = 0.932;
Std. beta = -1.19e-03, 95% CI \[-0.03, 0.03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on racial
and ethnic minority status-related social vulnerability and economic
outcomes.

### Housing & Transportation SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HOUSETRANSPT with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat \* post + cbsa) where
treat represents NMTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.11, F(75, 3360) = 5.71, p \< .001, adj. R2 = 0.09)

The effect of treat × post is statistically non-significant and positive
(beta = 0.09, 95% CI \[-0.19, 0.36\], t(3360) = 0.62, p = 0.537; Std.
beta = 0.01, 95% CI \[-0.02, 0.04\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on housing
and transportation access-related social vulnerability and economic
outcomes.

### Overall SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_OVERALL with treat, post and cbsa (formula:
SVI_FLAG_COUNT_OVERALL ~ treat + post + treat \* post + cbsa) where
treat represents NMTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.24, F(75, 3360) = 13.76, p \< .001, adj. R2 = 0.22)

The effect of treat × post is statistically non-significant and positive
(beta = 0.11, 95% CI \[-0.64, 0.85\], t(3360) = 0.28, p = 0.779; Std.
beta = 4.23e-03, 95% CI \[-0.03, 0.03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
socioeconomic, household characteristics, racial and ethnic minority
status, and housing and transportation access-related social
vulnerability and economic outcomes.

### Median Income Economic Outcomes

We fitted a linear model (estimated using OLS) to predict MEDIAN_INCOME
with treat, post and cbsa (formula: MEDIAN_INCOME ~ treat + post + treat
\* post + cbsa) where treat represents NMTC program participation, post
is the year of 2020 after starting period of 2010, and cbsa controls for
metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.17, F(75, 3360) = 9.26, p \< .001, adj. R2 = 0.15)

The effect of treat × post is statistically non-significant and positive
(beta = 0.03, 95% CI \[-0.04, 0.10\], t(3360) = 0.89, p = 0.373; Std.
beta = 0.01, 95% CI \[-0.02, 0.04\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on Median
Income-related social vulnerability and economic outcomes.

### Median Home Value Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
MEDIAN_HOME_VALUE with treat, post and cbsa (formula: MEDIAN_HOME_VALUE
~ treat + post + treat \* post + cbsa) where treat represents NMTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.26, F(75, 3248) = 14.99, p \< .001, adj. R2 = 0.24)

The effect of treat × post is statistically non-significant and positive
(beta = 0.05, 95% CI \[-0.07, 0.17\], t(3248) = 0.88, p = 0.381; Std.
beta = 0.01, 95% CI \[-0.02, 0.04\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on Median
Home Value-related social vulnerability and economic outcomes.

### House Price Index Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
HOUSE_PRICE_INDEX with treat, post and cbsa (formula: HOUSE_PRICE_INDEX
~ treat + post + treat \* post + cbsa) where treat represents NMTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.61, F(71, 1902) = 41.96, p \< .001, adj.
R2 = 0.60)

The effect of treat × post is statistically non-significant and negative
(beta = -5.21e-04, 95% CI \[-0.11, 0.11\], t(1902) = -9.32e-03, p =
0.993; Std. beta = -1.33e-04, 95% CI \[-0.03, 0.03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on House
Price Index-related social vulnerability and economic outcomes.

## LIHTC Diff-In-Diff Models

### Socioeconomic SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_SES with treat, post and cbsa (formula:
SVI_FLAG_COUNT_SES ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.26, F(39, 332) = 2.91, p \< .001, adj. R2 = 0.17)

The effect of treat × post is statistically non-significant and negative
(beta = -0.26, 95% CI \[-0.87, 0.35\], t(332) = -0.83, p = 0.406; Std.
beta = -0.04, 95% CI \[-0.13, 0.05\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

### Household Characteristics SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.43, F(39, 332) = 6.52, p \< .001, adj. R2
= 0.37)

The effect of treat × post is statistically non-significant and negative
(beta = -0.06, 95% CI \[-0.64, 0.53\], t(332) = -0.19, p = 0.847; Std.
beta = -7.97e-03, 95% CI \[-0.09, 0.07\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
household characteristics-related social vulnerability and economic
outcomes.

### Racial and Ethnic Minority SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_REM with treat, post and cbsa (formula:
SVI_FLAG_COUNT_REM ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.59, F(39, 332) = 12.22, p \< .001, adj.
R2 = 0.54)

The effect of treat × post is statistically non-significant and negative
(beta = -6.17e-03, 95% CI \[-0.20, 0.19\], t(332) = -0.06, p = 0.950;
Std. beta = -2.23e-03, 95% CI \[-0.07, 0.07\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on racial
and ethnic minority status-related social vulnerability and economic
outcomes.

### Housing and Transportation SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HOUSETRANSPT with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat \* post + cbsa) where
treat represents LIHTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.20, F(39, 332) = 2.08, p \< .001, adj. R2 = 0.10)

The effect of treat × post is statistically non-significant and positive
(beta = 0.19, 95% CI \[-0.37, 0.75\], t(332) = 0.67, p = 0.503; Std.
beta = 0.03, 95% CI \[-0.06, 0.13\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
housing and transportation access-related social vulnerability and
economic outcomes.

### Overall SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_OVERALL with treat, post and cbsa (formula:
SVI_FLAG_COUNT_OVERALL ~ treat + post + treat \* post + cbsa) where
treat represents LIHTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.42, F(39, 332) = 6.20, p \< .001, adj. R2
= 0.35)

The effect of treat × post is statistically non-significant and negative
(beta = -0.13, 95% CI \[-1.39, 1.12\], t(332) = -0.21, p = 0.837; Std.
beta = -8.60e-03, 95% CI \[-0.09, 0.07\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
socioeconomic, household characteristics, racial and ethnic minority
status, and housing and transportation access-related social
vulnerability and economic outcomes.

### Median Income Economic Outcomes

We fitted a linear model (estimated using OLS) to predict MEDIAN_INCOME
with treat, post and cbsa (formula: MEDIAN_INCOME ~ treat + post + treat
\* post + cbsa) where treat represents LIHTC program participation, post
is the year of 2020 after starting period of 2010, and cbsa controls for
metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.32, F(39, 332) = 4.10, p \< .001, adj. R2
= 0.25)

The effect of treat × post is statistically non-significant and positive
(beta = 0.04, 95% CI \[-0.20, 0.27\], t(332) = 0.33, p = 0.745; Std.
beta = 0.01, 95% CI \[-0.07, 0.10\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on Median
Income-related social vulnerability and economic outcomes.

### Median Home Value Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
MEDIAN_HOME_VALUE with treat, post and cbsa (formula: MEDIAN_HOME_VALUE
~ treat + post + treat \* post + cbsa) where treat represents LIHTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.48, F(39, 302) = 7.11, p \< .001, adj. R2
= 0.41)

The effect of treat × post is statistically non-significant and positive
(beta = 0.04, 95% CI \[-0.25, 0.32\], t(302) = 0.26, p = 0.798; Std.
beta = 0.01, 95% CI \[-0.07, 0.09\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on Median
Home Value-related social vulnerability and economic outcomes.

### House Price Index Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
HOUSE_PRICE_INDEX with treat, post and cbsa (formula: HOUSE_PRICE_INDEX
~ treat + post + treat \* post + cbsa) where treat represents LIHTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.65, F(23, 102) = 8.41, p \< .001, adj. R2
= 0.58)

The effect of treat × post is statistically non-significant and positive
(beta = 0.03, 95% CI \[-0.37, 0.44\], t(102) = 0.17, p = 0.865; Std.
beta = 9.99e-03, 95% CI \[-0.11, 0.13\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on House
Price Index-related social vulnerability and economic outcomes.

# Discussion and Recommendations

In conclusion, for the Mountain Region, there was a a moderate to high
correlation between tracts that received funding and those in need.
However, there was no statistically significant impact of these programs
on decreasing social vulnerability in any category.

Our analysis would indicate that the areas of need received funding.
However, the amount of funding greatly varied across tracts. The amount
of money should be included in our analysis to determine if the funding
amount affected neighborhood vulnerability. Additionally, it may be
beneficial to track gentrification, and check variables that measure
housing affordability and population mobility.

# References

## R and Package Libraries

## R Version

Analyses were conducted using the R Statistical language (version 4.4.1;
R Core Team, 2024) on Windows 11 x64 (build 26100)

## R Packages

- Arel-Bundock V (2022). “modelsummary: Data and Model Summaries in R.”
  *Journal of Statistical Software*, *103*(1), 1-23.
  <doi:10.18637/jss.v103.i01> <https://doi.org/10.18637/jss.v103.i01>.
- Arel-Bundock V (2025). *tinytable: Simple and Configurable Tables in
  ‘HTML’, ‘LaTeX’, ‘Markdown’, ‘Word’, ‘PNG’, ‘PDF’, and ‘Typst’
  Formats*. R package version 0.8.0,
  <https://vincentarelbundock.github.io/tinytable/>.
- Auguie B (2017). *gridExtra: Miscellaneous Functions for “Grid”
  Graphics*. R package version 2.3.
- Chan C, Leeper T, Becker J, Schoch D (2023). *rio: A Swiss-army knife
  for data file I/O*. <https://cran.r-project.org/package=rio>.
- Cheng J, Sievert C, Schloerke B, Chang W, Xie Y, Allen J (2024).
  *htmltools: Tools for HTML*. R package version 0.5.8.1,
  <https://rstudio.github.io/htmltools/>,
  <https://github.com/rstudio/htmltools>.
- Gagolewski M (2022). “stringi: Fast and portable character string
  processing in R.” *Journal of Statistical Software*, *103*(2), 1-59.
  <doi:10.18637/jss.v103.i02> <https://doi.org/10.18637/jss.v103.i02>.
- Gohel D, Skintzos P (2025). *ggiraph: Make ‘ggplot2’ Graphics
  Interactive*. R package version 0.8.13,
  <https://davidgohel.github.io/ggiraph/>.
- Grolemund G, Wickham H (2011). “Dates and Times Made Easy with
  lubridate.” *Journal of Statistical Software*, *40*(3), 1-25.
  <https://www.jstatsoft.org/v40/i03/>.
- Karambelkar B (2017). *widgetframe: ‘Htmlwidgets’ in Responsive
  ‘iframes’*. R package version 0.3.1,
  <https://bhaskarvk.github.io/widgetframe/>,
  <https://github.com/bhaskarvk/widgetframe>.
- Kassambara A (2023). *ggpubr: ‘ggplot2’ Based Publication Ready
  Plots*. R package version 0.6.0,
  <https://rpkgs.datanovia.com/ggpubr/>.
- Kassambara A, Mundt F (2020). *factoextra: Extract and Visualize the
  Results of Multivariate Data Analyses*. R package version 1.0.7,
  <http://www.sthda.com/english/rpkgs/factoextra>.
- Komsta L, Novomestky F (2022). *moments: Moments, Cumulants, Skewness,
  Kurtosis and Related Tests*. R package version 0.14.1,
  <http://www.komsta.net/>, <https://www.r-project.org>.
- Maechler M, Rousseeuw P, Struyf A, Hubert M, Hornik K (2025).
  *cluster: Cluster Analysis Basics and Extensions*. R package version
  2.1.8.1 - For new features, see the ‘NEWS’ and the ‘Changelog’ file in
  the package source), <https://CRAN.R-project.org/package=cluster>.
- Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B
  (2023). “Automated Results Reporting as a Practical Tool to Improve
  Reproducibility and Methodological Best Practices Adoption.” *CRAN*.
  <https://easystats.github.io/report/>.
- Mangiafico SS (2025). *rcompanion: Functions to Support Extension
  Education Program Evaluation*. Rutgers Cooperative Extension, New
  Brunswick, New Jersey. version 2.5.0,
  <https://CRAN.R-project.org/package=rcompanion/>.
- Müller K (2020). *here: A Simpler Way to Find Your Files*. R package
  version 1.0.1, <https://github.com/r-lib/here>,
  <https://here.r-lib.org/>.
- Müller K, Wickham H (2023). *tibble: Simple Data Frames*. R package
  version 3.2.1, <https://github.com/tidyverse/tibble>,
  <https://tibble.tidyverse.org/>.
- Ooms J (2025). *magick: Advanced Graphics and Image-Processing in R*.
  R package version 2.8.6,
  <https://docs.ropensci.org/magick/https://ropensci.r-universe.dev/magick>.
- Pedersen T (2024). *patchwork: The Composer of Plots*. R package
  version 1.3.0, <https://github.com/thomasp85/patchwork>,
  <https://patchwork.data-imaginist.com>.
- Prener C, Grossenbacher T, Zehr A (2022). *biscale: Tools and Palettes
  for Bivariate Thematic Mapping*. R package version 1.0.0,
  <https://chris-prener.github.io/biscale/>.
- Qiu Y, details. aotifSfAf (2020). *showtextdb: Font Files for the
  ‘showtext’ Package*. R package version 3.0.
- Qiu Y, details. aotifSfAf (2024). *sysfonts: Loading Fonts into R*. R
  package version 0.8.9, <https://github.com/yixuan/sysfonts>.
- Qiu Y, details. aotisSfAf (2024). *showtext: Using Fonts More Easily
  in R Graphs*. R package version 0.9-7,
  <https://github.com/yixuan/showtext>.
- R Core Team (2024). *R: A Language and Environment for Statistical
  Computing*. R Foundation for Statistical Computing, Vienna, Austria.
  <https://www.R-project.org/>.
- Slowikowski K (2024). *ggrepel: Automatically Position Non-Overlapping
  Text Labels with ‘ggplot2’*. R package version 0.9.6,
  <https://github.com/slowkow/ggrepel>, <https://ggrepel.slowkow.com/>.
- Ushey K, Wickham H (2025). *renv: Project Environments*. R package
  version 1.1.4, <https://CRAN.R-project.org/package=renv>.
- Vaidyanathan R, Xie Y, Allaire J, Cheng J, Sievert C, Russell K
  (2023). *htmlwidgets: HTML Widgets for R*. R package version 1.6.4,
  <https://github.com/ramnathv/htmlwidgets>.
- Vidonne C, Dicko A (2025). *unhcrthemes: UNHCR ‘ggplot2’ Theme and
  Colour Palettes*. R package version 0.6.3,
  <https://unhcr-dataviz.github.io/unhcrthemes/>,
  <https://github.com/unhcr-dataviz/unhcrthemes>.
- Walker K (2025). *tigris: Load Census TIGER/Line Shapefiles*. R
  package version 2.2.0, commit
  99b45062a24facbdbfdb6749ca531811d64a52b6,
  <https://github.com/walkerke/tigris>.
- Walker K, Herman M (2025). *tidycensus: Load US Census Boundary and
  Attribute Data as ‘tidyverse’ and ‘sf’-Ready Data Frames*. R package
  version 1.7.1, <https://walker-data.com/tidycensus/>.
- Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*.
  Springer-Verlag New York. ISBN 978-3-319-24277-4,
  <https://ggplot2.tidyverse.org>.
- Wickham H (2023). *forcats: Tools for Working with Categorical
  Variables (Factors)*. R package version 1.0.0,
  <https://github.com/tidyverse/forcats>,
  <https://forcats.tidyverse.org/>.
- Wickham H (2023). *stringr: Simple, Consistent Wrappers for Common
  String Operations*. R package version 1.5.1,
  <https://github.com/tidyverse/stringr>,
  <https://stringr.tidyverse.org>.
- Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
  Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller
  E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V,
  Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to
  the tidyverse.” *Journal of Open Source Software*, *4*(43), 1686.
  <doi:10.21105/joss.01686> <https://doi.org/10.21105/joss.01686>.
- Wickham H, Bryan J, Barrett M, Teucher A (2024). *usethis: Automate
  Package and Project Setup*. R package version 3.1.0,
  <https://github.com/r-lib/usethis>, <https://usethis.r-lib.org>.
- Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr: A
  Grammar of Data Manipulation*. R package version 1.1.4,
  <https://github.com/tidyverse/dplyr>, <https://dplyr.tidyverse.org>.
- Wickham H, Henry L (2025). *purrr: Functional Programming Tools*. R
  package version 1.0.4, <https://github.com/tidyverse/purrr>,
  <https://purrr.tidyverse.org/>.
- Wickham H, Hester J, Bryan J (2024). *readr: Read Rectangular Text
  Data*. R package version 2.1.5, <https://github.com/tidyverse/readr>,
  <https://readr.tidyverse.org>.
- Wickham H, Hester J, Chang W, Bryan J (2022). *devtools: Tools to Make
  Developing R Packages Easier*. R package version 2.4.5,
  <https://github.com/r-lib/devtools>, <https://devtools.r-lib.org/>.
- Wickham H, Pedersen T, Seidel D (2023). *scales: Scale Functions for
  Visualization*. R package version 1.3.0,
  <https://github.com/r-lib/scales>, <https://scales.r-lib.org>.
- Wickham H, Vaughan D, Girlich M (2024). *tidyr: Tidy Messy Data*. R
  package version 1.3.1, <https://github.com/tidyverse/tidyr>,
  <https://tidyr.tidyverse.org>.
- Wilke C (2024). *cowplot: Streamlined Plot Theme and Plot Annotations
  for ‘ggplot2’*. R package version 1.1.3,
  <https://wilkelab.org/cowplot/>.
- Zhu H (2024). *kableExtra: Construct Complex Table with ‘kable’ and
  Pipe Syntax*. R package version 1.4.0,
  <https://github.com/haozhu233/kableExtra>,
  <http://haozhu233.github.io/kableExtra/>.

## Data

- CDFI Fund (2023). *FY 2023 NMTC Public Data Release: 2003-2021 Data
  File Updated - Aug 21, 2023*.
  <https://www.cdfifund.gov/documents/data-releases>

- Centers for Disease Control and Prevention/ Agency for Toxic
  Substances and Disease Registry/ Geospatial Research, Analysis, and
  Services Program. (2022). *CDC/ATSDR Social Vulnerability Index 2020
  Methodology*.
  <https://web.archive.org/web/20241028180954/https://www.atsdr.cdc.gov/placeandhealth/svi/documentation/SVI_documentation_2020.html>

- FHFA (n.d.). *HPI® Census Tracts (Developmental Index; Not Seasonally
  Adjusted)*.
  <https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index-Datasets.aspx#atvol>

- HUD User (n.d.). *2010, 2011, and 2012 QCT data for all of the census
  tracts in the United States and Puerto Rico
  (qct_data_2010_2011_2012.xlsx)*.
  <https://www.huduser.gov/portal/datasets/qct.html#year2010>

- HUD User (2023). *Low-Income Housing Tax Credit (LIHTC): Property
  Level Data*.
  <https://www.huduser.gov/portal/datasets/lihtc/property.html>

- Novogradac New Markets Tax Credit Resource Center. (2017). *New
  Markets Tax Credit Low-Income Community Census Tracts - American
  Community Survey 2011-2015*.
  <https://www.novoco.com/resource-centers/new-markets-tax-credits/data-tables>

- Steven Manson, Jonathan Schroeder, David Van Riper, Katherine Knowles,
  Tracy Kugler, Finn Roberts, and Steven Ruggles. *IPUMS National
  Historical Geographic Information System: Version 18.0 \[2020 → 2010
  Block Groups → Census Tracts Crosswalks National File\]*. Minneapolis,
  MN: IPUMS. 2023. <http://doi.org/10.18128/D050.V18.0>

- U.S. Bureau of Labor Statistics (n.d.). *CPI Inflation Calculator*.
  <https://data.bls.gov/cgi-bin/cpicalc.pl>

- U.S. Bureau of Labor Statistics (n.d.). *QCEW County-MSA-CSA Crosswalk
  (For NAICS-Based Data)*.
  <https://www.bls.gov/cew/classifications/areas/county-msa-csa-crosswalk.htm>

- U.S. Census Bureau. (2011). *2006-2010 American Community Survey
  5-year*.
  <https://www.census.gov/newsroom/releases/archives/american_community_survey_acs/cb11-208.html>

- U.S. Census Bureau. (2013). *2008-2012 American Community Survey
  5-year*.
  <https://www.census.gov/newsroom/press-kits/2013/20131217_acs_5yr.html>

- U.S. Census Bureau. (2022). *2016-2020 American Community Survey
  5-year*.
  <https://www.census.gov/newsroom/press-releases/2022/acs-5-year-estimates.html>

## Readings

- Jayachandran, A. (2024). What Is House Price Index (HPI)?
  <https://www.wallstreetmojo.com/house-price-index-hpi/>

- Killingsworth, M. A. (2021). Experienced well-being rises with income,
  even above \$75,000 per year. Proceedings of the National Academy of
  Sciences - PNAS, 118(4).
  <https://doi.org/10.1073/pnas.2016976118_download>

- Tax Foundation (2020). An Overview of the Low-Income Housing Tax
  Credit (LIHTC)
  <https://taxfoundation.org/research/all/federal/low-income-housing-tax-credit-lihtc/>

- The Urban Institute (2021). The Past, Present, and Future of the New
  Markets Tax Credit Program
  <https://www.urban.org/events/past-present-and-future-new-markets-tax-credit-program>
