---
title: "Lab-06-Dodson"
author: "Kenaniah Dodson"
date: "2025-05-05"
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

Lab-06-Dodson
================
Kenaniah Dodson
2025-05-05

- [Introduction](#introduction)
- [Data](#data)
- [Analysis](#analysis)
- [Results](#results)
  - [NMTC Diff-In-Diff Models](#nmtc-diff-in-diff-models)
    - [Socioeconomic SVI](#socioeconomic-svi)
    - [Household Characteristics SVI](#household-characteristics-svi)
    - [Racial and Ethnic Minority SVI](#racial-and-ethnic-minority-svi)
    - [Housing and Transportation SVI](#housing-and-transportation-svi)
    - [Overall SVI](#overall-svi)
    - [Median Income Economic
      Outcomes](#median-income-economic-outcomes)
    - [Median Home Value Economic
      Outcomes](#median-home-value-economic-outcomes)
    - [House Price Index Economic
      Outcomes](#house-price-index-economic-outcomes)
  - [LIHTC Diff-In-Diff Models](#lihtc-diff-in-diff-models)
    - [Socioeconomic SVI](#socioeconomic-svi-1)
    - [Household Characteristics SVI](#household-characteristics-svi-1)
    - [Racial and Ethnic Minority
      SVI](#racial-and-ethnic-minority-svi-1)
    - [Housing and Transportation
      SVI](#housing-and-transportation-svi-1)
    - [Overall SVI](#overall-svi-1)
    - [Median Income Economic
      Outcomes](#median-income-economic-outcomes-1)
    - [Median Home Value Economic
      Outcomes](#median-home-value-economic-outcomes-1)
    - [House Price Index Economic
      Outcomes](#house-price-index-economic-outcomes-1)
- [Discussion and Recommendations](#discussion-and-recommendations)
- [References](#references)
  - [Packages](#packages)
  - [Data](#data-1)

# Introduction

This project investigates the relationship between federal investment
programs and social vulnerability in the South Atlantic Division of the
United States. Specifically, it evaluates the impact of the New Markets
Tax Credit (NMTC) and Low-Income Housing Tax Credit (LIHTC) programs on
vulnerable census tracts between 2010 and 2020. Social vulnerability is
assessed using the CDC’s Social Vulnerability Index (SVI), which
includes four dimensions: socioeconomic status, household
characteristics, racial and ethnic minority status, and housing and
transportation access. Data were sourced from the U.S. Census Bureau,
the Federal Housing Finance Agency, and were normalized to 2010 census
tracts using the NHGIS crosswalk.

The project employs a mix of spatial and statistical methods, including
choropleth and bivariate mapping to visualize geographic trends and
relationships, correlation analyses to explore variable associations,
K-means clustering to identify patterns in funding and vulnerability,
and difference-in-differences (diff-in-diff) regression models to
measure the effects of NMTC and LIHTC programs over time. Overall, we
found no statistically significant impact of either program on social
vulnerability outcomes. There was also no consistent correlation between
the amount of funding received and the vulnerability of the census
tracts, raising concerns about the allocation strategy. These findings
suggest a need for more targeted and transparent investment practices.
Future studies should investigate how and where funds were spent, and
whether other non-financial factors—such as local governance or
administrative capacity—played a role in determining outcomes.
Stakeholders would benefit from more granular, program-level data to
assess effectiveness and improve equity in resource distribution.

# Data

Data from this report is collected from the U.S. Census Bureau and the
Federal Housing Finance Agency. However, since census tracts have
changed between 2010 and 2020, the data from 2020 was crosswalked to
2010 tracts with the NHGIS crosswalk. Throughout the South Atlantic
Division section of this report, we will track indicators of social
vulnerability using data from the U.S. Census Bureau and the Federal
Housing Finance Agency. This data will be used in line withe Centers for
Diseas Control (CDC)’s Social Vulnerability Index, which divides Social
Vulnerability into four categories: socioeconomic status, household
characterisitcs, racial and ethnic minority status, and housing type and
transportation.

The SVI data sets contains 73057 tracts nationally. Divisionally, the
South Atlantic Division contains 13706 tracts. In the South Atlantic
Division, the most vulnerable state was Florida both in 2010 and in
2020. The most vulnerable by themes 1-4 in 2020 were: Broward County,
Miami-Dade County, Alachua County, and Hillsborough County. For
contrast, the most vulnerable by themes 1-4 in 2010 were: Broward
County, Hillsborough County, Alachua County, and Miami-Dade County.

Tracts were identified as being eligible based on a number of factors.
For the NMTC, census tract poverty rate would need to be equal or
greater than 20%, Median Family Income would need to be less than or
equal to 80% of the average, and tract unemployment to national
unemployment ratio would need to be greater than 1.5. Tracts qualifying
for NMTC awards would create a “flag”. Counting up these flags allow us
to see which areas were the most socially vulnerable. For the NMTC, the
largest ammount of flags counted was 9936. For the LIHTC, the maximum
was 2457.

Data was grouped and observed in a number of ways, including clustering
and diff-in-diff models. These models are used to show how different
tracts are affected, as well as how the flag count relates to the amount
of money invested into different tracts.

# Analysis

Throughout this project, we have used various different methodologies in
order to best understand our data.

Spatial analysis was used to map our division into states, counties, and
tracts, in order to understand how geography may have impacted the data.
Choropleth maps are shown to explain population, as well as our social
vulnrability flags. Bivariate mapping is used to show relationships
between SVI variables.

K-Means Clustering was used in order to discover relationships between
flag counts and the amount of money invested into at-risk areas. Since
there was a large variance between our maximum and minimum flag counts
as well as our maximum and minimum money invested, outliers were
affecting our data. Clustering allowed us to view the data in smaller
groups that were similar in flag counts, and money invested.
Diff-In-Diff regression was used in various models to view how the NMTC
and LIHTC programs affected our tracts between 2010 and 2020.

# Results

## NMTC Diff-In-Diff Models

### Socioeconomic SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_SES with treat, post and cbsa (formula:
SVI_FLAG_COUNT_SES ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.17, F(131, 10358) = 16.00, p \< .001, adj. R2 =
0.16)

The effect of treat × post is statistically non-significant and negative
(beta = -0.15, 95% CI \[-0.38, 0.08\], t(10358) = -1.28, p = 0.200; Std.
beta = -0.01, 95% CI \[-0.03, 6.08e-03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

### Household Characteristics SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.10, F(131, 10358) = 8.60, p \< .001, adj. R2 = 0.09)

The effect of treat × post is statistically non-significant and negative
(beta = -0.13, 95% CI \[-0.29, 0.03\], t(10358) = -1.59, p = 0.111; Std.
beta = -0.01, 95% CI \[-0.03, 3.44e-03\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on
household characteristics-related social vulnerability and economic
outcomes.

### Racial and Ethnic Minority SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_REM with treat, post and cbsa (formula:
SVI_FLAG_COUNT_REM ~ treat + post + treat \* post + cbsa) where treat
represents NMTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.25, F(131, 10358) = 25.92, p \< .001, adj. R2 =
0.24)

The effect of treat × post is statistically non-significant and negative
(beta = -0.02, 95% CI \[-0.09, 0.06\], t(10358) = -0.43, p = 0.667; Std.
beta = -3.67e-03, 95% CI \[-0.02, 0.01\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the NMTC program had a measurable impact on racial
and ethnic minority status-related social vulnerability and economic
outcomes.

### Housing and Transportation SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HOUSETRANSPT with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HOUSETRANSPT ~ treat + post + treat \* post + cbsa) where
treat represents NMTC program participation, post is the year of 2020
after starting period of 2010, and cbsa controls for metro-level
effects.

The model explains a statistically significant and weak proportion of
variance (R2 = 0.08, F(131, 10358) = 6.93, p \< .001, adj. R2 = 0.07)

The effect of treat × post is statistically non-significant and positive
(beta = 4.97e-03, 95% CI \[-0.16, 0.17\], t(10358) = 0.06, p = 0.953;
Std. beta = 5.51e-04, 95% CI \[-0.02, 0.02\])

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
of variance (R2 = 0.18, F(131, 10358) = 16.97, p \< .001, adj. R2 =
0.17)

The effect of treat × post is statistically non-significant and negative
(beta = -0.29, 95% CI \[-0.75, 0.16\], t(10358) = -1.26, p = 0.207; Std.
beta = -0.01, 95% CI \[-0.03, 6.23e-03\])

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
of variance (R2 = 0.20, F(131, 10350) = 19.93, p \< .001, adj. R2 =
0.19)

The effect of treat × post is statistically significant and positive
(beta = 0.06, 95% CI \[0.01, 0.11\], t(10350) = 2.54, p = 0.011; Std.
beta = 0.02, 95% CI \[5.08e-03, 0.04\])

Since the effect of treat x post is statistically significant, we can
conclude that the NMTC program had a measurable impact on Median
Income-related social vulnerability and economic outcomes.

### Median Home Value Economic Outcomes

We fitted a linear model (estimated using OLS) to predict
MEDIAN_HOME_VALUE with treat, post and cbsa (formula: MEDIAN_HOME_VALUE
~ treat + post + treat \* post + cbsa) where treat represents NMTC
program participation, post is the year of 2020 after starting period of
2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.42, F(131, 10116) = 56.78, p \< .001,
adj. R2 = 0.42)

The effect of treat × post is statistically non-significant and positive
(beta = 0.02, 95% CI \[-0.04, 0.09\], t(10116) = 0.67, p = 0.503; Std.
beta = 5.06e-03, 95% CI \[-9.74e-03, 0.02\])

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
proportion of variance (R2 = 0.37, F(123, 4962) = 23.82, p \< .001, adj.
R2 = 0.36)

The effect of treat × post is statistically non-significant and positive
(beta = 0.05, 95% CI \[-0.04, 0.13\], t(4962) = 1.05, p = 0.292; Std.
beta = 0.01, 95% CI \[-0.01, 0.03\])

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

The model explains a statistically significant and substantial
proportion of variance (R2 = 0.26, F(77, 928) = 4.33, p \< .001, adj. R2
= 0.20)

The effect of treat × post is statistically non-significant and positive
(beta = 0.03, 95% CI \[-0.37, 0.42\], t(928) = 0.14, p = 0.888; Std.
beta = 3.98e-03, 95% CI \[-0.05, 0.06\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on
socioeconomic status-related social vulnerability and economic outcomes.

### Household Characteristics SVI

We fitted a linear model (estimated using OLS) to predict
SVI_FLAG_COUNT_HHCHAR with treat, post and cbsa (formula:
SVI_FLAG_COUNT_HHCHAR ~ treat + post + treat \* post + cbsa) where treat
represents LIHTC program participation, post is the year of 2020 after
starting period of 2010, and cbsa controls for metro-level effects.

The model explains a statistically significant and moderate proportion
of variance (R2 = 0.24, F(77, 928) = 3.86, p \< .001, adj. R2 = 0.18)

The effect of treat × post is statistically non-significant and negative
(beta = -0.12, 95% CI \[-0.42, 0.18\], t(928) = -0.77, p = 0.442; Std.
beta = -0.02, 95% CI \[-0.08, 0.03\])

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
proportion of variance (R2 = 0.37, F(77, 928) = 6.99, p \< .001, adj. R2
= 0.31)

The effect of treat × post is statistically non-significant and positive
(beta = 2.18e-03, 95% CI \[-0.12, 0.12\], t(928) = 0.04, p = 0.972; Std.
beta = 9.29e-04, 95% CI \[-0.05, 0.05\])

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
of variance (R2 = 0.17, F(77, 928) = 2.44, p \< .001, adj. R2 = 0.10)

The effect of treat × post is statistically non-significant and negative
(beta = -0.02, 95% CI \[-0.30, 0.27\], t(928) = -0.12, p = 0.903; Std.
beta = -3.65e-03, 95% CI \[-0.06, 0.06\])

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
proportion of variance (R2 = 0.28, F(77, 928) = 4.65, p \< .001, adj. R2
= 0.22)

The effect of treat × post is statistically non-significant and negative
(beta = -0.10, 95% CI \[-0.83, 0.62\], t(928) = -0.28, p = 0.777; Std.
beta = -7.92e-03, 95% CI \[-0.06, 0.05\])

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
proportion of variance (R2 = 0.31, F(77, 926) = 5.47, p \< .001, adj. R2
= 0.26)

The effect of treat × post is statistically non-significant and negative
(beta = -4.13e-03, 95% CI \[-0.13, 0.12\], t(926) = -0.06, p = 0.949;
Std. beta = -1.73e-03, 95% CI \[-0.06, 0.05\])

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
proportion of variance (R2 = 0.41, F(77, 880) = 8.00, p \< .001, adj. R2
= 0.36)

The effect of treat × post is statistically non-significant and positive
(beta = 4.72e-03, 95% CI \[-0.17, 0.18\], t(880) = 0.05, p = 0.958; Std.
beta = 1.36e-03, 95% CI \[-0.05, 0.05\])

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
proportion of variance (R2 = 0.40, F(32, 241) = 4.98, p \< .001, adj. R2
= 0.32)

The effect of treat × post is statistically non-significant and positive
(beta = 0.09, 95% CI \[-0.19, 0.36\], t(241) = 0.64, p = 0.523; Std.
beta = 0.03, 95% CI \[-0.07, 0.13\])

Since the effect of treat x post is not statistically significant, we
cannot conclude that the LIHTC program had a measurable impact on House
Price Index-related social vulnerability and economic outcomes.

# Discussion and Recommendations

From our bivariate maps, we can see that there is a high ratio of flags
to population in West Virginia, eastern North Carolina, southern
Georgia, and across Florida. We can also see that the tracts appear to
be very similar between 2010 and 2020. Although this model does not show
total populations and may not be the best way to view this data, it
could suggest that the programs did not have the expected affect.

Suprisingly, when we look at our amount of flags compared to the amount
of money invested, we see that there is not a strong correlation. This
would suggest that the amount of money being spent may not have been
decided based on social vulnerability factors soley. Due to this bias in
our data, we viewed our data in groups so that we may see how different
flags and spending levels correlate. However, even in this model, we
cannot conclude that the amount of money spent had a significant impact
on social vulnerability due to the amount of flags between 2010 and 2020
remaining similar.

Finally, when we viewed the impact of both the LIHTC and NMTC programs
onto different social vulnerability outcomes, we cannot conclude that
either programs had an impact on any of the outcomes.

Due to the large varience in flags and amount of money spent, as well as
the lack of significance in the outcomes, it would be beneficial to
study further into how the money was spent specifically. It does not
appear as if funding was going where it was most needed. Although this
study could not conclude that social vulnerability flags were related to
the amount of money invested, it would be interesting to see what other
factors or decision makers were impactful. Understanding how the money
was spent could unlock further understanding into how the money could be
used to see a better result.

# References

## Packages

Analyses were conducted using the R Statistical language (version 4.4.0;
R Core Team, 2024) on Windows 10 x64 (build 19045)

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
  - Chan C, Leeper T, Becker J, Schoch D (2023). *rio: A Swiss-army
    knife for data file I/O*. <https://cran.r-project.org/package=rio>.
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
  - Komsta L, Novomestky F (2022). *moments: Moments, Cumulants,
    Skewness, Kurtosis and Related Tests*. R package version 0.14.1,
    <https://CRAN.R-project.org/package=moments>.
  - Maechler M, Rousseeuw P, Struyf A, Hubert M, Hornik K (2025).
    *cluster: Cluster Analysis Basics and Extensions*. R package version
    2.1.8.1 - For new features, see the ‘NEWS’ and the ‘Changelog’ file
    in the package source),
    <https://CRAN.R-project.org/package=cluster>.
  - Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik
    B (2023). “Automated Results Reporting as a Practical Tool to
    Improve Reproducibility and Methodological Best Practices Adoption.”
    *CRAN*. <https://easystats.github.io/report/>.
  - Mangiafico SS (2025). *rcompanion: Functions to Support Extension
    Education Program Evaluation*. Rutgers Cooperative Extension, New
    Brunswick, New Jersey. version 2.5.0,
    <https://CRAN.R-project.org/package=rcompanion/>.
  - Müller K (2020). *here: A Simpler Way to Find Your Files*. R package
    version 1.0.1, <https://CRAN.R-project.org/package=here>.
  - Müller K, Wickham H (2023). *tibble: Simple Data Frames*. R package
    version 3.2.1, <https://CRAN.R-project.org/package=tibble>.
  - Ooms J (2025). *magick: Advanced Graphics and Image-Processing in
    R*. R package version 2.8.6,
    <https://CRAN.R-project.org/package=magick>.
  - Pedersen T (2024). *patchwork: The Composer of Plots*. R package
    version 1.3.0, <https://CRAN.R-project.org/package=patchwork>.
  - Prener C, Grossenbacher T, Zehr A (2022). *biscale: Tools and
    Palettes for Bivariate Thematic Mapping*. R package version 1.0.0,
    <https://CRAN.R-project.org/package=biscale>.
  - Qiu Y, details. aotifSfAf (2020). *showtextdb: Font Files for the
    ‘showtext’ Package*. R package version 3.0,
    <https://CRAN.R-project.org/package=showtextdb>.
  - Qiu Y, details. aotifSfAf (2024). *sysfonts: Loading Fonts into R*.
    R package version 0.8.9,
    <https://CRAN.R-project.org/package=sysfonts>.
  - Qiu Y, details. aotisSfAf (2024). *showtext: Using Fonts More Easily
    in R Graphs*. R package version 0.9-7,
    <https://CRAN.R-project.org/package=showtext>.
  - R Core Team (2024). *R: A Language and Environment for Statistical
    Computing*. R Foundation for Statistical Computing, Vienna, Austria.
    <https://www.R-project.org/>.
  - Slowikowski K (2024). *ggrepel: Automatically Position
    Non-Overlapping Text Labels with ‘ggplot2’*. R package version
    0.9.6, <https://CRAN.R-project.org/package=ggrepel>.
  - Ushey K, Wickham H (2025). *renv: Project Environments*. R package
    version 1.1.4, <https://CRAN.R-project.org/package=renv>.
  - Vaidyanathan R, Xie Y, Allaire J, Cheng J, Sievert C, Russell K
    (2023). *htmlwidgets: HTML Widgets for R*. R package version 1.6.4,
    <https://CRAN.R-project.org/package=htmlwidgets>.
  - Vidonne C, Dicko A (2025). *unhcrthemes: UNHCR ‘ggplot2’ Theme and
    Colour Palettes*. R package version 0.6.3,
    <https://CRAN.R-project.org/package=unhcrthemes>.
  - Walker K (2025). *tigris: Load Census TIGER/Line Shapefiles*. R
    package version 2.2.0, commit
    99b45062a24facbdbfdb6749ca531811d64a52b6,
    <https://github.com/walkerke/tigris>.
  - Walker K, Herman M (2024). *tidycensus: Load US Census Boundary and
    Attribute Data as ‘tidyverse’ and ‘sf’-Ready Data Frames*. R package
    version 1.6.7, <https://CRAN.R-project.org/package=tidycensus>.
  - Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*.
    Springer-Verlag New York. ISBN 978-3-319-24277-4,
    <https://ggplot2.tidyverse.org>.
  - Wickham H (2023). *forcats: Tools for Working with Categorical
    Variables (Factors)*. R package version 1.0.0,
    <https://CRAN.R-project.org/package=forcats>.
  - Wickham H (2023). *stringr: Simple, Consistent Wrappers for Common
    String Operations*. R package version 1.5.1,
    <https://CRAN.R-project.org/package=stringr>.
  - Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
    Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller
    E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V,
    Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to
    the tidyverse.” *Journal of Open Source Software*, *4*(43), 1686.
    <doi:10.21105/joss.01686> <https://doi.org/10.21105/joss.01686>.
  - Wickham H, Bryan J, Barrett M, Teucher A (2024). *usethis: Automate
    Package and Project Setup*. R package version 3.1.0,
    <https://CRAN.R-project.org/package=usethis>.
  - Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr:
    A Grammar of Data Manipulation*. R package version 1.1.4,
    <https://CRAN.R-project.org/package=dplyr>.
  - Wickham H, Henry L (2025). *purrr: Functional Programming Tools*. R
    package version 1.0.4, <https://CRAN.R-project.org/package=purrr>.
  - Wickham H, Hester J, Bryan J (2024). *readr: Read Rectangular Text
    Data*. R package version 2.1.5,
    <https://CRAN.R-project.org/package=readr>.
  - Wickham H, Hester J, Chang W, Bryan J (2022). *devtools: Tools to
    Make Developing R Packages Easier*. R package version 2.4.5,
    <https://CRAN.R-project.org/package=devtools>.
  - Wickham H, Pedersen T, Seidel D (2023). *scales: Scale Functions for
    Visualization*. R package version 1.3.0,
    <https://CRAN.R-project.org/package=scales>.
  - Wickham H, Vaughan D, Girlich M (2024). *tidyr: Tidy Messy Data*. R
    package version 1.3.1, <https://CRAN.R-project.org/package=tidyr>.
  - Wilke C (2024). *cowplot: Streamlined Plot Theme and Plot
    Annotations for ‘ggplot2’*. R package version 1.1.3,
    <https://CRAN.R-project.org/package=cowplot>.
  - Zhu H (2024). *kableExtra: Construct Complex Table with ‘kable’ and
    Pipe Syntax*. R package version 1.4.0,
    <https://CRAN.R-project.org/package=kableExtra>.

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
