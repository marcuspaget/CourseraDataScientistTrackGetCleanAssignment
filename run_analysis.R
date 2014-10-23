#......................................................................................................#
# 
#  Author: Mark Paget		Script Name: run_analysis.R   GitHub: http://github.org/marcuspaget
#
#  Date: 16th Oct 2014
#
#  Description:  This script is part of the Data Science course provided by John Hopkins School via coursera 
#
#  Requirements:
#
#  1.  Merges the training and the test sets to create one data set.
#  2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
#  3.  Uses descriptive activity names to name the activities in the data set
#  4.  Appropriately labels the data set with descriptive variable names. 
#  5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#  Ref: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
#  Data Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
#  Data Source obtained: 22:29 hrs WAST 23rd Oct 2014 
#  Checksum: sha1sum: 566456a9e02a23c2c0144674d9fa42a8b5390e71
#  Modified Date:  Last-Modified: Wed, 15 Jan 2014 14:20:28 GMT

# read in the training data

trainData<-read.csv("./train/X_train.txt",sep=" ",header=F)

# read in the test data

testData<-read.csv("./test/X_test.txt",sep=" ",header=F)

# read in activities for train and test files

actTrain<-read.csv("./train/y_train.txt",header=F)
actTest<-read.csv("./test/y_test.txt",header=F)

# read in subjects for train and test files

subTrain<-read.csv("./train/subject_train.txt",header=F)
subTest<-read.csv("./test/subject_test.txt",header=F)

# create new DFs with train and test Data prefixed with activity and subject

actTrainData<-cbind(actTrain,subTrain,trainData)
actTestData<-cbind(actTest,subTest,testData)


#  1.  Merges the training and the test sets to create one data set.

totalData<-rbind(actTrainData,actTestData)

#  4.  Appropriately labels the data set with descriptive variable names. 

labels<-read.csv("./features.txt",sep=" ",header=F)
l<-c("activity","subject",as.character(labels[,2]))
names(totalData)<-l

#  2.  Extracts only the measurements on the mean and standard deviation for each measurement. 

x<-subset(totalData,select=grep("std|mean|activity|subject",names(totalData)))

#  3.  Uses descriptive activity names to name the activities in the data set

x$activity[x$activity=="1"]<-"WALKING"
x$activity[x$activity=="2"]<-"WALKING_UPSTAIRS"
x$activity[x$activity=="3"]<-"WALKING_DOWNSTAIRS"
x$activity[x$activity=="4"]<-"SITTING"
x$activity[x$activity=="5"]<-"STANDING"
x$activity[x$activity=="6"]<-"LAYING"

# end 3.

#  5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

t<-(aggregate(. ~ activity + subject,data=x,mean))
write.table(t,file="comb_results.txt",row.name=FALSE)

# Tidy dataset because only 1 observation (e.g. WALKING_DOWNSTAIRS for subject 4) per row and one 1 column per variable for that observation
