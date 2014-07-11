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
                  value = 500),
      br(),
      sliderInput("admit",
                  "How selective? % applicants admitted",
                  min = min(rankings$yield),
                  max = max(rankings$yield),
                  value = 50),
      sliderInput("igrnt",
                  "% Recieving School Grant/Scholarship:",
                  min = min(rankings$IGRNT_P),
                  max = max(rankings$IGRNT_P),
                  value = 50),
      sliderInput("netprice",
                  "Average Net Price during Year 1",
                  min = min(rankings$NPGRN2),
                  max = max(rankings$NPGRN2),
                  value = round(median(rankings$NPGRN2), 0)),
      sliderInput("retention",
                  "First-year Retention %",
                  min = min(rankings$RET_PCF),
                  max = max(rankings$RET_PCF),
                  value = 75),
      sliderInput("sf",
                  "Student : Faculty Ratio",
                  min = min(rankings$STUFACR),
                  max = max(rankings$STUFACR),
                  value = round(median(rankings$STUFACR), 0)),
      sliderInput("grad",
                  "% that Graduate in 6 years",
                  min = min(rankings$gradrate6),
                  max = max(rankings$gradrate6),
                  value = 50)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput(outputId="schools")
    )
  )
))