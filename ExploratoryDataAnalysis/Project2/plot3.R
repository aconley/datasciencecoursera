# Read the data
nei.file <- "summarySCC_PM25.rds"
if (!file.exists(nei.file)) stop("Can't find NEI file")
NEI <- readRDS(nei.file)

# Subset to baltimore
NEI <- subset(NEI, fips=="24510")

# Find the totals per year
library(plyr, quiet=TRUE)
year.type.totals = ddply(NEI, ~year + type, summarize, total=sum(Emissions))

# Plot year/type to show
ttl <- expression(paste("Total ",PM[2.5],
                        " emission in Baltimore by source type"))
library(ggplot2)
png("plot3.png")
qplot(year, total, data=year.type.totals, 
      geom=c("point", "line"), facets=.~type,
      main=ttl, asp=0.75)
dev.off()
