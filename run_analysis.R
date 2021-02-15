###################################################
#
#Getting and Cleaning Data Course Project
#File: run_analysis.R
#
##################################################

library(utils)


####Read in the data
features <- read.delim('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

dfTrainX <- read.table('./UCI HAR Dataset/train/X_train.txt')
dfTrainActivity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
dfTrainSubject<- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
dfTrain <-  data.frame(dfTrainSubject, dfTrainActivity, dfTrainX)
names(dfTrain) <- c(c('subject', 'activity'), features)

dfTestX <- read.table('./UCI HAR Dataset/test/X_test.txt')
dfTestActivity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
dfTestSubject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

dfTest <-  data.frame(dfTestSubject, dfTestActivity, dfTestX)
names(dfTest) <- c(c('subject', 'activity'), features)


###Merge the two data sets
df<-rbind(dfTrain, dfTest)


###extract the measurements including mean and std dev.
mean_std<-grep('mean|std', features)
dfMeanStd<-df[,c(1,2,mean_std+2)]

###Rename activities to in data set
ActLabels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
ActLabels <- as.character(ActLabels[,2])
dfMeanStd$activity <- ActLabels[dfMeanStd$activity]

###Update the column names
NewName <- names(dfMeanStd)
NewName <- gsub("[(][)]", "", NewName)
NewName <- gsub("^t", "TimeDomain_", NewName)
NewName <- gsub("^f", "FrequencyDomain_", NewName)
NewName <- gsub("Acc", "Accelerometer", NewName)
NewName <- gsub("Gyro", "Gyroscope", NewName)
NewName <- gsub("Mag", "Magnitude", NewName)
NewName <- gsub("-mean-", "_Mean_", NewName)
NewName <- gsub("-std-", "_StandardDeviation_", NewName)
NewName <- gsub("-", "_", NewName)
names(dfMeanStd) <- NewName


###Data set with average of each variable
dfAverage <- aggregate(dfMeanStd[,3:81], by = list(activity = dfMeanStd$activity, subject = dfMeanStd$subject),FUN = mean)
write.table(dfAverage, file = "dfAverageTidy.txt", row.names = FALSE)
