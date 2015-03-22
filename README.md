Project Description

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# 1) Merges the training and the test sets to create one data set.

## first create three new data files combining the training and test data sets for X, Y and subject

##Read in X_test and X_train data sets and write a new file with the test data and concatnate the training data to the end of the file.
test <-read.table("data/test/X_test.txt" )
train <-read.table("data/train/X_train.txt" )
write.table(test,"data/X_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/X_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

##Read in subject_test and subject_train data sets and write a new file with the test data and concatnate the training data to the end of the file.
test <-read.table("data/test/subject_test.txt" )
train <-read.table("data/train/subject_train.txt" )
write.table(test,"data/subject_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/subject_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

##Read in y_test and y_train data sets and write a new file with the test data and concatnate the training data to the end of the file.
test <-read.table("data/test/y_test.txt" )
train <-read.table("data/train/y_train.txt" )
write.table(test,"data/y_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/y_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

##Combine the X, Y and subject data into a single table by reading in x, 
##setting the second to last column to be the Y data and the last column to be the subject data
##write the combined data to a file called all_comb.txt 
x <-read.table("data/X_comb.txt" )
y <-read.table("data/y_comb.txt" )
s <-read.table("data/subject_comb.txt" )
x[,562] <- s
x[,563] <- y
write.table(x,"data/all_comb.txt", row.names=FALSE, col.names=FALSE )

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
##Read the previosly saved all_comb.txt file that contains all of the combined data
x <-read.table("data/all_comb.txt" )
##Set the columns indexes to include only those columns containing mean and STD elements
measures<- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,556:563)
##Extract the appropriate columns of data using the select statement. This extracts all rows
x <- select(x,measures)
##Write the subseted data to subset.txt
write.table(x,"data/subset.txt", row.names=FALSE, col.names=FALSE )

# 3) Uses descriptive activity names to name the activities in the data set
##Read in the subseted data from the previous file
x <-read.table("data/subset.txt" )
##Read in the activity labels and merge the labels into the subseted data using the merge function
y <- read.table("data/activity_labels.txt" )
z <- merge(x, y, by.x="V74",by.y="V1", sort= FALSE)
z <- select(z,c(2:75))

# 4) Appropriately labels the data set with descriptive variable names. 
##Read in the features and subset the labels corresponding to the subseted columns in step 2
f<-read.table("data/features.txt" )
measures<- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,556:561)
ff <- filter(f,(f$V1 %in% measures))
ff<- select(ff,2)
##Apply the column names to the subsetted data
colnames(z) <- ff[,1]
names(z)[73] <-"Subject"
names(z)[74] <-"Activity"
##Write the data back out to subset.txt
write.table(z,"data/subset.txt", row.names=FALSE, col.names=TRUE )

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#   for each activity and each subject.
##Setup to create a "molten" data set by both Subject and Activity using the melt function
ids <- c("Subject", "Activity")
labels <- setdiff(colnames(z), ids)
x <- melt(z, id = ids, measure.vars = labels)
##Take the "molten" data set x and recast it while calculating the mean of each column
y <- dcast(x, Subject + Activity ~ variable, mean)
##Write the resultant "tidy" data to tidy.txt
##This is the file that will be uploaded as the final project result
##Rownames are of no value but the column names are extremely useful
write.table(y, "data/tidy.txt", row.names=FALSE, col.names=TRUE)
