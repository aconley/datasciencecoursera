# Must be run from directory containing data files
# specified below

# Read the data
nei.file <- "summarySCC_PM25.rds"
if (!file.exists(nei.file)) stop("Can't find NEI file")
NEI <- readRDS(nei.file)
source.file <- "Source_Classification_Code.rds"
if (!file.exists(source.file)) stop("Can't find source file")
SCC <- readRDS(source.file)

# Figure out the SCC codes for combustion and coal
comb.related = grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal.related = grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE)
coal.and.comb.SCC = SCC[which(comb.related & coal.related),]$SCC
NEI<- subset(NEI, SCC %in% coal.and.comb.SCC)

# Find the totals per year.
library(plyr, quiet=TRUE)
year.totals = ddply(NEI, ~year, summarize, total=sum(Emissions))

# Plot the emissions vs year as a barplot using ggplot2
library(ggplot2, quiet=TRUE)
png(filename="plot4.png")
ggplot(year.totals, aes(as.factor(year), total/1e5)) +
    geom_bar(stat="identity", fill="blue") +
    labs(x="year", y=expression("Total Emission [10^5 tons]")) + 
    labs(title=expression("PM"[2.5]*" Coal Combustion Emissions"))
dev.off()
""
