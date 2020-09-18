library(fivethirtyeight)
library(shinythemes)
library(tidyverse)

# tidying the dataset
candy_rankings <- candy_rankings
candy_rankings_tidy <- candy_rankings %>%
  gather(characteristics, present, -c(competitorname, sugarpercent, pricepercent, winpercent)) %>%
  mutate(present = as.logical(present)) %>%
  arrange(competitorname)

# for checkboxGroupInput
name_choices <- (candy_rankings_tidy %>%
                  count(competitorname))$competitorname

y_choice_values = names(candy_rankings_tidy)[1]
y_choice_names <- as.list(c("None", candy_rankings_tidy$competitornames))
names(y_choice_names) <- c("None", candy_rankings_tidy$competitornames)


# ui 
ui <- fluidPage(
  
  h1("Candy Power Rankings"),
  
  h3("Majd Rouhana"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "compet"
                         , label = "Include candies:"
                         , choices = name_choices
                         , selected = name_choices
                         , inline = TRUE),
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs"
                  , tabPanel("Sugar Percentile Scatterplot", plotOutput(outputId = "scatter1"))
                  , tabPanel("Unit Price Percentile Scatterplot", plotOutput(outputId = "scatter2"))
                  , tabPanel("Table", tableOutput(outputId = "table"))
      )
    )
  )
)

# server
server <- function(input,output){
  
  use_data <- reactive({
    data <- filter(candy_rankings_tidy, competitorname %in% input$compet)
  })
  
  output$scatter1 <- renderPlot({
    ggplot(data = use_data(), aes_string(x = "sugarpercent", y = "winpercent")) +
      geom_point() +
      labs(x = "Sugar Percentile", y = "Win Percentage") +
      geom_label(data = filter(candy_rankings_tidy, competitorname == input$compet)
                 , aes(label = competitorname))
  })
  
  output$scatter2 <- renderPlot({
    ggplot(data = use_data(), aes_string(x = "pricepercent", y = "winpercent")) +
      geom_point() +
      labs(x = "Unit Price Percentile", y = "Win Percentage") +
      geom_label(data = filter(candy_rankings_tidy, competitorname == input$compet)
                 , aes(label = competitorname))
  })
  
  output$table <- renderTable({
    dplyr::select(use_data(), competitorname, characteristics, present, "winpercent")
  })
}

# call to shinyApp
shinyApp(ui = ui, server = server)

