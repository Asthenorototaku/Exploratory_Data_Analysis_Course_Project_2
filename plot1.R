library(tidyverse)

# download data if necessary
if (!dir.exists("exdata-data-NEI_data")) {
        if (!file.exists("exdata-data-NEI_data.zip")) {
                download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                              destfile = "exdata-data-NEI_data.zip",
                              method = "curl")
                unzip("exdata-data-NEI_data.zip")
        }
}

# read data

NEI <- read_rds("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- read_rds("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

# tidy data
NEI$type <- tolower(NEI$type)
NEI$type <- sub("-", "", NEI$type)


# caluculate total emissions
options(scipen = 2)
NEI <-  group_by(NEI, year)
pm25.year <- summarise(NEI, emission=sum(Emissions)) 

# plot
png("plot1.png")
barplot(pm25.year$emission, names.arg = pm25.year$year)
title(main = "Total PM2.5 Emission Changes in United States", 
      xlab = "Year", ylab = "PM 2.5 Emission (tons)")
dev.off()


