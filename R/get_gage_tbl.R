# Angus Watters
# make and save gage table data

# load libraries
library(dplyr)

source("R/utils.R")

gage_tbl_path <- "data/streamflow/gages/gage_table"

# check if streamflow discharge daily data already exists, otherwise get data
if(file.exists(paste0(gage_tbl_path, ".csv")) & file.exists(paste0(gage_tbl_path, ".rds")) ) {
  
  message(paste0("Reading data from:\n---> ", paste0(gage_tbl_path, ".rds")))
  
  gage_tbl <- readRDS(paste0(gage_tbl_path, ".rds"))
  
} else {
  
  # make gage table from utils.R function
  gage_tbl <- gage_tbl()
  
  message(paste0("Saving gage reference table:", 
                 "\n---> ", gage_tbl_path, ".csv",
                 "\n---> ", gage_tbl_path, ".rds"
  )
  )
  # save out RDS
  saveRDS(gage_tbl, paste0(gage_tbl_path, ".rds"))
  readr::write_csv(gage_tbl, paste0(gage_tbl_path, ".csv"))
  
} 

# # make gage table from utils.R function
# gage_tbl <- gage_tbl()
# 
# # save gage table to data/streamflow/gages/
# readr::write_csv(gage_tbl, "data/streamflow/gages/gage_table.csv")
