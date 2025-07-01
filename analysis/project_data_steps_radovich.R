#
# Author:     Drew Radovich
# Date:       "{r} Sys Date"
# Purpose:    Create custom functions to process data for SVI Tax Credit Project
#

# Library ----
library(here)
library(tidyverse)
library(stringi)
library(kableExtra)
library(tidycensus)


# Variables ----
author <- "Drew Radovich"
census_division <- "Pacific Division"
region <- "West Region"
state <- "WA"
county <- "King County"
person_icon = "\uf183"
house_icon = "\uf015"
car_icon = "\uf1b9"
parent_icon = "\ue53a"
health_icon = "\uf80d"
groupqtr_icon = "\uf1ad"

# Data ----

#Load US Census region data
census_regions <- readxl::read_excel(here::here("data/raw/Census_Data_SVI/census_regions.xlsx"))
colnames(census_regions) <- colnames(census_regions) %>% tolower()

# Load FIPS codes from TidyCensus
fips <- tidycensus::fips_codes

# Join FIPS codes to regions data
fips_census_regions <- left_join(fips, census_regions, join_by("state" == "state"))

# Functions ----

# Create fips region assignment function
fips_region_assignment <- function(df) {
  
  
  # Create columns with fips codes for df
  df <- df %>% mutate(FIPS_st = substr(GEOID_2010_trt, 1, 2),
                      FIPS_county = substr(GEOID_2010_trt, 3, 5),
                      FIPS_tract = substr(GEOID_2010_trt, 6, 11)) %>%
    relocate(c(FIPS_st, FIPS_county, FIPS_tract),.after = GEOID_2010_trt)
  
  
  # Join region data 
  df <- left_join(df, fips_census_regions, join_by("FIPS_st" == "state_code",
                                                   "FIPS_county" == "county_code")) %>%
    relocate(c(state, state_name, county, region_number, region, division_number, division),.after = FIPS_tract)
  
  # Output data frame  
  return(df)
}



