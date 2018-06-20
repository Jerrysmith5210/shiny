#First load the libraries to be use
library(googleVis)
library(wbstats) 
library(ggplot2)
library(dplyr)
library(shiny)

# load world bank world population data using "SP.DYN.LE00.IN" indicator
pop.data <- wb(indicator = "SP.POP.TOTL")
pop.data <- pop.data[,-c(1,4,5)]
colnames(pop.data) <- c("year","population", "country.Id", "country")

# load world bank GDP per capita data using "NY.GNP.PCAP.PP.CD" indicator
GDP.capita <- wb(indicator = "NY.GDP.PCAP.CD")
GDP.capita <- GDP.capita[,-c(1,4,5)]
colnames(GDP.capita) <- c("year","GDP.per.capita", "country.Id", "country")

#load world bank life Expectancy data using "SP.DYN.LE00.IN" indicator
LifeExp <- wb(indicator = "SP.DYN.LE00.IN")
LifeExp <- LifeExp[,-c(1,4,5)]
colnames(LifeExp) <- c("year","lifeExpectancy", "country.Id", "country")

#load world bank fertility rate bty birth per woman
Fertility <- wb(indicator = "SP.DYN.TFRT.IN")
Fertility <- Fertility[,-c(1,4,5)]
colnames(Fertility) <- c("year","fertility.rate", "country.Id", "country")

# pull the country mapping data from the world bank
countries <- wbcountries()


#Merge data sets
wbData <- merge(LifeExp, Fertility)
wbData <- merge(wbData, pop.data)
wbData <- merge(wbData, GDP.capita)

# Merge the wbData data sets with countries data
wbData <- merge(wbData,countries[c("iso2c","region","income")],
                by.x = "country.Id", by.y = "iso2c")


# check the pull data from the world bank
str(wbData)
head(wbData, 3)
tail(wbData, 3)


# Filter out the aggregates and country id 
finalwbData <- subset(wbData, !region %in% "Aggregates", select = - country.Id)


# check your data
head(finalwbData, 3)
tail(finalwbData, 3)

# change date into integer
finalwbData$year <- as.numeric(finalwbData$year)

#check your data
str(finalwbData)

#boxplot
boxPlot = ggplot(finalwbData, aes(x= region, y= lifeExpectancy)) + geom_boxplot()

#print plot
boxPlot

# googlevis geochart
geoChart <- gvisGeoChart(finalwbData, locationvar = "country", colorvar = "lifeExpectancy", options = list(width =700, height=600))

plot(geoChart)

# subset to plot geochart for life expectancy for 2015
finalwbData_subset <- finalwbData[finalwbData$year==2015,]

geoChart1 <- gvisGeoChart(finalwbData_subset, locationvar = "country", colorvar = "lifeExpectancy", options = list(width =700, height=600))

plot(geoChart1)

# googlevis motionchart
mochart <- gvisMotionChart(finalwbData, idvar = "country", timevar = "year")
plot(mochart)

s = ggplot(finalwbData, aes(x=GDP.per.capita, y=lifeExpectancy)) +
  geom_point()
s

# Save finalwbData Data
write.csv(finalwbData, file='my_data.csv', row.names=F)



