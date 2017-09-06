library(DT)
library(shinythemes)

tagList(
    shinythemes::themeSelector(),
    navbarPage(
        "Word predictor",
        sidebarPanel(textInput("text", label = h4("Enter text here:"))),
        mainPanel(
            h4("The next word:"),
            hr(),
            DT::dataTableOutput("datatable"),
            h5('Author: Yangang Chen. University of Waterloo. Data source: SwiftKey')
        )
    )
)