library(shiny)
library(dplyr)
library(fmsb)
library(maps)

data <- read.csv("incarceration_trends.csv")

summary_page <- tabPanel(
  "Index",
  titlePanel("Introduction"),
  p("In this incarceration data, I choose 8 variables to analyze. They are year, 
    and the jail population from total and different races, such as total jail 
    population, Jail Population Count, Asian American / Pacific Islander, 
    Jail Population Count, Black, Jail Population Count, Latinx, 
    Jail Population Count, Native American, Jail Population Count, White, 
    and Unknown or Other Racial Category"),
  p("5 relevant values of interest are the following:"),
  p("- The mean of each value in most recent year(2018): 248.944975   2.389794  83.602482 38.293354   3.483077 116.872256   1.291223
"),
  p("- The difference between the max and min mean number in different races: 247.6538
"),
  p("- The highest number of jail population in each race: 286.4  5024.0  8728.0   379.0  4577.0   608.0
"),
  p("- The lowest number of jail population in each race: 0 0 0 0 0 0 0
"),
  p("- The number of people are incarcerated in different racial groups in different
      years: from this table, we could see the change of jail population in different racial groups within the years."),
  
  titlePanel("Trends over time chart"),
  p("The chart I made shows the jail population in different races increased with 
  time. I created this graph to demonstrate how much and how quickly the jail 
  population grows in different races in comparison. This will be more visually 
  appealing. According to the graph, the total jail population increased significantly 
  between 1995 and 2000, with the white population increasing the most, followed by 
  the black and latinx populations."),
  
  titlePanel("Variable comparison chart"),
  p("This graph depicts the relationship between the black and total prison 
  populations. I included this chart to see if the increasing jail population in 
  black is related to the overall increasing population. According to the graph,
  as the total jail population increased, so did the black jail population. As a 
  result, they have a positive relationship."),
  
  titlePanel("Map"),
  p("In this project, two maps were created. These two charts were included because
  they show the jail population in the mainland United States for white and black 
  people separately. We can see from the maps that the density of both white and 
  black jail populations is fairly consistent across the country. The north of 
  the country appears to have a larger jail population than the south of the country 
  in general.")
)

ui <- navbarPage(
  title = "My website",
  summary_page,
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)

