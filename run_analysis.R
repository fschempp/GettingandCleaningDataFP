## Place all data in the ./data subdirectory
##
setwd("~/R/GettingData/project")

# 1) Merges the training and the test sets to create one data set.

test <-read.table("data/test/X_test.txt" )
train <-read.table("data/train/X_train.txt" )
write.table(test,"data/X_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/X_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

test <-read.table("data/test/subject_test.txt" )
train <-read.table("data/train/subject_train.txt" )
write.table(test,"data/subject_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/subject_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

test <-read.table("data/test/y_test.txt" )
train <-read.table("data/train/y_train.txt" )
write.table(test,"data/y_comb.txt",row.names=FALSE, col.names=FALSE)
write.table(train,"data/y_comb.txt", row.names=FALSE, col.names=FALSE, append=TRUE )

x <-read.table("data/X_comb.txt" )
y <-read.table("data/y_comb.txt" )
s <-read.table("data/subject_comb.txt" )
x[,562] <- s
x[,563] <- y

write.table(x,"data/all_comb.txt", row.names=FALSE, col.names=FALSE )

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
x <-read.table("data/all_comb.txt" )
measures<- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,556:563)
x <- select(x,measures)
write.table(x,"data/subset.txt", row.names=FALSE, col.names=FALSE )

# 3) Uses descriptive activity names to name the activities in the data set
x <-read.table("data/subset.txt" )
y <- read.table("data/activity_labels.txt" )
z<-merge(x,y,by.x="V1.2",by.y="V1", sort= FALSE)
z <- select(z,c(2:75))

# 4) Appropriately labels the data set with descriptive variable names. 
f<-read.table("data/features.txt" )
measures<- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,556:561)

ff <- filter(f,(f$V1 %in% measures))
ff<- select(ff,2)
colnames(z) <- ff[,1]
names(z)[73] <-"Subject"
names(z)[74] <-"Activity"
write.table(z,"data/subset.txt", row.names=FALSE, col.names=TRUE )

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#   for each activity and each subject.

ids <- c("Subject", "Activity")
labels <- setdiff(colnames(z), ids)
x <- melt(z, id = ids, measure.vars = labels)
y <- dcast(x, Subject + Activity ~ variable, mean)
write.table(y, "data/tidy.txt", row.names=FALSE, col.names=TRUE)

