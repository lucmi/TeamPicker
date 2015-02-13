library(shiny)

#players <- read.csv("Data/players.csv")

shinyUI(fluidPage(
  titlePanel("Basketball Team Picker"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("available",label = "Select available players", choices = c("None")),
      actionButton("makeTeams", label = "Make Teams")),
    mainPanel(
      helpText("Team 1:"),
      textOutput("team1"),
      helpText("Team 2:"),
      textOutput("team2")))
  
  ))