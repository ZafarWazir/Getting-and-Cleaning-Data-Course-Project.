# -----------------------------------------------------------
# Coursera: Getting and Cleaning Data - Course Project
# Author: Fawad
# -----------------------------------------------------------

# Step 1: Download and unzip dataset
filename <- "dataset.zip"
if (!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

# Step 2: Load data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Step 3: Merge training and test sets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# Step 4: Extract mean and standard deviation columns
library(dplyr)
TidyData <- Merged_Data %>%
  select(subject, code, contains("mean"), contains("std"))

# Step 5: Use descriptive activity names
TidyData$code <- activities[TidyData$code, 2]

# Step 6: Label dataset with descriptive variable names
names(TidyData)[2] <- "activity"
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean\(\)", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-std\(\)", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-freq\(\)", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))

# Step 7: Create final tidy dataset with averages for each subject and activity
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Step 8: Write the tidy data to a .txt file
write.table(FinalData, "tidy_data.txt", row.name = FALSE)

# Done! The file 'tidy_data.txt' is ready for upload.
# -----------------------------------------------------------
