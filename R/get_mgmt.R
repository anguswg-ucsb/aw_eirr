# Angus Watters
# collect managment implementation plans data to compare to observed streamflow data

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# flow_df <- readr::read_csv("data/streamflow/observed/boatable_flows.csv")

gage_table <- gage_tbl()


# *******************
# ---- Arkanasas ----
# *******************

ark <- readxl::read_xlsx("data/streamflow/observed/Arkansas_flow_program.xlsx")

# ***************
# ---- Yampa ----
# ***************

# **********************
# ---- Roaring Fork ----
# **********************

# Roaring fork RICD dates and flow regime
ricd       <- rf_ricd()


# RICD rules
# 10 total days
# 1 event in May lasting (2 days per event,  580 CFS per day = 2*580 CFS = 1160 CFS over 2 days)
# 2 events in June (4 days per event, 400 CFS per day = 4*400 CFS = 1600 CFS over 4 days)

# calculate RICD Management flows and boatable days under this scenario
rf_mgmt <- get_rf_ricd(df = flow_df)

# ***************
# ---- plots ----
# ***************

# # normal flows and then augmented flows
# rf_mgmt %>% 
#   dplyr::mutate(
#     month = lubridate::month(datetime),
#     year  = lubridate::year(datetime),
#     day   = lubridate::day(datetime)
#   ) %>%
#   dplyr::filter(
#     year %in% c(2022)
#   ) %>%
#   dplyr::select(datetime, uid, flow, aug_flow) %>% 
#   tidyr::pivot_longer(cols = c(flow, aug_flow)) %>% 
#   ggplot2::ggplot() +
#   ggplot2::geom_line(ggplot2::aes(x = datetime, y = value, color = name), size = 1, alpha = 0.8) +
#   ggplot2::labs(
#     title = "Observed flows vs. RICD augmented flows",
#     y     = "CFS",
#     x     = "Date",
#     color = "Scenario"
#   ) +
#   ggplot2::theme_bw() +
#   ggplot2::facet_wrap(~uid)
# 
# # boatable days count with RICD and without
# dboat <- 
#   rf_mgmt %>% 
#   dplyr::select(datetime, uid, flow, aug_flow, boat_obs, boat_mgmt) %>% 
#   dplyr::mutate(
#     month = lubridate::month(datetime),
#     year  = lubridate::year(datetime),
#     day   = lubridate::day(datetime)
#   ) %>%
#   dplyr::filter(
#     year %in% c(2020, 2021, 2022)
#   ) %>%
#   dplyr::group_by(month, year, uid) %>% 
#   dplyr::summarise(
#     boat_obs  = sum(boat_obs, na.rm = T),
#     boat_mgmt = sum(boat_mgmt, na.rm = T)
#   ) %>% 
#   dplyr::ungroup() %>% 
#   dplyr::group_by(month, year, uid) %>% 
#   dplyr::mutate(
#     date = as.Date(paste0(year, "-", month, "-01"))
#     # boat_diff = boat_obs - boat_mgmt
#   ) %>% 
#   dplyr::ungroup()
# 
# # line plot comparing boatable days to mamangement boatable days
# dboat %>% 
#   # dplyr::filter(uid == "09076300") %>% 
#   tidyr::pivot_longer(cols = c(boat_obs, boat_mgmt)) %>% 
#   ggplot2::ggplot(ggplot2::aes(x = date, y = value, color = name)) +
#   # ggplot2::geom_segment(aes(xend = date, yend = lead(value)), color = "black", size = 1) +
#   # ggplot2::geom_point(size = 5) +
#   ggplot2::geom_line(size = 2, alpha = 0.7) +
#   ggplot2::labs(
#     title = "Monthly total boatable days",
#     y     = "Boatable days",
#     x     = "Date",
#     color = "Scenario"
#   ) +
#   ggplot2::theme_bw() +
#   # ggplot2::geom_segment() + 
#   # ggplot2::geom_line(ggplot2::aes(x = date, y = value, color = name), size = 1, alpha = 0.8) +
#   ggplot2::facet_wrap(~uid)
# 
# # lollipop plot
# dboat %>% 
#   # dplyr::filter(uid == "09076300") %>% 
#   tidyr::pivot_longer(cols = c(boat_obs, boat_mgmt)) %>% 
#   ggplot2::ggplot(ggplot2::aes(x = date, y = value, color = name)) +
#   ggplot2::geom_segment(aes(xend = date, yend = lead(value)), color = "black", size = 1) +
#   ggplot2::geom_point(size = 5) +
#   ggplot2::labs(
#     title = "Monthly total boatable days",
#     y     = "Boatable days",
#     x     = "Date",
#     color = "Scenario"
#   ) +
#   ggplot2::theme_bw() +
#   ggplot2::facet_wrap(~uid)

