library(shiny)

#players <- read.csv("Data/players.csv")

navbarPage( 
  "Basketball Team Picker",
  tabPanel("Pick Team",  
          sidebarLayout(
            sidebarPanel(
              checkboxGroupInput("available",label = "Select available players", choices = c("None")),
              actionButton("makeTeams", label = "Make Teams")),
            mainPanel(
                      helpText("Team 1:"),
                      textOutput("team1"),
                      helpText("Team 2:"),
                      textOutput("team2"))
          )
  ),
  tabPanel("Edit Data",
           sidebarLayout(
             sidebarPanel(
               textInput("query", "Enter query to alter data"),
               actionButton("runQuery", label = "Run Query"),
               br(),
               helpText("Permissable actions are 'alter', 'add' and 'delete'. Expressions
                        should be in form: {alter|add|delete} name [score]. Score is optional for delete")),
             mainPanel(
               tableOutput("scores")))
  )
)