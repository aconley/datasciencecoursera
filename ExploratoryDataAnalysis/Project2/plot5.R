# Must be run from directory containing data files
# specified below

# Read the data
nei.file <- "summarySCC_PM25.rds"
if (!file.exists(nei.file)) stop("Can't find NEI file")
NEI <- readRDS(nei.file)
source.file <- "Source_Classification_Code.rds"
if (!file.exists(source.file)) stop("Can't find source file")
SCC <- readRDS(source.file)

# Figure out the SCC codes for vehicles;
# this isn't obvious, unfortunately.  Level.Two
# seems work well here
vehicle.SCC = unique(SCC[grepl("vehicle", SCC$SCC.Level.Two, 
                               ignore.case=TRUE),]$SCC)
# Subset to those SCCs and Baltimore
NEI<- subset(NEI, SCC %in% vehicle.SCC & fips=="24510")

# Find the totals per year
library(plyr, quiet=TRUE)
year.totals = ddply(NEI, ~year, summarize, total=sum(Emissions))

# Plot the emissions vs year as a barplot
library(ggplot2)
png(filename="plot5.png")
ggplot(year.totals, aes(as.factor(year), total)) +
    geom_bar(stat="identity", fill="blue") +
    labs(x="year", y=expression("Total Emission [tons]")) + 
    labs(title=expression("Baltimore PM"[2.5]*" Vehicle Emissions"))
dev.off()


