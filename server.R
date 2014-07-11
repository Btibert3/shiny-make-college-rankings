## load the required packages for the app
library(shiny)
library(plyr)

## read in the database created with R/collect.R for the user's session
rankings = readRDS(file="data/rankings-db.rds")

## filter the data to what we will use in the app
rankings = subset(rankings, select = c(INSTNM, 
                                       ENRLT,
                                       yield,
                                       IGRNT_P,
                                       NPGRN2,
                                       RET_PCF,
                                       STUFACR,
                                       gradrate6))

## Squared Euclidean distance for each school from the user's prefs
## http://en.wikipedia.org/wiki/Euclidean_distance#Squared_Euclidean_distance
calcUserPref = function(mydf, U_ENROLL = 975, 
                              U_YIELD = .30, 
                              U_IGRNT = 70, 
                              U_NPG = 21000, 
                              U_RET = 95, 
                              U_SF = 12, 
                              U_GR = 90) 
{
  ## calc the sum of squares 
  sed =  (mydf$ENRLT - U_ENROLL)^2 + 
        (mydf$yield - U_YIELD)^2 +
        (mydf$IGRNT_P - U_IGRNT)^2 + 
        (mydf$NPGRN2 - U_NPG)^2 + 
        (mydf$RET_PCF - U_RET)^2 + 
        (mydf$STUFACR - U_SF)^2 + 
        (mydf$gradrate6 - U_GR)^2
  
  ## add the column to the dataframe
  mydf$dist = sed
  
  ## create the rank, smaller values first
  mydf = transform(mydf, rank = )
  return(mydf)
}


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  ## build user rankings here
  user_df = rankings
  
  ## keep the columns we want from the user rankings
  ## rep

  
  
  ## apply distance function and return closest schools
  final_df = 1
  
  
  ## the data for the table
  user_rankings = user_df
  
  
  # Filter data based on selections
  output$schools <- renderDataTable({
    user_df
  })
  

  
  
  
  
})