## Step 1: Loading the data

rm(list=ls())

library (caret)
library (randomForest)
library (knitr)
library (ggplot2)
library (data.table)

# Set the working directory as the directory of the current script run_analysis.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(fileUrl, destfile = "training.csv")
fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl, destfile = "testing.csv")

training <- fread("training.csv", na.strings = c("NA","#DIV/0!"))
testing <- fread("testing.csv", na.strings = "NA")

## Step 2: Exploration of data

#head(training)
#names(training)
#summary(training)
#lapply(training, class)

nonNA_index <- colSums(is.na(training))==0
names(training[,!nonNA_index,with=FALSE])

nsv_index <- nearZeroVar(training,saveMetrics=TRUE)
nsv_index <- nsv_index[,"zeroVar"] > 0
names(training[,nsv_index,with=FALSE])

## Step 3: Cleaning the data

# The following two equivalent expressions subset the data, delete the other columns, and keep "data.table" structure
training <- training[, nonNA_index & !nsv_index, with=FALSE]
#training <- training[, .SD, .SDcols=nonNA_index&!nsv_index]

testing <- testing[, nonNA_index & !nsv_index, with=FALSE]

# The following expression deletes the selected columns and keeps "data.table" structure
training[,c("V1","user_name","raw_timestamp_part_1","raw_timestamp_part_2",
            "cvtd_timestamp","new_window","num_window"):=NULL]

testing[,c("V1","user_name","raw_timestamp_part_1","raw_timestamp_part_2",
           "cvtd_timestamp","new_window","num_window"):=NULL]

save(training,testing,file="data1.RData")

rm(list=ls())
load(file="data1.RData")

## Step 4: Separating the training data into a training set and a cross validation set

set.seed(1000)
inTrain <- createDataPartition(training$classe, p=3/4, list=FALSE)
validation <- training[-inTrain,]
training <- training[inTrain,]

## Step 5: Principal component analysis

index <- grep("classe", colnames(training))
preProc <- preProcess(training[,-index,with=FALSE],method=c("pca","center","scale"),thresh=0.9)

trainingPC <- predict(preProc,training[,-index,with=FALSE])
training_data <- data.table(classe=training$classe,trainingPC)

validationPC <- predict(preProc,validation[,-index,with=FALSE])
validation_data <- data.table(classe=validation$classe,validationPC)

testingPC <- predict(preProc,testing[,-index,with=FALSE])

save(training_data,validationPC,validation_data,testingPC, file="data2.RData")

rm(list=ls())
load(file="data1.RData")
load(file="data2.RData")

## Step 6: Machine Learning Algorithms

### Algorithms I: Random Forest

modelFit1 <- train(classe~.,method="rf",data=training_data,trControl=trainControl(method="cv"))

predict1 <- predict(modelFit1,validationPC)

confusionMatrix(validation$classe, predict1)

result1 <- predict(modelFit1,testingPC)
result1

save(modelFit1,predict1,result1, file="data3.RData")

### Algorithms II: Boosting Classfier (e.g. Gradient Boosting Machine)

modelFit2 <- train(classe~.,method="gbm",data=training_data,trControl=trainControl(method="cv"))

predict2 <- predict(modelFit2,validationPC)

confusionMatrix(validation$classe, predict2)

result2 <- predict(modelFit2,testingPC)
result2

save(modelFit2,predict2,result2, file="data4.RData")
