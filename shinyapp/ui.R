library(shiny)
library(shinythemes)

# Defining the About page for the Shiny application
about <- tabPanel(
    "About",
    titlePanel("About Page"),
    br(),
    
    h3("Overview:"),
    p("The United States Congress consists of many representatives,
      each of whom is an individual and unique among the masses.
      Every representative has differing characteristics, such as age,
      gender, party affiliation, contact information, and much more.
      All of this data is collected, stored, and readily accessible
      through the use of the ProPublica Congress API. Using this API,
      one can access legislative data on the House of Representatives,
      the Senate, and the Library of Congress. It includes detailed
      information regarding the representatives in these congressional
      bodies, such as personal information, contact information, voter
      information, and more. Access to this information requires an
      access key that can be claimed on the ProPublica website."),
    p("For this assignment, it was expected of me to access the
      legislative data through the ProPublica Congress API, organize
      it through R, Shiny, and any other resources I choose, and then
      publish it as a Shiny application online. To do so, I created
      four files in which I would store and run my code to make this
      work. The first two are the ui.R and server.R for my Shiny
      application, which set the UI format and server input and output.
      The third is the ProPublica API key, which allows me to access
      the information available through the API. The fourth is the
      propublica.R file, which defines many of the functions that are
      used by the Shiny application to gather and organize the data
      into the desirable chunks."),
    p("I was tasked with organizing this Shiny application into three
      pages. The first one, the page you are currently on, includes the
      assignment overview, the affiliation information, and a
      reflection on the assignment. The second one includes input
      variables on the sidebar that allow the user to filter the
      desired data results, which are then shown through the use of a
      data table in the main content section and a detailed summary of
      a specified representative at the bottom of the sidebar. The
      third page of this application uses the selected state input on
      the second page to display more summary information in the form
      of plots."),
    HTML("<p>Link to the ProPublica Congress API: <a
         href='https://projects.propublica.org/api-docs/congress-api/'>
         API Link</a></p>"),
    br(),
    
    h3("Affiliation:"),
    p("James Swartwood"),
    p("INFO-201A: Technical Foundations of Informatics"),
    p("The Information School"),
    p("University of Washington"),
    p("Autumn 2019"),
    br(),
    
    h3("Reflective Statement:"),
    p("This assignment provided valuable experience using both R and
      Shiny to create an application with much practical value. I was
      able to practice accessing an API for the first time and used a
      variety of R packages to organize the data into easily
      accessible visuals. I encountered many challenges along the way,
      but through perserverance, research, and critical thinking was
      able to complete the deliverable."),
    p("This application allows its users to view personal contact
      information of the representatives in the United States House of
      Representatives and Senate. These representatives ideally make
      decisions in hopes to better the community and the lives of the
      people they represent. But as Cathy O'Neil points out in her
      book Weapons of Math Destruction, \"We will probably never have
      a simple and universally agreed upon definition of what makes an
      algorithm fair... We're finally having the conversation... in a
      deliberate, careful, and inclusive way that will set a standard
      for the future...\" She acknowledges the fact that to make truly
      ethical decisions there is a need for input from a diverse array
      of individuals. Relating this to our representatives, we have
      the right to give our input in their dealings, and this Shiny
      application has the information that gives you that ability
      readily available to anyone.")
)

# Defining the Representatives page for the Shiny application
state_representatives <- tabPanel(
    "Representatives",
    titlePanel("State Representatives"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "chamber",
                label = "Select Chamber",
                choices = c("House" = "house", 
                            "Senate" = "senate")
            ),
            selectInput(
                inputId = "selected_state",
                label = "Select State",
                choices = state.name,
                selected = "Washington"
            ),
            textInput(
              inputId = "selected_representative",
              label = "Select Representative (by last name)"
            ),
            htmlOutput(outputId = "rep_data")
        ),
        mainPanel(
            DT::dataTableOutput("reps_table")
        )
    )
)

# Defining the Summary page for the Shiny application
summary_page <- tabPanel(
    "Summary",
    titlePanel("Summary Information"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "selected_state_2",
                label = "Select State",
                choices = state.name,
                selected = "Washington"
            )
        ),
        mainPanel(
            plotOutput("gender_plot"),
            plotOutput("party_plot")
        )
    )
)

# Defining the UI for the Shiny app and specifying the three pages
ui <- navbarPage(
    "ProPublica Assignment",
    theme = shinytheme("cerulean"),
    about,
    state_representatives,
    summary_page
)

shinyUI(ui)
