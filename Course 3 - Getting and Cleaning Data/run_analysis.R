library(knitr)
library(data.table)

## Step 1: Downloading the data

# Set the working directory as the directory of the current script run_analysis.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Dataset.zip")
unzip("Dataset.zip")

X_variable_names <- fread("./UCI HAR Dataset/features.txt")$V2
y_activity_names <- fread("./UCI HAR Dataset/activity_labels.txt")

## Step 2: The function of processing data

FullProcess <- function (X_file,y_file,subject_file) {
    
    # Step 2.1: Processing X_file
    X <- fread(X_file)
    setnames(X, old=names(X), new=X_variable_names)
    
    # Step 2.2: Processing y_file
    y <- fread(y_file)
    setnames(y, old=names(y), new="Activity")
    y$Activity <- factor(as.factor(y$Activity),levels=y_activity_names$V1,labels=y_activity_names$V2)
    
    # Step 2.3: Processing subject_file
    sub <- fread(subject_file)
    setnames(sub, old=names(sub), new="Subject")
    
    # Step 2.4: Merge the data X, y and sub
    data <- data.table(sub,X,y)
    
    return(data)
}

## Step 3: Process training set data

data_train <- FullProcess ("./UCI HAR Dataset/train/X_train.txt",
                           "./UCI HAR Dataset/train/y_train.txt",
                           "./UCI HAR Dataset/train/subject_train.txt")

## Step 4: Process testing set data

data_test <- FullProcess ("./UCI HAR Dataset/test/X_test.txt",
                          "./UCI HAR Dataset/test/y_test.txt",
                          "./UCI HAR Dataset/test/subject_test.txt")

## Step 5: Merging training and testing set data

data <- rbind(data_train,data_test) # vertical

## Step 6: Select the variables (columns) that are related to means and standard derivations

index <- names(data)=="Subject" | grepl("mean\\(\\)",names(data))|
    grepl("std\\(\\)",names(data)) | names(data)=="Activity"
data_select <- data[,index,with=FALSE]

## Step 7: Creates a second, independent tidy data set with the average of each variable for each activity and each subject

index <- names(data_select)!="Subject" & names(data_select)!="Activity"
data_summary <- aggregate(data_select[,index,with=FALSE],
                          list(data_select$Subject,data_select$Activity), mean)
setnames(data_summary,old=c("Group.1","Group.2"),new=c("Subject","Activity"))

head(data_summary)
#tail(data_summary)

## Step 8: Write the new data set into a txt file

write.table(data_summary, "./Data_Clean.txt", sep="\t", row.name=FALSE)