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
      "Thank you for using our app, if you have any questions, please contact us: slee2253@wisc.edu, xli2422@wisc.edu, zou47@wisc.edu",
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
    if (!is.numeric(input$x1)){
      stop(safeError("Please enter numeric inputs."))
    }
    if (!is.numeric(input$x2)){
      stop(safeError("Please enter numeric inputs."))
    }
    get_bdyfat(input$x1, input$x2)
  })
  
  output$value <- renderText({
    if (!bdyfat()>0 ) {
      stop(safeError("Negative bodyfat. Please check your inputs. "))
    }
    paste("Your estimated bodyfat is ", bdyfat(), "%.", sep = "")
  })
  
}

app <- shinyApp(ui, server)
# Run in browser
#runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))
