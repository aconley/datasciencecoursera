corr <- function(directory, threshold=0) {
  # This time the instructions don't talk about
  # knowing the number of files ahead of time
  # So we need to count the number
  
  files <- list.files(directory, pattern="*.csv",
                      full.names=TRUE)    
  
  # Loop, computing correlations from those that pass
  corrs <- numeric(0)
  for (file in files) {
    # Read
    data <- read.csv(file)
    
    # Check threshold
    nobs <- sum(complete.cases(data))
    if (nobs <= threshold) next
    
    # Correlate
    corrs <- c(corrs, cor(data$sulfate, data$nitrate,
               use="pairwise.complete.obs"))
  }
  corrs
}