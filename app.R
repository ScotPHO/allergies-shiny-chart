#Code to create chart of hepatitis c by board.

############################.
## Global ----
############################.
############################.
##Packages 

library(dplyr) #data manipulation
library(plotly) #charts
library(shiny)

#Preparing data - not needed unless new data coming through
library(reshape2)
library (readr)

data <- read_csv("//stats/phip/Website/Administration/Shiny/data/allergic_conditions.csv") %>%
  mutate_if(is.character, factor) %>%  #converting characters into factors
  setNames(tolower(names(.))) %>%
  melt(variable.name = "year")
data$year <- gsub("y", "", data$year)

# saveRDS(data, "./data/hepatitisc_board.rds")

data <- readRDS("./data/allergic_conditions.rds")

#Use for selection of areas
condition_list <- sort(unique(data$condition))

#ScotPHO logo. 
#Needs to be https address or if local in code 64 (the latter does not work with 4.7 plotly)
scotpho_logo <-  list(source ="https://raw.githubusercontent.com/jvillacampa/test/master/scotpho.png",
                      xref = "paper", yref = "paper",
                      x= -0.09, y= 1.2, sizex = 0.22, sizey = 0.18, opacity = 1)

############################.
## Visual interface ----
############################.
#Height and widths as percentages to allow responsiveness
#Using divs as issues with classing css 
ui <- fluidPage(style="width: 650px; height: 500px; ", 
                div(style= "width:100%", #Filters on top of page
                    h4("Chart 1. Acute Hospital Inpatient/Day Case Discharges with selected diagnoses"),
                    div(style = "width: 50%; float: left;",
                        selectInput("measure", label = "Select a measure type",
                                    choices = c("CIS", "Patients", "CIS Rate", "Patient Rate"
                                    ), selected = "CIS Rate")
                    ),
                    div(style = "width: 50%; float: left;",
                        selectInput("area", label = "Select a condition", 
                                    choices = condition_list))
                ),
                div(style= "width:100%; float: left;", #Main panel
                    plotlyOutput("chart", width = "100%", height = "350px"),
                    p(div(style = "width: 25%; float: left;", #Footer
                          HTML("Source: <a href='http://www.isdscotland.org/Health-Topics/Hospital-Care/Diagnoses/'>ISD, SMR 01</a>")),
                      div(style = "width: 25%; float: left;",
                          downloadLink('download_data', 'Download data')),
                      div(style = "width: 50%; float: left;",
                          "Notes: 1. These statistics are derived from data collected on discharges from hospitals for non-obstetric and 
    non-psychiatric hospitals (SMR01) in Scotland.
2. Data is for Main Diagnosis only.
3. Continuous Inpatient Stay (CIS) - A continuous inpatient stay is an unbroken period of time that a patient spends as an inpatient.
    A patient may change consultant, significant facility, speciality and/ or hospital during a CIS.
4. Data is for Scottish residents treated in Scotland.
5. Data is based on Financial Years which run from 1st April to 31st March.
")
                    )
                )
)

############################.
## Server ----
############################.
server <- function(input, output) {
  
  # Allowing user to download data
  output$download_data <- downloadHandler( 
    filename =  'allergic_conditions.csv', content = function(file) { 
      write.csv(data, file, row.names=FALSE) })
  
  ############################.
  #Visualization
  output$chart <- renderPlotly({
    #For Island plots and rates plot an empty chart
    

      #Data for condition
      data_condition <- data %>% subset(condition==input$area & measure==input$measure)
      
      #y axis title
      yaxistitle <- ifelse(input$measure == "CIS", "Number of Continuous Inpatient Stays (CIS)", ifelse(input$mearsure == "Patients", "Number of Patients", ifelse(input$mearsure == "CIS Rate", "Continuous Inpatient Stays (CIS), per 100,000 population",ifelse(input$mearsure == "Patient Rate", "Patients, per 100,000 population"))))
      
      plot <- plot_ly(data=data_condition, x=~year, y = ~value, 
                      type = "scatter", mode = 'lines',  line = list(color = '#08519c'),
                      name = unique(data_condition$condition), width = 650, height = 350) %>% 
      #Layout
        layout(annotations = list(), #It needs this because of a buggy behaviour
               yaxis = list(title = yaxistitle, rangemode="tozero", fixedrange=TRUE), 
               xaxis = list(title = "Financial Year",  fixedrange=TRUE),  
               font = list(family = 'Arial, sans-serif'), #font
               margin = list(pad = 4, t = 50), #margin-paddings
               hovermode = 'false',  # to get hover compare mode as default
               images = scotpho_logo) %>% 
        config(displayModeBar= T, displaylogo = F, collaborate=F, editable =F) # taking out plotly logo and collaborate button
    }
  ) 
  
} # end of server part

############################.
## Calling app ----
############################.

shinyApp(ui = ui, server = server)
