# Angus Watters
# Roaring fork flow management data collection
# collect management implementation plans data to compare to observed stream flow data

# # Roaring fork RICD dates and flow regime
# ricd       <- rf_ricd()

# # RICD rules
# # 10 total days
# # 1 event in May lasting (2 days per event,  580 CFS per day = 2*580 CFS = 1160 CFS over 2 days)
# # 2 events in June (4 days per event, 400 CFS per day = 4*400 CFS = 1600 CFS over 4 days)


# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# Roaring fork managment path 
rf_mgmt_path <- "data/streamflow/mgmt/roaring_fork_mgmt.rds"

# gage table
gage_table <- gage_tbl()

# **********************
# ---- Roaring Fork ----
# **********************

# check if flow managment data set exists, and read it in otherwise go get it
if(file.exists(rf_mgmt_path)) {
  
  message(paste0("Reading data from:\n---> ", rf_mgmt_path))
  
  rf_mgmt <- readRDS(rf_mgmt_path)
  
} else {
  
  # apply Roaring fork RICD rules
  rf_mgmt <- get_rf_mgmt(
    df = flow_df
    )
  
  message(paste0("Saving Roaring Fork managment flows:", 
                 "\n---> ", rf_mgmt_path
  ))
  
  # save out RDS
  saveRDS(rf_mgmt, (rf_mgmt_path))
  
} 

# **************************************
# **************************************
