
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(stringr)
library(reshape2)
library(plyr)
library(ggplot2)
library(shiny)

source('load_sra_data.R')
sra_df <- get_data()
dataset <- sra_df

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Commonly Sequenced Bacteria"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("x", "X", c("CenterName","Model","ScientificName"), selected = "ScientificName"),
            selectInput("fill", "Fill Variable:", c("None","CenterName","Model","ScientificName"), selected = 'None'),
            selectInput('facet_row', 'Facet Row', c(None='.', c("CenterName","Model","ScientificName"))),
            selectInput('facet_col', 'Facet Column', c(None='.', c("CenterName","Model","ScientificName"))),
            hr(),
            downloadButton('downloadData','Download'),
            hr(),
            checkboxGroupInput("orgs", "Select Organisms of Interest:", 
                               choices = unique(dataset$ScientificName), 
                               selected = unique(dataset$ScientificName)),
            hr(),
            checkboxGroupInput("plat","Sequencing Platform:", 
                               choices = unique(dataset$Model),
                               selected = unique(dataset$Model)),   
            hr(),
            checkboxGroupInput("center","Sequencing Center:", 
                               choices = unique(dataset$CenterName),
                               selected = unique(dataset$CenterName))
    ),
    mainPanel(
            tabsetPanel(type = "tabs",
                tabPanel("Plot", plotOutput('plot')),
                tabPanel("Table", dataTableOutput('table'))
            )       
    )
)
))