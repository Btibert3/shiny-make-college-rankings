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

## source the helper functions
source("R/calcUserPref.R")
source("R/between.R")
       
###############################################################################
## The Server
###############################################################################

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  user_prefs = reactive({
    
    ## get the average of the user's ranges per input to find the closest schools 
    ## based on Euclidian distance
    U_ENROLL = mean(input$enroll)
    U_YIELD = mean(input$yield)
    U_IGRNT = mean(input$igrnt)
    U_NPG = mean(input$netprice)
    U_RET = mean(input$retention)
    U_SF = mean(input$sf)
    U_GR = mean(input$grad)
    
    ## filter the data to include schools based on the users rankings
    user_pop = subset(rankings, 
                      between(ENRLT, input$enroll[1], input$enroll[2]) &
                      between(yield, input$yield[1], input$yield[2]) &
                      between(IGRNT_P, input$igrnt[1], input$igrnt[2]) &
                      between(NPGRN2, input$netprice[1], input$netprice[2]) &
                      between(RET_PCF, input$retention[1], input$retention[2]) &
                      between(STUFACR, input$sf[1], input$sf[2]) &
                      between(gradrate6, input$grad[1], input$grad[2]))
    
    ## apply the distance calculation to the filtered data
    ## so we can apply a user-driven rank-ordered list
    user_df = calcUserPref(user_pop, 
                           U_ENROLL,
                           U_YIELD,
                           U_IGRNT,
                           U_NPG,
                           U_RET,
                           U_SF,
                           U_GR)
    
    ## sort the schools based on ranking
    user_df = arrange(user_df, rank)
    
    ## remove the temp calcs
    user_df$dist = NULL
    user_df$rank = NULL
    
    ## user friendly column names
#     COLS = c("School",
#                  "FY Enrollment",
#                  "Presitge %",
#                  "% Awarded School $",
#                  "Net Price",
#                  "Freshmen Retention",
#                  "S:F Ratio",
#                  "% Grad in 6 Yrs")
#     colnames(user_df) = COLS
    
    ## return the data
    user_df

  })


  # Filter data based on selections
  output$schools <- renderDataTable({
    user_prefs()
  })
  
})