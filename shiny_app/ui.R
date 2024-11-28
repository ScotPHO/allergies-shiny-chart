############################.
## Visual interface ----
############################.
#Height and widths as percentages to allow responsiveness
#Using divs as issues with classing css 
secure_app(
fluidPage(style="width: 650px; height: 500px; ", 
                div(style= "width:100%", #Filters on top of page
                    h4("Chart 1. Hospital admissions for different allergic conditions"),
                    div(style = "width: 50%; float: left;",
                        selectInput("measure", label = "Select numbers or rates",
                                    choices = c("Number", "Rate"), selected = "Rate")
                    ),
                    div(style = "width: 50%; float: left;",
                        selectizeInput("conditions", label = "Select up to four allergic conditions", 
                                       choices = condition_list, multiple = TRUE, selected = "All allergies",
                                       options = list(maxItems =4L)))
                ),
                div(style= "width:100%; float: left;", #Main panel
                    #plotlyOutput("chart", width = "100%", height = "350px"),
                    highchartOutput("line_chart"),
                    p(div(style = "width: 25%; float: left;", #Footer
                          HTML("Source: <a href='https://publichealthscotland.scot/resources-and-tools/health-intelligence-and-data-management/national-data-catalogue/national-datasets/search-the-datasets/general-acute-inpatient-and-day-case-scottish-morbidity-record-smr01/' target='_blank'>PHS, SMR 01</a>")),
                      div(style = "width: 25%; float: left;",
                          downloadLink('download_data', 'Download data')),
                      div(style = "width: 100%; float: left;",
                          h6("Notes: 1. These statistics are derived from data collected on discharges from hospitals for non-obstetric and 
    non-psychiatric hospitals (SMR01) in Scotland.", tags$br() , "
              2. Data is for main diagnosis only and for Scottish residents .")
                      )
                    )
                )
)#fluid page bracket
)