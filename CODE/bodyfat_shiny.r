library(shiny)
library(tidyverse)
library(lubridate)



get_bdyfat = function(x1, x2) {
  int = -38.57
  x1 = x1 * 2.54 #convert inch input to model cm input
  coef1 = 0.88
  coef2 = -0.14
  
  return(int + x1*coef1 + x2*coef2 )
}


ui = fluidPage(
  titlePanel("Bodyfat Prediction"),

  sidebarLayout(
    sidebarPanel(
      "Please enter your measurements: ",
      numericInput("x1", "Abdomin Circumference (inch)", 35),
      numericInput("x2", "Weight (lbs)", 180)
      
    ),
    mainPanel(
      textOutput("value"),
      tags$head(tags$style("#value{color: black;
                                 font-size: 20px;
                                 font-style: italic;
                                 }"
      )
      )
    )
  )
  ,
  
  #textOutput("value"),
  #verbatimTextOutput("cal")
)

server <- function(input, output) {
  bdyfat = reactive({
    get_bdyfat(input$x1, input$x2)
  })
  
  output$value <- renderText({
    paste("Your estimated bodyfat is ", bdyfat(), "%.", sep = "")
  })
  
}

app <- shinyApp(ui, server)
# Run in browser
runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))
