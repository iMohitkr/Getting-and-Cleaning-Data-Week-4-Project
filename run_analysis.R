
#author: Mohit Kumar
#date: 28-05-2016
#This script cleans the dataset and store the Tidy dataset generated
#Detailed explainations are provided in the codeBook.md and README.md



library(reshape2) #for melt and dcast functions


f <- "UCI HAR Dataset.zip" 

#to check for the original dataset and download it
if (!file.exists(f)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, f, method="curl")
}  

#to extract the dataset
if (!file.exists("UCI HAR Dataset")) { 
  unzip(f) 
}
#to read the acitivity labels and convert it into character
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

#to read the features and convert it into character
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#to filter the features based on the given criteria 
required_features <- grep(".*mean.*|.*std.*", features[,2])

#to provide descriptive names for the features
required_features_names <- features[required_features,2]
required_features_names <- gsub('[-()]', '', required_features_names)
required_features_names = gsub('-std', 'Std', required_features_names)
required_features_names = gsub('-mean', 'Mean', required_features_names)
required_features_names = gsub('^t', 'Time', required_features_names)
required_features_names = gsub('^f', 'Freq', required_features_names)


#to read the X_train data set filtered using the required features 
train <- read.table("UCI HAR Dataset/train/X_train.txt")[required_features]

#to read the Y_train and subject_train data sets
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

#to column bind the read datasets together 
train <- cbind(train_subjects, train_activities, train)

#to read the X_test data set filtered using the required features 
test <- read.table("UCI HAR Dataset/test/X_test.txt")[required_features]

#to read the Y_test and subject_test data sets
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

#to column bind the read datasets together
test <- cbind(test_subjects, test_activities, test)


#to mergethe test and train data together row wise 
merge_train_test <- rbind(train, test)

#to provide descriptive variable names for the merged dataset
colnames(merge_train_test) <- c("subject", "activity", required_features_names)

#to convert the activity and subject column into factors 
merge_train_test$activity <- factor(merge_train_test$activity, levels = activity_labels[,1], labels = activity_labels[,2])
merge_train_test$subject <- as.factor(merge_train_test$subject)

#to create a second, independent tidy data set with the average of each variable for each activity and each subject
merge_train_test.melted <- melt(merge_train_test, id = c("subject", "activity"))
merge_train_test.mean <- dcast(merge_train_test.melted, subject + activity ~ variable, mean)

#to write the cleaned dataset to the working directory
write.table(merge_train_test.mean, "ActivityRecognitionUsingSmartphones.txt", row.names = FALSE, quote = FALSE)

#to generate the codeBook.md and codeBook.html files
library(knitr)
library(markdown)
knit("CodeBook.Rmd", output="codeBook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("codeBook.md", "codeBook.html")


