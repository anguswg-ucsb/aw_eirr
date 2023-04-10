# Angus Watters
# Roaring fork flow management data collection
# collect management implementation plans data to compare to observed stream flow data

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

# # Roaring fork RICD dates and flow regime
# ricd       <- rf_ricd()
# 
# 
# # RICD rules
# # 10 total days
# # 1 event in May lasting (2 days per event,  580 CFS per day = 2*580 CFS = 1160 CFS over 2 days)
# # 2 events in June (4 days per event, 400 CFS per day = 4*400 CFS = 1600 CFS over 4 days)


# # calculate RICD Management flows and boatable days under this scenario
# rf_mgmt <- get_rf_ricd(df = flow_df)
# 
# # rf_mgmt %>% 
# #   dplyr::filter(datetime >= "2010-01-01") %>%
# #   tidyr::pivot_longer(cols = c(flow_imp, flow_preimp)) %>% 
# #   ggplot2::ggplot() + 
# #   ggplot2::geom_line(ggplot2::aes(x = datetime, y = value, color = name), size = 1, alpha= 0.7) +
# #   ggplot2::facet_wrap(~uid)
# 
# # TODO: add 2 boatable days in May and 8 in June to get max # boatable days
# 
# # calculate new number of boatable days with RICD event flows added to increase boatable days when needed
# boatable_month <- 
#   rf_mgmt %>% 
#   dplyr::mutate(
#     month = lubridate::month(datetime),
#     year = lubridate::year(datetime)
#   ) %>% 
#   dplyr::group_by(uid, month, year) %>% 
#   dplyr::mutate(
#     total_boat = sum(boat_mgmt, na.rm = T),
#     days_in_month = lubridate::days_in_month(datetime),
#     diff_boat    = days_in_month - total_boat
#   ) %>% 
#   dplyr::ungroup() %>% 
#   dplyr::group_by(uid, month, year) %>% 
#   dplyr::mutate(
#     new_total = dplyr::case_when(
#       month == 5 & diff_boat >= 2 ~ total_boat + 2,
#       month == 5 & diff_boat < 2 ~ total_boat + diff_boat,
#       month == 6 & diff_boat >= 8 ~ total_boat + 8,
#       month == 6 & diff_boat < 8 ~ total_boat + diff_boat,
#       TRUE ~ total_boat
#       )
#   )
# 
# boatable_month



