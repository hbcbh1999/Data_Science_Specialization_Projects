setwd("/home/yangang/[Programming] Data Science/[4] Exploratory Data Analysis/Project/Project2/")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Q1

Emissions_yearly <- split(NEI$Emissions,NEI$year)
Emissionsum_yearly <- sapply(Emissions_yearly,sum)
year <- as.numeric(names(Emissionsum_yearly))

png('plot1.png')
plot(year,Emissionsum_yearly,ylim=c(0,max(Emissionsum_yearly)),xlab="Year",ylab="Total emission",pch=20,
     main="Total PM2.5 emission in the United States by years")
dev.off()

# Q2

NEI_B <- subset(NEI,fips=="24510") # Select "Baltimore"
Emissions_yearly <- split(NEI_B$Emissions,NEI_B$year)
Emissionsum_yearly <- sapply(Emissions_yearly,sum)
year <- as.numeric(names(Emissionsum_yearly))

png('plot2.png')
plot(year,Emissionsum_yearly,ylim=c(0,max(Emissionsum_yearly)),xlab="Year",ylab="Total emission",pch=20,
     main="Total PM2.5 emission in Baltimore by years")
dev.off()

# Q3

library(dplyr)
library(ggplot2)

NEI_B <- subset(NEI,fips=="24510") # Select "Baltimore"

#Emissions_yearly_type <- split(NEI_B$Emissions,list(NEI_B$year,NEI_B$type))
#Emissionsum_yearly_type <- sapply(Emissions_yearly_type,sum)
# Summation of "Emissions" grouped by both "year" and "type"
data <- aggregate(NEI_B$Emissions,
                  list(NEI_B$year,NEI_B$type), sum)
data <- rename(data,year=Group.1,type=Group.2,Emissionsum_yearly_type=x)

png('plot3.png')
qplot(year,Emissionsum_yearly_type,data=data,color=type) + xlab("Year") + ylab("Total Emission") +
  ylim(0,max(data$Emissionsum_yearly_type)) + ggtitle("PM2.5 emission in Baltimore by years (and source types)")
dev.off()

# Q4

library(dplyr)
library(ggplot2)

#SCC_coal$Data.Category <- NULL
SCC <- subset(SCC, , -c(Data.Category,Created_Date,Revised_Date,Usage.Notes,Last.Inventory.Year,Map.To,Option.Set))
summary(SCC$EI.Sector)
SCC_coal <- SCC[grepl("Coal",SCC$EI.Sector),"SCC"]

# match(c(1,3,4),c(1,4,5))
# c(1,3,4) %in% c(1,4,5)
index <- NEI$SCC %in% SCC_coal
NEI_coal <- subset(NEI,index) # Select the observations that correspond to "Coal"

# Summation of "Emissions" grouped by "year"
data <- aggregate(NEI_coal$Emissions,
                  list(NEI_coal$year), sum)
data <- rename(data,year=Group.1,Emissionsum_yearly=x)

png('plot4.png')
qplot(year,Emissionsum_yearly,data=data) + xlab("Year") + ylab("Total Emission") +
  ylim(0,max(data$Emissionsum_yearly)) + ggtitle("PM2.5 emission from coal combustion-related sources in the United State by years")
dev.off()

# Q5

library(dplyr)
library(ggplot2)

NEI_B <- subset(NEI,fips=="24510") # Select "Baltimore"

SCC <- subset(SCC, , -c(Data.Category,Created_Date,Revised_Date,Usage.Notes,Last.Inventory.Year,Map.To,Option.Set))
summary(SCC$EI.Sector)
SCC_motor <- SCC[grepl("Mobile",SCC$EI.Sector),"SCC"]

index <- NEI_B$SCC %in% SCC_motor
NEI_B_motor <- subset(NEI_B,index) # Select the observations that correspond to "Mobile"

# Summation of "Emissions" grouped by "year"
data <- aggregate(NEI_B_motor$Emissions,
                  list(NEI_B_motor$year), sum)
data <- rename(data,year=Group.1,Emissionsum_yearly=x)

png('plot5.png')
qplot(year,Emissionsum_yearly,data=data) + xlab("Year") + ylab("Total Emission") +
  ylim(0,max(data$Emissionsum_yearly)) + ggtitle("PM2.5 emission from motor vehicle sources in Baltimore by years")
dev.off()

# Q6

library(dplyr)
library(ggplot2)

NEI_BL <- subset(NEI,fips=="24510"|fips=="06037") # Select "Baltimore" and "LA county"

SCC <- subset(SCC, , -c(Data.Category,Created_Date,Revised_Date,Usage.Notes,Last.Inventory.Year,Map.To,Option.Set))
summary(SCC$EI.Sector)
SCC_motor <- SCC[grepl("Mobile",SCC$EI.Sector),"SCC"]

index <- NEI_BL$SCC %in% SCC_motor
NEI_BL_motor <- subset(NEI_BL,index) # Select the observations that correspond to "Mobile"

# Summation of "Emissions" grouped by both "year" and "fips (county)"
data <- aggregate(NEI_BL_motor$Emissions,
                  list(NEI_BL_motor$year,NEI_BL_motor$fips), sum)
data <- rename(data,year=Group.1,county=Group.2,Emissionsum_yearly=x)

# Use more descriptive name for "Baltimore" and "LA county"
data <- mutate( data, county=factor(as.factor(data$county),
                                    levels=c("24510","06037"),labels=c("Baltimore","LA county")) )

png('plot6.png')
qplot(year,Emissionsum_yearly,data=data,color=county) + xlab("Year") + ylab("Total Emission") +
  ylim(0,max(data$Emissionsum_yearly)) + ggtitle("PM2.5 emission from motor vehicle sources in Baltimore and LA county by years")
dev.off()