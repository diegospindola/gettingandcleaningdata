# File: "run_analysis.R"
# Author: Diego Spíndola
# Creation: January, 2015
# Use: R script for creating a tidy data set from Anguita et al. data.
# More Info: https://github.com/diegospindola/gettingandcleaningdata

#
#
#step 1 - Merges the training and the test sets to create one data set.
#
#

#Loading training and test sets
X_train <- read.table("./train/X_train.txt")
names(X_train) <- 1:length(X_train)
y_train <- read.table("./train/y_train.txt")
X_test <- read.table("./test/X_test.txt")
names(X_test) <- 1:length(X_test)
y_test <- read.table("./test/y_test.txt")

#Binding training and test sets
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
#Subjects yet to be bound together in step 5

######################################################

#
#
#step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
#
#

#Loading feature names
features <- read.table("features.txt")

#Taking only the mean and standard deviation columns.
desiredFeatureIndices <- grep("-(mean|std)\\(\\)",features$V2)
X_extracted <- X[,desiredFeatureIndices]



######################################################

#
#
#step 3 - Uses descriptive activity names to name the activities in the data set
#
#

#Loading activity labels
activityLabels <- read.table("activity_labels.txt")

#Adding corresponding labels to the activities
activityLabels$V2 <- sub("_"," ",activityLabels$V2)
library(dplyr)
y <- mutate(y, activityLabel = activityLabels$V2[V1])





######################################################

#
#
#step 4 - Appropriately labels the data set with descriptive variable names.
#
#

#Taking desired features' names.
desiredFeatures <- features[desiredFeatureIndices,]


#Making more descriptive names from the originals.
desiredFeatures <- desiredFeatures %>% mutate(descriptiveName=V2) %>% mutate(descriptiveName=gsub("(Body)+","body",descriptiveName)) %>% mutate(descriptiveName=gsub("Gravity","gravity",descriptiveName)) %>% mutate(descriptiveName=gsub("^t","",descriptiveName)) %>% mutate(descriptiveName=gsub("^f(\\w+)Mag","\\1FrequencyMag",descriptiveName)) %>% mutate(descriptiveName=gsub("^f(\\w+)-","\\1Frequency-",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyAccJerkMag","JerkBodyAccelerationMagnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyAccJerk","JerkBodyAcceleration",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyGyroJerkMag","JerkBodyAngularVelocityMagnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyGyroJerk","JerkBodyAngularVelocity",descriptiveName)) %>% mutate(descriptiveName=gsub("Acc([A-Z]|-)","Acceleration\\1",descriptiveName)) %>% mutate(descriptiveName=gsub("Gyro","AngularVelocity",descriptiveName)) %>% mutate(descriptiveName=gsub("Mag","Magnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("-mean\\(\\)","Mean",descriptiveName)) %>% mutate(descriptiveName=gsub("-std\\(\\)","StandardDeviation",descriptiveName)) %>% mutate(descriptiveName=gsub("-([X|Y|Z])","For\\1Axis",descriptiveName)) 

#Renaming variables
names(X_extracted) <- desiredFeatures$descriptiveName

#Binding measures with activity labels
tidyData <- X_extracted
tidyData$activityLabel <- y$activityLabel



######################################################

#
#
#step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#

#Loading the subjects and binding them to the data set
subjectsTrain <- read.table("./train/subject_train.txt")
subjectsTest <- read.table("./test/subject_test.txt")
subjects <- rbind(subjectsTrain,subjectsTest)
tidyData$subject <- subjects$V1

#Grouping by activity and then by subject
groupedTidyData <- group_by(tidyData, activityLabel, subject)

#Summarising data
tidyData2 <- summarise_each(groupedTidyData, funs(mean)) 

#Writing tidy data into text file
write.table(tidyData2,"tidyData2.txt", row.names = FALSE)



