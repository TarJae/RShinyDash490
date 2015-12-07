#Necessary Packages
library(shiny)
library(shinydashboard)
library(sp)
library(rworldmap)
library(ggplot2)
library(reshape2)
library(Hmisc)
library(WDI)

#Data that will be run at opening of app
# "SE.XPD.TOTL.GD.ZS",  "Pub.edu","SE.ADT.LITR.ZS",  "Lit.R", 
wb.data = WDI( country = c('AU', 'AF', 'BE', 'BZ', 'BR', 'CM', 'CA', 'CL', 'CN', 'CO', 'DK', 'EG', 'FI', 'FR', 'DE', 'GR', 'GL', 'IS', 'IN', 'IR', 'IQ', 'IE', 'IT', 'JP', 'KE', 'ML', 'MX', 'MA', 'NZ', 'NG', 'RU', 'SA', 'ZA', 'ES', 'TR', 'UY', 'US', 'GB', 'AR'), indicator = c("SP.DYN.LE00.IN","SH.IMM.MEAS", "SH.IMM.IDPT", "SE.XPD.TOTL.GD.ZS", "SE.ADT.LITR.ZS"), start = 1994, end = 2014, extra = F)
names(wb.data) = c("remove", "Country.Name", "Year","Life.E", "Imm.Meas", "Imm.DPT", "Pub.edu", "Lit.R")
wb.data = wb.data[ , 2:8]

