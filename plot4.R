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

png(file = "./results/plot4.png", width = 480, height = 480)


# draw the histogram
hpc$Date<- as.Date(hpc$Date,"%d/%m/%Y")
hpc$Time <- strptime(paste(hpc$Date,hpc$Time),format = "%Y-%m-%d %H:%M:%S")

par(mfrow=c(2,2)) 


# 1.  histogram
hist(hpc$Global_active_power, 
     col = "red", 
     main = "",
     xlab= "datetime",
     ylab = "Global Active Power (kilowatts)")


# 2. plot ts
with(hpc, plot(Time,Global_active_power,type="l", 
               xlab="", ylab="Global Active Power (kilowatts)"))


# 3. plot multiple ts
with(hpc, {plot(Time,Sub_metering_1,type="l", 
                xlab="", ylab="Energy sub metering")
        lines(Time,Sub_metering_2,col="red")
        lines(Time,Sub_metering_3,col="blue")
})

legend("topright", pch="-", col=c("black","red","blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))


# 4. plot ts
with(hpc, plot(Time,Global_reactive_power,type="l", 
               xlab="", ylab="Global_reactive_power"))

# plot.ts(ts(hpc$Global_reactive_power, frequency = 1440), 
#         plot.type = "single",
#         ylab="Global_reactive_power",
#         xlab="datetime")

# close the device
dev.off()

# Clean up the files
rm("cols")
rm("hpc")
