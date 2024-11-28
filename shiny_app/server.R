############################.
## Server ----
############################.
credentials_allergy <- readRDS("admin/credentials.rds")

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
  output$line_chart <- renderHighchart({
    
    #Data for condition
    data_condition <- data_allergy |> subset(type %in% input$conditions & measure == input$measure)
    
    #y axis title
    yaxistitle <- case_when(input$measure == "Number" ~ "Number of hospital admissions",
                            input$measure == "Rate" ~ "Hospital admissions <br>per 100,000 population")
    
    data_condition |> 
      hchart("line", hcaes(y = value, x = year, group = type)) |> 
      hc_colors(c('#abd9e9', '#74add1', '#4575b4', '#313695', '#022031')) |> 
      hc_xAxis(title = list(text = "Year")) |> 
      hc_yAxis(title = list(text = yaxistitle), min = 0) |> 
      hc_legend(align = "left", verticalAlign = "top")
    
  })
  
} # end of server part
