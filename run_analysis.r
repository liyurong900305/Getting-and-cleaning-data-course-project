url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#destination zip
destfile<-paste0(getwd(),"/","dataweek4.zip")
#download zip file
download.file(url,destfile,method = curl)
#unzip file
unzip("dataweek4.zip",list = TRUE)

#read the features and activities data sets
library(dplyr)
library(data.table)
features_names<-read.table("features.txt")
activities_names<-read.table("activity_labels.txt")
#read the data sets in train and test folders
features_train<-read.table("./train/X_train.txt")
activities_train<-read.table("./train/Y_train.txt")
subjects_train<-read.table("./train/subject_train.txt")
bodyAccX_train<-read.table("./train/Inertial Signals/body_acc_x_train.txt")
bodyAccY_train<-read.table("./train/Inertial Signals/body_acc_y_train.txt")
bodyAccZ_train<-read.table("./train/Inertial Signals/body_acc_z_train.txt")
bodyGyroX_train<-read.table("./train/Inertial Signals/body_gyro_x_train.txt")
bodyGyroY_train<-read.table("./train/Inertial Signals/body_gyro_y_train.txt")
bodyGyroZ_train<-read.table("./train/Inertial Signals/body_gyro_z_train.txt")
totalAccX_train<-read.table("./train/Inertial Signals/total_acc_x_train.txt")
totalAccY_train<-read.table("./train/Inertial Signals/total_acc_y_train.txt")
totalAccZ_train<-read.table("./train/Inertial Signals/total_acc_z_train.txt")
features_test<-read.table("./test/X_test.txt")
activities_test<-read.table("./test/Y_test.txt")
subjects_test<-read.table("./test/subject_test.txt")
bodyAccX_test<-read.table("./test/Inertial Signals/body_acc_x_test.txt")
bodyAccY_test<-read.table("./test/Inertial Signals/body_acc_y_test.txt")
bodyAccZ_test<-read.table("./test/Inertial Signals/body_acc_z_test.txt")
bodyGyroX_test<-read.table("./test/Inertial Signals/body_gyro_x_test.txt")
bodyGyroY_test<-read.table("./test/Inertial Signals/body_gyro_y_test.txt")
bodyGyroZ_test<-read.table("./test/Inertial Signals/body_gyro_z_test.txt")
totalAccX_test<-read.table("./test/Inertial Signals/total_acc_x_test.txt")
totalAccY_test<-read.table("./test/Inertial Signals/total_acc_y_test.txt")
totalAccZ_test<-read.table("./test/Inertial Signals/total_acc_z_test.txt")
#rename columns in features, activities, and subjects sets in train and test data
names(features_train)<-features_names$V2
names(features_test)<-features_names$V2
names(activities_train)<-"activities"
names(activities_test)<-"activities"
names(subjects_train)<-"subjects"
names(subjects_test)<-"subjects"
# add subjects and acitivities sets to train and test data
addedTrain=cbind(subjects_train,activities_train,features_train)
addedTest=cbind(subjects_test,activities_test,features_test)
#1. Merge the training and test data sets to create one data set
mergedData<-rbind(addedTrain,addedTest)
# Make the column names valid and unique
validNames <- make.names(names=names(mergedData), unique=TRUE, allow_ = TRUE)
names(mergedData) <- validNames
#2. Extract only the measurements on the mean and standard deviation for each measurement
extractedData<-mergedData%>%select(matches("subjects|activities|mean|std"))
#3. Use descriptive activity names to name the activities in the data set
descriptiveData<-extractedData%>% 
  arrange(activities) %>% 
  mutate(activities = as.character(factor(activities, levels=1:6, labels= activities_names$V2)))
#4. Appropriately label the data set with descriptive variable names
#Use CamelCase
names(descriptiveData)<-gsub("tBodyAcc","BodyAccelerationTimeDomainAccelerometer",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyAccMag","BodyAccelerationTimeDomainAccelerometerFastFourierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyAccJerk","BodyAccelerationJerkTimeDomainAccelerometer",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyAccJerkMag","BodyAccelerationJerkTimeDomainAccelerometerFastFourrierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("tGravityAcc","GravityAccelerationTimeDomainAccelerometer",names(descriptiveData))
names(descriptiveData)<-gsub("tGravityAccMag","GravityAccelerationTimeDomainAccelerometerFastFourierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyGyro","BodyAccelerationTimeDomainGyroscope",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyGyroMag","BodyAccelerationTimeDomainGyroscopeFastFourrierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyGyroJerk","BodyAccelerationJerkTimeDomainGyroscope",names(descriptiveData))
names(descriptiveData)<-gsub("tBodyGyroJerkMag","BodyAccelerationJerkTimeDomainGyroscopeFastFourrierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyAcc","BodyAccelerationFrequencyDomainAccelerometer",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyAccMag","BodyAccelerationFrequencyDomainAccelerometerFastFourierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyAccJerk","BodyAccelerationJerkFrequencyDomainAccelerometer",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyGyro","BodyAccelerationFrequencyDomainGyroscope",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyAccJerkMag","BodyAccelerationJerkFrequencyDomainAccelerometerFastFourrierTransform",names(descriptiveData))
names(descriptiveData)<-gsub("fBodyGyroMag","BodyAccelerationFrequencyDomainGyroscopeFastFourierTransform",names(descriptiveData))
#5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData<-descriptiveData%>%group_by(subjects,activities)%>%summarise_all(mean)
write.table(tidyData, "TidyData.txt", row.name=FALSE)
