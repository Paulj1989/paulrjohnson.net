# Script for pulling and combining raw data from FB Ref and Transfermarkt

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helper Functions ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fix_team_names <- 
  function(data) {
    dplyr::case_when(
      data == "1.FC Heidenheim 1846" ~ "Heidenheim",
      data == "1.FC Köln" ~ "Köln",
      data == "1.FC Nuremberg" ~ "Nürnberg",
      data == "1.FC Union Berlin" ~	"Union Berlin",
      data == "1.FSV Mainz 05" ~ "Mainz",
      data == "AC Carpi" ~ "Carpi",
      data == "AC Cesena" ~ "Cesena",
      data == "AC Monza" ~ "Monza",
      data == "AC Siena" ~ "Siena",
      data == "ACF Fiorentina" ~ "Fiorentina",
      data == "ACR Siena 1904" ~ "Siena",
      data == "AFC Bournemouth" ~ "Bournemouth",
      data == "AJ Auxerre" ~ "Auxerre",
      data == "AC Ajaccio" ~ "Ajaccio",
      data == "Ajaccio AC" ~ "Ajaccio",
      data == "Alavés" ~ "Deportivo Alavés",
      data == "Amiens SC" ~ "Amiens",
      data == "Angers SCO" ~ "Angers",
      data == "Arminia" ~ "Arminia Bielefeld",
      data == "Arsenal FC" ~ "Arsenal",
      data == "AS Livorno" ~ "Livorno",
      data == "AS Monaco" ~ "Monaco",
      data == "AS Nancy-Lorraine" ~ "Nancy",
      data == "AS Roma" ~ "Roma",
      data == "AS Saint-Étienne" ~ "Saint-Étienne",
      data == "Atalanta BC" ~ "Atalanta",
      data == "Athletic Carpi 2021" ~ "Carpi",
      data == "Athletic Club" ~ "Athletic Bilbao",
      data == "Atlético de Madrid" ~ "Atlético Madrid",
      data == "Bayer 04 Leverkusen" ~ "Bayer Leverkusen",
      data == "Benevento Calcio" ~ "Benevento",
      data == "Betis" ~ "Real Betis",
      data == "Bologna FC 1909" ~ "Bologna",
      data == "Brentford FC" ~ "Brentford",
      data == "Brescia Calcio" ~ "Brescia",
      data == "Brest" ~ "Stade Brest",
      data == "Brighton & Hove Albion" ~ "Brighton",
      data == "Burnley FC" ~ "Burnley",
      data == "CA Osasuna" ~ "Osasuna",
      data == "Cádiz CF" ~ "Cádiz",
      data == "Cagliari Calcio" ~	"Cagliari",
      data == "Calcio Catania" ~ "Catania",
      data == "Carpi FC 1909" ~ "Carpi",
      data == "Catania FC" ~ "Catania",
      data == "Catania SSD" ~ "Catania",
      data == "CD Leganés" ~ "Leganés",
      data == "Celta de Vigo" ~ "Celta Vigo",
      data == "Cesena FC" ~ "Cesena",
      data == "Chelsea FC" ~ "Chelsea",
      data == "Chievo Verona" ~ "Chievo",
      data == "Clermont Foot 63" ~ "Clermont Foot",
      data == "Córdoba CF" ~ "Córdoba",
      data == "Darmstadt 98" ~ "Darmstadt",
      data == "Delfino Pescara 1936" ~ "Pescara",
      data == "Dijon FCO" ~ "Dijon",
      data == "Dortmund" ~ "Borussia Dortmund",
      data == "EA Guingamp" ~ "Guingamp",
      data == "Eint Frankfurt" ~ "Frankfurt",
      data == "Eintracht Braunschweig" ~ "Braunschweig",
      data == "Eintracht Frankfurt" ~ "Frankfurt",
      data == "Elche CF" ~ "Elche",
      data == "Empoli FC" ~ "Empoli",
      data == "ESTAC Troyes" ~ "Troyes",
      data == "Everton FC" ~ "Everton",
      data == "FC Augsburg" ~ "Augsburg",
      data == "FC Barcelona" ~ "Barcelona",
      data == "FC Crotone" ~ "Crotone",
      data == "FC Empoli" ~ "Empoli",
      data == "FC Évian Thonon Gaillard" ~ "Evian",
      data == "FC Girondins Bordeaux" ~ "Bordeaux",
      data == "FC Ingolstadt 04" ~ "Ingolstadt",
      data == "FC Internazionale" ~ "Inter Milan",
      data == "FC Lorient" ~ "Lorient",
      data == "FC Metz" ~ "Metz",
      data == "FC Nantes" ~ "Nantes",
      data == "FC Schalke 04" ~ "Schalke",
      data == "FC Sochaux-Montbéliard" ~ "Sochaux",
      data == "FC Toulouse" ~ "Toulouse",
      data == "Fortuna Düsseldorf" ~ "Düsseldorf",
      data == "Frosinone Calcio" ~ "Frosinone",
      data == "Fulham FC" ~ "Fulham",
      data == "Gazélec Ajaccio" ~ "Ajaccio",
      data == "Gazélec Ajaccio GFC" ~ "Ajaccio",
      data == "Genoa CFC" ~ "Genoa",
      data == "Getafe CF" ~ "Getafe",
      data == "GFC Ajaccio" ~ "Ajaccio",
      data == "Girona FC" ~ "Girona",
      data == "Granada CF" ~ "Granada",
      data == "Huddersfield Town" ~ "Huddersfield",
      data == "Ingolstadt 04" ~ "Ingolstadt",
      data == "Inter" ~ "Inter Milan",
      data == "Juventus FC" ~ "Juventus",
      data == "La Coruña" ~ "Deportivo de La Coruña",
      data == "Le Havre AC" ~ "Le Havre",
      data == "Levante UD" ~ "Levante",
      data == "Leverkusen" ~ "Bayer Leverkusen",
      data == "Liverpool FC" ~ "Liverpool",
      data == "LOSC Lille" ~ "Lille",
      data == "Mainz 05" ~ "Mainz",
      data == "Málaga CF" ~ "Málaga",
      data == "Manchester United" ~ "Manchester Utd",
      data == "M'Gladbach" ~ "Borussia Mönchengladbach",
      data == "Gladbach" ~ "Borussia Mönchengladbach",
      data == "Middlesbrough FC" ~ "Middlesbrough",
      data == "Milan" ~ "AC Milan",
      data == "Montpellier HSC" ~ "Montpellier",
      data == "Newcastle United" ~ "Newcastle",
      data == "Newcastle Utd" ~ "Newcastle",
      data == "Nîmes Olympique" ~ "Nîmes",
      data == "Nott'ham Forest" ~ "Nottingham Forest",
      data == "OGC Nice" ~ "Nice",
      data == "Olympique Lyon" ~ "Lyon",
      data == "Olympique Marseille" ~ "Marseille",
      data == "Paderborn 07" ~ "Paderborn",
      data == "Palermo FC" ~ "Palermo",
      data == "Paris S-G" ~ "Paris Saint-Germain",
      data == "Parma Calcio 1913" ~ "Parma",
      data == "Parma FC" ~ "Parma",
      data == "Queens Park Rangers" ~ "QPR",
      data == "RC Lens" ~ "Lens",
      data == "RC Strasbourg Alsace" ~ "Strasbourg",
      data == "RCD Espanyol Barcelona" ~ "Espanyol",
      data == "RCD Mallorca" ~ "Mallorca",
      data == "Reading FC" ~ "Reading",
      data == "Real Betis Balompié" ~ "Real Betis",
      data == "Real Valladolid CF" ~ "Real Valladolid",
      data == "Reims" ~ "Stade Reims",
      data == "SC Bastia" ~ "Bastia",
      data == "SC Freiburg" ~ "Freiburg",
      data == "SC Paderborn 07" ~ "Paderborn",
      data == "Schalke 04" ~ "Schalke",
      data == "SD Eibar" ~ "Eibar",
      data == "SD Huesca" ~ "Huesca",
      data == "Sevilla FC" ~ "Sevilla",
      data == "Sheffield United" ~ "Sheffield Utd",
      data == "Siena FC" ~ "Siena",
      data == "SM Caen" ~ "Caen",
      data == "Southampton FC" ~ "Southampton",
      data == "SPAL 2013" ~ "SPAL",
      data == "Spezia Calcio" ~ "Spezia",
      data == "SpVgg Greuther Fürth" ~ "Greuther Fürth",
      data == "SS Lazio" ~ "Lazio",
      data == "SSC Napoli" ~ "Napoli",
      data == "Stade Brestois 29" ~ "Stade Brest",
      data == "Stade Rennais FC" ~ "Rennes",
      data == "Sunderland AFC" ~ "Sunderland",
      data == "SV Darmstadt 98" ~ "Darmstadt",
      data == "SV Werder Bremen" ~ "Werder Bremen",
      data == "Thonon Évian Grand Genève FC" ~ "Evian",
      data == "Torino FC" ~ "Torino",
      data == "Tottenham Hotspur" ~ "Tottenham",
      data == "TSG 1899 Hoffenheim" ~ "Hoffenheim",
      data == "UC Sampdoria" ~ "Sampdoria",
      data == "UD Almería" ~ "Almería",
      data == "UD Las Palmas" ~ "Las Palmas",
      data == "Udinese Calcio" ~ "Udinese",
      data == "US Cremonese" ~ "Cremonese",
      data == "US Lecce" ~ "Lecce",
      data == "US Livorno 1915" ~ "Livorno",
      data == "US Palermo" ~ "Palermo",
      data == "US Salernitana 1919" ~ "Salernitana",
      data == "US Sassuolo" ~ "Sassuolo",
      data == "Valencia CF" ~ "Valencia",
      data == "Valenciennes FC" ~ "Valenciennes",
      data == "Valladolid" ~ "Real Valladolid",
      data == "Venezia FC" ~ "Venezia",
      data == "VfB Stuttgart" ~ "Stuttgart",
      data == "VfL Bochum" ~ "Bochum",
      data == "VfL Wolfsburg" ~ "Wolfsburg",
      data == "Villarreal CF" ~ "Villarreal",
      data == "Watford FC" ~ "Watford",
      data == "West Bromwich Albion" ~ "West Brom",
      data == "West Ham United" ~ "West Ham",
      data == "Wolverhampton Wanderers" ~ "Wolves",
      data == "Zaragoza" ~ "Real Zaragoza",
      .default = data
    )
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Squad Values ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# get player values from transfermarkt
player_values_raw <- 
  worldfootballR::tm_player_market_values(
    country_name = c("England", "Spain", "Germany", "Italy", "France"),
    start_year = c(2012:2023)
  )

# wrangle to team total values per season?tm
squad_values <- 
  player_values_raw |>
  dplyr::mutate(
    league = comp_name,
    league = dplyr::case_when(
      league == "LaLiga" ~ "La Liga",
      .default = league
    ),
    season = season_start_year
  ) |> 
  tidyr::drop_na(player_market_value_euro) |>
  dplyr::summarise(
    squad_value = sum(player_market_value_euro),
    .by = c(squad, league, season)
  ) |> 
  dplyr::mutate(squad = fix_team_names(squad))

readr::write_csv(
  squad_values, 
  here::here("blog", "2024-07-20-money-in-football", "data", "squad_values.csv")
)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# League Tables ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# get league tables from fb ref
league_table_raw <- 
  worldfootballR::fb_season_team_stats(
    country = c("ENG", "ESP", "GER", "ITA", "FRA"),
    gender = "M",
    season_end_year = c(2013:2024),
    tier = "1st",
    stat_type = "league_table",
    time_pause = 5
  )
 
# wrangle league tables to merge with squad values
league_tables <-
  league_table_raw |>
  janitor::clean_names(
    replace = c(
      "xGD" = "xgd",
      "xGA"= "xga",
      "xG" = "xg"
      )
    ) |>
  dplyr::mutate(
    season = season_end_year - 1,
    league =
      dplyr::case_when(
        competition_name == "Fußball-Bundesliga" ~ "Bundesliga",
        .default = competition_name
        ),
    squad = fix_team_names(squad)) |> 
  dplyr::select(league, squad, season, rk, mp, pts, gf, ga, gd, xg, xga, xgd)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Transfer Balances ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

country_list <- c("England", "Spain", "Germany", "Italy", "France")

season_list <- c(2012:2023)

crossed <- tidyr::crossing(country_list, season_list)

# specify function for transfer balances
balance_fun <- 
  function(countries, years){
    worldfootballR::tm_team_transfer_balances(
      country_name = countries,
      start_year = years
    ) |>
      dplyr::mutate(season = years)
  }

# get transfer balances 
transfer_balance_raw <- 
  purrr::map2_dfr(
    crossed$country_list,
    crossed$season_list,
    .f = balance_fun
  )

transfer_balances <-
  transfer_balance_raw |>  
  dplyr::mutate(
    net_spend = expenditure_euros - income_euros,
    gross_spend = expenditure_euros,
    league = dplyr::case_when(
      league == "LaLiga" ~ "La Liga",
      .default = league
    ),
    squad = fix_team_names(squad)) |> 
  dplyr::select(league, season, squad, gross_spend, net_spend)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Number of Players ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fb_std_raw <- 
  worldfootballR::fb_season_team_stats(
    country = c("ENG", "ESP", "GER", "ITA", "FRA"),
    gender = "M",
    season_end_year = c(2013:2024),
    tier = "1st",
    stat_type = "standard",
    time_pause = 5
    )

num_players <-
  fb_std_raw |>
  janitor::clean_names() |>
  dplyr::filter(team_or_opponent == "team") |>
  dplyr::mutate(
    season = season_end_year - 1,
    league =
      dplyr::case_when(
        competition_name == "Fußball-Bundesliga" ~ "Bundesliga",
        .default = competition_name
        ),
    squad = fix_team_names(squad)) |> 
  dplyr::select(league, season, squad, num_players) |>
  tidyr::drop_na()

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Combine Datasets ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

tm_combined <-
  dplyr::full_join(squad_values, transfer_balances)

fb_combined <-
  dplyr::full_join(league_tables, num_players)

club_resources <- 
  dplyr::full_join(fb_combined, tm_combined) |> 
  dplyr::mutate(
    season =
      forcats::as_factor(
        glue::glue(
          "{season}/{as.numeric(stringr::str_sub(season, start = -2)) + 1}"
        )
      )
  )

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save Final Dataset ----
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

readr::write_rds(
  club_resources, 
  file = here::here(
    "blog", "2024-07-20-money-in-football", "data", "club_resources.rds"
    )
  )
