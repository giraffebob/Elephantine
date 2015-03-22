# Getting and Cleaning Data Course Project Submission

run_analysis.R is the script that does the assignment. It does not call any other scripts.

tidyData.txt is the required tidy data set, and should match the one submitted on the assignment page.
Furthermore, it should match the output of run_analysis.R

CodeBook.md is the codebook for the tidy data set.

## How does the script work? (Heavily based on the comments in the script.)


I assume that you have unzipped the data, but not altered the sub-directory structure.
The working directory should be set to the UCI HAR Dataset directory, so that test and train are subdirectories of the
current working directory. You must have installed and loaded the reshape2 library, for recast, used in Task 5.
Running the script should then output the small tidy data set. (It will also put both tidy data sets in your workspace unless you uncomment the final cleanup.)

## Task 1: read in the data and clip it together:

The main data is 561 feature values for each case. We also need to read in the labels (subject and activity) and add these to
each case (cbind). Train and test data have been separated and we want to add them together again (rbind) 
and give the columns the appropriate names. Whenever we are finished with a large object, we discard it to make space.


## Task 2: There are several summary statistics for each type of measurement. We are only interested in the mean and standard deviation:

Other features with "mean" in their names don't fall into the same category, so only the 66 variables resulting from application
of mean() or std() will be taken. A bit of grepping does the trick. Not forgetting to add on the subject and activity columns.



##Task 3: Replace activity numbers with names:

Just manually creates the vector of names and directly assigns it to the appropriate column.



##Task 4: Give the features informative names:
Actually, the names are already pretty informative. I don't think expanding every element would be an improvement

They could do with some clean-up, though. This is pretty repetitive, so I apply some gsubs to the column names.

The goal is consistent names in lowerCamelCase - see the codebook for more details.

##Task 5 Group the data by applying mean to rows sharing the same subject and activity:

Recast does this in one go! Thus:

tidyData <- recast(dataSelected,subjectNumber + Activity ~ ...,fun.aggregate=mean,id.var=1:2)


## Final Details

The data is probably better with the subject number and activity as factors, so this has been done.

Data written with this command:

write.table(tidyData,"tidyData.txt",row.names=FALSE)

Use read.table("tidyData.txt",header=TRUE) to read the data back in.

By default, subjectNumber will be an integer, so you should turn it back to a factor(if desired)

By default, Activity will be a factor.