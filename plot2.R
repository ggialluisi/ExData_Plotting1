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





# plot 2


# store langugage settings
user_lang <- Sys.getlocale("LC_TIME")

# set locale to english to correct weekdays names
Sys.setlocale("LC_TIME", "English")


# open the device
png(filename = "plot2.png", width = 480, height = 480, units = "px")

#build the plot
with(hpc, plot(datetime, Global_active_power, 
                    ylab = "Global Active Power (kilowatts)",
                    xlab = "",
                    type = "n"
))
# annotate, add the line
lines(hpc$datetime, y = hpc$Global_active_power)

# close the device
dev.off()


#restore language
Sys.setlocale("LC_TIME", user_lang)



