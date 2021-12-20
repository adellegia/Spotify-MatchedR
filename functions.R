## MATCHEDR: Back End Functions

library(Rspotify)
library(tidyverse)
library(BBmisc)


# I. Preliminaries ----
# set up developer keys first in order to retrieve data
client_id <- '8b3bd5ccb690416f85c876e2ffc4138a'
secret <- '45f55d8ebb1645eeb903b558d3288417' #do not share
user_id <- '12153873361'
#keys <- spotifyOAuth(user_id, client_id, secret)


# II. Functions ----
  ## IIa. Data: Top tracks ----
get_toptracks <- function(userid = "None", year = 2021) {
    # get user info
  userinfo <- getUser(userid, token = keys) %>%
    rename(user_id = id, user_followers = followers)
  
    # get all user playlists
  u <- getPlaylists(user_id = userid, token = keys)
  
    # get top 100 tracks of the year
  tracks <- getPlaylistSongs(user_id = userid, 
                             playlist_id = u$id[u$name == paste0("Your Top Songs ",year)], 
                             token = keys) %>%
    rename(track_id = id) %>%
    mutate(user_id = userid) %>%
    as.data.frame()
  
    # get features of tracks
  topsongs_features <- getFeatures(track_id = tracks$track_id[1], 
                                   token = keys)
  
  for (i in 2:nrow(tracks)) {
    topsongs_features[i,] <- getFeatures(track_id = tracks$track_id[i], 
                                         token = keys)
  }
  
  topsongs_features <-  topsongs_features %>% 
    rename(track_id = id)
  
    # join datasets
  toptracks <- as.data.frame(left_join(tracks, topsongs_features, by = "track_id"))
  toptracks<- left_join(toptracks, userinfo, by = "user_id") %>%
    mutate(popularity = popularity/100)
  
  return(toptracks)
}

# Example to retrieve data
#cbind(get_toptracks(userid, year), get_topartists(userid, year))

  ## IIb. Data: Top artists ----
get_topartists <- function(userid = "None", year = 2021) {
  u <- getPlaylists(user_id = userid, token = keys)
  
  tracks <- getPlaylistSongs(user_id = userid, 
                             playlist_id = u$id[u$name == paste0("Your Top Songs ",year)], 
                             token = keys) %>%
    rename(track_id = id) %>%
    mutate(user_id = userid) %>%
    as.data.frame()
  
    # get artist genre in top 100 tracks of the year as "artists" df
  artists <- searchArtist(tracks$artist[1], 
                                   token = keys) %>%
            filter(id == tracks$artist_id[1])
  
  for (i in 2:nrow(tracks)) {
    try(artists[i,] <- searchArtist(artist = tracks$artist[i], 
                                         token = keys) %>%
                  filter(id == tracks$artist_id[i]), silent = T)
  }
  artists <- artists %>%
    select(artist, genres, id, popularity, followers) %>%
    rename(artist_id = id,
           artist_popularity = popularity,
           artist_followers = followers)
  
  artists$year <- year

  return(artists) 
}

  ## IIc. Matching: similarity score ----

    # Euclidean distance for calculating similarity score
euclid <- function(x, y){
  1/(1+sqrt(sum((x - y) ^ 2)))
} 

# III. Aesthetics ----
charts.theme <- theme(axis.title.y = element_text(size = 10, margin = margin(l = 15), face = "bold"),
                      axis.title.x = element_text(size = 10, margin = margin(t = 15), face = "bold"),
                      axis.text.x = element_text(size = 10),
                      axis.text.y = element_text(size = 10),
                      axis.ticks = element_blank(),
                      #axis.line.x = element_line("black", size = 0.5), 
                      #axis.line.y = element_line("black", size = 0.5),
                      axis.line.x = element_line("transparent", size = 0.5), 
                      axis.line.y = element_line("transparent", size = 0.5),
                      panel.border = element_rect(color = "#a3a3a3", fill = "transparent"),
                      panel.background = element_rect(fill = "white", color = "white"),
                      #panel.grid.major = element_line(color = "white"),
                      #panel.grid.minor = element_line(color = "white"),
                      panel.grid.major = element_line(color = "#d4d4d4", linetype = 2),
                      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
                      plot.subtitle = element_text(size = 10, face = "italic", hjust = 0.5, margin = margin(b = 15)),
                      legend.position = "bottom",
                      legend.box = "vertical",
                      legend.box.margin = margin(b = 15),
                      legend.margin = margin(r = 10),
                      legend.background = element_rect(fill = "transparent"),
                      legend.spacing.x = unit(0.4, "cm"),
                      legend.key = element_blank(),
                      legend.title = element_blank(),
                      legend.text = element_text(size = 12),
                      plot.caption = element_text(size = 10, hjust = 0),
                      strip.background = element_rect(fill = "transparent"),
                      strip.text = element_text(size = 12, face = "bold"))





