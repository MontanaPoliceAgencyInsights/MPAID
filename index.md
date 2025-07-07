---
title: " "
layout: single
toc: true
author_profile: true
---


# MPAID Project Summary

The Montana Police Agency Insights Dashboard (MPAID) is designed to provide a centralized resource for members of the Montana Police Protective Association (MPPA) and city union leaders, facilitating informed employment decisions and supporting union contract bargaining. This project addresses the challenges of accessing contract information and wage comparisons, particularly for smaller agencies. MPAID consolidates data from various police agencies across Montana, enabling users to analyze key metrics such as the relationship between the population served and the number of sworn officers, as well as hourly compensation relative to population size. Through comprehensive data analysis, including correlation and regression techniques, the dashboard reveals significant relationships between officer wages and various independent variables, such as median household income and agency size. Findings indicate that higher wages are strongly correlated with larger populations and agency sizes, while economic indicators like income and housing prices also influence wage levels. By integrating interactive visualizations and statistical tools, MPAID empowers users to make data-driven decisions that enhance their bargaining power. Ultimately, the dashboard not only serves as a valuable resource for contract negotiations but also promotes clarity and collaboration within the law enforcement community, contributing to improved outcomes for all member agencies.

## MPAID Goals

The MPAID project aims to serve as a comprehensive resource that includes data on police agencies throughout Montana, specifically focusing on MPPA member agencies. 


## Data

The MPAID (Montana Police Agency Information Database) project focuses on gathering and analyzing compensation information for law enforcement officers across various cities in Montana. The data collection process involved multiple sources and methodologies to ensure a comprehensive overview of wages and related variables. The primary source of wage data came from collective bargaining agreements (CBAs), which were either accessible online or obtained through direct communication with city clerks, finance clerks, or city treasurers. Out of twenty-eight MPPA (Montana Police Protective Association) member cities, 18 provided CBA data, while wage information from six cities was sourced from interviews due to the unavailability of CBAs.

The analysis centered on the base hourly wages of full-time sworn officers at various career milestones (e.g., probationary, five-year, ten-year, etc.). Complex wage matrices and rank-based pay structures were taken into account, although supervisory wages were excluded from the analysis. U.S. Census Bureau estimates for July 1, 2024, were utilized for cities with populations over 5,000, while 2020 Census data was used for smaller towns due to the lack of estimates for these areas. The necessity for the most up-to-date information was emphasized because of significant population growth in Montana since 2020. Crime data was sourced from the Montana Board of Crime Control Statistical Center, adhering to Uniform Crime Reporting (UCR) standards, with the latest available data from 2024 used for all cities. Additionally, median household income, median house prices, and poverty rates were derived from U.S. Census Bureau data, with county data used for cities with populations under 5,000. The gender of officers was inferred from names, supplemented by online searches for ambiguous names.

## Methods

The dashboard consolidates data into a centralized location with interactive statistical and visual features. Data was gathered from collective bargaining agreements and U.S. Census Bureau sources, compiled into an Excel spreadsheet, and uploaded to R for integration into a Shiny dashboard. Additional variables were created, including ratios related to officer wages and city demographics.

The visualization page includes bar charts categorized by population sizes, allowing comparisons among agencies. An interactive chart shows correlations between wage variables and other metrics, with regression lines for analysis. A distribution tab presents boxplots, histograms, and summary statistics for selected variables, while a correlation matrix displays Pearson’s R values for all variables.

Choropleth maps illustrate officer wages in relation to population, agency size, and income metrics, consistently using five-year wage data. An interactive multiple regression table enables users to analyze wage predictors, showing statistical significance of independent variables. Overall, these features facilitate exploration of complex relationships between officer wages and demographic/economic factors.

# Results and Conclusion

The MPAID dashboard analysis reveals key factors influencing officer wages. A strong correlation (Pearson’s R of 1.0) exists between city population and agency size, suggesting potential bias in regression models if both are included. Officer wages are highly correlated (above 0.93) with other wage categories, highlighting the importance of existing wage standards in negotiations.

Moderate correlations with economic indicators like population (0.6), median household income (0.57), and median house price (0.52) indicate that wages are influenced by community economic conditions. In contrast, low correlations with poverty (-0.18) and crime ratio (0.20) suggest these factors are less significant.

The findings suggest negotiation teams should leverage data from the dashboard to advocate for fair wages, emphasizing local economic conditions and prioritizing variables like median household income. Promoting diversity within the police force is also recommended to positively impact wage negotiations. Overall, the analysis underscores the value of data-driven insights in advocating for equitable compensation for officers in Montana.


<br>
<hr>
<br>

# References

Carabetta, G. (2025). Collective Bargaining for Police and Other Essential Services (First edition.). Routledge.

Jeremy M Wilson, Clifford A Grammich, Terry Cherry, Anthony Gibson, Police Retention: A Systematic Review of the Research, Policing: A Journal of Policy and Practice, Volume 17, 2023, paac117, https://doi-org.ezproxy1.lib.asu.edu/10.1093/police/paac117

Labor Relations Information System. (2025). Labor contract library. LRIS. https://lris.com/labor-contract-library/

Montana Board of Crime Control. (2025, April). Statistical Analysis Center: Crime in Montana, Reported offenses & clearance rates. https://dataportal.mt.gov/t/MBCC/views/CIM-DecennialAgencyOffenseClearanceRates/Dash_AgencyDecennialOverview?iframeSizedToWindow=true&%3Aembed=y&%3AshowAppBanner=false&%3Adisplay_count=n&%3AshowVizHome=n&%3Aorigin=viz_share_link

Montana Police Protective Association. (2021). Montana Police Protective Association. https://www.montanapolice.org/ 

