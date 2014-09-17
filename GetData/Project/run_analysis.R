# This is a script to carry out the course project
# assignment for the Getting and Cleaning Data coursera MOOC
#
# The assignment focuses on making a tidy data set out of
# some Samsung Galaxy S accelerometers
#
# This assumes that the data has already been downloaded
# and unzipped into the current working directory (which
# therefore creates a subdirectory "UCI HAR Dataset")

# This function cleans up feature names as read from features.txt
# Inputs
#   nms    Vector of names
# Returns
#   Cleanup up names
#     * t -> Time., f-> Freq.
#     * - -> .
#     * mean -> Mean, std -> Sd
#     * repeated Body (BodyBody) replaced with Body; this seems
#        to be a mistake in the original data set
clean.names <- function(nms) {
  newnames <- gsub("[\\(\\)]", "", nms)
  newnames <- gsub("-", ".", newnames)
  newnames <- gsub("^t", "Time.", newnames, perl=TRUE)
  newnames <- gsub("^f", "Freq.", newnames, perl=TRUE)
  newnames <- gsub("mean", "Mean", newnames)
  newnames <- gsub("std", "Sd", newnames)
  newnames <- gsub("BodyBody", "Body", newnames)
  
  newnames
}


# This function reads either the training or test data sets
# into a data frame.  Only the mean and std variables
# are included, where these are defined to include the
# string mean() or std() in their names, based on the
# descriptions in features_info.txt
#
# Inputs
#    type    char    Either "test" or "train", controlling which
#                     data set to read in
# Returns
#  A data frame with the data loaded, labels added
read.accel.subset <- function(type) {
  # There are three datasets to load and combine
  #   1) The main dataset, with the accelerometer data.
  #       This comes from X_[train|test].txt, with
  #       column names in features.txt
  #   2) The activity type, y_[train|test].txt with
  #        level descriptions from activity_labels.txt
  #   3) The subject ID, from subject_[train|test].txt
  datadir <- "UCI HAR Dataset"
  if (!file.exists(datadir)) 
    stop(paste("Couldn't find data directory:", datadir))
  
  # Read in feature names
  features.file <- paste(datadir,"features.txt", sep="/")
  if (!file.exists(features.file))
    stop(paste("Couldn't find feature names file:", features.file))
  feature.names <- read.table(features.file, as.is=TRUE)[,2]
  
  # Read in actual data
  subdir = paste(datadir, type, sep="/")
  if (!file.exists(subdir))
    stop(paste("Couldn't find specified subdir:", subdir))
  xdata.file <- paste(subdir, paste("X_", type, ".txt", sep=""), sep="/")
  if (!file.exists(xdata.file))
    stop(paste("Couldn't find data file:", xdata.file))
  xdata <- read.table(xdata.file, colClasses="numeric")
  
  nrows <- dim(xdata)[1]
  ncols <- dim(xdata)[2]
  if (ncols != length(feature.names))
    stop(paste("Number of columns in ", xdata.file, " doesn't match number",
               " of feature names in ", features.file, sep=""))
  
  # Select the variables we want, which all contain either
  #  mean() or std() in their names.  The (very poorly documented)
  #  R regex engine requires \\ to escape literals
  idx.keep <- grep("mean\\(\\)|std\\(\\)", feature.names)
  xdata <- xdata[,idx.keep]
  
  # Clean up some of the feature.names into more R-friendly
  # forms, as well as subset down to idx.keep.
  # Store those as the column names for xdata
  names(xdata) <- clean.names(feature.names[idx.keep])
  
  # Now add in Y (activity type) data.  This is a feature vector,
  # with the names of the features in activity_labels.txt
  # So first read that
  activities.file <- paste(datadir,"activity_labels.txt", sep="/")
  if (!file.exists(activities.file))
    stop(paste("Couldn't find activity names file:", activities.file))
  activity.names <- read.table(activities.file, as.is=TRUE)
  
  # Read in actual Y data
  ydata.file <- paste(subdir, paste("y_", type, ".txt", sep=""), sep="/")
  if (!file.exists(ydata.file))
    stop(paste("Couldn't find activity type data file:", ydata.file))
  ydata <- read.table(ydata.file, as.is=TRUE)
  if (nrows != dim(ydata)[1])
    stop(paste("Number of rows in ", xdata.file, " doesn't match number",
               " of rows in ", ydata.file, sep=""))
  # Turn into factor and add to frame
  xdata$activity <- factor(ydata[,1], activity.names[,1],
                           labels=activity.names[,2])
  
  # Add subject ID, leave as number (rather than factor)
  subject.file <- paste(subdir, paste("subject_", type, ".txt", sep=""),
                        sep="/")
  if (!file.exists(subject.file))
    stop(paste("Couldn't find subject ID data file:", subject.file))
  subject.id <- read.table(subject.file, colClasses="integer")[,1]
  if (nrows != length(subject.id))
    stop(paste("Number of rows in ", xdata.file, " doesn't match number",
               " of rows in ", subject.file, sep=""))
  xdata$subject.id <- subject.id
  
  # Mark type (train, test)
  xdata$subset <- factor(replicate(nrows, type), levels=c("train", "test"))
  
  # Done
  xdata
}

# This reads in and merges the test and training datasets
read.accel <- function() {
  test <- read.accel.subset("test")
  train <- read.accel.subset("train")
  
  # Make sure that no subject appears in both
  if (any(duplicated(unique(test$subject.id), unique(train$subject.id))))
    stop("Duplicate subjects found in test and training data")
  
  # Make sure the row names are in the same order
  if (any(names(test) != names(train)))
    stop("Didn't find the same columns in test and train")
  
  rbind(test, train)
}

# This builds the tidy data set
#  Specifically:
#    * The test and training data are read and combined
#    * Only mean and standard deviation variables are kept
#    * The columns are given descriptive names
#    * The mean value for each variable across each activity/subject pair
#        is computed and stored as a new dataset
make.tidy.accel <- function() {
  # Read
  data <- read.accel()
  
  # Make sure we have no NAs or else fail
  data <- na.fail(data)
  
  # Find mean values.  Aggregate is quite useful here
  agg <- list(activity=data$activity, subject.id=data$subject.id)
  # Get rid of subject.id, activity, subset in input
  #  since those are meaningless to average
  for (nm in c("activity", "subject.id", "subset"))
    data[nm] <- NULL
  
  # Create and return tidy data set
  aggregate(data, by=agg, mean)
}

# Top level: makes the tidy data and writes it to a text file
# This must be run from a directory containing the "UCI HAR Dataset"
# subdirectory with the data in it.  This can be read back with, e.g.,
#  read.table(file, header=TRUE, sep="\t")
# Inputs
#   outfile: File to write tidy dataset to (as tab-separated text)
# We write as tab separated text, rather than something nicer,
# because of the limitation of the coursera site.
create.and.write.tidy <- function(outfile="tidy_accel.txt") {
  tidy <- make.tidy.accel()
  write.table(tidy, file=outfile, row.name=FALSE, sep="\t")
}

