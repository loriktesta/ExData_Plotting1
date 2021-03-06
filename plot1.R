# load the packages
# library(data.table)
# library(dplyr)


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
                  col.names = names(cols))

rm("start")
rm("end")

# get PNG device ready to receive histogram
if (!file.exists("./results")){ dir.create("results") }

png(file = "./results/plot1.png", width = 480, height = 480)


# draw the histogram
hist(hpc$Global_active_power, 
     col = "red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# close the device
dev.off()

rm("hpc")
rm("cols")

