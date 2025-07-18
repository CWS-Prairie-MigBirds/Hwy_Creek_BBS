# ---
# title: "Wrangling BBS data for Boreal Fire Analysis"
# author: "Eve Downey"
# created: "2025-07-17"

# notes: 
# ---

# 1. Load Packages


install.packages("tidyverse")
install.packages("usethis")
installed.packages("gitcreds")
library(gitcreds)
library(usethis)
library(tidyverse) #basic data manipulation (v.2.0.0)
install.packages("remotes")
remotes::install_github("ABbiodiversity/wildrtrax")
library(wildrtrax)


# download point count and ARU data from Wildtrax (v.1.3.0)

# 2. Log in to wildtrax

config <- "wt_login.R"
source(config)
wt_auth()

# 3. read in list of projects

project.list <- wt_get_download_summary(sensor_id ='PC')
bbmp.proj <- project.list %>% filter(organization =="CWS-PRA", sensor =="PC")

# 4. Download required data

bbmp <- wt_download_report(
    project_id = 2830, sensor_id = "PC", reports = c("main"),
    weather_cols = FALSE)


# . Read Data - BBS data from raw data folder



# 3. Clean Data