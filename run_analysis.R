setwd("~/Trainings/Coursera/Getting and cleaning data/Week4")

library(data.table)
library(dplyr)

## loading metadata
featurenames <- fread("./data/features.txt", col.names = c("id","featurename"))
activitylabes <- fread("./data/activity_labels.txt", col.names = c("id","activityname"))

## loading the training data
subjectrain <- fread("./data/train/subject_train.txt", col.names = "subjectid")
X_train <- fread("./data/train/X_train.txt")
X_train <- cbind(subjectrain$subjectid,X_train)
## Task 4: Appropriately labels with descriptive variable names.
names(X_train) <- c("subjectid", featurenames$featurename)

y_train <- fread("./data/train/y_train.txt", col.names = c("id"))
## Task 3: Using  activity labels to describe activity in dataset
y_train <- merge(y_train,activitylabes, by = "id")

traindataset <- cbind(y_train, X_train) 
traindataset$id <- NULL

## loading the test data 
subjectest <- fread("./data/test/subject_test.txt", col.names = "subjectid")
X_test <- fread("./data/test/X_test.txt")
X_test <- cbind(subjectest$subjectid,X_test)
## Task 4: Appropriately labels with descriptive variable names.
names(X_test) <- c("subjectid", featurenames$featurename)

y_test <- fread("./data/test/y_test.txt", col.names = c("id"))
## Task 3: using  activity labels to describe activity in dataset
y_test <- merge(y_test,activitylabes, by = "id")

testset <- cbind(y_test, X_test)
testset$id <- NULL

## Task 1: merging train & test set
dataset <- rbind(traindataset, testset)

## Task 2: selecting only measurements of mean and std, keeping activityname und subjectid.
colnames <- grep("[Mm]ean|[Ss]td|activityname|subjectid",names(dataset), value=TRUE)
dataset <- tbl_df(dataset)
data1 <- dataset[,c(colnames)]

## Task 5: average of each variable for each activity and each subject.
data2 <- aggregate(. ~ activityname + subjectid, data1[-3], mean)
newnames <- paste("Mean_of",names(data2[3:87]), sep ="_")
names(data2) <- c("activityname","subjectid",newnames)

## Outpu of this script:
write.table(data2, file ="data2.txt", row.names = FALSE)
