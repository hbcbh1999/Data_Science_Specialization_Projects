# The Applications of Machine Learning Algorithms on Weight Lifting Exercises
Yangang Chen  

## Abstract

In this report, I classify how well people perform barbell lifts, where class "A" corresponds to the correct performance, and classes "B", "C", "D", "E" are different types of incorrect performances. I use two machine learning algorithms - **Random Forest**, and **Boosting Classfier (e.g. Gradient Boosting Machine)**. First I train these two algorithms on the training set. Then I apply the trained models on the cross validation set and conclude that **the Random Forest algorithm outperforms the Boosting Classfier algorithm**. In the end, I use the trained model to classify the test set, and **the result using the Random Forest algorithm is 95% accurate** (according to the feedback from the Course Project Prediction Quiz).

## Step 1: Loading the data



```r
library (caret)
library (randomForest)
library (knitr)
library (ggplot2)
library (data.table)
```

I download the data for training and testing sets.

```r
fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(fileUrl, destfile = "training.csv")
fileUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl, destfile = "testing.csv")
```

I notice that the data in both "testing.csv" and "training.csv" contains missing data. In addition, the data in "training.csv" contains special characters "#DIV/0!". Hence, when loading the data, I specify the "na.strings" options and convert all these missing data and special characters into "NA".

```r
training <- fread("training.csv", na.strings = c("NA","#DIV/0!"))
testing <- fread("testing.csv", na.strings = "NA")
```

## Step 2: Exploration of data

The following functions help us get some ideas about the data:

```r
head(training)
names(training)
summary(training)
lapply(training, class)
```

The data contains 160 variables in total. Many of them contains **NA**:

```r
nonNA_index <- colSums(is.na(training))==0
names(training[,!nonNA_index,with=FALSE])
```

```
##   [1] "kurtosis_roll_belt"       "kurtosis_picth_belt"     
##   [3] "kurtosis_yaw_belt"        "skewness_roll_belt"      
##   [5] "skewness_roll_belt.1"     "skewness_yaw_belt"       
##   [7] "max_roll_belt"            "max_picth_belt"          
##   [9] "max_yaw_belt"             "min_roll_belt"           
##  [11] "min_pitch_belt"           "min_yaw_belt"            
##  [13] "amplitude_roll_belt"      "amplitude_pitch_belt"    
##  [15] "amplitude_yaw_belt"       "var_total_accel_belt"    
##  [17] "avg_roll_belt"            "stddev_roll_belt"        
##  [19] "var_roll_belt"            "avg_pitch_belt"          
##  [21] "stddev_pitch_belt"        "var_pitch_belt"          
##  [23] "avg_yaw_belt"             "stddev_yaw_belt"         
##  [25] "var_yaw_belt"             "var_accel_arm"           
##  [27] "avg_roll_arm"             "stddev_roll_arm"         
##  [29] "var_roll_arm"             "avg_pitch_arm"           
##  [31] "stddev_pitch_arm"         "var_pitch_arm"           
##  [33] "avg_yaw_arm"              "stddev_yaw_arm"          
##  [35] "var_yaw_arm"              "kurtosis_roll_arm"       
##  [37] "kurtosis_picth_arm"       "kurtosis_yaw_arm"        
##  [39] "skewness_roll_arm"        "skewness_pitch_arm"      
##  [41] "skewness_yaw_arm"         "max_roll_arm"            
##  [43] "max_picth_arm"            "max_yaw_arm"             
##  [45] "min_roll_arm"             "min_pitch_arm"           
##  [47] "min_yaw_arm"              "amplitude_roll_arm"      
##  [49] "amplitude_pitch_arm"      "amplitude_yaw_arm"       
##  [51] "kurtosis_roll_dumbbell"   "kurtosis_picth_dumbbell" 
##  [53] "kurtosis_yaw_dumbbell"    "skewness_roll_dumbbell"  
##  [55] "skewness_pitch_dumbbell"  "skewness_yaw_dumbbell"   
##  [57] "max_roll_dumbbell"        "max_picth_dumbbell"      
##  [59] "max_yaw_dumbbell"         "min_roll_dumbbell"       
##  [61] "min_pitch_dumbbell"       "min_yaw_dumbbell"        
##  [63] "amplitude_roll_dumbbell"  "amplitude_pitch_dumbbell"
##  [65] "amplitude_yaw_dumbbell"   "var_accel_dumbbell"      
##  [67] "avg_roll_dumbbell"        "stddev_roll_dumbbell"    
##  [69] "var_roll_dumbbell"        "avg_pitch_dumbbell"      
##  [71] "stddev_pitch_dumbbell"    "var_pitch_dumbbell"      
##  [73] "avg_yaw_dumbbell"         "stddev_yaw_dumbbell"     
##  [75] "var_yaw_dumbbell"         "kurtosis_roll_forearm"   
##  [77] "kurtosis_picth_forearm"   "kurtosis_yaw_forearm"    
##  [79] "skewness_roll_forearm"    "skewness_pitch_forearm"  
##  [81] "skewness_yaw_forearm"     "max_roll_forearm"        
##  [83] "max_picth_forearm"        "max_yaw_forearm"         
##  [85] "min_roll_forearm"         "min_pitch_forearm"       
##  [87] "min_yaw_forearm"          "amplitude_roll_forearm"  
##  [89] "amplitude_pitch_forearm"  "amplitude_yaw_forearm"   
##  [91] "var_accel_forearm"        "avg_roll_forearm"        
##  [93] "stddev_roll_forearm"      "var_roll_forearm"        
##  [95] "avg_pitch_forearm"        "stddev_pitch_forearm"    
##  [97] "var_pitch_forearm"        "avg_yaw_forearm"         
##  [99] "stddev_yaw_forearm"       "var_yaw_forearm"
```

