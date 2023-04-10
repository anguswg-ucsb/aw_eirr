# Angus Watters
# Cache La Poudre River flow management data collection
# collect management implementation plans data to compare to observed stream flow data

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# table of gages
gage_table <- gage_tbl()

# Poudre managment path to save to
poudre_mgmt_path <- "data/streamflow/mgmt/poudre_mgmt.rds"

# provide API key if needed
api_key = NULL

# ****************
# ---- Poudre ----
# ****************

# poudre_mgmt <- get_poudre_mgmt(
#   df            = flow_df,
#   api_key       = api_key
# )

# check if streamflow discharge daily data already exists, otherwise get data
if(file.exists(poudre_mgmt_path)) {
  
  message(paste0("Reading data from:\n---> ", poudre_mgmt_path))
  
  poudre_mgmt <- readRDS(poudre_mgmt_path)
  
} else {
  
  poudre_mgmt <- get_poudre_mgmt(
    df            = flow_df,
    api_key       = api_key
  )
  
  message(paste0("Saving Poudre managment flows:", 
                 "\n---> ",poudre_mgmt_path
                 ))
  
  # save out RDS
  saveRDS(poudre_mgmt, poudre_mgmt_path)
  
  # save out CSV
  # readr::write_csv(ark_mgmt, paste0(ark_mgmt_path, ".csv"))
  
} 
# *************************************
