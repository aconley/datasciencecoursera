Code Book for `tidy_accel.csv`
==============================

Data Source
-----------
The raw data input for this script can be
downloaded from [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
The specific version used to generate the included
tidy data set (`tidy_accel.csv`) in the repository was
downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
on 2014-09-17.  

Acknowledgements
----------------
Any use of this data set in publications must be acknowledged
with the following reference:

 Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Description of Data
-------------------
More details of the data set can be found on the original site
linked above.  Briefly, this data consists of accelerometer
data measured using smartphones for a set of 30 subjects in the
age range 19-48 years performing various activities
(walking, walking up stairs, walking down stairs, sitting, standing,
and laying).  The accelerometer measured 3-axis acceleration
and 3-axis angular acceleration at 50 Hz.  The data were low-pass
filtered to remove noise, and acceleration due to gravity was
removed.  Measurements are presented in the time domain,
and, in some cases, the frequency domain.  Note that each variable has been
rescaled to the range [-1, 1].

#### Description of each variable
The time domain measurements are prefaced with Time., the frequency
domain ones with Freq.  For each variable, the Mean and Standard
Deviation are provided (Mean and Sd, respectively).  All measurement
variables come in 3 versions (X, Y, Z) representing the three axes of
motion (both linear and angular).  The tidy dataset consists of the
mean values for each subject performing each activity of the mean and
standard deviation of each variable, along with the subject id and
activity type.  So, for example, Time.BodyAcc.Mean.X is the
time-domain mean acceleration along the X axis, which has been further
averaged over all of the measurement sets for each subject performing
a particular activity.

The following features are included, where [Time|Freq] means
Time or Freq, [XYZ] means one of X, Y, Z, and [Mean|Sd] means
one of Mean or Sd:

* activity		The activity type (WALKING, WALKING\_UPSTAIRS,
  			WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING)
* subject.id        The subject ID number (1 to 30, inclusive)
* [Time|Freq].BodyAcc.[Mean|Sd].[XYZ]  Body acceleration, linear,
    with the effects of gravity removed
* [Time|Freq].GravityAcc.[Mean|Sd].[XYZ]  Gravitational acceleration, 
    linear
* [Time|Freq].BodyAccJerk.[Mean|Sd].[XYZ]  Body jerk, linear
    (derivative of acceleration)
* [Time|Freq].BodyGyro.[Mean|Sd].[XYZ] Angular acceleration along
     each gyroscopic axis
* [Time|Freq].BodyGyroJerk.[Mean|Sd].[XYZ] Angular jerk along
     each gyroscopic axis
* [Time|Freq].BodyAccMag.[Mean|Sd] Mean magnitude of linear body
   acceleration (euclidean norm of body [XYZ] acceleration, gravity 
   removed)
* [Time|Freq].GravityAccMag.[Mean|Sd] Mean magnitude of gravitational 
    acceleration (euclidean norm)
* [Time|Freq].BodyAccJerkMag.[Mean|Sd] Mean magnitude of linear body
   jerk (euclidean norm of body [XYZ] jerk)
* [Time|Freq].BodyGyroMag.[Mean|Sd] Mean magnitude of angular body
   acceleration (euclidean norm of body [XYZ] angular acceleration)
* [Time|Freq].BodyGyroJerkMag.[Mean|Sd] Mean magnitude of angular body
   jerk (euclidean norm of body [XYZ] jerk)

#### Units
Because each physical variable has been rescaled to the range [-1, 1],
they have been rendered unitless.
