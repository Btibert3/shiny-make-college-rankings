###############################################################################
## Setup
###############################################################################

## load the packages we need for the user
library(shiny)

## read in the database created with R/collect.R for the user's session
rankings = readRDS(file="data/rankings-db.rds")




###############################################################################
## Build the UI for the app
###############################################################################
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Create Your Own College Rankings"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      h3("Setup"),
      p("Use the sliders below to input your preferences."),
      br(),
      sliderInput("enroll",
                  "First Year Enrollment",
                  min = min(rankings$ENRLT),
                  max = max(rankings$ENRLT),
                  value = c(1000, 3000)),
      br(),
      sliderInput("yield",
                  "Prestige: The % of admits that enroll",
                  min = min(rankings$yield),
                  max = max(rankings$yield),
                  value = c(30, 85)),
      sliderInput("igrnt",
                  "% Recieving School Grant/Scholarship:",
                  min = min(rankings$IGRNT_P),
                  max = max(rankings$IGRNT_P),
                  value = c(20, 80)),
      sliderInput("netprice",
                  "Average Net Price during Year 1",
                  min = min(rankings$NPGRN2),
                  max = max(rankings$NPGRN2),
                  value = c(5000, 32000)),
      sliderInput("retention",
                  "First-year Retention %",
                  min = min(rankings$RET_PCF),
                  max = max(rankings$RET_PCF),
                  value = c(75, 95)),
      sliderInput("sf",
                  "Student : Faculty Ratio",
                  min = min(rankings$STUFACR),
                  max = max(rankings$STUFACR),
                  value = c(5, 15)),
      sliderInput("grad",
                  "% that Graduate in 6 years",
                  min = min(rankings$gradrate6),
                  max = max(rankings$gradrate6),
                  value = c(75, 95))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput(outputId="schools")
    )
  )
))