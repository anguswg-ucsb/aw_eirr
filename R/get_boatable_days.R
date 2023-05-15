# Angus Watters
# Calculate boatable days for preimplementation and implementation flows at Yampa, Roaring Fork, Cache La Poudre, and Arkansas river reaches

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_tbl.R")
source("R/get_gage_data.R")
source("R/poudre.R")
source("R/roaring_fork.R")
source("R/arkansas.R")
source("R/yampa.R")

# manamgent flows data
mgmt_flow_path <- "data/streamflow/mgmt/mgmt_flows.rds"
boat_path      <- "data/boatable_days_output/boatable_days"

# check if streamflow discharge daily data already exists, otherwise get data
if(file.exists(mgmt_flow_path) & file.exists(boat_path)) {
  
  message(paste0("Reading data from:\n---> ", mgmt_flow_path))
  
  # read in management data
  mgmt_df <- readRDS(mgmt_flow_path)
  
  # read in boatable days data
  boat_df <- readRDS(boat_path)
  
} else {
  
  # combine all managment scenarios into single dataframe
  
  mgmt_df <- dplyr::bind_rows(ark_mgmt, rf_mgmt, poudre_mgmt, yampa_mgmt)
  
  message(paste0("Saving complete managment flows output:", 
                 "\n---> ", mgmt_flow_path))
  # save out RDS
  saveRDS(mgmt_df, mgmt_flow_path)
  
  message(paste0("Calculating boatable days..."))

  # Calculate boatable days
  boat_df <- calc_boatable(df = mgmt_df)
  
  message(paste0("Saving complete managment flows output:", 
                 "\n---> ", boat_path, ".rds",
                 "\n---> ", boat_path, ".csv"
                 )
          )
  # save out RDS/CSV
  saveRDS(boat_df, paste0(boat_path, ".rds"))
  readr::write_csv(boat_df, paste0(boat_path, ".csv"))
  
}

rm(ark_mgmt, flow_df, poudre_mgmt, rf_mgmt, yampa_mgmt)
























