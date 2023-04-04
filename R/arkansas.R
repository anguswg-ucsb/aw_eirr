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
