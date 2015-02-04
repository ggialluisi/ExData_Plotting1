library(dplyr)


if(!file.exists("./data")){dir.create("./data")}




# Set up files, if 'household_power_consumption.txt' file is not already on the './data' folder

datafile <- "./data/household_power_consumption.txt"
if(!file.exists(datafile)){
    
    zipfile <- "./data/exdata___household_power_consumption.zip"
    if(!file.exists(zipfile)){
        
        ## downloads project files
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile=zipfile)
    }
    
    # 
    unzip (zipfile, exdir = "./data")
}



#1) Read the data
hpc <- read.table(datafile, 
                  sep = ";",
                  header = TRUE, 
                  na.strings = "?",
                  colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
hpc <- hpc[hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007",]

# date and time to a single column
hpc <- mutate(hpc, datetime = paste(Date, Time, sep=" "))

# convert to datetime
hpc$datetime <- strptime(x = hpc$datetime, format = "%d/%m/%Y %H:%M:%S")




# plot 3


png(filename = "plot3.png", width = 480, height = 480, units = "px")


# store langugage settings
user_lang <- Sys.getlocale("LC_TIME")

# set locale to english to correct weekdays names
Sys.setlocale("LC_TIME", "English")


# create the plot
with(hpc, plot(datetime, Sub_metering_1, 
               ylab = "Energy sub metering",
               xlab = "",
               type = "n"
))

lines(x = hpc$datetime, y = hpc$Sub_metering_1, col = "black")
lines(x = hpc$datetime, y = hpc$Sub_metering_2, col = "red")
lines(x = hpc$datetime, y = hpc$Sub_metering_3, col = "blue")

legend("topright", 
       lwd = 1, 
       pch = "", 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# close the device
dev.off()


#restore language
Sys.setlocale("LC_TIME", user_lang)

