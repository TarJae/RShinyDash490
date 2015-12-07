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
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Graphs", tabName = "graphtab", icon = icon("bar-chart")),
      menuItem("Data Tables", tabName = "tablestab", icon = icon("table")),
      menuItem("Our Code", tabName = "information", icon = icon("code")),
      sidebarMenuOutput("tutorial"),
      sidebarMenuOutput("getourcode")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "World Map", width = 12, status = "warning", solidHeader = T, 
                  plotOutput("plot1", height = 400)
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
                  width = 4, height = 150, background = "orange", solidHeader = T
                ),
                box(
                  width = 4, height = 150, status = "warning", solidHeader = T,
                  h3("PSYC 490 Final Project"),
                  h4("by Elizabeth Fink and Carlton Rollins")
                )
                
              )
      ),
      tabItem(tabName = "graphtab", 
              fluidRow(
                box(width = 12, background = "navy",
                  h2("Graphs")
                ),
                tabBox(
                  title = "Life Expectancy Graphs", width = 12, height = 600,
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
                  width = 2, background = "navy", height = 100
                ),
                box(
                  width = 2, status = "primary", solidHeader = T, height = 100
                ),
                box(
                  width = 2, background = "navy", height = 100
                ),
                box(
                  width = 2, status = "primary", solidHeader = T, height = 100
                ),
                box(
                  width = 2, background = "navy", height = 100
                ),
                box(
                  width = 2, status = "primary", solidHeader = T, height = 100
                )
              )
      ),
      tabItem(tabName = "tablestab",
              box(width = 12, background = "olive",
                  h2("World Bank Data Table")),
              box(width = 12, height = 3, background = "green"),
              tabBox(
                title = "Data Tables", width = 12, 
                id = "tabset1", 
                tabPanel("1994-1997", 
                         tableOutput("table1")),
                tabPanel("1998-2001", 
                         tableOutput("table2")), 
                tabPanel("2002-2005", 
                         tableOutput("table3")),
                tabPanel("2006-2009", 
                         tableOutput("table4")),
                tabPanel("2010-2013", 
                         tableOutput("table5")), 
                tabPanel("2014", 
                         tableOutput("table6"))
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
      ),
      tabItem(tabName = "information",
              fluidRow(
                box(
                  h1("Check out our code!"), background = "maroon", width = 12, solidHeader = TRUE,
                  p("For the full text, click the link in the sidebar to download our code at GitHub")
                ),
                box(
                  width = 6, status = "danger", solidHeader = T, height = 550,
                  h3("Getting the Data"),
                  h5("packages: WDI, Hmisc"),
                  p(code("library(WDI), library(Hmisc)")),
                  p(code("wb.data = WDI(country = c('AU',  'AF', 'BE', 'BZ', 'BR', 'CM', 'CA', 'CL', 'CN', 'CO', 'DK', 'EG', 'FI', 'FR', 'DE', 'GR', 'GL', 'IS', 'IN', 'IR', 'IQ', 'IE', 'IT', 'JP', 'KE', 'ML', 'MX', 'MA', 'NZ', 'NG', 'RU', 'SA', 'ZA', 'ES', 'TR', 'UY', 'US', 'GB', 'AR'), indicator = c('SP.DYN.LE00.IN','SH.IMM.MEAS', 'SH.IMM.IDPT, 'SE.XPD.TOTL.GD.ZS', 'SE.ADT.LITR.ZS'), start = 1994, end = 2014, extra = F)")),
                  h6("for ggplot2 graphs we used the argument extra = T, to include region and income variables in the data"),
                  p(code("names(wb.data) = c('remove', 'Country.Name', 'Year', 'Life.E', 'Imm.Meas', 'Imm.DPT', 'Pub.ed', 'Lit.R')")),
                  p(code("wb.data = wb.data[ , 2:8]"))
                ),
                box(
                  width = 6, status = "danger", solidHeader = T, height = 550,
                  h3("ggplot2 Graphs"),
                  h5("packages: ggplot2"),
                  p(code("library(ggplot2)")),
                  p(code("gg_life.e <- ggplot(data = wb.data2, aes(x = Year, y = Life.E))")),
                  p(code("gg_life.e + geom_point(aes(x = Year, y = Life.E, alpha = .3, color = Region)) + guides(size = F, alpha = F)")),
                  p(code("+ xlab('Year') + ylab('Life Expectancy (years)') + ggtitle('Life Expectancy from 1994-2014 by Country')"))
                ),
                box(
                  width = 5, status = "danger", solidHeader = T,
                  h3("World Graph"),
                  h5("packages: sp, rworldmap"),
                  p(code("library(sp), library(rworldmap)")),
                  p(code("WBMAP = joinCountryData2Map(wb.data, joinCode = 'NAME', nameJoinColumn = 'Country.Name'")),
                  p(code("mapCountryData(WBMAP, nameColumnToPlot = 'Lit.E', catMethod = 'fixedwidth')"))
                ), 
                  box(
                    width = 7, status = "danger", solidHeader = T,
                    h3("Shiny App Code"),
                    h4("This is the basic code needed to run a Shiny Dashboard"),
                    h4("This code will run a blank dashboard app with nothing in it"),
                    h5("User Interface (ui.R)"),
                    p(code("dashboardPage(")),
                    p(code("dashboardHeader(),")),
                    p(code("dashboardSidebar(),")),
                    p(code("dashboardBody())")),
                    p(code(")")),
                    h5("Server (server.R)"),
                    p(code("function(input, output) { }")),
                    p("You can check out our full code by clicking the Download Link!")
                  )
              )
          )
      )
    )
  ) 