Montana Police Protective Association. (2025, June). Montana police protective association: Annual report.

North American Community Hub Statistics. (2025). Montana population. NCHS Stats. https://nchstats.com/montana-population/

Police Officers – Strikes Prohibited – Binding Arbitration, Montana Code Annotated MCA 39-31-501 – 39-31-505. (2023). https://archive.legmt.gov/bills/mca/title_0390/chapter_0310/part_0050/sections_index.html
Skaggs, S. L., Harris, C., & Montgomery, L. (2022). The impact of police–community relations: Recruitment and retention concerns of local police agencies. Policing : A Journal of Policy and Practice, 16(3), 462–475. https://doi.org/10.1093/police/paac029

U.S. Census Bureau. (2025). QuickFacts. U.S. Census Bureau. https://www.census.gov/quickfacts/fact/table



## R Versions

Analyses were conducted using the R Statistical language (version 4.4.1;
R Core Team, 2024) on Windows 10 x64 (build 26100)

## R Packages

The following R packages were used in the MPAID project:

-Xie Y, Cheng J, Tan X (2024). _DT: A Wrapper of the JavaScript Library
  'DataTables'_. R package version 0.33,
  <https://CRAN.R-project.org/package=DT>.

-C. Sievert. Interactive Web-Based Data Visualization with R, plotly,
  and shiny. Chapman and Hall/CRC Florida, 2020.

-H. Wickham. ggplot2: Elegant Graphics for Data Analysis.
  Springer-Verlag New York, 2016.

-Wilke C, Wiernik B (2022). _ggtext: Improved Text Rendering Support for
  'ggplot2'_. R package version 0.1.2,
  <https://CRAN.R-project.org/package=ggtext>.

-Kassambara A (2023). _ggcorrplot: Visualization of a Correlation Matrix
  using 'ggplot2'_. R package version 0.1.4.1,
  <https://CRAN.R-project.org/package=ggcorrplot>.

-Becker OScbRA, Minka ARWRvbRBEbTP, Deckmyn. A (2024). _maps: Draw
  Geographical Maps_. R package version 3.4.2.1,
  <https://CRAN.R-project.org/package=maps>.

-Walker K (2024). _tigris: Load Census TIGER/Line Shapefiles_. R package
  version 2.1, <https://CRAN.R-project.org/package=tigris>.

-Cheng J, Schloerke B, Karambelkar B, Xie Y (2024). _leaflet: Create
  Interactive Web Maps with the JavaScript 'Leaflet' Library_. R package
  version 2.2.2, <https://CRAN.R-project.org/package=leaflet>.

-Wickham H (2023). _conflicted: An Alternative Conflict Resolution
  Strategy_. R package version 1.2.0,
  <https://CRAN.R-project.org/package=conflicted>.

-Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J,
  McPherson J, Dipert A, Borges B (2024). _shiny: Web Application
  Framework for R_. R package version 1.9.1,
  <https://CRAN.R-project.org/package=shiny>.

-Chang W, Borges Ribeiro B (2025). _shinydashboard: Create Dashboards
  with 'Shiny'_. R package version 0.7.3,
  <https://CRAN.R-project.org/package=shinydashboard>.

-Wickham H, Bryan J (2023). _readxl: Read Excel Files_. R package
  version 1.4.3, <https://CRAN.R-project.org/package=readxl>.

-Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A
  Grammar of Data Manipulation_. R package version 1.1.4,
  <https://CRAN.R-project.org/package=dplyr>.

-Pebesma, E., & Bivand, R. (2023). Spatial Data Science: With
  Applications in R. Chapman and Hall/CRC.
  https://doi.org/10.1201/9780429459016

-Pebesma, E., 2018. Simple Features for R: Standardized Support for
  Spatial Vector Data. The R Journal 10 (1), 439-446,
  https://doi.org/10.32614/RJ-2018-009

-Xie Y (2024). _knitr: A General-Purpose Package for Dynamic Report
  Generation in R_. R package version 1.49, <https://yihui.org/knitr/>.

-Yihui Xie (2015) Dynamic Documents with R and knitr. 2nd edition.
  Chapman and Hall/CRC. ISBN 978-1498716963

-Yihui Xie (2014) knitr: A Comprehensive Tool for Reproducible Research
  in R. In Victoria Stodden, Friedrich Leisch and Roger D. Peng, editors,
  Implementing Reproducible Computational Research. Chapman and Hall/CRC.
  ISBN 978-1466561595

-Allaire J, Xie Y, Dervieux C, McPherson J, Luraschi J, Ushey K, Atkins
  A, Wickham H, Cheng J, Chang W, Iannone R (2024). _rmarkdown: Dynamic
  Documents for R_. R package version 2.28,
  <https://github.com/rstudio/rmarkdown>.

-Xie Y, Allaire J, Grolemund G (2018). _R Markdown: The Definitive
  Guide_. Chapman and Hall/CRC, Boca Raton, Florida. ISBN 9781138359338,
  <https://bookdown.org/yihui/rmarkdown>.

-Xie Y, Dervieux C, Riederer E (2020). _R Markdown Cookbook_. Chapman
  and Hall/CRC, Boca Raton, Florida. ISBN 9780367563837,
  <https://bookdown.org/yihui/rmarkdown-cookbook>.

-Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R,
  Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E,
  Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi
  K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the
  tidyverse.” _Journal of Open Source Software_, *4*(43), 1686.
  doi:10.21105/joss.01686 <https://doi.org/10.21105/joss.01686>.



## License

  This project uses the MIT License for reproducibility. For more info, check out the license [here.](https://choosealicense.com/licenses/mit/)
