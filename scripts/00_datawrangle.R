# ---
# title: "Wrangling BBS data for Boreal Fire Analysis"
# author: "Eve Downey"
# created: "2025-07-17"

# notes: 
# ---

# 1. Load Packages


#install.packages("tidyverse")
#install.packages("usethis")
#installed.packages("gitcreds")
library(gitcreds)
library(usethis)
library(tidyverse) #basic data manipulation (v.2.0.0)
#install.packages("remotes")
#remotes::install_github("ABbiodiversity/wildrtrax")
library(wildrtrax)


# download point count and ARU data from Wildtrax (v.1.3.0)

# 2. Log in to wildtrax

config <- "wt_login.R"
source(config)
wt_auth()

# 3. read in list of projects

#project.list <- wt_get_download_summary(sensor_id ='PC')
#bbmp.proj <- project.list %>% filter(organization =="CWS-PRA", sensor =="PC")

# 4. Download required data

#bbmp <- wt_download_report(
 #   project_id = 2830, sensor_id = "PC", reports = c("main"),
 #  weather_cols = FALSE)

# . Read Data - BBS data from raw data folder

HCBBS_data <- read.csv(
  "C:/Users/DowneyE/Documents/GithubProjects/Hwy_Creek_BBS/data/Highway_Creek_BBS.csv",
  fileEncoding = "latin1"  # or "UTF-8", if latin1 fails
)

#str(HCBBS_data)
#head(HCBBS_data)
#names(HCBBS_data)


# 3. Clean Data

#change headers
HCBBS_data <- HCBBS_data %>%
  rename(
    `2015` = `X2015`,
    `2022` = `X2022`,
    `2025` = `X.2025`
  )

#remove unknown species
HCBBS_data <- HCBBS_data %>%
  filter(Species.List != "unid. woodpecker")

#remove last 2 rows of data (total # of species and total # individuals - do this in data summary)

HCBBS_data <- HCBBS_data[1:(nrow(HCBBS_data) - 2), ]


