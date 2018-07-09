#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

select_years <- c(2042, 2092)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Lakes"),
   sidebarLayout(
     sidebarPanel(
      selectInput( "Year_select","Year", choices = select_years)
     ),

   
        


      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
    ggmap(Wisconsin_map) +
    geom_point(data = filter(shape_reg_predictions, Year == input$Year_select), aes(x = V1, V2, color = log(Prob)))
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

