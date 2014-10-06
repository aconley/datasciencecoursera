# Must be run from directory containing household_power_consumption.txt
datafile <- "household_power_consumption.txt"
if (!file.exists(datafile)) stop(paste("Didn't find data file", datafile))

# The data is in a ; separated file with ? for NA
col.class <- c("character", "character", "numeric", "numeric", "numeric", "numeric",
              "numeric", "numeric", "numeric")
data <- read.table(datafile, sep=";", header=TRUE,
                   colClasses=col.class, na.strings="?",
                   nrows=2075260)
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# select desired dates and variable
data <- subset(data, Date=="2007-02-01" | Date=="2007-02-02",
               Global_active_power)

# Histogram
png(filename="plot1.png", width=480, height=480)
hist(data$Global_active_power, xlab="Global Active Power (kilowatts)",
     col="red", main="Global Active Power")
dev.off()
