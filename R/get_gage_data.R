# Angus Watters
# Get Observed streamflows data + boatable days

# load libraries
library(cdssr)
library(dplyr)

source("R/utils.R")

# save output path
save_path <- "data/streamflow/observed/flows"

# check if streamflow discharge daily data already exists, otherwise get data
# if(file.exists(save_path)) {
if(file.exists(paste0(save_path, ".csv")) & file.exists(paste0(save_path, ".rds")) ) {
  
  message(paste0("Reading data from:\n---> ", paste0(save_path, ".rds")))
  
  flow_df <- readRDS(paste0(save_path, ".rds"))
  # flow_df <- readr::read_csv(save_path)
} else {
  
  # table with gage info and thresholds 
  gage_table <-  gage_tbl()
  
  # get flows data w/ boatable days calculated
  flow_df <- get_flows(
                  gage_table = gage_table,
                  start_date = "1980-01-01",
                  end_date   = Sys.Date()
                  )

  message(paste0("Saving gage reference table:", 
                 "\n---> ", save_path, ".csv",
                 "\n---> ", save_path, ".rds"
  )
  )
  
  # save out CSV
  saveRDS(flow_df, paste0(save_path, ".rds"))
  readr::write_csv(flow_df, paste0(save_path, ".csv"))
  
} 

