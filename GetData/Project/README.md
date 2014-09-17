Coursera "Getting and Cleaning Data" Course Project
-----------------------------------------------------

Summary
-------
This repository contains code related to the course
project for the 2014 "Getting and Cleaning Data"
course from Coursera.  The primary purpose is to
read in a dataset consisting of smartphone accelerometer 
measurements for 30 subjects performing various activities,
and prepare a summary ('tidy') dataset.

Usage
-----
The reduction script (`run_analysis.R`) must be run in a 
directory containing the
unzipped input data (see below).  The script can be
run and the resulting tidy data set read in by doing
the following (from R):

    source("run_analysis.R")
    create.and.write.tidy()
    tidy <- read.csv("tidy_accel.csv", header=TRUE)

As a result of these commands, a comma separated
file "tidy_accel.csv" will be created in the current 
working directory.  For a description of the tidy data
set, as well as where it can be obtained, 
see `CodeBook.md` in this repository.


Description of Processing
-------------------------
The original data set consists of 30 total training and test subjects
(randomly assigned) performing one of 6 activities.  There are
multiple measurement sets per subject/activity.  For each measurement
set, in each variable, mean and standard deviation summaries
are available.  Since our goal is to work only with these
summaries, the raw accelerometer data is not processed by this script
(since it would be later discarded anyways).  The processing proceeds
as follows for each of the training and test datasets:

1. The summary statistics are read in from the `x_[train|test].txt`
   files
2. The names of the columns for that file are read from features.txt
3. All variables that do not contain the mean() or std() in their name are
   discarded.  Note that this means that the angle variables are
   not included because, while these involve the mean variables, 
   they are not means themselves.  For example, `angle(tBodyAccMean, 
   gravity)` is the angle between a mean variable (`tBodyAccMean`) and 
   `gravity`, but is not a mean variable itself.  Furthermore,
   meanFreq() variables are not included (since they are means in
   a different domain).
4. The columns are renamed to be more descriptive and R-friendly.
   `t` and `f` are changed to `Time\.` and `Freq\.`, `()`s are removed,
   `\-` is converted to `\.`, and `mean` and `std` are renamed `Mean` and `Sd`,
   which are closer to the R usage.  Repeated uses of `Body`
   (e.g., `fBodyBody`) are replaced with a single one (`fBody`); this seems
   to be a mistake in the original data set.
5. The activity types are read in from `y_[test|train].txt` and
   appended to the table.
6. The subject id is read in from `subject_[test|train].txt` and appended

The test and training data sets are simply combined (since the set
of subjects are disjoint).  Again, this consists of multiple
sets of data for each subject/activity pair.  The data set is split
up by subject/activity pair, and the mean values of each are computed
and stored in a new, tidy, data set.  Thus, for example,
there are 95 measurments of subject 1 walking, and the mean value
of those measurements is computed for each measured varaible and
stored in the tidy data set.  This is then written to a comma-separated
data file ("tidy_accel.csv" by default).


    

