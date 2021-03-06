# Getting-and-cleaning-data-course-project
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis.
The original data is the data collected from the accelerometers from the Samsung Galaxy S smartphone.

This project includes the following files:
* README.md file (you are reading it)
* CodeBook.md file (describes the variables, the data, and any transformations or work that has been performed to clean up the data)
* run_analysis.r file (works with the original data and creates a tidy data set)

The run_analysis.r file does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each 
subject.
