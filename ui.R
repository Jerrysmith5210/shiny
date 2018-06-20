library(shiny)
library(plotly)


finaldata1 <- read.csv("my_data.csv")


fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP per Capita vs. Life Expectancy
")
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
)