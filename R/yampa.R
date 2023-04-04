# Angus Watters
# Yampa River streamflow and boatable days 

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/utils.R")
source("R/get_gage_data.R")

gage_table <- gage_tbl()

# ***************
# ---- Yampa ----
# ***************