Some of them are constants:

```r
nsv_index <- nearZeroVar(training,saveMetrics=TRUE)
nsv_index <- nsv_index[,"zeroVar"] > 0
names(training[,nsv_index,with=FALSE])
```

```
## [1] "kurtosis_yaw_belt"     "skewness_yaw_belt"     "kurtosis_yaw_dumbbell"
## [4] "skewness_yaw_dumbbell" "kurtosis_yaw_forearm"  "skewness_yaw_forearm"
```

## Step 3: Cleaning the data

For convenience, I decide to remove all the variables that contain "NA" and that are constant, as follows:

```r
# The following two equivalent expressions subset the data, delete the other columns, and keep "data.table" structure
training <- training[, nonNA_index & !nsv_index, with=FALSE]
#training <- training[, .SD, .SDcols=nonNA_index&!nsv_index]

testing <- testing[, nonNA_index & !nsv_index, with=FALSE]
```

In addition, I notice that the first few variables are irrelavent to how well an activity was performed by the wearer. More specifically, the reference mentioned that relavent quantities are the measurements such as "arm/belt/forearm/dumbbell sensors' orientations". The first few variables have nothing to do with these quantities, such as index (X), wearer's name (user_name), etc. Hence, I remove these variables to avoid overfiitings.

```r
# The following expression deletes the selected columns and keeps "data.table" structure
training[,c("V1","user_name","raw_timestamp_part_1","raw_timestamp_part_2",
            "cvtd_timestamp","new_window","num_window"):=NULL]

testing[,c("V1","user_name","raw_timestamp_part_1","raw_timestamp_part_2",
           "cvtd_timestamp","new_window","num_window"):=NULL]
```

After this step, the training and testing data contain 53 variables.

## Step 4: Separating the training data into a training set and a cross validation set

Next, I separate the training data into a training set and a cross validation set, using the standard function "createDataPartition" in the caret package.

```r
set.seed(1000)
inTrain <- createDataPartition(training$classe, p=3/4, list=FALSE)
validation <- training[-inTrain,]
training <- training[inTrain,]
```

## Step 5: Principal component analysis

There are still 53 variables in the training/testing set. If the machine learning algorithms are applied directly on these 53 variables, the computational cost will be extremely expensive. Considering this, it is desirable to reduce the dimension of the problem.

The standard technique to achieve this is called "principal component analysis", which uses singular value decomposition (SVD) to reduce the dimension of the problem. I choose the threashold to be 0.9, which means that the number of principal components capture 90% of the variance.

```r
index <- grep("classe", colnames(training))
preProc <- preProcess(training[,-index,with=FALSE],method=c("pca","center","scale"),thresh=0.9)
```

Then I apply the PCA to training, cross validation and test sets.

```r
trainingPC <- predict(preProc,training[,-index,with=FALSE])
training_data <- data.table(classe=training$classe,trainingPC)

validationPC <- predict(preProc,validation[,-index,with=FALSE])
validation_data <- data.table(classe=validation$classe,validationPC)

testingPC <- predict(preProc,testing[,-index,with=FALSE])
```

