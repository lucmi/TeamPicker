library(shiny)

shinyServer(function(input,output,session){
  
  players <- read.csv("Data/players.csv")
  
  team1 <- c("")
  team2 <- c("")
  
  updateCheckboxGroupInput(session,"available",choices=paste(players[,1]))
  
  observe({
    
    input$makeTeams
    
    isolate({
      availPlayers <- input$available
      availScores <- paste(players[which(players[,1] %in% input$available),2])
      
      if(!is.null(availPlayers)){
        teams <- combn(availPlayers, ceiling(length(availPlayers)/2))
        
        oppose <- apply(teams, 2, function(x) availPlayers[!availPlayers %in% x])
        
        teamTotals <- apply(teams,2,function(x) sum(as.double(availScores[match(x,availPlayers)])))
        opposeTotals <- apply(oppose,2,function(x) sum(as.double(availScores[match(x,availPlayers)])))
        
        team1 <- teams[,which.min(abs(teamTotals-opposeTotals))]
        team2 <- oppose[,which.min(abs(teamTotals-opposeTotals))]
      }
    })
          
    output$team1 <- renderText({
      team1
    })
    
    output$team2 <- renderText({
      team2
    })
  })
})