library(Rspotify)
library(lubridate)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(ggvis)
library(plotly)
library(ggplot2)
library(tidyverse)
library(data.table)
library(dplyr)
library(viridis)
library(hrbrthemes)
library(DT)
library(lsa)
library(SnowballC)
if (FALSE) {
  library(RSQLite)
  library(dbplyr)
}


source("functions.R")
source("ui.R")
source("server.R")

# IV. Run App ---------------------------------------------------------------
shinyApp(ui = ui, server = server)
