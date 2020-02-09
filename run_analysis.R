## This is the Week 4 project on the Getting and Cleaning Data couse on Coursera
## by Derek Dixon 
## February 2, 2020

## Download the data file, unzip the file, and insert it into an object
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "dataset.zip", method = "curl")
unzip(zipfile = "dataset.zip", exdir = getwd())
path_data <- file.path("C:/Users/Derek/Desktop/R Projects/CleanTidyProj", "UCI HAR Dataset")

##Directions are the following:
## 1. Merge the training and test sets to create one data set
## 2. Extract only the measurements on the mean and standard deviations for each measurement
## 3. Use descriptive activity names to name the activities in the data set
## 4. Label the data set with descriptive variable names
## 5. From the data set in step 4, create a second independent tidy data set with the average of each 
##    variable for each activity and each subject


## We have three variables:
## - Activity
## - Subject
## - Features

## Reading the data files
## - Activity
dataActivityTest <- read.table(file.path(path_data, "test", "y_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(path_data, "train", "y_train.txt"), header = FALSE)
## - Subject
dataSubjectTest <- read.table(file.path(path_data, "test", "subject_test.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(path_data, "train", "subject_train.txt"), header = FALSE)
## - Features
dataFeaturesTest <- read.table(file.path(path_data, "test", "X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_data, "train", "X_train.txt"), header = FALSE)


# Examining variable structures
str(dataActivityTest)
str(dataActivityTrain)

str(dataSubjectTest)
str(dataSubjectTrain)

str(dataFeaturesTest)
str(dataFeaturesTrain)


## Now we merge the trainig and test sets to create a single data set
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

## Naming variables
names(dataActivity) <- c("activity")
names(dataSubject) <- c("subject")
FeatureNames <- read.table(file.path(path_data, "features.txt"), head = FALSE)
names(dataFeatures) <- FeatureNames$V2

## Merge colummns and complete the data set
datacombine <- cbind(dataSubject, dataActivity)
data <- cbind(dataFeatures, datacombine)

## This completes the first objective
##################################################################################

## subsetting the name of features by the mean and standard deviations
subsetFeatureNames <- FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", FeatureNames$V2)]
## subset the complete data set by the selected names of the features from the previous line
selectedNames <- c(as.character(subsetFeatureNames), "subject", "activity")
data <- subset(data, select = selectedNames)

## This completes the second objective
##################################################################################

activitylabels <- read.table(file.path(path_data, "activity_labels.txt"), header = FALSE)
data$activity <- activitylabels[data$activity, 2]

## That completes the third objective
##################################################################################

names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("-mean()", "Mean", names(data))
names(data) <- gsub("-std()", "STD", names(data))
names(data) <- gsub("angle", "Angle", names(data))
names(data) <- gsub("gravity", "Gravity", names(data))

## That completes the fourth objective
##################################################################################

FinalData <- data %>%
    group_by(subject, activity) %>%
    summarize_all(funs(mean))

write.table(FinalData, "FinalData.txt", row.names = FALSE)

str(FinalData)

FinalData

## And thus the fifth objective
##