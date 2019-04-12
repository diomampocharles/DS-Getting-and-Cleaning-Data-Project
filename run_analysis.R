if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, "Course 3", method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip("Course 3") 
}

features <- read.table("./features.txt", col.names = c("n","functions"))
activities <- read.table("./activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/y_test.txt", col.names = "code")
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_train <- read.table("./train/X_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data1 <- cbind(Subject, Y, X)

Merged_Data2 <- Merged_Data1 %>% select(subject, code, contains("mean"), contains("std"))

Merged_Data2$code <- activities[Merged_Data2$code, 2]

names(Merged_Data2)[2] = "activity"
names(Merged_Data2)<-gsub("Acc", "Accelerometer", names(Merged_Data2))
names(Merged_Data2)<-gsub("Gyro", "Gyroscope", names(Merged_Data2))
names(Merged_Data2)<-gsub("BodyBody", "Body", names(Merged_Data2))
names(Merged_Data2)<-gsub("Mag", "Magnitude", names(Merged_Data2))
names(Merged_Data2)<-gsub("^t", "Time", names(Merged_Data2))
names(Merged_Data2)<-gsub("^f", "Frequency", names(Merged_Data2))
names(Merged_Data2)<-gsub("tBody", "TimeBody", names(Merged_Data2))
names(Merged_Data2)<-gsub("-mean()", "Mean", names(Merged_Data2), ignore.case = TRUE)
names(Merged_Data2)<-gsub("-std()", "STD", names(Merged_Data2), ignore.case = TRUE)
names(Merged_Data2)<-gsub("-freq()", "Frequency", names(Merged_Data2), ignore.case = TRUE)
names(Merged_Data2)<-gsub("angle", "Angle", names(Merged_Data2))
names(Merged_Data2)<-gsub("gravity", "Gravity", names(Merged_Data2))

FinalData <- Merged_Data2 %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