# Create rank_variables function
rank_variables <- function(df, rank_by="national", location=NULL, state_abbr=NULL) {
  
  # Search column names for our estimated percentile columns
  epl_cols <- colnames(df) %>% str_detect("^EPL_")
  # Select these from all column names
  epl_cols_names <- colnames(df)[epl_cols]
  
  
  if (tolower(rank_by) == "regional") {
    # Create estimated percentile rankings on a regional level, with 4 significant digits
    location <- tolower(location)
    for (epl in epl_cols_names) {
      epct <- str_replace(epl, "EPL_", "EP_")
      df2 <- df %>% 
        filter(tolower(region) == location) %>%
        filter(!is.na(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := rank(!!as.name(epct))/length(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := signif(!!as.name(epl), 4)) %>% select(GEOID_2010_trt,
                                                                       !!as.name(epl))
      df3 <- df  %>% 
        filter(tolower(region) == location) %>%
        select(-quote(!!as.name(epl)))
      
      df <- left_join(df3, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
        relocate(c(!!as.name(epl)),.after = !!as.name(epct))
    }
  } else if (tolower(rank_by) == "divisional") {
    # Create estimated percentile rankings on a divisional level, with 4 significant digits
    location <- tolower(location)
    for (epl in epl_cols_names) {
      epct <- str_replace(epl, "EPL_", "EP_")
      df2 <- df %>% 
        filter(tolower(division) == location) %>%
        filter(!is.na(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := rank(!!as.name(epct))/length(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := signif(!!as.name(epl), 4)) %>% select(GEOID_2010_trt,
                                                                       !!as.name(epl))
      df3 <- df  %>% 
        filter(tolower(division) == location) %>% 
        select(-quote(!!as.name(epl)))
      
      df <- left_join(df3, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
        relocate(c(!!as.name(epl)),.after = !!as.name(epct))
    }
  } else if (tolower(rank_by) == "state") {
    # Create estimated percentile rankings on a state level, with 4 significant digits
    location <- tolower(location)
    for (epl in epl_cols_names) {
      epct <- str_replace(epl, "EPL_", "EP_")
      df2 <- df %>% 
        filter(tolower(state) == location) %>%
        filter(!is.na(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := rank(!!as.name(epct))/length(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := signif(!!as.name(epl), 4)) %>% select(GEOID_2010_trt,
                                                                       !!as.name(epl))
      df3 <- df  %>% 
        filter(tolower(state) == location) %>% 
        select(-quote(!!as.name(epl)))
      
      df <- left_join(df3, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
        relocate(c(!!as.name(epl)),.after = !!as.name(epct))
    }
  } else if (tolower(rank_by) == "county") {
    # Create estimated percentile rankings on a county level, require a state selection as 
    # county names are not unique outside of states, with 4 significant digits
    if (is.null(state_abbr)) {
      print("Enter state abbreviation in function and re-try")
      df <- NULL
    } else {
      location <- tolower(location)
      state_abbr <- tolower(state_abbr)
      for (epl in epl_cols_names) {
        epct <- str_replace(epl, "EPL_", "EP_")
        df2 <- df %>% 
          filter(tolower(state) == state_abbr) %>% 
          filter(tolower(county) == location) %>% 
          filter(!is.na(!!as.name(epct))) %>%
          mutate(!!as.name(epl) := rank(!!as.name(epct))/length(!!as.name(epct))) %>%
          mutate(!!as.name(epl) := signif(!!as.name(epl), 4)) %>% select(GEOID_2010_trt,
                                                                         !!as.name(epl))
        df3 <- df  %>% 
          filter(tolower(state) == state_abbr) %>% 
          filter(tolower(county) == location) %>% 
          select(-quote(!!as.name(epl)))
        
        df <- left_join(df3, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
          relocate(c(!!as.name(epl)),.after = !!as.name(epct))
        
        
      }
    }
  } else {
    # If no lower level region is selected, create percentiles on a national level, with 4 significant digits
    for (epl in epl_cols_names) {
      epct <- str_replace(epl, "EPL_", "EP_")
      df2 <- df %>%
        filter(!is.na(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := rank(!!as.name(epct))/length(!!as.name(epct))) %>%
        mutate(!!as.name(epl) := signif(!!as.name(epl), 4)) %>% select(GEOID_2010_trt,
                                                                       !!as.name(epl))
      df3 <- df  %>% 
        select(-quote(!!as.name(epl)))
      
      df <- left_join(df3, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
        relocate(c(!!as.name(epl)),.after = !!as.name(epct))
    }
  }
  # Output ranked df
  return(df)
}


# Create theme variables function
svi_theme_variables <- function(df) {
  
  # Sum of Theme1: Socioeconomic Status Percentiles
  SES_cols <- colnames(df) %>% str_detect("EPL_POV|EPL_UNEMP|EPL_HBURD_[0-9]|EPL_NOHSDP|EPL_UNINSUR")
  
  SES_select <- colnames(df)[SES_cols]
  
  SES <- paste0(SES_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(SES)) %>% mutate(SPL_THEME1 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, SPL_THEME1)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Ranking for Theme1: Socioeconomic Status Percentiles with 4 significant digits
  
  df <- df %>% 
    mutate(RPL_THEME1 = rank(SPL_THEME1)/length(SPL_THEME1)) %>%
    mutate(RPL_THEME1 = signif(RPL_THEME1, 4))
  
  # Sum of Theme2: Household Characteristics
  
  HHchar_cols <- colnames(df) %>% str_detect("EPL_AGE65|EPL_AGE17|EPL_DISABL|EPL_SNGPNT|EPL_LIMENG")
  
  HHchar_select <- colnames(df)[HHchar_cols]
  
  HHchar <- paste0(HHchar_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(HHchar)) %>% mutate(SPL_THEME2 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, SPL_THEME2)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Ranking for Theme2: Household Characteristics
  
  df <- df %>% 
    mutate(RPL_THEME2 = rank(SPL_THEME2)/length(SPL_THEME2)) %>%
    mutate(RPL_THEME2 = signif(RPL_THEME2, 4))
  
  
  # Sum of Theme3: Racial & Ethnic Minority Status
  
  REM_cols <- colnames(df) %>% str_detect("EPL_MINRTY")
  
  REM_select <- colnames(df)[REM_cols]
  
  REM <- paste0(REM_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(REM)) %>% mutate(SPL_THEME3 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, SPL_THEME3)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Ranking for Theme3: Racial & Ethnic Minority Status
  
  df <- df %>% 
    mutate(RPL_THEME3 = rank(SPL_THEME3)/length(SPL_THEME3)) %>%
    mutate(RPL_THEME3 = signif(RPL_THEME3, 4))
  
  
  # Sum of Theme4: Housing Type & Transportation
  
  HTT_cols <- colnames(df) %>% str_detect("EPL_MUNIT|EPL_MOBILE|EPL_CROWD|EPL_NOVEH|EPL_GROUPQ")
  
  HTT_select <- colnames(df)[HTT_cols]
  
  HTT <- paste0(HTT_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(HTT)) %>% mutate(SPL_THEME4 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, SPL_THEME4)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Ranking for Theme4: Housing Type & Transportation
  
  df <- df %>% 
    mutate(RPL_THEME4 = rank(SPL_THEME4)/length(SPL_THEME4)) %>%
    mutate(RPL_THEME4 = signif(RPL_THEME4, 4))
  
  # Sum for All Themes
  SPL_cols <- colnames(df) %>% str_detect("SPL_THEME")
  
  SPL_select <- colnames(df)[SPL_cols]
  
  SPL <- paste0(SPL_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(SPL)) %>% mutate(SPL_THEMES = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, SPL_THEMES)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Ranking for All These
  
  df <- df %>% 
    mutate(RPL_THEMES = rank(SPL_THEMES)/length(SPL_THEMES)) %>%
    mutate(RPL_THEMES = signif(RPL_THEMES, 4))
  
  # Output data
  return(df)
  
}


# Create theme flags function
svi_theme_flags <- function(df, percentile) {
  
  # Search column names for our estimated percentile columns
  epl_cols <- colnames(df) %>% str_detect("^EPL_")
  # Select these from all column names
  epl_cols_names <- colnames(df)[epl_cols]
  
  for (epl in epl_cols_names) {
    eflg <- str_replace(epl, "EPL_", "F_")
    df <- df %>%
      mutate(!!as.name(eflg) := if_else(!!as.name(epl) > percentile, 1, 0)) %>%
      relocate(c(!!as.name(eflg)),.after = !!as.name(epl))
  }
  
  # Find flags by category, sum
  
  # Sum of Theme1 Flags: Socioeconomic Status
  SES_cols <- colnames(df) %>% str_detect("F_POV|F_UNEMP|F_HBURD_[0-9]|F_NOHSDP|F_UNINSUR")
  
  SES_select <- colnames(df)[SES_cols]
  
  SES <- paste0(SES_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(SES)) %>% mutate(F_THEME1 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, F_THEME1)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
    relocate(c(F_THEME1),.after = RPL_THEME1) 
  
  
  # Sum of Theme2 Flags: Household Characteristics
  
  HHchar_cols <- colnames(df) %>% str_detect("F_AGE65|F_AGE17|F_DISABL|F_SNGPNT|F_LIMENG")
  
  HHchar_select <- colnames(df)[HHchar_cols]
  
  HHchar <- paste0(HHchar_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(HHchar)) %>% mutate(F_THEME2 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, F_THEME2)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))  %>%
    relocate(c(F_THEME2),.after = RPL_THEME2) 
  
  
  # Sum of Theme3 Flags: Household Characteristics
  
  REM_cols <- colnames(df) %>% str_detect("F_MINRTY")
  
  REM_select <- colnames(df)[REM_cols]
  
  REM <- paste0(REM_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(REM)) %>% mutate(F_THEME3 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, F_THEME3)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))  %>%
    relocate(c(F_THEME3),.after = RPL_THEME3) 
  
  # Sum of Theme4 Flags: Housing Type & Transportation
  
  HTT_cols <- colnames(df) %>% str_detect("F_MUNIT|F_MOBILE|F_CROWD|F_NOVEH|F_GROUPQ")
  
  HTT_select <- colnames(df)[HTT_cols]
  
  HTT <- paste0(HTT_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(HTT)) %>% mutate(F_THEME4 = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, F_THEME4) 
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt")) %>%
    relocate(c(F_THEME4),.after = RPL_THEME4) 
  
  # Sum of all theme flags
  
  THEME_cols <- colnames(df) %>% str_detect("F_THEME")
  
  THEME_select <- colnames(df)[THEME_cols]
  
  THEME <- paste0(THEME_select)
  
  df2 <- df %>% select(GEOID_2010_trt, all_of(THEME)) %>% mutate(F_TOTAL = rowSums(across(where(is.numeric)))) %>% select(GEOID_2010_trt, F_TOTAL)
  
  df <- left_join(df, df2, join_by("GEOID_2010_trt" == "GEOID_2010_trt"))
  
  # Return data
  return(df)
}


# Process data ----

load_svi_data <- function(df, rank_by="national", location=NULL, state_abbr=NULL, percentile=.90) {
  
  df <- fips_region_assignment(df)
  df <- rank_variables(df, rank_by, location, state_abbr)
  df <- svi_theme_variables(df)
  df <- svi_theme_flags(df, percentile)
  return(df)
}


# Merge SVI data periods ----

merge_svi_data <- function(df10, df20) {
  
  joint_tracts <- dplyr::intersect(df10$GEOID_2010_trt, df20$GEOID_2010_trt) %>% tibble()
  colnames(joint_tracts) <- "GEOID_2010_trt"
  
  svi_merged <- left_join(joint_tracts, df10, join_by("GEOID_2010_trt" == "GEOID_2010_trt" ))
  
  df20 <- df20 %>% select(!c(colnames(df20)[2:11]))
  
  svi_merged <- left_join(svi_merged, df20, join_by("GEOID_2010_trt" == "GEOID_2010_trt" ))
  
  colnames(svi_merged) <- str_replace(colnames(svi_merged), "\\.x", "_10")
  
  colnames(svi_merged) <- str_replace(colnames(svi_merged), "\\.y", "_20") 
  
  return(svi_merged)
}

# Calculate SVI variable percentages ----

svi_percentages10 <- function(df, division_name) {
  df_out <- 
    df %>% 
    filter(!is.na(ET_INSURSTATUS_12)) %>%
    summarise(
      division = division_name,
      year = 2010,
      `pct in poverty` = round(sum(E_POV150_10)/sum(ET_POVSTATUS_10)*100),
      `pct not in poverty` = round(((sum(ET_POVSTATUS_10) - sum(E_POV150_10))/sum(ET_POVSTATUS_10))*100),
      `pct unemployed` = round(sum(E_UNEMP_10)/sum(ET_EMPSTATUS_10)*100),
      `pct employed` = round(((sum(ET_EMPSTATUS_10) - sum(E_UNEMP_10))/sum(ET_EMPSTATUS_10))*100),
      `pct housing cost-burdened` = round(sum(E_HBURD_10)/sum(ET_HOUSINGCOST_10)*100),
      `pct not housing cost-burdened` = round(((sum(ET_HOUSINGCOST_10) - sum(E_HBURD_10))/sum(ET_HOUSINGCOST_10))*100),
      `pct adults without high school diploma` = round(sum(E_NOHSDP_10)/sum(ET_EDSTATUS_10)*100),
      `pct adults with high school diploma` = round(((sum(ET_EDSTATUS_10) - sum(E_NOHSDP_10))/sum(ET_EDSTATUS_10))*100),
      `pct age 17 & under` = round(sum(E_AGE17_10)/sum(E_TOTPOP_10)*100),
      `pct age 18-64` = round(((sum(E_TOTPOP_10) - sum(E_AGE17_10, E_AGE65_10))/sum(E_TOTPOP_10))*100),
      `pct age 65+` = round(sum(E_AGE65_10)/sum(E_TOTPOP_10)*100),
      `pct single parent families` = round(sum(E_SNGPNT_10)/sum(ET_FAMILIES_10)*100),
      `pct other families` = round(((sum(ET_FAMILIES_10) - sum(E_SNGPNT_10))/sum(ET_FAMILIES_10))*100),
      `pct limited English speakers` = round(sum(E_LIMENG_10)/sum(ET_POPAGE5UP_10)*100),
      `pct proficient English speakers` = round(((sum(ET_POPAGE5UP_10) - sum(E_LIMENG_10))/sum(ET_POPAGE5UP_10))*100),
      `pct Minority race/ethnicity` = round(sum(E_MINRTY_10)/sum(ET_POPETHRACE_10)*100),
      `pct Non-Hispanic White race/ethnicity` = round(((sum(ET_POPETHRACE_10) - sum(E_MINRTY_10))/sum(ET_POPETHRACE_10))*100),
      `pct in multi-unit housing` = round(sum(E_MUNIT_10)/sum(E_STRHU_10)*100),
      `pct in mobile housing` = round(sum(E_MOBILE_10)/sum(E_STRHU_10)*100),
      `pct in other housing` = (100 - sum(round(sum(E_MUNIT_10)/sum(E_STRHU_10)*100), round(sum(E_MOBILE_10)/sum(E_STRHU_10)*100))),
      `pct in crowded living spaces` = round(sum(E_CROWD_10)/sum(ET_OCCUPANTS_10)*100),
      `pct in non-crowded living spaces` = round(((sum(ET_OCCUPANTS_10) - sum(E_CROWD_10))/sum(ET_OCCUPANTS_10))*100),
      `pct with no vehicle access` = round(sum(E_NOVEH_10)/sum(ET_KNOWNVEH_10)*100),
      `pct with vehicle access` = round(((sum(ET_KNOWNVEH_10) - sum(E_NOVEH_10))/sum(ET_KNOWNVEH_10))*100),
      `pct in group living quarters` = round(sum(E_GROUPQ_10)/sum(ET_HHTYPE_10)*100),
      `pct not in group living quarters` = round(((sum(ET_HHTYPE_10) - sum(E_GROUPQ_10))/sum(ET_HHTYPE_10))*100),
      `pct without health insurance` = round(sum(E_UNINSUR_12)/sum(ET_INSURSTATUS_12)*100),
      `pct with health insurance` = round(((sum(ET_INSURSTATUS_12) - sum(E_UNINSUR_12))/sum(ET_INSURSTATUS_12))*100),
      `pct disabled civilians` = round(sum(E_DISABL_12)/sum(ET_DISABLSTATUS_12)*100),
      `pct not disabled civilians` = round(((sum(ET_DISABLSTATUS_12) - sum(E_DISABL_12))/sum(ET_DISABLSTATUS_12))*100)
    )
  return(df_out)
}


svi_percentages20 <- function(df, division_name) {
  df_out <-  df %>% 
    summarise(
      division = division_name,
      year = 2020,
      `pct in poverty` = round(sum(E_POV150_20)/sum(ET_POVSTATUS_20)*100),
      `pct not in poverty` = round(((sum(ET_POVSTATUS_20) - sum(E_POV150_20))/sum(ET_POVSTATUS_20))*100),
      `pct unemployed` = round(sum(E_UNEMP_20)/sum(ET_EMPSTATUS_20)*100),
      `pct employed` = round(((sum(ET_EMPSTATUS_20) - sum(E_UNEMP_20))/sum(ET_EMPSTATUS_20))*100),
      `pct housing cost-burdened` = round(sum(E_HBURD_20)/sum(ET_HOUSINGCOST_20)*100),
      `pct not housing cost-burdened` = round(((sum(ET_HOUSINGCOST_20) - sum(E_HBURD_20))/sum(ET_HOUSINGCOST_20))*100),
      `pct adults without high school diploma` = round(sum(E_NOHSDP_20)/sum(ET_EDSTATUS_20)*100),
      `pct adults with high school diploma` = round(((sum(ET_EDSTATUS_20) - sum(E_NOHSDP_20))/sum(ET_EDSTATUS_20))*100),
      `pct age 17 & under` = round(sum(E_AGE17_20)/sum(E_TOTPOP_20)*100),
      `pct age 18-64` = round(((sum(E_TOTPOP_20) - sum(E_AGE17_20, E_AGE65_20))/sum(E_TOTPOP_20))*100),
      `pct age 65+` = round(sum(E_AGE65_20)/sum(E_TOTPOP_20)*100),
      `pct single parent families` = round(sum(E_SNGPNT_20)/sum(ET_FAMILIES_20)*100),
      `pct other families` = round(((sum(ET_FAMILIES_20) - sum(E_SNGPNT_20))/sum(ET_FAMILIES_20))*100),
      `pct limited English speakers` = round(sum(E_LIMENG_20)/sum(ET_POPAGE5UP_20)*100),
      `pct proficient English speakers` = round(((sum(ET_POPAGE5UP_20) - sum(E_LIMENG_20))/sum(ET_POPAGE5UP_20))*100),
      `pct Minority race/ethnicity` = round(sum(E_MINRTY_20)/sum(ET_POPETHRACE_20)*100),
      `pct Non-Hispanic White race/ethnicity` = round(((sum(ET_POPETHRACE_20) - sum(E_MINRTY_20))/sum(ET_POPETHRACE_20))*100),
      `pct in multi-unit housing` = round(sum(E_MUNIT_20)/sum(E_STRHU_20)*100),
      `pct in mobile housing` = round(sum(E_MOBILE_20)/sum(E_STRHU_20)*100),
      `pct in other housing` = (100 - sum(round(sum(E_MUNIT_20)/sum(E_STRHU_20)*100), round(sum(E_MOBILE_20)/sum(E_STRHU_20)*100))),
      `pct in crowded living spaces` = round(sum(E_CROWD_20)/sum(ET_OCCUPANTS_20)*100),
      `pct in non-crowded living spaces` = round(((sum(ET_OCCUPANTS_20) - sum(E_CROWD_20))/sum(ET_OCCUPANTS_20))*100),
      `pct with no vehicle access` = round(sum(E_NOVEH_20)/sum(ET_KNOWNVEH_20)*100),
      `pct with vehicle access` = round(((sum(ET_KNOWNVEH_20) - sum(E_NOVEH_20))/sum(ET_KNOWNVEH_20))*100),
      `pct in group living quarters` = round(sum(E_GROUPQ_20)/sum(ET_HHTYPE_20)*100),
      `pct not in group living quarters` = round(((sum(ET_HHTYPE_20) - sum(E_GROUPQ_20))/sum(ET_HHTYPE_20))*100),
      `pct without health insurance` = round(sum(E_UNINSUR_20)/sum(ET_INSURSTATUS_20)*100),
      `pct with health insurance` = round(((sum(ET_INSURSTATUS_20) - sum(E_UNINSUR_20))/sum(ET_INSURSTATUS_20))*100),
      `pct disabled civilians` = round(sum(E_DISABL_20)/sum(ET_DISABLSTATUS_20)*100),
      `pct not disabled civilians` = round(((sum(ET_DISABLSTATUS_20) - sum(E_DISABL_20))/sum(ET_DISABLSTATUS_20))*100)
    )
  return(df_out)
}

# Waffle Charts ----

waffle_charts <- function(svi_pcts, var_search, fa_icon, filter_year1, title_label_div_year1, title_label_usa_year1, filter_year2, title_label_div_year2, title_label_usa_year2, census_division) {
  
  # Filter data  to find columns by var_search keyword, select all columns with keyword, count number of columns
  cols <- tolower(colnames(svi_pcts)) %>% str_detect(tolower(var_search))
  cols_select <- colnames(svi_pcts)[cols]
  n_cols_select <- length(cols_select)
  
  # Set color palette for visualizations
  one_color_palette <- c("#960018", "#91A3B0")
  two_color_palette <- c("#7BA05B", "#E23D28", "#91A3B0")
  three_color_palette <- c("#003262", "#91A3B0" , "#960018", "#ED9121")
  
  
  if (n_cols_select == 2) {
    color_palette <- one_color_palette
  } else if (n_cols_select == 3 & var_search != "age") {
    color_palette <- two_color_palette
  } else {
    color_palette <- three_color_palette
  }
  
  # Division Year1
  svidf <- svi_pcts %>% filter(division == census_division & year == filter_year1) %>% select(all_of(cols_select))
  
  # Create 10x10 grid and then display variables of interests' categories the number of times they appear in data to total to 100
  # For example, for group quarters, the code repeats group quarters 2 times and non-group quarters 98 times
  # for 2020 national data for plotting
  df <- expand.grid(y = 1:10, x = 1:10)
  df$category<-factor(rep(names(svidf),svidf), levels=names(svidf))
  
  # Pull in downloaded fontawesome font to display font awesome icons in graphic
  font_add(family = "FontAwesome", regular = here::here("resources/fontawesome-free-6.5.1-web/webfonts/fa-solid-900.ttf"))
  showtext_auto(T)
  p1 <- ggplot(df, aes(x = y, y = x, color=category)) +
    geom_text(label = fa_icon,
              family = 'FontAwesome',
              size = 6) +
    scale_color_manual(values = color_palette) +
    coord_fixed(ratio = 1) + 
    scale_x_continuous(expand = c(0.1, 0.1)) +
    scale_y_continuous(expand = c(0.1, 0.1),trans = 'reverse') +
    theme(
      panel.background = element_blank(),
      plot.title = element_text(size = 22, hjust = 0),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.title = element_blank(),
      legend.position = "right",
      legend.key = element_rect(colour = NA, fill = NA),
      legend.key.size = unit(1.5, "cm"),
      legend.text = element_text(size = rel(1.2))) +
    guides(fill = guide_legend(byrow = TRUE)) +
    labs(title=title_label_div_year1) 
  
  
  # Division Year2
  svidf <- svi_pcts %>% filter(division == census_division & year == filter_year2) %>% select(all_of(cols_select))
  
  # Create 10x10 grid and then display variables of interests' categories the number of times they appear in data to total to 100
  # For example, for group quarters, the code repeats group quarters 2 times and non-group quarters 98 times
  # for 2020 national data for plotting
  df <- expand.grid(y = 1:10, x = 1:10)
  df$category<-factor(rep(names(svidf),svidf), levels=names(svidf))
  
  # Pull in downloaded fontawesome font to display font awesome icons in graphic
  font_add(family = "FontAwesome", regular = here::here("resources/fontawesome-free-6.5.1-web/webfonts/fa-solid-900.ttf"))
  showtext_auto(T)
  p2 <- ggplot(df, aes(x = y, y = x, color=category)) +
    geom_text(label = fa_icon,
              family = 'FontAwesome',
              size = 6) +
    scale_color_manual(values = color_palette) +
    coord_fixed(ratio = 1) + 
    scale_x_continuous(expand = c(0.1, 0.1)) +
    scale_y_continuous(expand = c(0.1, 0.1),trans = 'reverse') +
    theme(
      panel.background = element_blank(),
      plot.title = element_text(size = 22, hjust = 0),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.title = element_blank(),
      legend.position = "right",
      legend.key = element_rect(colour = NA, fill = NA),
      legend.key.size = unit(1.5, "cm"),
      legend.text = element_text(size = rel(1.2)) ) +
    guides(fill = guide_legend(byrow = TRUE)) +
    labs(title=title_label_div_year2) 
  
  
  # National Year1
  svidf <- svi_pcts %>% filter(division != census_division & year == filter_year1) %>% select(all_of(cols_select))
  
  # Create 10x10 grid and then display variables of interests' categories the number of times they appear in data to total to 100
  # For example, for group quarters, the code repeats group quarters 2 times and non-group quarters 98 times
  # for 2020 national data for plotting
  df <- expand.grid(y = 1:10, x = 1:10)
  df$category<-factor(rep(names(svidf),svidf), levels=names(svidf))
  
  # Pull in downloaded fontawesome font to display font awesome icons in graphic
  font_add(family = "FontAwesome", regular = here::here("resources/fontawesome-free-6.5.1-web/webfonts/fa-solid-900.ttf"))
  showtext_auto(T)
  p3 <- ggplot(df, aes(x = y, y = x, color=category)) +
    geom_text(label = fa_icon,
              family = 'FontAwesome',
              size = 6) +
    scale_color_manual(values = color_palette) +
    coord_fixed(ratio = 1) + 
    scale_x_continuous(expand = c(0.1, 0.1)) +
    scale_y_continuous(expand = c(0.1, 0.1),trans = 'reverse') +
    theme(
      panel.background = element_blank(),
      plot.title = element_text(size = 22, hjust = 0),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.title = element_blank(),
      legend.position = "right",
      legend.key = element_rect(colour = NA, fill = NA),
      legend.key.size = unit(1.5, "cm"),
      legend.text = element_text(size = rel(1.2)) ) +
    guides(fill = guide_legend(byrow = TRUE)) +
    labs(title=title_label_usa_year1) 
  
  
  # National Year2
  svidf <- svi_pcts %>% filter(division != census_division & year == filter_year2) %>% select(all_of(cols_select))
  
  # Create 10x10 grid and then display variables of interests' categories the number of times they appear in data to total to 100
  # For example, for group quarters, the code repeats group quarters 2 times and non-group quarters 98 times
  # for 2020 national data for plotting
  df <- expand.grid(y = 1:10, x = 1:10)
  df$category<-factor(rep(names(svidf),svidf), levels=names(svidf))
  
  # Pull in downloaded fontawesome font to display font awesome icons in graphic
  font_add(family = "FontAwesome", regular = here::here("resources/fontawesome-free-6.5.1-web/webfonts/fa-solid-900.ttf"))
  showtext_auto(T)
  p4 <- ggplot(df, aes(x = y, y = x, color=category)) +
    geom_text(label = fa_icon,
              family = 'FontAwesome',
              size = 6) +
    scale_color_manual(values = color_palette) +
    coord_fixed(ratio = 1) + 
    scale_x_continuous(expand = c(0.1, 0.1)) +
    scale_y_continuous(expand = c(0.1, 0.1),trans = 'reverse') +
    theme(
      panel.background = element_blank(),
      plot.title = element_text(size = 22, hjust = 0),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank(),
      legend.title = element_blank(),
      legend.position = "right",
      legend.key = element_rect(colour = NA, fill = NA),
      legend.key.size = unit(1.5, "cm"),
      legend.text = element_text(size = rel(1.2)) ) +
    guides(fill = guide_legend(byrow = TRUE)) +
    labs(title=title_label_usa_year2) 
  
  # Create list of all plots
  plotlist = list(p1, p2, p3, p4)
  
  return(plotlist)
}

# Flag Summary
flag_summarize <- function (df, pop_var) {
  df_flags <- df %>% 
    filter(!is.na(F_TOTAL)) %>% 
    group_by(FIPS_st, FIPS_county) %>% 
    mutate(flag_count = sum(F_TOTAL),
           pop = sum(!!as.name(pop_var)),
           flag_by_pop = flag_count/pop) %>% 
    select(FIPS_st, FIPS_county, state, state_name, county, region_number, region, division_number, division, flag_count, pop, flag_by_pop) %>% 
    unique()
  
  # Assign counts to quantiles
  df_flags <- df_flags %>% 
    mutate(
      flag_count_quantile = cut(flag_count,quantile(df_flags$flag_count, probs = seq(0, 1, .2)),include.lowest=TRUE,labels=FALSE),
      flag_pop_quantile = cut(flag_by_pop,quantile(df_flags$flag_by_pop, probs = seq(0, 1, .2)),include.lowest=TRUE,labels=FALSE) ) %>%
    # Convert quantiles to ratios from .20 - 1
    mutate(flag_count_quantile = case_when(
      flag_count_quantile == 1 ~ .20,
      flag_count_quantile == 2 ~ .40,
      flag_count_quantile == 3 ~ .60,
      flag_count_quantile == 4 ~ .80,
      flag_count_quantile == 5 ~ 1
    )
    ) %>%
    # Convert quantiles to ratios from .20 - 1
    mutate(flag_pop_quantile = case_when(
      flag_pop_quantile == 1 ~ .20,
      flag_pop_quantile == 2 ~ .40,
      flag_pop_quantile == 3 ~ .60,
      flag_pop_quantile == 4 ~ .80,
      flag_pop_quantile == 5 ~ 1
    )
    )
  
  return(df_flags)
}

# Note that "\n" indicates a line break in HTML and will place the elements on different lines of our tooltip
# htmltools::htmlEscape(df$county, TRUE) encodes any special characters county names for HTML
map_tooltip <- function(df) {
  df$flag_pop_quantile_pct <- scales::percent(df$flag_pop_quantile, accuracy = 1)
  df$tooltip <- paste0(htmltools::htmlEscape(df$county, TRUE), ", ", df$state, "\n", 
                       "SVI Flags: ", prettyNum(df$flag_count, big.mark = ",", scientific = FALSE), "\n", 
                       "County Population: ", prettyNum(df$pop, big.mark = ",", scientific = FALSE), "\n", 
                       "SVI-Flag-to-Population Ratio (per 1,000): ", (round(df$flag_by_pop, 6)*1000), "\n",
                       "Quintile: ", df$flag_pop_quantile_pct)
  
  return(df)
}

choropleth_map <- function(df, fill_var, year_var) {
  gg_int <- ggplot() +
    # Make theme empty for customization
    theme_void() +
    # Set color palette
    scale_fill_gradient2(low = "#B9D9EB", high="#003262", labels = scales::label_percent()) +
    # Load interactive shapefile layer with county data
    geom_sf_interactive(data=df , aes(geometry=geometry, fill=!!as.name(fill_var), tooltip = tooltip, data_id = tooltip), size = 0.1) +
    # Load overall state outlines from state shapefiles, can update linewidth thickness to highlight outlines depending on size/spacing of states, .5 - 1.5 is usually a good range
    geom_sf(data=st_sf, color="white", fill=NA, linewidth=.5, aes(geometry=geometry)) +
    labs(title= paste0(year_var, " SVI Flag to Population Ratio", "\U2014", census_division),
         fill="Quintile")
  
  return(gg_int)
}

# County Level
summarize_county_nmtc <- function(df) {
  # Find count of new NMTC projects after 2010 by county
  county_nmtc_project_cnt <- aggregate(df$post10_nmtc_project_cnt,
                                       by=list(State=df$state,
                                               County=df$county,
                                               Division=df$division), 
                                       FUN=sum) %>% 
    arrange(State, County) %>%
    rename("post10_nmtc_project_cnt" = "x")
  
  # Find count of census tracts in each county
  county_nmtc_tracts <- aggregate(df$GEOID_2010_trt,
                                  by=list(State=df$state,
                                          County=df$county,
                                          Division=df$division), 
                                  FUN=length) %>% 
    mutate(tract_cnt = x) %>% 
    select (-x)
  
  # Find sum of NMTC project dollars in each county
  county_nmtc_dollars <- aggregate(df$post10_nmtc_dollars,
                                   by=list(State=df$state,
                                           County=df$county,
                                           Division=df$division), 
                                   FUN=sum) %>% 
    arrange(State, County) %>%
    rename("post10_nmtc_project_dollars" = "x")
  
  # Create character column with NMTC dollars formatted as currency
  county_nmtc_dollars$post10_nmtc_dollars_formatted <-
    scales::dollar_format()(county_nmtc_dollars$post10_nmtc_project_dollars)
  
  # Join project counts and census tract counts datasets
  county_nmtc0 <- left_join(county_nmtc_project_cnt, county_nmtc_tracts,
                            join_by("State" == "State",
                                    "County" == "County",
                                    "Division" == "Division"))
  
  # Add dollar amounts
  county_nmtc <- left_join(county_nmtc0, county_nmtc_dollars,
                           join_by("State" == "State",
                                   "County" == "County",
                                   "Division" == "Division"))
  
  # Output data
  return(county_nmtc)
}

# County LIHTC
summarize_county_lihtc <- function(df) {
  # Find count of new LIHTC projects after 2010 by county
  county_lihtc_project_cnt <- aggregate(df$post10_lihtc_project_cnt,
                                        by=list(State=df$state,
                                                County=df$county,
                                                Division=df$division), 
                                        FUN=sum) %>% 
    arrange(State, County) %>%
    rename("post10_lihtc_project_cnt" = "x")
  
  # Find count of census tracts in each county
  county_lihtc_tracts <- aggregate(df$GEOID_2010_trt,
                                   by=list(State=df$state,
                                           County=df$county,
                                           Division=df$division), 
                                   FUN=length) %>% 
    mutate(tract_cnt = x) %>% 
    select (-x)
  
  # Find sum of LIHTC project dollars in each county
  county_lihtc_dollars <- aggregate(df$post10_lihtc_project_dollars,
                                    by=list(State=df$state,
                                            County=df$county,
                                            Division=df$division), 
                                    FUN=sum) %>% 
    arrange(State, County) %>%
    rename("post10_lihtc_project_dollars" = "x")
  
  # Create character column with NMTC dollars formatted as currency
  county_lihtc_dollars$post10_lihtc_dollars_formatted <-
    scales::dollar_format()(county_lihtc_dollars$post10_lihtc_project_dollars)
  
  # Join project counts and census tract counts datasets
  county_lihtc0 <- left_join(county_lihtc_project_cnt, county_lihtc_tracts,
                             join_by("State" == "State",
                                     "County" == "County",
                                     "Division" == "Division"))
  
  # Add dollar amounts
  county_lihtc <- left_join(county_lihtc0, county_lihtc_dollars,
                            join_by("State" == "State",
                                    "County" == "County",
                                    "Division" == "Division"))
  
  # Output data
  return(county_lihtc)
}

# Elbow Plot ----
elbow_plot <- function(df) {
  
  # Code source: https://uc-r.github.io/kmeans_clustering
  
  # Repeats same outcome each time run
  set.seed(123)
  
  # function to compute total within-cluster sum of square 
  wss <- function(k) {
    print(k)
    kmeans(df, k, nstart = 10, iter.max=25  )$tot.withinss
  }
  
  # Compute and plot wss for k = 1 to k = 15 (or one less than nrow(15) if row count is <= 15)
  if (nrow(df) > 15) {
    k.values <- 1:15
    print(k.values)
  } else {
    end <- nrow(df)-1
    k.values <- 1:end
    print(k.values)
  }
  
  # extract wss for 2-15 clusters (or one less than nrow(15) if row count is <= 15)
  wss_values <- map_dbl(k.values, wss)
  
  plot(k.values, wss_values,
       type="b", pch = 19, frame = FALSE, 
       xlab="Number of clusters K",
       ylab="Total within-clusters sum of squares")  
}

# Slopegraph Plot ----

slopegraph_plot <- function(df, status1_label, status2_label, title_label, subtitle_label) {
  # Plot
  ggplot(df, aes(
    x = year,
    y = outcome,
    group = status
  )) +
    geom_line(
      linewidth = 0.75,
      color = "steelblue",
      lineend = "round"
    ) +
    geom_text_repel(
      data = df %>%filter(year == 2020),
      aes(label = paste0(status, ", ", outcome_label)),
      size = 8 / .pt,
      hjust = 0,
      vjust = -.5,
      direction = "y",
      nudge_x = 0.3
    ) +
    geom_point(
      size = 2.5,
      color = "steelblue" 
    ) +
    geom_text_repel(
      data = df %>%filter(year == 2010) %>% filter(status == status1_label),
      aes(label = outcome_label
      ),
      size = 8 / .pt,
      hjust = 0,
      vjust = -1,
      direction = "y",
      nudge_x = -1
    ) +
    geom_text_repel(
      data = df %>%filter(year == 2010) %>% filter(status == status2_label),
      aes(label = outcome_label
      ),
      size = 8 / .pt,
      hjust = 0,
      vjust = -.5,
      direction = "y",
      nudge_x = -1
    ) +
    labs(
      title = title_label, 
      subtitle = subtitle_label
    ) +
    scale_x_continuous(
      breaks = c(2010, 2020),
      limits = c(2005, 2025)
    ) +
    theme_unhcr(
      grid = "X",
      axis = FALSE,
      axis_title = FALSE,
      axis_text = "X"
    )
}

# TidyCensus Pull ----

# TidyCensus pull
census_pull<- function(st, yr) {
  df <- tibble(GEOID = "", NAME = "", variable = "", estimate = double(), moe = double())
  
  pull <- get_acs(geography = "tract", 
                  variables = c(
                    # Median Income
                    Median_Income = "B06011_001",
                    # Median Home Value
                    Median_Home_Value = "B25077_001"
                  ), 
                  survey = "acs5",
                  state = st, 
                  year = yr)
  df <- bind_rows(df, pull)
}

# Report ----
write_model_outcomes <- function(df, program, measure) {
  
  # Find outcome of treat x post
  outcome <- report_parameters(df)
  outcome <- outcome[length(outcome)]
  
  # Write report findings
  if (grepl("non-significant", outcome) ) {
    cat(paste(paste0("We fitted a ", report_model(df), " where treat represents ", program, " program participation, post is the year of 2020 after starting period of 2010, and cbsa controls for metro-level effects."), report_performance(df), outcome, paste0("Since the effect of treat x post is not statistically significant, we cannot conclude that the ", program, " program had a measurable impact on ", measure, "-related social vulnerability and economic outcomes."), sep="\n\n"))
  } else {
    cat(paste(paste0("We fitted a ", report_model(df), " where treat represents ", program, " program participation, post is the year of 2020 after starting period of 2010, and cbsa controls for metro-level effects."), report_performance(df), outcome, paste0("Since the effect of treat x post is statistically significant, we can conclude that the ", program, " program had a measurable impact on ", measure, "-related social vulnerability and economic outcomes."), sep="\n\n"))
  }
  
}