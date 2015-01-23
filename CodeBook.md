---
title: "Code Book"
output: html_document
---

## Introduction
There are 2 data sets: `tidy_data.txt` and `tidy_data_2.txt`. 
The latter data set contains the average numbers of each variable for each activity and each subject of the former one.

These two files are results after cleaning the [raw data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), and reference information could be found on the website of [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Both file share the same variables. `tidy_data.txt` has 10299 observations and `tidy_data_2.txt` has 180 observations.


```r
dim(tidy_data)
```

```
## [1] 10299    68
```

```r
dim(tidy_data_2)
```

```
## [1] 180  68
```

## Variables
Concerning variables (features), some transformations are made based on the raw data:
    <li> Clean the meaningless symbols using `gsub("\\(|\\)", "", feature)`, where `feature` is loaded from the raw data `features.txt`. </li>
    <li> Keep only the variables measuring the mean and standard deviation (`grep("(std|mean[^F])", features)`) for each measurement. </li>

## Observations of "tidy_data.txt"
There are 2 sets of data, one for `train` and the other for `test`. Combining them together respectively for `X`, `subject` and `y`. `X` contains all the numbers collected by wearing devices, `subject` stands for the subject who performed the activity for each window sample. Its range is from 1 to 30. `y` contains the number/label of activities where you can link the number to the activity name according to the file `activity_lables.txt`.
Observation data are modified following the steps below:
    <li> Combine (by row) train and test data sets concerning `X`. </li>
    <li> Replace `y` (activity number) by activity names. </li>
    <li> Make the activity name descriptive and more readable (`gsub("_"," ",tolower(activity[y[,1], 2]))`). </li>
    <li> Combine `subject`, `y` and `X` by column. </li>
    
## Observations of "tidy_data_2.txt"
The 2nd tidy data set is a summary on level of activity and subject. So `activity` and `subject` in `tidy_data` is the standard of grouping and we borrow function `aggregate()` to do this job.

```r
tidy_data_2 <- aggregate(tidy_data[3:ncol(tidy_data)], 
                         list(activity = tidy_data$activity, 
                              subject = tidy_data$subject), 
                         mean)
```

