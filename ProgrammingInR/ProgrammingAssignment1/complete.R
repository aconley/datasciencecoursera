complete <- function(directory, id=1:332) {
  # Construct filenames
  basenames <- sprintf("%03d.csv", id)
  filenames <- paste(directory, basenames, sep="/")
  
  # Make anonymous function to read in data, count
  # number of complete cases (using the complete.cases
  # built in)
  f <- function(file) { 
    data <- read.csv(file)
    sum(complete.cases(data))
  }
  
  # Build output frame
  data.frame(id=id, nobs=sapply(filenames, f))
}