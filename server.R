#Necessary Packages
library(shiny)
library(shinydashboard)
library(sp)
library(rworldmap)
library(ggplot2)
library(reshape2)
library(Hmisc)
library(WDI)
library(RColorBrewer)

#Data that will be run at opening of app
# "SE.XPD.TOTL.GD.ZS",  "Pub.edu","SE.ADT.LITR.ZS",  "Lit.R", 
wb.data = WDI( country = c('AU', 'AF', 'BE', 'BZ', 'BR', 'CM', 'CA', 'CL', 'CN', 'CO', 'DK', 'EG', 'FI', 'FR', 'DE', 'GR', 'GL', 'IS', 'IN', 'IR', 'IQ', 'IE', 'IT', 'JP', 'KE', 'ML', 'MX', 'MA', 'NZ', 'NG', 'RU', 'SA', 'ZA', 'ES', 'TR', 'UY', 'US', 'GB', 'AR'), indicator = c("SP.DYN.LE00.IN","SH.IMM.MEAS", "SH.IMM.IDPT", "SE.XPD.TOTL.GD.ZS", "SE.ADT.LITR.ZS"), start = 1994, end = 2014, extra = F)
names(wb.data) = c("remove", "Country.Name", "Year","Life.E", "Imm.Meas", "Imm.DPT", "Pub.edu", "Lit.R")
wb.data = wb.data[ , 2:8]


#data for ggplots
wb.data2 = WDI( country = c('AU', 'AF', 'BE', 'BZ', 'BR', 'CM', 'CA', 'CL', 'CN', 'CO', 'DK', 'EG', 'FI', 'FR', 'DE', 'GR', 'GL', 'IS', 'IN', 'IR', 'IQ', 'IE', 'IT', 'JP', 'KE', 'ML', 'MX', 'MA', 'NZ', 'NG', 'RU', 'SA', 'ZA', 'ES', 'TR', 'UY', 'US', 'GB', 'AR'), indicator = c("SE.ADT.LITR.ZS", "SP.DYN.LE00.IN", "SE.XPD.TOTL.GD.ZS", "SH.IMM.MEAS", "SH.IMM.IDPT"), start = 1994, end = 2014, extra = T)
wb.data2 = wb.data2[ , c(2:8, 10, 14)]
names(wb.data2) = c("Country.Name", "Year", "Lit.R", "Life.E", "Pub.edu", "Imm.Meas", "Imm.DPT", "Region", "Income")

wb.data3 = wb.data
wb.data3 = wb.data3[order(wb.data3$Year, decreasing = FALSE), ]

function(input, output) {
  set.seed(1234)
  output$tutorial <- renderMenu({
    sidebarMenu(
      menuItem("Learn More About Shiny", icon = icon("question"), 
               href = "http://shiny.rstudio.com/tutorial/")
    )
  })
  output$getourcode <- renderMenu({
    menuItem("Download Our Code", icon = icon("download"), 
             href = "https://github.com/elizabit/RShinyDash490.git")
  })
  output$plot1 <- renderPlot({
    varibchoice <- input$varib
    WBMAP = joinCountryData2Map(wb.data, joinCode = "NAME", nameJoinColumn = "Country.Name")
    mapCountryData(WBMAP, nameColumnToPlot = varibchoice, catMethod = "fixedWidth", colourPalette = input$palchoice)
  })
  output$plot2 <- renderPlot({
    gg_life.e <- ggplot(data = wb.data2, aes(x = Year, y = Life.E))
    gg_life.e + geom_point(aes(x = Year, y = Life.E, alpha = .3, color = Region)) + guides(size = F, alpha = F) + xlab("Year") + ylab("Life Expectancy (years)") + ggtitle("Life Expectancy from 1994-2014 by Country")
  })
  output$plot3 <- renderPlot({
    plot3shiny = ggplot(data = wb.data2, aes(x = Pub.edu, y = Life.E))
    plot3shiny + geom_point(aes(alpha = .5, color = Region, size = .1)) + guides(alpha = F, size = F) + xlab("Public Spending on Education (% GDP)") + ylab("Life Expectancy (years)") + ggtitle("Public Education Spending and Life Expectancy")
    
  })
  output$plot4 <- renderPlot({
    plot4shiny = ggplot(data = wb.data2, aes(x = Imm.DPT, y = Life.E))
    plot4shiny + geom_point(aes(alpha = .5, color = Region, size = .1)) + guides(alpha = F, size = F) + xlab("DPT Immunization (% of Population)") + ylab("Life Expectancy (years)") + ggtitle("DPT Immunization and Life Expectancy")
    
  })
  output$plot5 <- renderPlot({
    plot5shiny = ggplot(data = wb.data2, aes(x = Imm.Meas, y = Life.E))
    plot5shiny + geom_point(aes(alpha = .5, color = Region, size = .1)) + guides(alpha = F, size = F) + xlab("DPT Immunization (% of Population)") + ylab("Life Expectancy (years)") + ggtitle("DPT Immunization and Life Expectancy")
    
  })
  output$plot6 <- renderPlot({
    plot6shiny = ggplot(data = wb.data2, aes(x = Income, y = Life.E))
    plot6shiny + geom_point(aes(alpha = .5, color = Region, size = .1)) + guides(alpha = F, size = F) + xlab("Income Level Grouping") + ylab("Life Expectancy (years)") + ggtitle("Income and Life Expectancy")
    
  })
  output$table1 <- renderTable(wb.data3[1:156, ])
  output$table2 <- renderTable(wb.data3[157:312, ])
  output$table3 <- renderTable(wb.data3[313:468, ])
  output$table4 <- renderTable(wb.data3[469:624, ])
  output$table5 <- renderTable(wb.data3[625:780, ])
  output$table6 <- renderTable(wb.data3[781:819, ])
}
