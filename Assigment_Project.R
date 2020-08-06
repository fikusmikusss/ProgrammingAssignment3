
path <- setwd("/Users/Aga/Documents/Coursera/Data science/Course 3 - Getting and Cleaning Data/Final Course Project")

#read the features
features <- read.table("features.txt")
colnames(features) <- c("Id", "feature")

#read activity labels
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <- c("Id", "activity")

#read the test set
test_x <- read.table(paste0(path,"/test/X_test.txt"))
test_y <- read.table(paste0(path,"/test/Y_test.txt"))
subject_test <- read.table(paste0(path,"/test/subject_test.txt"))

#read the train set
train_x <- read.table(paste0(path,"/train/X_train.txt"))
train_y <- read.table(paste0(path,"/train/Y_train.txt"))
subject_train <- read.table(paste0(path,"/train/subject_train.txt"))


#---------Merging the training and the test sets to create one data set
all_x <- rbind(test_x, train_x)
all_y <- rbind(test_y, train_y)
all_subject <- rbind(subject_test, subject_train)

#------removing unnecessary sets
rm(test_x)
rm(test_y)
rm(train_x)
rm(train_y)
rm(subject_test)
rm(subject_train)
#------------------------------CLEANING all_x SET

#rename cols for all_x set
colnames(all_x) <- features$feature

#extracting only the measurements on the mean and standard deviation for each measurement
colnames(all_x)
mean_col <- grep("mean", colnames(all_x))
std_col <- grep("std", colnames(all_x))

final_col <- mean_col
final_col <- append(final_col, std_col)
final_col <- sort(final_col)

#removing from all_x set all column apart mean and std measurement
all_x <- all_x[,final_col]

#removing unnecessary variables
rm(mean_col)
rm(std_col)
rm(final_col)

##------------------------------CLEANING all_y SET
# replace activity id with activity label
colnames(all_y) <- "activityId"
all_y <- merge(x=all_y, y=activity_labels,
                by.x = "activityId", by.y = "Id")


#rename all_subject cols
colnames(all_subject) <- "subjectId"

#-----combining text_x and test_y
all_data <- cbind(all_subject, all_y, all_x)


#------CREATING TIDY DATA SET with the average of each variable for each activity and each subject
library(dplyr)
tidy_data <- all_data %>%
  group_by(subjectId, activityId, activity) %>%
  summarise_all(list(mean))

write.csv(all_data, "all_data.csv")
write.csv(tidy_data, "tidy_data.csv")
