# load the packages
library(lubridate)
library(dplyr)

# Download & Unzip file if it is not available in the current directory
if (!file.exists("./data")){ dir.create("data") }
fileName <- "./data/household_power_consumption.zip"
if (!file.exists(fileName))
{ 
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile = fileName )
  unzip(fileName, exdir = "./data")

}


# read in data 
# find the first record for Feb 1st // seems there are two lines for header
cols <- read.table("./data/household_power_consumption.txt", 
                     sep = ";", header=TRUE,nrows=1)

start <- grep("1/2/2007", readLines("./data/household_power_consumption.txt")) 
end <- grep("^2/2/2007", readLines("./data/household_power_consumption.txt")) 
hpc <- read.table("./data/household_power_consumption.txt", 
                  sep = ";", 
                  na.strings = c("?"),
                  stringsAsFactors = FALSE,
                  skip = start[1]-1,
                  nrows = max(end)-start[1]+1,
                  col.names = names(cols) )


# draw the histogram
hpc <- mutate(hpc, dateTime = as.POSIXct(dmy(hpc$Date)+hms(hpc$Time)))
hpc <- transform(hpc, Date = factor(wday(dmy(hpc$Date),label = TRUE)))

hpc <- mutate(hpc,dow = as.Date(cut(hpc$dateTime, breaks = "day")))

plot(ts(hpc$Global_active_power, 
           frequency = 1440),
     ylab="Global Active Power (kilowatts)")



