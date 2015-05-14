
# This is the server logic for a Shiny web application.
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

shinyServer(function(input, output) {    
    # make user specific variables
    dataset <- reactive({
    sra_df[sra_df$ScientificName %in% input$orgs & sra_df$Model %in% input$plat & sra_df$CenterName %in% input$center,]
    })
    
    output$plot <- renderPlot({
        # need to work out how to specify axis, nad maybe facet as well
        p <- ggplot(dataset(), aes_string(x=input$x, y= input$y)) + geom_bar() + theme_bw() + theme(axis.text.x = element_text(angle = 90))
        
        if(input$fill != 'None')
           p <- p + aes_string(fill = input$fill)
        
        facets <- paste(input$facet_row, '~', input$facet_col)
        if(facets != '. ~ .')
            p <- p + facet_grid(facets)
    
        print(p) 
    })
    
    output$table <- renderDataTable({
        dataset()
    })
    output$downloadData <- downloadHandler(
        filename = 'selected_sra.csv',
        content = function(file){
            write.csv(dataset(),file)
        }
    )
})
