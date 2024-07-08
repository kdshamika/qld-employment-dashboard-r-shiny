library(shiny)
library(readxl)
library(ggplot2)
library(bslib)
library(bsicons)
library(thematic)

# Load data
data_emp <- read_excel("data/employment.xlsx")
data_unemp <- read_excel("data/unemployment.xlsx")

# Define UI for application
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "united"),
  
  # Application title
  titlePanel("Employment and Unemployment in Queensland"),
  p('Welcome to the Queensland Employment Dashboard, an interactive tool that visualises employment trends and unemployment rates across various industries in Queensland over several decades. This dashboard provides a clear view of workforce dynamics, allowing users to identify long-term trends and make informed decisions. Explore the features and filters to tailor the data visualisation to your interests.'),
  # Tabs
  tabsetPanel(
    tabPanel("Employment",
             fluidRow(
               column(width = 6,
                      selectInput("industry", "Select Industry", choices = sort(c(colnames(data_emp)[-1])), selected = "All Industries")
               ),
               column(width = 6,
                      sliderInput("yearRange", "Select Year Range", min = 1986, max = 2024, value = c(2000, 2024), sep = "")
               )),
             hr(),
             fluidRow(
               column(width = 3,
                      value_box(
                        title = "Employments at Lowest Year",
                        value = uiOutput("lowestEmployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("people-fill")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "Employments at Highest Year",
                        value = uiOutput("highestEmployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("people-fill")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "Difference",
                        value = uiOutput("employmentDiff"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("plus-slash-minus")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "% Difference",
                        value = uiOutput("employmentPctDiff"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("percent")
                      )
               )), hr(),  
             fluidRow(
               column(width = 12,
                      plotOutput("timeSeriesPlot_Emp")
               )
             )),
    tabPanel("Unemployment", 
             fluidRow(
               column(width = 12,
                      sliderInput("yearRangeUnemp", "Select Year Range", min = 1979, max = 2023, value = c(2000, 2023), sep = "")
               )),hr(),
             fluidRow( 
               column(width = 6,
                      value_box(
                        title = "Unemployment Rate at Lowest Year (%)",
                        value = uiOutput("lowestUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("person-fill-exclamation")
                      )
               ),
               column(width = 6,
                      value_box(
                        title = "Unemployment Rate at Highest Year (%)",
                        value = uiOutput("highestUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("person-fill-exclamation")
                      )
               )),hr(),
             fluidRow( 
               column(width = 3,
                      value_box(
                        title = "Female Unemployment Rate at Lowest Year (%)",
                        value = uiOutput("lowestFemaleUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("gender-female")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "Male Unemployment Rate at Lowest Year (%)",
                        value = uiOutput("lowestMaleUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("gender-male")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "Female Unemployment Rate at Highest Year (%)",
                        value = uiOutput("highestFemaleUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("gender-female")
                      )
               ),
               column(width = 3,
                      value_box(
                        title = "Male Unemployment Rate at Highest Year (%)",
                        value = uiOutput("highestMaleUnemployment"),
                        align = "center",
                        font_size = "70%",
                        showcase = bs_icon("gender-male")
                      )
               )),hr(),
             fluidRow( 
               column(width = 12,
                      plotOutput("timeSeriesPlot_Unemp")
               ),
               column(width = 12,
                      plotOutput("barPlot_Unemp")
               )
             )
    ),
    tabPanel("Explanatory Notes",
             h5("Key insights"),
             p("Employment in Queensland has been steadily increasing from 1986 to 2024. In 2020, during the COVID-19 pandemic, employment levels were less than 12,900 below the 2019 pre-COVID levels, representing a 0.51% decrease. Since then, employment has been recovering from the pandemic-induced drop."),
             p("Employment in 2024 has grown by 193,700, representing a 7.15% increase compared to the COVID-19 peak year of 2022."),
             p("Employment in most industries has grown from 1986 to 2024, except in Agriculture, Forestry and Fishing, and Information Media and Telecommunications. Most industries experienced an employment drop during COVID-19 and recovered by 2024, except for Agriculture, Forestry and Fishing, Information Media and Telecommunications, and Wholesale Trade. Meanwhile, employment in industries such as Health Care and Social Assistance, Manufacturing, and Mining has grown during the COVID-19 period."),
             p("The overall trend in unemployment rates has been decreasing. Unemployment peaked at 6.8% during COVID-19 but fell to 3.7% by 2023. Since 2020, the unemployment rate for males has been higher than that for females, a reversal from 2019."),
             h5("Notes"),
             p("The years referenced refer to the financial year ending. Employment figures include both full-time and part-time positions and are averaged over four quarters: August, November, February, and May. Industries are classified according to ANZSIC 2006. Unemployment rate data are based on a 12-month average."),
             h5("Data Source"),
             HTML('For data sources and more information: <a href="https://www.qgso.qld.gov.au/statistics/theme/economy/labour-employment/state">Queensland Government Statistician\'s Office (QGSO)',
                  sep="<br/>", 
                  'Original data source: <a href="https://www.abs.gov.au/statistics/labour/employment-and-unemployment/labour-force-australia/latest-release#employment">ABS Labour force data')
             )
  )
)