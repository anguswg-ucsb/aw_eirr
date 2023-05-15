# Angus Watters
# Generate flow timeseries plots and other misc plots

# load libraries
library(dplyr)
library(ggplot2)
library(cdssr)

source("R/get_boatable_days.R")
source("R/utils.R")

# -------------------------------
# ---- Flow timeseries plots ----
# -------------------------------

flow_plots <- create_flow_plots(
  df        = boat_df,
  save_path = "plot/"
)
# --------------------
# ---- MISC PLOTS ----
# --------------------

monthly <-
  boat_df %>%
  tidyr::pivot_longer(cols = c(contains("boat"))) %>%
  dplyr::filter(river == "Roaring Fork") %>%
  dplyr::mutate(
    month = lubridate::month(datetime),
    year = lubridate::year(datetime)
  ) %>%
    dplyr::group_by(river, uid, name, month, year) %>%
    dplyr::summarise(
      value = sum(value, na.rm = T)
    ) %>%
  dplyr::group_by(river, uid, name, month, year) %>%
  tidyr::pivot_wider(names_from = "name", values_from = "value") %>%
  dplyr::mutate(
    boat_opt_diff    = boat_imp_opt - boat_preimp_opt,
    boat_accept_diff = boat_imp_accept - boat_preimp_accept,
    date = as.Date(paste0(year, "-", month, "-01"))
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(river, date, uid, boat_opt_diff, boat_accept_diff) %>%
  tidyr::pivot_longer(cols = c(contains("boat")))

# difference plot
change_boatable_bar <-
  monthly %>%
  dplyr::filter(date > "2012-01-01", date <= "2013-01-01") %>%
  dplyr::mutate(
    name = dplyr::case_when(
      name == "boat_opt_diff" ~ "Optimal",
      name == "boat_accept_diff" ~ "Acceptable"
    )
  ) %>%
  dplyr::mutate(
    month = lubridate::month(date, label = T)
  ) %>%
  # ggplot2::ggplot() +
  ggplot2::ggplot(ggplot2::aes(fill=name, y=value, x=month)) +
  ggplot2::geom_bar(
    position="dodge",
    # width = 0.2,
    # position=position_dodge(width = 2),
    stat="identity"
    ) +
  # ggplot2::geom_col(ggplot2::aes(x = month, y = value, fill = name),
  #                   position = ggplot2::position_dodge2(
  #                     # width = 0.5,
  #                     # padding = 0.1
  #                   ),
  #                   # width = 15,
  #                   # size = 1
  #                   ) +
  ggplot2::labs(
    title = "Differences in boatable days pre and post implementation",
    subtitle = "Roaring Fork Reaches (2012-13)",
    x = "",
    fill = "Threshold",
    y = "Monthly Boatable days"
  ) +
  ggplot2::scale_x_discrete() +
  ggplot2::scale_fill_manual(values = c('darkorange', 'forestgreen')) +
  ggplot2::coord_cartesian(ylim = c(0, max(monthly$value))) +

  # ggplot2::scale_y_continuous(limits = c(0, 31), expand = c(0, 0)) +
  # ggplot2::ylim(0, 31)+
  # ggplot2::geom_line(ggplot2::aes(x = date, y = value, color = name), size = 1) +
  ggplot2::facet_wrap(~uid, nrow = 2) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 18, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 16),
    strip.text = ggplot2::element_text(size = 12, face = "bold"),
    axis.title = ggplot2::element_text(size = 14, face = "bold"),
    axis.text =  ggplot2::element_text(size = 12),
    legend.text =  ggplot2::element_text(size = 12),
    legend.title =  ggplot2::element_text(size = 12, face = "bold", hjust = 0.5)
  )
  # ggplot2::facet_grid(uid~river)
change_boatable_bar
ggplot2::ggsave(
  change_boatable_bar,
  filename = "plot/change_boatable_days_bar_plot.png",
  height = 10,
  width = 12,
  scale = 1
)

# difference plot
change_boatable_line <-
  monthly %>%
  dplyr::filter(date > "2012-01-01", date <= "2013-01-01") %>%
  dplyr::mutate(
    name = dplyr::case_when(
      name == "boat_opt_diff" ~ "Optimal",
      name == "boat_accept_diff" ~ "Acceptable"
    )
  ) %>%
  dplyr::mutate(
    month = lubridate::month(date, label = T)
  ) %>%
  # ggplot2::ggplot() +
  ggplot2::ggplot(ggplot2::aes(color=name, y=value, x=date)) +
  # ggplot2::geom_bar(position="dodge", stat="identity") +
  ggplot2::geom_line(size = 1.5) +
  ggplot2::labs(
    title = "Differences in boatable days pre and post implementation",
    subtitle = "Roaring Fork Reaches (2012-13)",
    x = "",
    color = "Threshold",
    y = "Monthly Boatable days"
  ) +
  ggplot2::facet_wrap(~uid, nrow = 2) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 18, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 16),
    strip.text = ggplot2::element_text(size = 12, face = "bold"),
    axis.title = ggplot2::element_text(size = 14, face = "bold"),
    axis.text =  ggplot2::element_text(size = 12),
    legend.text =  ggplot2::element_text(size = 12),
    legend.title =  ggplot2::element_text(size = 12, face = "bold", hjust = 0.5)
  )

ggplot2::ggsave(
  change_boatable_line,
  filename = "plot/change_boatable_days_line_plot.png",
  height = 10,
  width = 12,
  scale = 1
)

# pre and post implementation flows

flow_ts_plot <-
  boat_df %>%
  dplyr::filter(river == "Roaring Fork") %>%
  dplyr::select(datetime, uid, contains("flow")) %>%
  tidyr::pivot_longer(cols = c(contains("flow"))) %>%
  dplyr::mutate(
    name = dplyr::case_when(
    name == "flow_imp" ~ "Implementation flows",
    name == "flow_preimp" ~ "Preimplementation flows"
    )
  ) %>%
  dplyr::filter(datetime > "2012-01-01", datetime <= "2013-01-01") %>%
  ggplot2::ggplot() +
  ggplot2::geom_line(ggplot2::aes(x = datetime, y = value, color = name), size = 1, alpha = 0.9) +
  ggplot2::labs(
    title = "Flow Managment Scenarios",
    subtitle = "Roaring Fork Reaches",
    x = "",
    color = "Scenario",
    y = "CFS"
  ) +
  ggplot2::facet_wrap(~uid, nrow = 2) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(size = 18, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 16),
    strip.text = ggplot2::element_text(size = 12, face = "bold"),
    axis.title = ggplot2::element_text(size = 14, face = "bold"),
    axis.text =  ggplot2::element_text(size = 12),
    legend.text =  ggplot2::element_text(size = 12),
    legend.title =  ggplot2::element_text(size = 12, face = "bold", hjust = 0.5)
  )

ggplot2::ggsave(
  flow_ts_plot,
  filename = "plot/rf_flow_ts_plot.png",
  height = 10,
  width = 12,
  scale = 1
)


