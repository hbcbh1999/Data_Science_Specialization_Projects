library(leaflet)
library(DT)

# Choices for drop-downs
vars_language <- c( "Total population of the cities/divisions" = "Total",
                    "Population speaking only English in the cities/divisions" = "ENG",
                    "Population speaking only French in the cities/divisions" = "FRA",
                    "Population speaking both English and French in the cities/divisions" = "ENGFRA",
                    "Population speaking neither official languages in the cities/divisions" = "NO" )
vars_age <- c( "All ages" = "1", "0 to 14" = "2", "0 to 4" = "3", "5 to 9" = "4", "10 to 14" = "5",
               "15 to 64" = "6", "15 to 24" = "7", "15 to 19" = "8", "20 to 24" = "9", "25 to 44" = "10",
               "45 to 64" = "11", "65 and over" = "12", "65 to 74" = "13", "75 and over" = "14" )
vars_province <- c( "Canada" = "Canada", "Alberta" = "AB", "British Columbia" = "BC",
                    "Manitoba" = "MB", "New Brunswick" = "NB", "Newfoundland and Labrador" = "NL",
                    "Nova Scotia" = "NS", "Northwest Territories" = "YT",
                    "Ontario" = "ON", "Prince Edward Island" = "PE", 
                    "Quebec" = "QC", "Saskatchewan" = "SK", "Yukon" = "YT")

navbarPage("A Canadian Language Map - Population by knowledge of official languages", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        # Main panel: Interactive map
                        tags$head(
                            # Include our custom CSS
                            includeCSS("styles.css"),
                            includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Side panel: Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 520, bottom = "auto",
                                      width = 350, height = "auto",

                                      selectInput("age", "Select age group", vars_age),
                                      selectInput("language", "Select language", vars_language),
                                      selectInput("province", "Select province/territory", vars_province)
                        ),

                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 10, bottom = "auto",
                                      width = 500, height = "auto",

                                      plotOutput("pieNational")
                        ),
                        
                        # End tag of the map
                        tags$div(id="cite",
                                 'Data source: Statistics Canada, open data. Yangang Chen. University of Waterloo.')
                    )
           ),
           
           tabPanel("Data explorer",
                    fluidRow(selectInput("province1", "Select province/territory", vars_province),
                             selectInput("age1", "Select age group", vars_age)
                    ),
                    hr(),
                    DT::dataTableOutput("datatable"),
                    h5('Data source: Statistics Canada, open data.
                       http://open.canada.ca/data/en/dataset/e1ab446f-f619-47e7-89a2-745157d26ded')
           )
)
