# Download the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("w4.zip")){download.file(fileUrl, "w4.zip")}
if (!file.exists("UCI HAR Dataset")){unzip("w4.zip")}

#Read the dataset
features <- read.table ("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table ("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table ("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table ("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table ("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table ("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table ("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table ("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#step 1 
library (dplyr)
x <- rbind (x_test, x_train)
y <- rbind (y_test, y_train)
subject <- rbind (subject_train, subject_test)
merge <- cbind (subject, x, y)

# step 2
tidydata <- merge %>% select (subject, code, contains("mean"), contains("std"))

# step 3
tidydata$code <- activities[tidydata$code, 2]

# step 4
names(tidydata)[2] = "activity"
names(tidydata) <- gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

# step 5
tidydata0 <- tidydata %>%
      group_by(subject,activity) %>%
      summarise_all(funs(mean))

# write table
write.table(tidydata0,"TidyData.txt", row.name=FALSE)

