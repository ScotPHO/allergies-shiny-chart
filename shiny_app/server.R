############################.
## Server ----
############################.
credentials_allergy <- readRDS("credentials.rds")

function(input, output) {
  
  # Shinymanager Auth
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials_allergy)
  )
  
  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })
  
  # Allowing user to download data
  output$download_data <- downloadHandler( 
    filename =  'allergic_conditions.csv', content = function(file) { 
      write.csv(data_allergy, file, row.names=FALSE) })
  
  ############################.
  #Visualization
  output$chart <- renderPlotly({
    
    #Data for condition
    data_condition <- data_allergy %>% subset(type %in% input$conditions & measure==input$measure)
    
    #y axis title
    yaxistitle <- case_when(input$measure == "Number" ~ "Number of hospital admissions",
                            input$measure == "Rate" ~ "Hospital admissions <br>per 100,000 population")
    
    plot <- plot_ly(data=data_condition, x=~year, y = ~value, color = ~type,
                    colors = c('#abd9e9', '#74add1', '#4575b4', '#313695', '#022031'),
                    type = "scatter", mode = 'lines',
                    width = 650, height = 350) %>% 
      #Layout
      layout(annotations = list(), #It needs this because of a buggy behaviour
             yaxis = list(title = yaxistitle, rangemode="tozero", fixedrange=TRUE), 
             xaxis = list(title = "Financial year",  fixedrange=TRUE, tickangle = 270),  
             font = list(family = 'Arial, sans-serif'), #font
             margin = list(pad = 4, t = 50, r = 30), #margin-paddings
             hovermode = 'false',  # to get hover compare mode as default
             images = scotpho_logo) %>% 
      config(displayModeBar= T, displaylogo = F) # taking out plotly logo and collaborate button
  }
  ) 
  
} # end of server part