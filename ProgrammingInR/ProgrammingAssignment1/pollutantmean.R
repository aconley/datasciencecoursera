# Assignment 1, part 1

pollutantmean <- function(directory, pollutant, id=1:332) {
  # Read in all the data
  basenames <- sprintf("%03d.csv", id)
  filenames <- paste(directory, basenames, sep="/")
  data <- lapply(filenames, read.csv)

  # The mean we want is the mean of the individual
  # values, not the mean of each station;
  # If we wanted the mean of each station, we could
  # just do something like
  #   f <- function(x) { mean(x[[pollutant]], na.rm=TRUE)}
  #   mean(sapply(data, f))
  # But this will first average each station then average
  # those, which doesn't come out the same if the stations
  # can have different numbers of measurements
  #
  # This will pull out the pollutant values, remove the
  #  the NAs, then repack as a vector
  f <- function(x, pollutant) { as.vector(na.omit(x[[pollutant]])) }
  # Run that over the data
  vals <- lapply(data, f, pollutant)
  # Next, combine all the data into a single list
  # using stack.  However, stack, because R is written by
  # morons and the documentation by their idiot cousins
  # requires that the list be given names -- which the
  # documentation doesn't mention
  names(vals) <- filenames
  alldata <- stack(vals)$values
  mean(alldata)
}