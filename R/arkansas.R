# Angus Watters
# collect managment implementation plans data to compare to observed streamflow data

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

# local path to Arkansas flow program (Wellsville Flow)
ark_flow_path <- "data/streamflow/observed/Arkansas_flow_program.xlsx"

# table of gages
gage_table <- gage_tbl()

# *******************
# ---- Arkanasas ----
# *******************

ark <- process_ark(
  ark_flow_path = ark_flow_path, 
  threshold     = c(200, 100000)
  )

ark

# *************************************
# *************************************
# *************************************

# Random Data Vis

# flow plot
flow_df %>% 
  dplyr::filter(river == "Arkansas") %>% 
  # dplyr::group_by(uid) %>% 
  # dplyr::arrange(datetime, .by_group = T) %>% 
  # dplyr::slice(1:800) %>% 
  ggplot2::ggplot() +
  ggplot2::geom_line(ggplot2::aes(x = datetime, y = flow)) +
  ggplot2::facet_wrap(~uid)

# count boatable days by reach
flow_df %>% 
  dplyr::filter(river == "Arkansas")
dplyr::group_by(uid) %>% 
  count(boat_obs)

# view map of gages
gages <- cdssr::get_sw_stations(county = "Fremont")

gages %>% 
  sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>% 
  mapview::mapview()