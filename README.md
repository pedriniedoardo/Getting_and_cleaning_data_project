# GETTING AND CLEANING DATA PROJECT

## Aim
The purpose of this project is to test some of the ability learned to collect, work with, and clean a data set.

## Backgorund
One of the most exciting areas in all of data science right now is wearable computing. 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data represent measurements collected from the accelerometers from the Samsung Galaxy S smartphone. 

## Data Source
[Here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) are the data for the project.

A full description of the data is available at [this site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Task

The data were downloaded locally and stored in the working directory.

The R script `run_analysis.R` contains all the steps used to produce the tidy datase `tidy_df.txt`, starting from the raw data.
In particular the main steps implemented into the script are:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
