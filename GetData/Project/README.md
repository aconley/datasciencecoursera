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
the following (from R), and after changing the working
directory to the directory containing the unzipped
data set `UCI HAR Dataset`:

    source("run_analysis.R")
    create.and.write.tidy()
    tidy <- read.table("tidy_accel.txt", header=TRUE, sep="\t")

As a result of these commands, a tab separated
file "tidy_accel.txt" will be created in the current 
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
	* t and f are changed to Time\. and Freq\.
	* \(\)s are removed
	* \- is converted to \.
	* mean and std are renamed Mean and Sd, which are closer to R
		usage
	* Repeated use of Body is changed to single usage
           (e.g., fBodyBody -> fBody).  This seems to be an error
	   in the original data set.
	* The Gyroscopic Jerk variables are renamed to acceleration
	   (e.g., GyroJerk -> GyroAcc).  This is another error in the
	   original data set, where the first derivative of the angular
	   velocity of the measuement is incorrectly identified as the
	   jerk, when in fact it is the angular acceleration.  Note
	   that this is not the case for the BodyJerk variables,
	   which really are the Jerk.
5. The activity types are read in from `y_[test|train].txt` and
   appended to the table as factors.  These is assumed to be in
   the same order as the summary variables from `X_[train|test].txt`, 
   which is supported by the data set documentation.
6. The subject id is read in from `subject_[test|train].txt` and appended.
   Again, these are assumed to be in the same order as the
   summary statistics.

The test and training data sets are simply combined (since the set
of subjects are disjoint).  Again, this consists of multiple
sets of data for each subject/activity pair.  The data set is split
up by subject/activity pair, and the mean values of each are computed
and stored in a new, tidy, data set.  Thus, for example,
there are 95 measurments of subject 1 walking, and the mean value
of those measurements is computed for each measured varaible and
stored in the tidy data set.  This is then written to a tab-separated
data file ("tidy_accel.txt" by default); tab separation is used
because the coursera web site seems to have problems with 
comma-separated files.
