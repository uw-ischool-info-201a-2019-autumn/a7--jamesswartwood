library(httr)
library(jsonlite)
library(dplyr)
library(eeptools)
library(ggplot2)

# Getting the API access key for the ProPublica Congress API
source("../api_key.R")

# Creating a data frame that consists of the states and
# their abbreviations
state_data <- data_frame(state.abb, state.name)

# This function receives a state name and abbreviates it
abb_state <- function(state_name = "Washington") {
  state_abb <- state_data %>%
    filter(state_data$state.name == state_name) %>%
    pull(state.abb)
}

# This function receives two parameters, a chamber and state,
# and uses that information to access the API for data and
# then return the response as a data frame
get_reps_data <- function(chamber = "house", state = "Washington") {
  url <- paste0("https://api.propublica.org/congress/v1/members/", chamber,
                "/", abb_state(state), "/current.json")
  response <- GET(url, add_headers("X-API-Key" = api_key))
  response_text <- content(response, type = "text", encoding = "UTF-8")
  response_data <- fromJSON(response_text)
  df <- as.data.frame(response_data)
}

# This function receives a single parameter that represents an
# ID and then uses it to access the API for data related to the
# representative with that ID and then returns it as a data frame
get_rep_data <- function(id) {
  url <- paste0("https://api.propublica.org/congress/v1/members/",
                id, ".json")
  response <- GET(url, add_headers("X-API-Key" = api_key))
  response_text <- content(response, type = "text", encoding = "UTF-8")
  response_data <- fromJSON(response_text)
  df <- as.data.frame(response_data)
}

# This function receives a representative's ID and then
# calculates and returns their current age
get_rep_age <- function(id) {
  dob <- get_rep_data(id)
  dob <- as.Date(dob$results.date_of_birth)
  floor(age_calc(dob, enddate = Sys.Date(), units = "years"))
}

# This function receives a chamber and state as parameters
# and then organizes information on the representatives of
# the state into a data table
state_reps_table <- function(cha = "house", sta = "WA") {
  df <- get_reps_data(cha, sta) %>%
    mutate(Name = results.name,
           Party = results.party,
           Age = results.id,
           Twitter = results.twitter_id,
           Facebook = results.facebook_account)
  df$Age <- lapply(df$Age, get_rep_age)
  df <- df %>% select(Name, Party, Age, Twitter, Facebook)
}

# This function receives a chamber and state as parameters
# and uses them to return a vector consisting of the last
# names of the state's representatives
get_reps_names <- function(cha = "house", sta = "Washington") {
  get_reps_data(cha, sta) %>%
    select(results.last_name) %>%
    pull(results.last_name)
}

# This function receives a name, chamber, and state as parameters
# and then calls on multiple functions to gather and organize data
# specific to the representative with that name into a text return
rep_data <- function(name, cha= "house", sta = "Washington") {
  names <- get_reps_names(cha, sta)
  match <- data.frame(
    list = names
  )
  match <- match %>%
    filter(list == name) %>%
    nrow()
  if (match == 1) {
    df <- get_reps_data(cha, sta)
    id <- filter(df, df[[7]] == name)[[3]]
    full_name <- filter(df, results.last_name == name)[[4]]
    data <- get_rep_data(id)
    return(HTML(paste0("Name:<br>", full_name,
                       "<br><br>Website URL:<br>",
                       data$results.url,
                       "<br><br>Telephone Number:<br>",
                       data[[28]][[1]][[16]][[1]],
                       "<br><br>Postal Address:<br>",
                       data[[28]][[1]][[15]][[1]],
                       "<br><br>Party:<br>",
                       data[[28]][[1]][[6]][[1]])))
  } else {
    return(paste0(name, " is not a member of congress."))
  }
}

# This function receives a state as a parameter and then
# generates a plot that represents the gender balance of
# that state
gender_plot <- function(sta = "Washington") {
  df <- get_reps_data("house", sta)
  gender_freq <- df %>%
    mutate(Gender = results.gender) %>%
    group_by(Gender) %>%
    summarize(Freq = n())
  freq_plot <- ggplot(data = gender_freq) +
    geom_col(mapping = aes(x = Gender, y = Freq), fill = "steelblue") +
    coord_flip() +
    labs(
      title = "Gender balance:",
      x = "Gender",
      y = "Number of Representatives"
    )
}

# This function receives a state as a parameter and then
# generates a plot that represents the party balance of
# that state
party_plot <- function(sta = "Washington") {
  df <- get_reps_data("house", sta)
  party_freq <- df %>%
    mutate(Party = results.party) %>%
    group_by(Party) %>%
    summarize(Freq = n())
  freq_plot <- ggplot(data = party_freq) +
    geom_col(mapping = aes(x = Party, y = Freq), fill = "steelblue") +
    coord_flip() +
    labs(
      title = "Party balance:",
      x = "Party",
      y = "Number of Representatives"
    )
}
