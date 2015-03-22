## run_analysis.R
## I assume that you have unzipped the data, but not altered the sub-directory structure
## The working directory should be set to the UCI HAR Dataset directory, so that test and train are subdirectories of the
## current working directory. You must have installed and loaded the reshape2 library, for recast, used in Task 5.
##Running this script should then output the tidy data sets.

## Task 1: read in the data and clip it together
## The main data is 561 feature values for each case. We also need to read in the labels (subject and activity) and add these to
## each case (cbind). Train and test data have been separated and we want to add them together again (rbind) 
## and give the columns the appropriate names.Whenever we are finished with a large object, we'll discard it to make space.

##test data
testSubjectNumbers <- read.table("test/subject_test.txt")
testActivityNumbers <- read.table("test/y_test.txt")
testFeatures <- read.table("test/X_test.txt")
testComplete <- cbind(testSubjectNumbers,testActivityNumbers,testFeatures)
rm(testSubjectNumbers)
rm(testActivityNumbers)
rm(testFeatures)

##training data
trainSubjectNumbers <- read.table("train/subject_train.txt")
trainActivityNumbers <- read.table("train/y_train.txt")
trainFeatures <- read.table("train/X_train.txt")
trainComplete <- cbind(trainSubjectNumbers,trainActivityNumbers,trainFeatures)
rm(trainSubjectNumbers)
rm(trainActivityNumbers)
rm(trainFeatures)
##test and train together
dataComplete <- rbind(trainComplete,testComplete)
rm(trainComplete)
rm(testComplete)
## add feature names
featureNames <- read.table("features.txt",stringsAsFactors=FALSE)
names(dataComplete)[1:2]<-c("subjectNumber","Activity")
names(dataComplete)[3:563]<-featureNames$V2
rm(featureNames)

## Task 1 Complete

## Task 2: There are several summary statistics for each type of measurement. We are only interested in the mean and standard deviation.
## Other features with "mean" in their names don't fall into the same category, so only the 66 variables resulting from application
## of mean() or std() will be taken. A bit of grepping should do the trick.

dataSelected <- dataComplete[grep("mean[(][)]|std",names(dataComplete))]
dataSelected <- cbind(dataComplete[1:2],dataSelected)
rm(dataComplete)
##Task 2 Complete

##Task 3: Replace activity numbers with namestestSubjectNUmbers <- read.table("test/subject_test.txt")

ActivityNames <- c("Walking","WalkingUpstairs","WalkingDownstairs","Sitting","Standing","Laying")
dataSelected$Activity <- ActivityNames[dataSelected$Activity]
rm(ActivityNames)
## Task 3 Complete

##Task 4: Give the features informative names.
## Actually, the names are already pretty informative. I don't think expanding every element would be an improvement.
## They could do with some clean-up, though. This is pretty repetitive, so I'm going to hit it with a few gsubs.
## The goal is consistent names in lowerCamelCase.
## Clean up "Mean" and "Std"
names(dataSelected) <- gsub("[-]mean[(][)]","Mean",names(dataSelected))
names(dataSelected) <- gsub("[-]std[(][)]","Std",names(dataSelected))
##Get rid of annoying typo
names(dataSelected) <- gsub("BodyBody","Body",names(dataSelected))
## Make sure Mean and Std come last
names(dataSelected) <- gsub("Mean-X","XcompMean",names(dataSelected))
names(dataSelected) <- gsub("Mean-Y","YcompMean",names(dataSelected))
names(dataSelected) <- gsub("Mean-Z","ZcompMean",names(dataSelected))
names(dataSelected) <- gsub("Std-X","XcompStd",names(dataSelected))
names(dataSelected) <- gsub("Std-Y","YcompStd",names(dataSelected))
names(dataSelected) <- gsub("Std-Z","ZcompStd",names(dataSelected))
## There is no "GravityGyro"
names(dataSelected) <- gsub("BodyGyro","Gyroscope",names(dataSelected))


##Task 4 Complete

##Task 5 Group the data by applying mean to rows sharing the same subject and activity
## recast does this in one go!
tidyData <- recast(dataSelected,subjectNumber + Activity ~ ...,fun.aggregate=mean,id.var=1:2)

## OK, the data is probably better with the subject number and activity as factors

tidyData$Activity <- factor(tidyData$Activity)
tidyData$subjectNumber <- factor(tidyData$subjectNumber)

## Task 5 Complete
## Write the data as instructed
write.table(tidyData,"tidyData.txt",row.names=FALSE)

## Use read.table("tidyData.txt",header=TRUE) to read the data back in.
## By default, subjectNumber will be an integer, so you should turn it back to a factor as above (if desired) 

##final cleanup if desired
## rm(dataSelected)
## rm(tidyData)