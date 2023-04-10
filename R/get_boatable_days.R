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
if(file.exists(mgmt_flow_path)) {
  
  message(paste0("Reading data from:\n---> ", mgmt_flow_path))
  
  mgmt_df <- readRDS(mgmt_flow_path)
  
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
  

  # save out RDS/CSV
  saveRDS(boat_df, paste0(boat_path, ".rds"))
  readr::write_csv(boat_df, paste0(boat_path, ".csv"))
  
} 


# # Calculate boatable days
# boat_df <- calc_boatable(df = mgmt_df)
# 
# # names(gage_table)
# # gage_table %>% 
# #   dplyr::select(uid, min_accept, max_accept, min_opt, max_opt)
# # mgmt_df %>% 
# #   dplyr::filter(uid %in% unique(gage_table$uid))
# 
# calc_boatable <- function(df) {
#   
#   gage_table <- gage_tbl()
#   
#   boat_df <- 
#     df  %>% 
#     dplyr::filter(uid %in% unique(gage_table$uid)) %>% 
#     dplyr::left_join(
#       dplyr::select(gage_table, uid, min_accept, max_accept, min_opt, max_opt), 
#       by = "uid"
#     ) %>% 
#     dplyr::mutate(
#       boat_preimp_opt = dplyr::case_when(
#         flow_preimp >= min_opt & flow_preimp <= max_opt ~ 1,              # Preimplementation optimal thresholds
#         TRUE                                            ~ 0
#       ),
#       boat_preimp_accept = dplyr::case_when(
#         flow_preimp >= min_accept & flow_preimp <= max_accept ~ 1,        # Preimplementation acceptable thresholds
#         TRUE                                                  ~ 0
#       ),
#       boat_imp_opt = dplyr::case_when(
#         flow_imp >= min_opt & flow_imp <= max_opt       ~ 1,              # Implementation optimal thresholds
#         TRUE                                            ~ 0
#       ),
#       boat_imp_accept = dplyr::case_when(
#         flow_imp >= min_accept & flow_imp <= max_accept ~ 1,              # Implementation acceptable thresholds
#         TRUE                                            ~ 0
#       )
#     )
#   
#   return(boat_df)
#   
# }
# 
# mgmt_df <- 
#   mgmt_df %>% 
#   dplyr::filter(uid %in% unique(gage_table$uid)) %>% 
#   dplyr::left_join(
#     dplyr::select(gage_table, uid, min_accept, max_accept, min_opt, max_opt), 
#     by = "uid"
#   )
# 
# boat_df <- 
#   mgmt_df %>% 
#   dplyr::mutate(
#     boat_preimp_opt = dplyr::case_when(
#       flow_preimp >= min_opt & flow_preimp <= max_opt ~ 1,              # Preimplementation optimal thresholds
#       TRUE                                            ~ 0
#     ),
#     boat_preimp_accept = dplyr::case_when(
#       flow_preimp >= min_accept & flow_preimp <= max_accept ~ 1,        # Preimplementation acceptable thresholds
#       TRUE                                                  ~ 0
#     ),
#     boat_imp_opt = dplyr::case_when(
#       flow_imp >= min_opt & flow_imp <= max_opt       ~ 1,              # Implementation optimal thresholds
#       TRUE                                            ~ 0
#     ),
#     boat_imp_accept = dplyr::case_when(
#       flow_imp >= min_accept & flow_imp <= max_accept ~ 1,              # Implementation acceptable thresholds
#       TRUE                                            ~ 0
#     )
#   )
# 
# 
# unique(mgmt_df$uid)
