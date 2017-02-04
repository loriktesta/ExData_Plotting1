# load the packages
library(lubridate)

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

png(file = "./results/plot3.png", width = 480, height = 480)


# draw the histogram
hpc <- transform(hpc, Date = as.Date(Date,"%d/%m/%y"))
hpc <- select(hpc, -Time)

sm1 <- ts(hpc$Sub_metering_1, frequency = 1440)
sm2 <- ts(hpc$Sub_metering_2, frequency = 1440)
sm3 <- ts(hpc$Sub_metering_3, frequency = 1440)

ts.plot(sm1,sm2,sm3,plot.type="single", 
        gpars =list(ylab="Energy sub metering", col=c("black","red","blue")))
legend("topright", pch="-", col=c("black","red","blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))


# close the device
dev.off()

# Clean up the files
rm("sm1")
rm("sm2")
rm("sm3")
rm("cols")
rm("hpc")
