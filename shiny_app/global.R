############################.
## Global ----
############################.
############################.
##Packages 

library(dplyr) #data manipulation
library(plotly) #charts
library(highcharter) #charts
library(shiny)
library(shinymanager)
library(phsstyles) #chart colours

data_allergy <- readRDS("allergy_scotland_chart.rds")

#Use for selection of conditions
condition_list <- sort(unique(data_allergy$type))

## END