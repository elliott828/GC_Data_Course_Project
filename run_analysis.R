# set working directory path
if(!file.exists("./UCI HAR Dataset"))dir.create("./UCI HAR Dataset")
setwd("./UCI HAR Dataset")

# create function for combining corresponding data in 2 folders
combine_data <- function(common.name){
    df_test <- read.table(paste("test/", common.name, 
                                "_test.txt", sep = ""))
    df_train <- read.table(paste("train/", common.name, 
                                 "_train.txt", sep =""))
    df <- rbind(df_test, df_train)
    return(df)
}

# apply combine_data() on 3 types of files
X <- combine_data("X")
y <- combine_data("y")
subject <- combine_data("Subject")

# read features and exclude the number of features
feature <- read.table("features.txt")[,2]
activity <- read.table("activity_labels.txt")[,2]

# assign colnames to X with some of features renamed (remove parethesis)
names(X) <- gsub("\\(|\\)", "", feature)

# keep only mean and sd.
mean_std_position <- grep("(std|mean[^F])", features)
X <- X[,mean_std_position]

# using activity to replace y, remove "_"
y[,1] <- gsub("_"," ",tolower(activity[y[,1], 2]))

# combine all the elements and rename the data frame
tidy_data <- cbind(subject, y, X)
names(tidy_data) <- c("subject", "activity", names(X))

# export tidy_data
write.table(tidy_data, "tidy_data.txt")

# creats 2nd tidy_data with average of each variable for 
# each activity and each subject
tidy_data_2 <- aggregate(tidy_data[3:ncol(tidy_data)], 
                         list(activity = tidy_data$activity, 
                              subject = tidy_data$subject), 
                         mean)

write.table(tidy_data_2, "tidy_data_2.txt")



