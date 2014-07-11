## load the required packages for the app
library(shiny)


## read in the database created with R/collect.R for the user's session
rankings = readRDS(file="data/rankings-db.rds")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  ## build user rankings here
  user_df = rankings
  
  ## keep the columns we want from the user rankings
  ## rep
  user_df = subset(user_df, select = c(INSTNM, gradrate6, yield))
  
  
  ## apply distance function and return closest schools
  
  
  ## the data for the table
  user_rankings = user_df
  
  
  # Filter data based on selections
  output$schools <- renderDataTable({
    user_df
  })
  

  
  
  
  
})