dashboardPage(
  dashboardHeader(
    title = "World Bank Analysis-Shiny Dashboard", 
    titleWidth = 450
  ),#dashboardHeader closing
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Graphs", tabName = "graphtab", icon = icon("bar-chart")),
      menuItem("Data Tables", tabName = "tablestab", icon = icon("table")),
      menuItem("Our Code", tabName = "information", icon = icon("code")),
      sidebarMenuOutput("tutorial"),
      sidebarMenuOutput("getourcode")
    )
  ),#dashboardSidebar closing
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "World Map", width = 12, status = "warning", solidHeader = T, 
                  plotOutput("plot1", height = 300)
                ),
                box(
                  width = 6,height = 200, 
                  title = "Choose Variables to Explore on the Map!", background = "orange", solidHeader = T,
                  selectInput("varib", label = "Select a Variable:",
                              choices = c("Life Expectancy" = 'Life.E', 
                                          "DPT immunization" = 'Imm.DPT',
                                          "Measles immunization" = 'Imm.Meas', 
                                          "Public Education Spending" = 'Pub.edu', 
                                          "Literacy Rate" = 'Lit.R')),
                  selectInput("palchoice", label = "Choose a Color Theme:", 
                              choices = c("Orange" = "heat", 
                                          "Rainbow" = "rainbow", 
                                          "Blue and Green" = "topo", 
                                          "Black and White" = "white2Black",
                                          "Terrain" = "terrain", 
                                          "Diverging Colors" = "diverging"))
                ),
                box(
                  width = 6, height = 200,
                  title = "RWorldMap", status = "warning", solidHeader = F,
                  "We used the Rworldmap package to create a colored image of the values on the map.", br(), strong("packages:"),"rworldmap and sp", br(),
                  strong("functions:"),"joinCountryData2Map(data, joinCode = , nameJoinColumn = ) and mapCountryData(data, nameColumnToPlot = , catMethod = )"
                ), 
                box(
                  width = 4, height = 150, status = "warning", solidHeader = T,  
                  h4("Thank you for Checking out our World Map!"), 
                  div(class = "header", checked = NA, 
                      tags$p("Want to check out more information about rworldmaps?"),
                      tags$a(href = "https://cran.r-project.org/web/packages/rworldmap/vignettes/rworldmap.pdf", "Click Here!")
                      )
                ),
                box(
                  width = 4, height = 150, status = "warning", solidHeader = T
                ),
                box(
                  width = 4, height = 150, status = "warning", solidHeader = T,
                  h3("PSYC 490 Final Project"),
                  h4("by Elizabeth Fink and Carlton Rollins")
                )
                
              )#fluid row
      ), #DASHBOARD TABitem closing
      tabItem(tabName = "graphtab", 
              fluidRow(
                box(width = 12, background = "navy",
                  h2("Graphs")
                ),
                tabBox(
                  title = "Life Expectancy Graphs", width = 12, 
                  id = "tabset1", 
                  tabPanel("Years", "Life Expectancy from 1994-2014 by Region and Country", status = "info",
                           plotOutput("plot2")),
                  tabPanel("Spending", "Public Education Spending and Life Expectancy by Country and Region", 
                           plotOutput("plot3")), 
                  tabPanel("DPT", "DPT Immunization and Life Expectancy by Country and Region", 
                           plotOutput("plot4")),
                  tabPanel("Measles", "Measles Immunization and Life Expectancy by Country and Region",
                           plotOutput("plot5")),
                  tabPanel("Income", "Income Grouping and Life Expectancy by Country and Region",
                           plotOutput("plot6"))
                ),
                box(
                  width = 8, title = "Graph Dynamic",
                  plotOutput("plot7")
                ) 
              )
      ),#graphtab tabitem closing
      tabItem(tabName = "tablestab",
              h2("World Bank Data Table"),
              box(
                width = 12, background = "light-blue",
                tableOutput("table1")
              ),
              box(
                width = 6, status = "primary",
                strong(h4("Variables:")),
                h4("Country, Year, Life Expectancy (years), Measles Immunization (total number), DPT immunization (total number), Public Spending on Education (%GDP), Literacy Rate (age 15+)")
              ),
              box(
                width = 6, status = "primary", 
                strong(h4("Countries:")),
                h4("Afghanistan, Argentina, Australia, Belgium, Brazil, Belize, Canada, Chile, Cameroon, China, Colombia, Germany, Denmark, Egypt, Spain, Finland, France, United Kingdom, Greenland, Greece, Ireland, India, Iraq, Iran, Iceland, Italy, Japan, Kenya, Morocco, Mali, Mexico, Nigeria, New Zealand, Russian Federation, Saudi Arabia, Turkey, United States, Uruguay, South Africa")
              )
      ),# tablestab tabitem closing
      tabItem(tabName = "information",
              fluidRow(
                box(
                  h2("Check out our code!"), background = "maroon", width = 12
                )
              ),
              h3("Getting the Data"),
              h5("packages: WDI, Hmisc"),
              p(code("library(WDI), library(Hmisc)")),
              p(code("wb.data = WDI(country = c('AU',  'AF', 'BE', 'BZ', 'BR', 'CM', 'CA', 'CL', 'CN', 'CO', 'DK', 'EG', 'FI', 'FR', 'DE', 'GR', 'GL', 'IS', 'IN', 'IR', 'IQ', 'IE', 'IT', 'JP', 'KE', 'ML', 'MX', 'MA', 'NZ', 'NG', 'RU', 'SA', 'ZA', 'ES', 'TR', 'UY', 'US', 'GB', 'AR'), indicator = c('SP.DYN.LE00.IN','SH.IMM.MEAS', 'SH.IMM.IDPT'), start = 1994, end = 2014, extra = F)")),
              h6("for ggplot2 graphs we used the argument extra = T, to include region and income variables in the data"),
              p(code("names(wb.data) = c('remove', 'Country.Name', 'Year', 'Life.E', 'Imm.Meas', 'Imm.DPT')")),
              p(code("wb.data = wb.data[ , 2:6]")),
              h3("World Graph"),
              h5("packages: sp, rworldmap"),
              p(code("library(sp), library(rworldmap)")),
              p(code("WBMAP = joinCountryData2Map(wb.data, joinCode = 'NAME', nameJoinColumn = 'Country.Name'")),
              p(code("mapCountryData(WBMAP, nameColumnToPlot = 'Lit.E', catMethod = 'fixedwidth')")),
              h3("ggplot2 Graphs"),
              h5("packages: ggplot2"),
              p(code("library(ggplot2)")),
              p(code("code")),
              h3("Shiny App Code"),
              h4("This is the basic code needed to run a Shiny Dashboard"),
              h5("User Interface (ui.R)"),
              p(code("code")),
              h5("Server (server.R)"),
              p(code("code")),
              p("You can check out our full code by clicking the Download Link!")
      )
    )
  ) #dashboardBody closing
)
