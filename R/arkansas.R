# Angus Watters
# Arkansas River flow management data collection
# collect management implementation plans data to compare to observed streamflow data

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# local path to Arkansas flow program (Wellsville Flow)
ark_flow_path <- "data/streamflow/flow_programs/Arkansas_flow_program.xlsx"

# Arkansas managment path
ark_mgmt_path <- "data/streamflow/mgmt/arkansas_mgmt.rds"

# table of gages
gage_table <- gage_tbl()

# *******************
# ---- Arkanasas ----
# *******************

# check if streamflow discharge daily data already exists, otherwise get data
if(file.exists(ark_mgmt_path)) {
  
  message(paste0("Reading data from:\n---> ", ark_mgmt_path))
  
  ark_mgmt <- readRDS(ark_mgmt_path)
  
} else {
  
  ark_mgmt <- get_ark_mgmt(
    df            = flow_df, 
    ark_flow_path = ark_flow_path
  )
  
  message(paste0("Saving Arkansas managment flows:", 
                 "\n---> ", ark_mgmt_path
                 ))
  
  # save out RDS
  saveRDS(ark_mgmt, ark_mgmt_path)
  
  # save out CSV
  # readr::write_csv(ark_mgmt, paste0(ark_mgmt_path, ".csv"))
  
} 

# *************************************
# *************************************

# # flow plot
# flow_df %>% 
#   dplyr::filter(river == "Arkansas") %>% 
#   # dplyr::group_by(uid) %>% 
#   # dplyr::arrange(datetime, .by_group = T) %>% 
#   # dplyr::slice(1:800) %>% 
#   ggplot2::ggplot() +
#   ggplot2::geom_line(ggplot2::aes(x = datetime, y = flow)) +
#   ggplot2::facet_wrap(~uid)
# 
# # count boatable days by reach
# flow_df %>% 
#   dplyr::filter(river == "Arkansas")
# dplyr::group_by(uid) %>% 
#   count(boat_obs)
# 
# # view map of gages
# gages <- cdssr::get_sw_stations(county = "Fremont")
# 
# gages %>% 
#   sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>% 
#   mapview::mapview()*******************

# Random Data Vis
