---
title: "Results and Conclusion"
author: "Drew Radovich"
#date: "2024-04-18"
layout: single
sidebar:
  nav: "sidebar"
toc: true
---

## Introduction

For this project, we are evaluating the effect of two national tax
credit programs, the New Market Tax Credits (NMTC) and the Low Income
Housing Tax Credits (LIHTC), on improving social vulnerability and
economic outcomes for eligible census tracts. To measure change, we will
first be evaluating the perceived social vulnerability of each
neighborhood using the CDC’s Social Vulnerability Index, which defines
four main categories: socioeconomic status, household characteristics,
racial & ethnic minority status, and housing type & transportation. In
addition, we will measure economic outcomes using data from the U.S.
Census Bureau and the Federal Housing Finance Agency (FHFA).

We will be using data from 2010 and 2020 to evaluate longitudinal change
in neighborhoods. Geographical and economic data was brought in by the
U.S. Census Bureau and American Community Survey (ACS), where the FHFA
provided data on economic outcomes, namely the housing price index.

To accurately evaluate change, the data was wrangled to match tracts
from 2010 to 2020 and determine eligibility for each tax credit program
as defined below. We then utilized visual and statistical analysis tools
such as waffle plots, bivariate and choropleth mapping, k-means
analysis, and diff-in-diff regression analysis.

## Data

The data we are using is being sourced from the U.S. Census Bureau
American Community Survey (ACS) from 2010 and 2020. In 2010, the data
pulled was at a tract-level, whereas in 2020 the data was pulled at the
Census Block Group-level. This is due to the changes in tract boundaries
over time to help ensure that we are making an equal comparison. Census
Block Groups help us determine which 2020 blocks belong to which cenus
tracts from 2010. These were then assigned using FIPS crosswalk data
from the IPUMS National Historical Geographic Information System
(NHGIS).

For our national census tract data there were 73057 rows of raw data in
both 2010 and 2020. The Pacific division had 10867 rows of data for both
time periods. The most vulnerable tracts, as determined by number of SVI
flags, in the division for 2010 were Fresno County, CA, Kern County, CA,
and Los Angeles County, CA.

