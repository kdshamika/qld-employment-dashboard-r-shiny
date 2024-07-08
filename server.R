# Define server logic
server <- function(input, output) {
  
  # Reactive expression to filter employment data based on selected industry and year range
  filtered_data_emp <- reactive({
    data_emp %>%
      filter(Year >= input$yearRange[1] & Year <= input$yearRange[2]) %>%
      select(Year, !!sym(input$industry))
  })
  
  # Get the employment values at the ends of the selected year range
  startEmployment <- reactive({
    filtered_data_emp() %>%
      filter(Year == input$yearRange[1]) %>%
      pull(!!sym(input$industry))
  })
  
  endEmployment <- reactive({
    filtered_data_emp() %>%
      filter(Year == input$yearRange[2]) %>%
      pull(!!sym(input$industry))
  })
  
  # Calculate the diff and % diff values
  employmentDiff <- reactive({
    endEmployment() - startEmployment()
  })
  
  employmentPctDiff <- reactive({
    round((employmentDiff() / startEmployment()) * 100, 2)
  })
  
  output$lowestEmployment <- renderText({
    startEmployment()
  })
  
  output$highestEmployment <- renderText({
    endEmployment()
  })
  
  output$employmentDiff <- renderText({
    employmentDiff()
  })
  
  output$employmentPctDiff <- renderText({
    employmentPctDiff()
  })
  
  output$timeSeriesPlot_Emp <- renderPlot({
    industry <- input$industry
    yearRange <- input$yearRange
    
    # Filter data based on the selected industry and year range
    plot_data <- filtered_data_emp()
    
    # Plotting with ggplot
    p <- ggplot(plot_data, aes(x = Year, y = !!sym(industry))) +
      geom_line(size = 1) +
      geom_point(size = 2) +  
      scale_y_continuous(
        labels = unit_format(unit = "K", scale = 1e-3)
      ) +
      labs(x = "Year", y = "Number of Employees") +
      ggtitle(paste("Employment Trend", if (!is.null(industry)) paste("in", industry), "(", yearRange[1], "-", yearRange[2], ")")) +
      theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5))  # Customize title font size and boldness
    
    print(p)
  })
  
  # Reactive expression to filter unemployment data based on selected year range
  filtered_data_unemp <- reactive({
    data_unemp %>%
      filter(Year >= input$yearRangeUnemp[1] & Year <= input$yearRangeUnemp[2])
  })
  
  # Get the unemployment values at the ends of the selected year range
  startUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[1]) %>%
      pull(Overall)
  })
  
  endUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[2]) %>%
      pull(Overall)
  })
  
  # Get the male unemployment values at the ends of the selected year range
  startMaleUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[1]) %>%
      pull(Male)
  })
  
  endMaleUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[2]) %>%
      pull(Male)
  })
  
  # Get the female unemployment values at the ends of the selected year range
  startFemaleUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[1]) %>%
      pull(Female)
  })
  
  endFemaleUnemployment <- reactive({
    filtered_data_unemp() %>%
      filter(Year == input$yearRangeUnemp[2]) %>%
      pull(Female)
  })
  
  output$lowestUnemployment <- renderText({
    startUnemployment()
  })
  
  output$highestUnemployment <- renderText({
    endUnemployment()
  })
  
  output$lowestMaleUnemployment <- renderText({
    startMaleUnemployment()
  })
  
  output$highestMaleUnemployment <- renderText({
    endMaleUnemployment()
  })
  
  output$lowestFemaleUnemployment <- renderText({
    startFemaleUnemployment()
  })
  
  output$highestFemaleUnemployment <- renderText({
    endFemaleUnemployment()
  })
  
  output$timeSeriesPlot_Unemp <- renderPlot({
    yearRange <- input$yearRangeUnemp
    
    # Filter data based on the selected year range
    plot_data <- filtered_data_unemp()
    
    # Plotting with ggplot
    p <- ggplot(plot_data, aes(x = Year, y = Overall)) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      labs(x = "Year", y = "Unemployment Rate (%)") +
      ggtitle(paste("Unemployment Rate (", yearRange[1], "-", yearRange[2], ")")) +
      theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5)) # Customize title font size and boldness
    
    print(p)
  })
  
  output$barPlot_Unemp <- renderPlot({
    yearRange <- input$yearRangeUnemp
    
    # Filter data based on the selected year range
    plot_data <- filtered_data_unemp() %>%
      pivot_longer(cols = c("Male", "Female"), names_to = "Gender", values_to = "Count")
    
    # Get unique years within the selected range
    selected_years <- unique(plot_data$Year)
    
    # Plotting with ggplot as a bar plot based on gender
    p <- ggplot(plot_data, aes(x = factor(Year), y = Count, fill = Gender)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Year", y = "Unemployment Rate (%)", fill = "Gender") +
      scale_x_discrete(labels = as.character(selected_years)) +  # Ensure x-axis labels are shown as strings
      ggtitle(paste("Unemployment Rate by Gender (", yearRange[1], "-", yearRange[2], ")")) +
      theme_minimal() +  # Optional: Apply a minimal theme
      theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5)) # Customize title font size and boldness
    
    print(p)
  })
}