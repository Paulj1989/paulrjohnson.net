# Script for pulling and combining Bundesliga staff costs and Transfermarkt squad values data

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Import Data ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

staff_costs <- googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/18rm612C13eY3e2BIwryBzqkz-43y-inE_iIb8cbJ_Dc/edit?usp=sharing"
)

squad_values <-
  readRDS(
    here::here(
      "blog",
      "2024-10-09-analysing-money-in-football",
      "data",
      "club_resources.rds"
    )
  ) |>
  dplyr::rename(team = squad)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Wrangle BuLi Data ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

buli_resources <-
  squad_values |>
  dplyr::filter(league == "Bundesliga") |>
  dplyr::filter(
    season %in% c("2022/23", "2021/22", "2020/21", "2019/20", "2018/19")
  ) |>
  dplyr::select("team", "season", "squad_value", "pts", "gd", "xgd") |>
  dplyr::right_join(staff_costs)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save Final Dataset ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

readr::write_rds(
  buli_resources,
  file = here::here(
    "blog",
    "2025-05-01-staff-costs-vs-squad-values",
    "data",
    "buli_resources.rds"
  )
)