Since our primary interest is in the effectiveness of the NMTC and LIHTC
programs, only tracts deemed as eligible to receive benefits were
analysed. Tract eligibility was determined by not having previously
received tax credit dollars and the NMTC and LIHTC conditions for
eligibility. In addition, we looked at areas that experienced high
levels of migration which were not previously flagged as eligible. More
information on eligibility can be found here: -
NMTC\[<https://www.cdfifund.gov/programs-training/programs/new-markets-tax-credit>\] -
LIHTC\[<https://www.urban.org/sites/default/files/publication/98758/lithc_how_it_works_and_who_it_serves_final_0.pdf>\]
Of the 73057 national census-tracts, 29068 were eligible for the NMTC
and 3723 were eligible for the LIHTC. In the Pacific division, 4237
tracts were eligible for the NMTC and 584 for the LIHTC.

This project was also interested in the economic outcomes of these
tracts as measured by changes in median income, median home value, and
the housing price index. This data was pulled from the U.S. Census
Bureau’s estimates on median income and home value and used the Federal
Housing Finance Agency (FHFA)’s House Price Index data.

Data was grouped for analysis on the divisional level and then again by
census-tracts using adjusted FIPS crosswalk data for the year 2020. We
also pulled in shapefiles from the ACS to visualize changes in SVI flag
counts using choropleth mapping. Individual factors for social
vulnerability were mapped using waffle charts to compare specific areas
of vulnerability (recall that the CDC has four categories of
vulnerability).

## Analysis

To analyze the data we implored various methods including waffle charts,
spatial analysis (choropleth and bivariate mapping), correlation
analyses, k-means clustering, and diff-in-diff regression analysis. -
Waffle Charts were used to visualize the amounts of social vulnerability
across the four categories defined by the CDC: socioeconomic status,
household characteristics, racial & ethnic minority status, and housing
type & transportation. - Spatial Analysis using choropleth maps and
bivariate color grading was used to visualize the flag-to-population
ratio for census tracts. A flag-to-population ratio was used to create
an equitable comparison across county tracts since larger counties will
likely have larger amounts of flags for social vulnerability. -
Correlation Analyses was used to determine the correlation between the
amount of SVI flags and the amount of tax credit dollars recieved -
k-means clustering is a machine learning technique that evaluates data
points and clusters them based on similarities, helping to limit the
effect of outliers. For most of our variables, this resulted in two
distinct groups for the Pacific division. - A diff-in-diff regression
model was chosen to evaluate effectiveness since we have data from two
separate time points, before and after intervention of the tax credit
programs. This model was then applied to each of our four dependent
variables (the social vulnerability categories)

Each analysis method was applied to both the NMTC and LIHTC program.

## Results

### NMTC Diff-in-Diff Models

#### Socioeconomic SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_SES with treat, post and cbsa (formula:
SVI_FLAG_COUNT_SES ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.27, F(69, 8170) = 43.83, p \< .001, adj.
R2 = 0.26)

The effect of treat × post is statistically non-significant and negative
(beta = -0.05, 95% CI \[-0.32, 0.22\], t(8170) = -0.35, p = 0.724; Std.
beta = -3.34e-03, 95% CI \[-0.02, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

#### Household Characteristics SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.11, F(69, 8170) = 14.88, p \< .001, adj. R2 = 0.10)

The effect of treat × post is statistically non-significant and negative
(beta = -0.05, 95% CI \[-0.25, 0.15\], t(8170) = -0.48, p = 0.634; Std.
beta = -4.97e-03, 95% CI \[-0.03, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
household characteristics-related social vulnerability and economic
outcomes.

#### Racial and Ethnic Minority SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_REM with treat, post and cbsa (formula:
SVI_FLAG_COUNT_REM ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.30, F(69, 8170) = 51.08, p \< .001, adj.
R2 = 0.30)

The effect of treat × post is statistically non-significant and negative
(beta = -0.01, 95% CI \[-0.09, 0.07\], t(8170) = -0.32, p = 0.749; Std.
beta = -2.96e-03, 95% CI \[-0.02, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on racial
and ethnic minority status-related social vulnerability and economic
outcomes.

#### Housing and Transportation SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HOUSETRANSPT with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat \* post + cbsa) where
treat represents NMTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.06, F(69, 8170) = 7.56, p \< .001, adj. R2 = 0.05)

The effect of treat × post is statistically non-significant and negative
(beta = -0.01, 95% CI \[-0.22, 0.19\], t(8170) = -0.12, p = 0.901; Std.
beta = -1.33e-03, 95% CI \[-0.02, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on housing
and transportation access-related social vulnerability and economic
outcomes.

#### Overall SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_OVERALL with treat, post and cbsa (formula:
SVI_FLAG_COUNT_OVERALL ~ treat + post + treat \* post + cbsa) where
treat represents NMTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.23, F(69, 8170) = 36.00, p \< .001, adj. R2 = 0.23)

The effect of treat × post is statistically non-significant and negative
(beta = -0.12, 95% CI \[-0.67, 0.42\], t(8170) = -0.44, p = 0.659; Std.
beta = -4.27e-03, 95% CI \[-0.02, 0.01\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
socioeconomic, household characteristics, racial and ethnic minority
status, and housing and transportation access-related social
vulnerability and economic outcomes.

#### Median Income Economic Outcomes

We fitted a linear model (estimated using OLS) to predict MEDIAN_INCOME
with treat, post and cbsa (formula: MEDIAN_INCOME ~ treat + post + treat
\* post + cbsa) where treat represents NMTC program participation, post
is the year of 2020 after starting period of 2010, and cbsa controls for
metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.18, F(69, 8166) = 26.31, p \< .001, adj. R2 = 0.17)

The effect of treat × post is statistically significant and positive
(beta = 0.06, 95% CI \[4.76e-03, 0.11\], t(8166) = 2.14, p = 0.033; Std.
beta = 0.02, 95% CI \[1.77e-03, 0.04\])

Since the effect of treat x post is statistically significant, we can
conclude that the NMTC program had a measurable impact on Median
Income-related social vulnerability and economic outcomes.

#### Median Home Value Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
MEDIAN_HOME_VALUE with treat, post and cbsa (formula: MEDIAN_HOME_VALUE
~ treat + post + treat \* post + cbsa) where treat represents NMTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.42, F(68, 7847) = 82.65, p \< .001, adj.
R2 = 0.41)

The effect of treat × post is statistically non-significant and positive
(beta = 2.91e-03, 95% CI \[-0.08, 0.08\], t(7847) = 0.07, p = 0.943;
Std. beta = 6.13e-04, 95% CI \[-0.02, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on Median
Home Value-related social vulnerability and economic outcomes.

#### House Price Index Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
HOUSE_PRICE_INDEX with treat, post and cbsa (formula: HOUSE_PRICE_INDEX
~ treat + post + treat \* post + cbsa) where treat represents NMTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.49, F(67, 5458) = 77.52, p \< .001, adj.
R2 = 0.48)

The effect of treat × post is statistically non-significant and negative
(beta = -0.02, 95% CI \[-0.12, 0.09\], t(5458) = -0.36, p = 0.716; Std.
beta = -3.52e-03, 95% CI \[-0.02, 0.02\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on House
Price Index-related social vulnerability and economic outcomes.

### LIHTC Diff-in-Diff Models

#### Socioeconomic SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_SES with treat, post and cbsa (formula:
SVI_FLAG_COUNT_SES ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.24, F(35, 1110) = 10.06, p \< .001, adj. R2 = 0.22)

The effect of treat × post is statistically non-significant and positive
(beta = 7.39e-03, 95% CI \[-0.32, 0.34\], t(1110) = 0.04, p = 0.965;
Std. beta = 1.15e-03, 95% CI \[-0.05, 0.05\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

#### Household Characteristics SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.21, F(35, 1110) = 8.59, p \< .001, adj. R2 = 0.19)

The effect of treat × post is statistically non-significant and negative
(beta = -0.05, 95% CI \[-0.33, 0.23\], t(1110) = -0.36, p = 0.720; Std.
beta = -9.57e-03, 95% CI \[-0.06, 0.04\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
household characteristics-related social vulnerability and economic
outcomes.

#### Racial and Ethnic Minority SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_REM with treat, post and cbsa (formula:
SVI_FLAG_COUNT_REM ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.33, F(35, 1110) = 15.92, p \< .001, adj.
R2 = 0.31)

The effect of treat × post is statistically non-significant and positive
(beta = 8.81e-03, 95% CI \[-0.10, 0.12\], t(1110) = 0.16, p = 0.877;
Std. beta = 3.80e-03, 95% CI \[-0.04, 0.05\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on racial
and ethnic minority status-related social vulnerability and economic
outcomes.

#### Housing and Transportation SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HOUSETRANSPT with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat \* post + cbsa) where
treat represents LIHTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.06, F(35, 1110) = 2.11, p \< .001, adj. R2 = 0.03)

The effect of treat × post is statistically non-significant and positive
(beta = 0.10, 95% CI \[-0.17, 0.38\], t(1110) = 0.73, p = 0.463; Std.
beta = 0.02, 95% CI \[-0.04, 0.08\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
housing and transportation access-related social vulnerability and
economic outcomes.

#### Overall SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_OVERALL with treat, post and cbsa (formula:
SVI_FLAG_COUNT_OVERALL ~ treat + post + treat \* post + cbsa) where
treat represents LIHTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.27, F(35, 1110) = 11.51, p \< .001, adj.
R2 = 0.24)

The effect of treat × post is statistically non-significant and positive
(beta = 0.07, 95% CI \[-0.60, 0.73\], t(1110) = 0.20, p = 0.842; Std.
beta = 5.14e-03, 95% CI \[-0.05, 0.06\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
socioeconomic, household characteristics, racial and ethnic minority
status, and housing and transportation access-related social
vulnerability and economic outcomes.

#### Median Income Economic Outcomes

We fitted a linear model (estimated using OLS) to predict MEDIAN_INCOME
with treat, post and cbsa (formula: MEDIAN_INCOME ~ treat + post + treat
\* post + cbsa) where treat represents LIHTC program participation, post
is the year of 2020 after starting period of 2010, and cbsa controls for
metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.23, F(35, 1110) = 9.35, p \< .001, adj. R2 = 0.20)

The effect of treat × post is statistically non-significant and positive
(beta = 0.02, 95% CI \[-0.07, 0.10\], t(1110) = 0.40, p = 0.688; Std.
beta = 0.01, 95% CI \[-0.04, 0.06\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on Median
Income-related social vulnerability and economic outcomes.

#### Median Home Value Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
MEDIAN_HOME_VALUE with treat, post and cbsa (formula: MEDIAN_HOME_VALUE
~ treat + post + treat \* post + cbsa) where treat represents LIHTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.35, F(34, 1031) = 16.30, p \< .001, adj.
R2 = 0.33)

The effect of treat × post is statistically non-significant and positive
(beta = 2.73e-03, 95% CI \[-0.14, 0.15\], t(1031) = 0.04, p = 0.970;
Std. beta = 9.33e-04, 95% CI \[-0.05, 0.05\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on Median
Home Value-related social vulnerability and economic outcomes.

#### House Price Index Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
HOUSE_PRICE_INDEX with treat, post and cbsa (formula: HOUSE_PRICE_INDEX
~ treat + post + treat \* post + cbsa) where treat represents LIHTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.55, F(31, 586) = 22.81, p \< .001, adj.
R2 = 0.52)

The effect of treat × post is statistically non-significant and negative
(beta = -0.05, 95% CI \[-0.20, 0.09\], t(586) = -0.70, p = 0.483; Std.
beta = -0.02, 95% CI \[-0.07, 0.04\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on House
Price Index-related social vulnerability and economic outcomes.

## Discussion and Recommendations

Our choropleth maps show that the highest amounts of SVI flags that also
recieve the most tax credit dollars are located near large metropolitan
areas such as Los Angeles, CA and Seattle, WA. As a whole, Alaska has
high amounts of social vulnerability, most likely due to lower
populations than the rest of the division. Hawaii also has high amounts
of social vulnerability, but received a lower amount of tax credit
dollars compared to tracts with similar SVI flags.

In the Pacific Division, the Los Angeles County, CA tract has the
highest amount of flags at 9210 and also received the highest amount of
tax credits. In the overall correlation analysis, there was a 0.98
correlation between SVI flags and tax credits received. However, after
k-means analyses and placing Los Angeles County in a separate group, ur
correlation analysis shows a moderate positive correlation between SVI
flags and tax credits received.

The diff-in-diff modeling did not reveal any statistically significant
coefficients except for on the outcome of Median Income under the NMTC
program. This suggests a correlation between receiving credits under the
NMTC program and an increase in median income from 2010 to 2020.

## References

### R

Analyses were conducted using the R Statistical language (version 4.3.1;
R Core Team, 2023) on Windows 11 x64 (build 26100)

### Packages

- Arel-Bundock V (2022). “modelsummary: Data and Model Summaries in R.”
  *Journal of Statistical Software*, *103*(1), 1-23.
  <doi:10.18637/jss.v103.i01> <https://doi.org/10.18637/jss.v103.i01>.
- Arel-Bundock V (2025). *tinytable: Simple and Configurable Tables in
  ‘HTML’, ‘LaTeX’, ‘Markdown’, ‘Word’, ‘PNG’, ‘PDF’, and ‘Typst’
  Formats*. R package version 0.8.0,
  <https://CRAN.R-project.org/package=tinytable>.
- Auguie B (2017). *gridExtra: Miscellaneous Functions for “Grid”
  Graphics*. R package version 2.3,
  <https://CRAN.R-project.org/package=gridExtra>.
- Chan C, Leeper T, Becker J, Schoch D (2023). *rio: A Swiss-army knife
  for data file I/O*. <https://cran.r-project.org/package=rio>.
- Cheng J, Sievert C, Schloerke B, Chang W, Xie Y, Allen J (2024).
  *htmltools: Tools for HTML*. R package version 0.5.8.1,
  <https://CRAN.R-project.org/package=htmltools>.
- Gagolewski M (2022). “stringi: Fast and portable character string
  processing in R.” *Journal of Statistical Software*, *103*(2), 1-59.
  <doi:10.18637/jss.v103.i02> <https://doi.org/10.18637/jss.v103.i02>.
- Gohel D, Skintzos P (2025). *ggiraph: Make ‘ggplot2’ Graphics
  Interactive*. R package version 0.8.13,
  <https://CRAN.R-project.org/package=ggiraph>.
- Grolemund G, Wickham H (2011). “Dates and Times Made Easy with
  lubridate.” *Journal of Statistical Software*, *40*(3), 1-25.
  <https://www.jstatsoft.org/v40/i03/>.
- Karambelkar B (2017). *widgetframe: ‘Htmlwidgets’ in Responsive
  ‘iframes’*. R package version 0.3.1,
  <https://CRAN.R-project.org/package=widgetframe>.
- Kassambara A (2023). *ggpubr: ‘ggplot2’ Based Publication Ready
  Plots*. R package version 0.6.0,
  <https://CRAN.R-project.org/package=ggpubr>.
- Kassambara A, Mundt F (2020). *factoextra: Extract and Visualize the
  Results of Multivariate Data Analyses*. R package version 1.0.7,
  <https://CRAN.R-project.org/package=factoextra>.
- Komsta L, Novomestky F (2022). *moments: Moments, Cumulants, Skewness,
  Kurtosis and Related Tests*. R package version 0.14.1,
  <https://CRAN.R-project.org/package=moments>.
- Maechler M, Rousseeuw P, Struyf A, Hubert M, Hornik K (2025).
  *cluster: Cluster Analysis Basics and Extensions*. R package version
  2.1.8.1 - For new features, see the ‘NEWS’ and the ‘Changelog’ file in
  the package source), <https://CRAN.R-project.org/package=cluster>.
- Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B
  (2023). “Automated Results Reporting as a Practical Tool to Improve
  Reproducibility and Methodological Best Practices Adoption.” *CRAN*.
  <https://easystats.github.io/report/>.
- Mangiafico SS (2024). *rcompanion: Functions to Support Extension
  Education Program Evaluation*. Rutgers Cooperative Extension, New
  Brunswick, New Jersey. version 2.4.36,
  <https://CRAN.R-project.org/package=rcompanion/>.
- Müller K (2020). *here: A Simpler Way to Find Your Files*. R package
  version 1.0.1, <https://CRAN.R-project.org/package=here>.
- Müller K, Wickham H (2023). *tibble: Simple Data Frames*. R package
  version 3.2.1, <https://CRAN.R-project.org/package=tibble>.
- Ooms J (2025). *magick: Advanced Graphics and Image-Processing in R*.
  R package version 2.8.6, <https://CRAN.R-project.org/package=magick>.
- Pedersen T (2024). *patchwork: The Composer of Plots*. R package
  version 1.3.0, <https://CRAN.R-project.org/package=patchwork>.
- Prener C, Grossenbacher T, Zehr A (2022). *biscale: Tools and Palettes
  for Bivariate Thematic Mapping*. R package version 1.0.0,
  <https://CRAN.R-project.org/package=biscale>.
- Qiu Y, details. aotifSfAf (2020). *showtextdb: Font Files for the
  ‘showtext’ Package*. R package version 3.0,
  <https://CRAN.R-project.org/package=showtextdb>.
- Qiu Y, details. aotifSfAf (2024). *sysfonts: Loading Fonts into R*. R
  package version 0.8.9, <https://CRAN.R-project.org/package=sysfonts>.
- Qiu Y, details. aotisSfAf (2024). *showtext: Using Fonts More Easily
  in R Graphs*. R package version 0.9-7,
  <https://CRAN.R-project.org/package=showtext>.
- R Core Team (2023). *R: A Language and Environment for Statistical
  Computing*. R Foundation for Statistical Computing, Vienna, Austria.
  <https://www.R-project.org/>.
- Slowikowski K (2024). *ggrepel: Automatically Position Non-Overlapping
  Text Labels with ‘ggplot2’*. R package version 0.9.6,
  <https://CRAN.R-project.org/package=ggrepel>.
- Ushey K, Wickham H (2025). *renv: Project Environments*. R package
  version 1.1.4, <https://CRAN.R-project.org/package=renv>.
- Vaidyanathan R, Xie Y, Allaire J, Cheng J, Sievert C, Russell K
  (2023). *htmlwidgets: HTML Widgets for R*. R package version 1.6.4,
  <https://CRAN.R-project.org/package=htmlwidgets>.
- Vidonne C, Dicko A (2025). *unhcrthemes: UNHCR ‘ggplot2’ Theme and
  Colour Palettes*. R package version 0.6.3,
  <https://CRAN.R-project.org/package=unhcrthemes>.
- Walker K (2024). *tigris: Load Census TIGER/Line Shapefiles*. R
  package version 2.1, <https://CRAN.R-project.org/package=tigris>.
- Walker K, Herman M (2025). *tidycensus: Load US Census Boundary and
  Attribute Data as ‘tidyverse’ and ‘sf’-Ready Data Frames*. R package
  version 1.7.1, <https://CRAN.R-project.org/package=tidycensus>.
- Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*.
  Springer-Verlag New York. ISBN 978-3-319-24277-4,
  <https://ggplot2.tidyverse.org>.
- Wickham H (2023). *forcats: Tools for Working with Categorical
  Variables (Factors)*. R package version 1.0.0,
  <https://CRAN.R-project.org/package=forcats>.
- Wickham H (2023). *stringr: Simple, Consistent Wrappers for Common
  String Operations*. R package version 1.5.1,
  <https://CRAN.R-project.org/package=stringr>.
- Wickham H, Averick M, Bryan J, Chang W, McGowan LD, Françoi R,
  Grolemun G, Haye A, Henr L, Heste J, Kuh M, Pederse TL, Mille E, Bach
  SM, Müll K, Oo ,J, Robins ,D, Seid ,DP, Spi ,V, Takahas ,K, Vaugh ,D,
  Wil ,C, W ,K, Yutani ,H (2019). “Welcome to the tidyverse.” *Journal
  of Open Source Software*, *4*(43), 1686. <doi:10.21105/joss.01686>
  <https://doi.org/10.21105/joss.01686>.
- Wickham H, Bryan J, Barrett M, Teucher A (2024). *usethis: Automate
  Package and Project Setup*. R package version 3.1.0,
  <https://CRAN.R-project.org/package=usethis>.
- Wickham H, Francois R, Henry L, Muller K, Vaughan D (2023). *dplyr: A
  Grammar of Data Manipulation*. R package version 1.1.4,
  <https://CRAN.R-project.org/package=dplyr>.
- Wickham H, Henry L (2025). *purrr: Functional Programming Tools*. R
  package version 1.0.4, <https://CRAN.R-project.org/package=purrr>.
- Wickham H, Hester J, Bryan J (2024). *readr: Read Rectangular Text
  Data*. R package version 2.1.5,
  <https://CRAN.R-project.org/package=readr>.
- Wickham H, Hester J, Chang W, Bryan J (2022). *devtools: Tools to Make
  Developing R Packages Easier*. R package version 2.4.5,
  <https://CRAN.R-project.org/package=devtools>.
- Wickham H, Pedersen T, Seidel D (2023). *scales: Scale Functions for
  Visualization*. R package version 1.3.0,
  <https://CRAN.R-project.org/package=scales>.
- Wickham H, Vaughan D, Girlich M (2024). *tidyr: Tidy Messy Data*. R
  package version 1.3.1, <https://CRAN.R-project.org/package=tidyr>.
- Wilke C (2024). *cowplot: Streamlined Plot Theme and Plot Annotations
  for ‘ggplot2’*. R package version 1.1.3,
  <https://CRAN.R-project.org/package=cowplot>.
- Zhu H (2024). *kableExtra: Construct Complex Table with ‘kable’ and
  Pipe Syntax*. R package version 1.4.0,
  <https://CRAN.R-project.org/package=kableExtra>.

### Data

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
  \`\`\`
