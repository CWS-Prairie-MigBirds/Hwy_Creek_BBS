# ---
# title: "Summary of BBS data for Boreal Fire Analysis"
# author: "Eve Downey"
# created: "2025-07-17"

# notes: 
# ---

# 1. Look at total number of species per year and total number of individuals

year_summary <- data.frame(
  Year = c("2015", "2022", "2025"),
  Total_Individuals = colSums(HCBBS_data[, c("2015", "2022", "2025")], na.rm = TRUE),
  Species_Detected = sapply(HCBBS_data[, c("2015", "2022", "2025")], function(x) sum(x > 0, na.rm = TRUE))
)

# Transpose to have metrics as rows and years as columns
summary_t <- t(year_summary[, -1])  # Remove Year column before transpose
colnames(summary_t) <- year_summary$Year
summary_df <- as.data.frame(summary_t)

# Add directional and absolute change columns
summary_df$Change_2015_to_2022 <- summary_df$`2022` - summary_df$`2015`
summary_df$Change_2022_to_2025 <- summary_df$`2025` - summary_df$`2022`
summary_df$Abs_Change_2015_to_2022 <- abs(summary_df$Change_2015_to_2022)
summary_df$Abs_Change_2022_to_2025 <- abs(summary_df$Change_2022_to_2025)


#Magnitude of change:  Per species change in the number of individuals detected
species_change <- HCBBS_data %>%
  mutate(
    change_2015_2022 = `2022` - `2015`,                        # directional change
    abs_change_2015_2022 = abs(`2022` - `2015`),               # absolute change
    
    change_2022_2025 = `2025` - `2022`,                        # directional change
    abs_change_2022_2025 = abs(`2025` - `2022`)                # absolute change
  ) %>%
  select(Species.List, change_2015_2022, abs_change_2015_2022,
         change_2022_2025, abs_change_2022_2025)

#average change in number of individuals detected across all species
avg_changes <- species_change %>%
  summarise(
    avg_change_2015_2022 = mean(change_2015_2022, na.rm = TRUE),
    avg_abs_change_2015_2022 = mean(abs_change_2015_2022, na.rm = TRUE),
    
    avg_change_2022_2025 = mean(change_2022_2025, na.rm = TRUE),
    avg_abs_change_2022_2025 = mean(abs_change_2022_2025, na.rm = TRUE)
  )


#How many SAR detected per year - species and individuals

  #join SAR list
SAR<- read.csv("C:/Users/DowneyE/Documents/GithubProjects/Hwy_Creek_BBS/data/SAR_updated_792024.csv")

#change species column name to match HCBBS_data to join by Species.List
HCBBS_data<-HCBBS_data%>% rename(common.name = Species.List)


commonnames<- read.csv("C:/Users/DowneyE/Documents/GithubProjects/Hwy_Creek_BBS/data/commonnames.csv")

HCBBS_data_SAR<- HCBBS_data %>%
  left_join(commonnames %>% select(common.name, Species), by ="common.name")

HCBBS_data_SAR <- HCBBS_data_SAR %>%
  mutate(Species = case_when(
    common.name == "(Yellow-shafted Flicker) Northern Flicker" ~ "NOFL",
    common.name == "Northern House Wren" ~ "HOWR",
    common.name == "(Slate-colored Junco) Dark-eyed Junco" ~ "DEJU",
    common.name == "(Myrtle Warbler) Yellow-rumped Warbler" ~ "YRWA",
    TRUE ~ Species  # Keep existing value if no match
  ))

#join status to HCBBS_data
HCBBS_data_SAR <- HCBBS_data_SAR %>%
  left_join(SAR %>% select(Species, status), by = "Species")
