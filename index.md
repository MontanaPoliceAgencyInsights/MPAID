---
title: " "
layout: single
toc: true
author_profile: true
---


# Executive Summary

## Overview 

The US Census Bureau has categorized the 50 states and District of Columbia into 4 distinct regions. Those regions are further divided into 9 districts. For the purposes of this report, we are focusing on the following districts:

-   Mountain Division
-   Pacific Division
-   South Atlantic Division

We examined the impact of two federally funded tax programs, the New Markets Tax Program and the Low Income Housing Tax Credit program on qualifying neighborhoods. In order to evaluate the change in neighborhoods,we will be looking at Social Variability Index (SVI) Census variables which are defined by U.S. Centers for Disease Control and Prevention (CDC)’s to measure neighborhood vulnerability. In addition, we will also be looking at economic outcomes variables to include: median home values and median income from Census data, and the Federal Housing Finance Agency’s house price index.

The purpose of the federally funded New Markets Tax Credits and Low Income Housing Tax credits is to provide low-income neighborhoods investment funding to improve vulnerable neighborhoods.

The CDC’s SVI looks at 4 categories of vulnerability. All variables within these categories can be pulled from Census Data API.

We will also be including the following economic variables in our analysis: Median Home Values, Median Incomes, and House Price Index.

We will look at these variables in vulnerable neighborhoods who received investment from the NMTC and LIHTC programs and compare them with neighborhoods who did not receive funding from these programs. Specifically we will be looking at 2010 and 2020 Census data for these neighborhoods. It is our hypothesis that those neighborhoods who received NMTC and LIHTC funding will have decreased SVI vulnerability flags and improved economic outcomes.


## Data

Data for this project was sourced from the U.S. Census Bureau (2010 and 2020) and the Federal Housing Finance Agency, with all 2020 data normalized to 2010 census tract boundaries using NHGIS crosswalks.

Social Vulnerability Index data was based on CDC-defined categories:

- Socioeconomic Status (SES):  percent living below 150% poverty, percent unemployed, population housing cost-burned, percent adults without high school diploma, percent without health insurance.
- Household Characteristics: percent age 17 and under, percent age 65 and over, percent disabled civilians, percent single parent families, percent limited English speakers.
- Racial/Ethnic Minority Status: percent minority race/ethnicity.
- Housing Type/Transportation: percent in multi-unit housing, percent in mobile housing, percent in crowded living spaces, percent with no vehicle access, percent living in group quarters.

Additional variables included median income, median home values, and the House Price Index. Median income and median home values were pulled from the census API. The house price index was pulled from the Federal Housing Finance Agency API.

We identified tracts that were eligible for our two tax programs; the New Markets Tax Credit (NMTC), and the Low Income Housing Tax Credit (LIHTC). We wrangled our data to determine tracts that were deemed eligible for these tax credits, but excluded tracts that received funding prior to 2010, to insure that we are measuring the impact of the programs.

The analysis covered 73,057 tracts nationally, with 5,250 in the Mountain Division, 13,706 in the South Atlantic Division, and 10,867 in the Pacific Division. Eligibility and funding data for NMTC and LIHTC were integrated to isolate program impacts post-2010, focusing on new interventions and avoiding pre-existing funded tracts.

## Methods

A variety of spatial and statistical techniques were used to analyze the impact of tax credit investments.

These included:

- waffle charts
- choropleth and bivariate mapping
- k-means clustering

Each was used to  visualize funding distribution and vulnerability in various ways and groupings. 

Correlation analyses (Pearson’s r) assessed alignment between funding levels and tract need. 

To estimate causal impacts, difference-in-differences (diff-in-diff) regression models were used, controlling for metro-level effects via CBSA fixed effects. This approach allowed for comparisons of change over time between treated (funded) and untreated tracts in both divisions, across multiple outcome variables.

# Results and Conclusion

In the Mountain, Pacific, and South Atlantic Divisions, the NMTC and LIHTC programs did not produce statistically significant improvements in any of the four social vulnerability categories or most economic indicators.

A moderate to strong correlation was observed between funding and vulnerability in the Mountain Division, suggesting relatively effective targeting; however, actual program impacts were negligible.

In the South Atlantic Division, funding did not consistently align with areas of highest need, and difference-in-differences models showed no significant outcomes except for a small positive impact of NMTC on median income.

Overall, neither program demonstrated clear effectiveness in reducing social vulnerability or driving economic improvements over the decade studied.


<br>
<hr>
<br>

# References


## R Versions

Dodson: Analyses were conducted using the R Statistical language (version 4.4.0;
R Core Team, 2024) on Windows 10 x64 (build 19045)

Knopp: Analyses were conducted using the R Statistical language (version 4.4.1;
R Core Team, 2024) on Windows 11 x64 (build 26100)

Radovich: Analyses were conducted using the R Statistical language (version 4.3.1; R Core Team,
2023) on Windows 11 x64 (build 26100)

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

  ## License

  This project uses the MIT License for reproducibility. For more info, check out the license [here.](https://choosealicense.com/licenses/mit/)
