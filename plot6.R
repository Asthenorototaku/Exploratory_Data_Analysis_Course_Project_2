library(tidyverse)

if (!dir.exists("exdata-data-NEI_data")) {
        if (!file.exists("exdata-data-NEI_data.zip")) {
                download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                              destfile = "exdata-data-NEI_data.zip",
                              method = "curl")
                unzip("exdata-data-NEI_data.zip")
        }
}

NEI <- read_rds("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- read_rds("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

NEI$type <- tolower(NEI$type)
NEI$type <- sub("-", "", NEI$type)

NEI <- NEI %>% subset(fips == "24510" | fips == "06037") %>%
        rename(city = fips)

NEI$city <- sub("24510", "Baltimore City", NEI$city)      
NEI$city <- sub("06037", "Los Angeles County", NEI$city)      

SCC$SCC <- as.character(SCC$SCC)
SCC$Short.Name <- as.character(SCC$Short.Name)
motorv <- str_detect(SCC$Short.Name, "Motor")

SCC.motor <- SCC$SCC[motorv]


NEI.motor <- subset(NEI, SCC %in% SCC.motor ) %>%
        group_by(city, year) %>%
        summarise(emission = sum(Emissions))

p <- ggplot(NEI.motor, aes(year, emission, color=city))
p + geom_point() + geom_line()

