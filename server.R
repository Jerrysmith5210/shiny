library(shiny)
library(plotly)
library(dplyr)


finaldata1 <- read.csv("my_data.csv")

# Define the server logic

function(input, output) { 
  
  output$plot <- renderPlotly({
    
    # Plot using plotly
    plot_ly(finaldata1, x = ~GDP.per.capita, y = ~lifeExpectancy, color = ~region, size = ~population, type = "scatter", mode = "markers", sizes = c(10, 1000), text = ~country, frame = ~year) %>%
      layout(title = "GDP per Capita vs. Life Expectancy",
             xaxis = list(title = "GDP Per Capita", type = "log"),
             yaxis = list(title = "Life Expectancy"))
    
  })
}