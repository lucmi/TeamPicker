library(shiny)

function(input,output,session){
  
  players <- read.csv("Data/players.csv", stringsAsFactors = F)
  
  team1 <- c("")
  team2 <- c("")
  
  updateCheckboxGroupInput(session,"available",choices=players[,1])
  
  output$scores <- renderTable(players)
  
  # function makes teams from players selected in checkboxGroupInput "available" using the scores
  # provided the players data file
  funcMakeTeams <- function(){
    availPlayers <- input$available
    availScores <- players[which(players[,1] %in% input$available),2]
    
    if(!is.null(availPlayers)){
      teams <- combn(availPlayers, ceiling(length(availPlayers)/2))
      
      oppose <- apply(teams, 2, function(x) availPlayers[!availPlayers %in% x])
      
      teamTotals <- apply(teams,2,function(x) sum(as.double(availScores[match(x,availPlayers)])))
      opposeTotals <- apply(oppose,2,function(x) sum(as.double(availScores[match(x,availPlayers)])))
      
      team1 <- teams[,which.min(abs(teamTotals-opposeTotals))]
      team2 <- oppose[,which.min(abs(teamTotals-opposeTotals))]
    }
    
    output$team1 <- renderText({
      team1
    })
    
    output$team2 <- renderText({
      team2
    })
  }
  
  # Function will alter data in the players table based on the input provided in the textboxInput
  # "query". Allows scores to change, and players to be added and deleted.
  funcChangeData <- function(strInput){
    
    strInput <- unlist(strsplit(strInput," "))
    
    if(tolower(strInput[1]) == "alter"){
           funcAlter(strInput[2],as.double(strInput[3]))
    }
    else if(tolower(strInput[1]) == "add"){
           funcAdd(strInput[2],as.double(strInput[3]))
    }
    else if(tolower(strInput[1]) == "delete"){
           funcDelete(strInput[2])
    }   
    
    updateCheckboxGroupInput(session,"available",choices=players[,1])      
    output$scores <- renderTable(players)
    write.csv(players,file="Data/players.csv",quote = F,row.names=F)
  }
  
  funcAdd <- function(strPlayer,dblScore){
    if(is.character(strPlayer) && is.double(dblScore)){
      players <<- rbind(players,data.frame(player=strPlayer,score=dblScore, stringsAsFactors = F))
    }
  }
  
  funcAlter <- function(strPlayer,dblScore){
    if(is.character(strPlayer) && is.double(dblScore) && nrow(players[which(players[,1] == strPlayer),]) > 0){
      players[which(players[,1] == strPlayer),]$score <<- dblScore
    }
  }
  
  funcDelete <- function(strPlayer){
    players <<- players[which(players[,1] != strPlayer),]
  }
  
  observeEvent(input$makeTeams,funcMakeTeams())

  observeEvent(input$runQuery,funcChangeData(input$query))
  
}