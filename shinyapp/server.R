library(shiny)
library(DT)
library(stringr)

source("../propublica.R")

shinyServer(function(input, output) {
    
    # Defining a reactive function that calls on the
    # state_reps_table function to create the data table
    data_table <- reactive({
        state_reps_table(input$chamber,
                         input$selected_state)
    })
    
    # Defining the data table output by calling on the
    # reactive data_table function
    output$reps_table <- DT::renderDataTable({data_table()})
    
    # Defining a reactive function that generates the
    # desired output text for individual representative data
    representative_data <- reactive({
        if (input$selected_representative == "") {
            return("Enter a last name for detailed information
                   on a representative.")
        } else {
            return(rep_data(input$selected_representative,
                            input$chamber, input$selected_state))
        }
    })
    
    # Defining the individual representative data output by
    # calling on the reactive representative_data function
    output$rep_data <- renderUI({representative_data()})
    
    # Defining a reactive function that generates the
    # state gender balance plot
    reactive_gender_plot <- reactive({
        gender_plot(input$selected_state_2)
    })
    
    # Outputs the state gender balance plot
    output$gender_plot <- renderPlot({reactive_gender_plot()})
    
    # Defining a reactive function that generates the
    # state party balance plot
    reactive_party_plot <- reactive({
        party_plot(input$selected_state_2)
    })
    
    # Outputs the state party balance plot
    output$party_plot <- renderPlot({reactive_party_plot()})
})
