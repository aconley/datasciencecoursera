# Must be run from directory containing household_power_consumption.txt
datafile <- "household_power_consumption.txt"
if (!file.exists(datafile)) stop(paste("Didn't find data file", datafile))

# The data is in a ; separated file with ? for NA
col.class <- c("character", "character", "numeric", "numeric", "numeric", "numeric",
               "numeric", "numeric", "numeric")
data <- read.table(datafile, sep=";", header=TRUE,
                   colClasses=col.class, na.strings="?",
                   nrows=2075260)

# select desired dates
data <- subset(data, Date=="1/2/2007" | Date=="2/2/2007")

data$Date.Time <- strptime(paste(data$Date, data$Time),
                           format="%d/%m/%Y %H:%M:%S")

# Plot
png(filename="plot3.png", width=480, height=480)
plot(data$Date.Time, data$Sub_metering_1, xlab="",
     ylab="Energy sub metering", main="", type="n")
lines(data$Date.Time, data$Sub_metering_1, col="black")
lines(data$Date.Time, data$Sub_metering_2, col="red")
lines(data$Date.Time, data$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","red","blue"), lty=1)
dev.off()