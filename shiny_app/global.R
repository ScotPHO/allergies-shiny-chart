############################.
## Global ----
############################.
############################.
##Packages 

library(dplyr) #data manipulation
library(plotly) #charts
library(shiny)
library(shinymanager)


# Preparing data - not needed unless new data coming through
library(tidyr)
# 
# data_allergy <- readRDS("/PHI_conf/ScotPHO/Website/Topics/Allergy/december2020_update/allergy_scotland_chart.rds") %>%
#   mutate(rate = round(rate, 1), # round numbers more (one decimal place)
#          numerator = case_when(numerator < 5 ~ NA_real_,
#                                TRUE ~ numerator)) %>%  # supression of under 5
#   gather(measure, value, -c(type, year)) %>%
#   mutate(measure = recode(measure, "numerator" = "Number", "rate" = "Rate"))

#saveRDS(data_allergy, "data/allergy_scotland_chart.rds")
#PRA Data - not to be published
#saveRDS(data_allergy, "allergy_scotland_chart_PRA.rds")

#data_allergy <- readRDS("allergy_scotland_chart.rds") 
data_allergy <- readRDS("allergy_scotland_chart_PRA.rds") 

#Use for selection of conditions
condition_list <- sort(unique(data_allergy$type))

#ScotPHO logo. 
#Needs to be https address or if local in code 64 (the latter does not work with 4.7 plotly)
scotpho_logo <-  list(source ="https://raw.githubusercontent.com/ScotPHO/plotly-charts/master/scotpho.png",
                      xref = "paper", yref = "paper",
                      x= -0.09, y= 1.2, sizex = 0.22, sizey = 0.18, opacity = 1)

