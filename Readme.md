run_analysis is a R function to extract data from the data contained in the file 
shttps://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

run_analysis takes the data from the training and test files, adds the necessary subject number 
and activity codes and then combines the two data frames into one data frame.  There is a sub 
function that modifies the header names to make them more understandable.  Finally an aggregate 
function summarizes the data over subject and activity.