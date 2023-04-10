# Angus Watters
# Yampa River streamflow and boatable days 

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# local path to yampa flow program 
yampa_flow_path <- "data/streamflow/flow_programs/CWT_SC_Releases_2012to2022.xlsx"

# Yampa managment path to save to
yampa_mgmt_path <- "data/streamflow/mgmt/yampa_mgmt.rds"

# ***************
# ---- Yampa ----
# ***************

# check if streamflow discharge daily data already exists, otherwise get data
if(file.exists(yampa_mgmt_path)) {
  
  message(paste0("Reading data from:\n---> ", yampa_mgmt_path))
  
  yampa_mgmt <- readRDS(yampa_mgmt_path)
  
} else {
  
  yampa_mgmt <- get_yampa_mgmt(
    df              = flow_df,
    yampa_flow_path = yampa_flow_path
  )
  
  message(paste0("Saving Yampa managment flows:", 
                 "\n---> ", yampa_flow_path
  ))
  
  # save out RDS
  saveRDS(yampa_mgmt, yampa_mgmt_path)
  
  # save out CSV
  # readr::write_csv(yampa_mgmt, yampa_mgmt_path)
  
} 