## Step 6: Machine Learning Algorithms

### Algorithms I: Random Forest

Random Forest is a highly accurate machine learning algorithm for classification and regression, by constructing a multitude of decision trees at training time and outputting the class that is the mode of the classes (classification) or mean prediction (regression) of the individual trees.

I use the function "train" in the caret package, with the method "rf" (Random Forest), to train the random forest using the training set.

```r
modelFit1 <- train(classe~.,method="rf",data=training_data,trControl=trainControl(method="cv"))
```

Then I apply the trained model to the cross validation set

```r
predict1 <- predict(modelFit1,validationPC)
```
and analyse the accuracy of the prediction

```r
confusionMatrix(validation$classe, predict1)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1380   11    3    1    0
##          B   11  930    7    0    1
##          C    5   17  822    9    2
##          D    4    0   23  775    2
##          E    1    3    7    7  883
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9768          
##                  95% CI : (0.9721, 0.9808)
##     No Information Rate : 0.2857          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9706          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9850   0.9677   0.9536   0.9785   0.9944
## Specificity            0.9957   0.9952   0.9918   0.9929   0.9955
## Pos Pred Value         0.9892   0.9800   0.9614   0.9639   0.9800
## Neg Pred Value         0.9940   0.9922   0.9901   0.9959   0.9988
## Prevalence             0.2857   0.1960   0.1758   0.1615   0.1811
## Detection Rate         0.2814   0.1896   0.1676   0.1580   0.1801
## Detection Prevalence   0.2845   0.1935   0.1743   0.1639   0.1837
## Balanced Accuracy      0.9904   0.9815   0.9727   0.9857   0.9949
```
The accuracy of the prediction using the Random Forest algorithm on the cross validation set is 98%, which is quite good.

Eventually I predict the class of the test set by applying the trained model to the test set:

```r
result1 <- predict(modelFit1,testingPC)
result1
```

```
##  [1] B A A A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
According to the feedback from the Course Project Prediction Quiz, the only mistake occurs on the third test sample. Hence, the prediction is quite accurate.

### Algorithms II: Boosting Classfier (e.g. Gradient Boosting Machine)

Boosting Classfier is a machine learning algorithm for classification and regression, which produces a prediction model in the form of an ensemble of weak prediction models, typically decision trees.

I use the function "train" in the caret package, with the method "gbm" (Gradient Boosting Machine), to train the random forest using the training set.

```r
modelFit2 <- train(classe~.,method="gbm",data=training_data,trControl=trainControl(method="cv"))
```

Then I apply the trained model to the cross validation set

```r
predict2 <- predict(modelFit2,validationPC)
```
and analyse the accuracy of the prediction

```r
confusionMatrix(validation$classe, predict2)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1238   35   42   70   10
##          B  101  692   88   40   28
##          C   56   78  685   20   16
##          D   37   31   90  628   18
##          E   48   53   64   36  700
## 
## Overall Statistics
##                                           
##                Accuracy : 0.804           
##                  95% CI : (0.7926, 0.8151)
##     No Information Rate : 0.3018          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.7517          
##  Mcnemar's Test P-Value : < 2.2e-16       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.8365   0.7784   0.7069   0.7909   0.9067
## Specificity            0.9541   0.9360   0.9568   0.9572   0.9514
## Pos Pred Value         0.8875   0.7292   0.8012   0.7811   0.7769
## Neg Pred Value         0.9310   0.9502   0.9299   0.9595   0.9820
## Prevalence             0.3018   0.1813   0.1976   0.1619   0.1574
## Detection Rate         0.2524   0.1411   0.1397   0.1281   0.1427
## Detection Prevalence   0.2845   0.1935   0.1743   0.1639   0.1837
## Balanced Accuracy      0.8953   0.8572   0.8319   0.8741   0.9290
```
We can see that the accuracy of the prediction using the Boosting Classfier algorithm on the cross validation set is lower than the Random Forest algorithm.

Eventually I predict the class of the test set by applying the trained model to the test set:

```r
result2 <- predict(modelFit2,testingPC)
result2
```

```
##  [1] A A A A A E D B A A A C B A E A A B D B
## Levels: A B C D E
```
Compared to the Random Forest algorithm, the prediction on the test set using the Boosting Classfier algorithm is not as good.
