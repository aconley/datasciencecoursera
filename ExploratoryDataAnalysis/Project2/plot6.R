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
# Subset to those SCCs and to baltimore and LA
NEI<- subset(NEI, SCC %in% vehicle.SCC &
                 (fips=="24510" | fips=="06037"))

# Add city as factor
NEI$City <- factor(NEI$fips, labels=c("Los Angeles", "Baltimore"))

# Find the totals per year by city
library(plyr, quiet=TRUE)
year.totals = ddply(NEI, ~year + City, summarize, total=sum(Emissions))
year.totals$year <- as.factor(year.totals$year)

# Plot the emissions vs year as a barplot
library(ggplot2)
png(filename="plot6.png")
ggplot(year.totals, aes(year, total)) +
    geom_bar(stat="identity", fill="blue") +
    facet_grid(. ~ City) +
    labs(x="year", y=expression("Total Emission [tons]")) + 
    labs(title=expression("Baltimore vs. LA PM"[2.5]*" Vehicle Emissions"))
dev.off()



