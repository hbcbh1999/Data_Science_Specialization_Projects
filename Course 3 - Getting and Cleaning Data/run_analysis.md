# Getting and Cleaning Smartphones Data Set for Human Activity Recognition
Yangang Chen  

## Introduction

One of the most exciting areas in all of data science right now is wearable computing - see for example this article:

http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for human activity recognition:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The purpose of this project is to collect, work with, and clean the data set. The goal is to prepare tidy data that can be used for later analysis.

### 'run_analysis.R' (or 'run_analysis.Rmd') performs the following:

* Download the data
* Read the training data: X_train.txt, y_train.txt, subject_train.txt
* Read the testing data: X_test.txt, y_test.txt, subject_test.txt
* Merge the two data together
* Rename the variable names in X_train.txt and X_test.txt, so that they are descriptive
* Rename the activity labels in y_train.txt and y_test.txt, so that they are descriptive
* Select the variables (columns) with means and standagrd derivation
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject
* Write the new data set into a txt file

### 'Data_Clean.txt' contains the following information:

* An identifier of the subject who carried out the experiment.
* A 66-feature vector with time and frequency domain variables. See codebook.md for more details. 
* Its activity label (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). 

### Features (Variables) in 'Data_Clean.txt'

* **tBodyAcc-XYZ:** \ time domain body acceleration signals in the X, Y and Z directions
* **tGravityAcc-XYZ:** \ time domain gravity acceleration signals in the X, Y and Z directions
* **tBodyAccJerk-XYZ:** \ time domain body acceleration Jerk signals in the X, Y and Z directions
* **tBodyGyro-XYZ:** \ time domain body gyroscope signals in the X, Y and Z directions
* **tBodyGyroJerk-XYZ:** \ time domain body gyroscope Jerk signals in the X, Y and Z directions
* **tBodyAccMag:** \ time domain body acceleration magnitude
* **tGravityAccMag:** \ time domain gravity acceleration magnitude
* **tBodyAccJerkMag:** \ time domain body acceleration Jerk magnitude
* **tBodyGyroMag:** \ time domain body gyroscope magnitude
* **tBodyGyroJerkMag:** \ time domain body gyroscope Jerk magnitude
* **fBodyAcc-XYZ:** \ freqency domain body acceleration signals in the X, Y and Z directions
* **fBodyAccJerk-XYZ:** \ freqency domain body acceleration Jerk signals in the X, Y and Z directions
* **fBodyGyro-XYZ:** \ freqency domain body gyroscope signals in the X, Y and Z directions
* **fBodyAccMag:** \ freqency domain body acceleration magnitude
* **fBodyAccJerkMag:** \ freqency domain body acceleration Jerk magnitude
* **fBodyGyroMag:** \ freqency domain body gyroscope magnitude
* **fBodyGyroJerkMag:** \ freqency domain body gyroscope Jerk magnitude
* **mean():** \ Mean value
* **std():** \ Standard deviation

## Step 1: Downloading the data

Here are the required libraries:


```r
library(knitr)
library(data.table)
```

I download the data from the following url as "Dataset.zip", and unzip it to a folder called "UCI HAR Dataset".

```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Dataset.zip")
unzip("Dataset.zip")
```

Inside this unzipped folder, there are several files for general information, such as "./README.txt". After reading them, I decide that the data in "./train/Inertial Signals" and "./test/Inertial Signals" are not going to be used for this project. To save spaces, I delete these files and keep only necessary files. Two files are important. One is "features.txt", which  specifies the name of each variables in "./train/X\_train.txt" and "./test/X\_test.txt".

```r
X_variable_names <- fread("./UCI HAR Dataset/features.txt")$V2
```
The other is "activity_labels.txt". It specifies the meaning of "1", "2", "3", "4", "5" and "6" in "./train/y\_train.txt" and "./test/y\_test.txt", which are "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING", respectively.

```r
y_activity_names <- fread("./UCI HAR Dataset/activity_labels.txt")
y_activity_names
```

```
##    V1                 V2
## 1:  1            WALKING
## 2:  2   WALKING_UPSTAIRS
## 3:  3 WALKING_DOWNSTAIRS
## 4:  4            SITTING
## 5:  5           STANDING
## 6:  6             LAYING
```

## Step 3: Processing the training set data

### Step 2.1: Processing "X\_train.txt"

There are three files to process. The first file is "X\_train.txt", which contains the feature data collected by smartphone devices. 

```r
X <- fread("./UCI HAR Dataset/train/X_train.txt")
```
I notice that the names of the variables in X are not descriptive.

```r
head(names(X))
```

```
## [1] "V1" "V2" "V3" "V4" "V5" "V6"
```
I use the following command to **replace the variable names by their corresponding descriptive names**, which have been stored in "X\_variable\_names".

```r
setnames(X, old=names(X), new=X_variable_names)
```
As a result, the names of the variables in X are descriptive.

```r
head(names(X))
```

```
## [1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"
## [4] "tBodyAcc-std()-X"  "tBodyAcc-std()-Y"  "tBodyAcc-std()-Z"
```

### Step 2.2: Processing "y\_train.txt"

The second file to process is "y\_train.txt", which contains the data that describe the activity of the participants, namely, "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING".

```r
y <- fread("./UCI HAR Dataset/train/y_train.txt")
setnames(y, old=names(y), new="Activity")
```
y is a vector of numbers "1", "2", "3", "4", "5" and "6".

```r
summary(y)
```

```
##     Activity    
##  Min.   :1.000  
##  1st Qu.:2.000  
##  Median :4.000  
##  Mean   :3.643  
##  3rd Qu.:5.000  
##  Max.   :6.000
```
**I convert them to their corresponding descriptive names, which are "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING"**.

```r
y$Activity <- factor(as.factor(y$Activity),levels=y_activity_names$V1,labels=y_activity_names$V2)
```
Now y is a vector of the factors "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING".

```r
summary(y)
```

```
##                Activity   
##  WALKING           :1226  
##  WALKING_UPSTAIRS  :1073  
##  WALKING_DOWNSTAIRS: 986  
##  SITTING           :1286  
##  STANDING          :1374  
##  LAYING            :1407
```

### Step 2.3: Processing "subject\_train.txt"

Now I read "subject\_train.txt", which contains the labels of the subjects (participants).

```r
sub <- fread("./UCI HAR Dataset/train/subject_train.txt")
setnames(sub, old=names(sub), new="Subject")
```

### Step 2.4: Merge the data

Now I merge the data that have been loaded from "X\_train.txt", "y\_train.txt" and "subject\_train.txt".

```r
data_train <- data.table(sub,X,y)
#data_train <- data.table(sub,source='train',Feature=X,y)
```

### Integrating Step 2.1-2.4 into a generic function "FullProcess"

Since the training and testing set data are processed in a similar fashion, I write a generic function "FullProcess" as follows:

```r
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
```

Now the processing of the training set data can be simply written as follows:

```r
data_train <- FullProcess ("./UCI HAR Dataset/train/X_train.txt",
                           "./UCI HAR Dataset/train/y_train.txt",
                           "./UCI HAR Dataset/train/subject_train.txt")
```

## Step 3: Processing the testing set data

In the similar vein, the testing set data is processed as follows:

```r
data_test <- FullProcess ("./UCI HAR Dataset/test/X_test.txt",
                          "./UCI HAR Dataset/test/y_test.txt",
                          "./UCI HAR Dataset/test/subject_test.txt")
```

## Step 4: Merging training and testing set data

I use "rbind" to merge training set data and testing set data vertically.

```r
data <- rbind(data_train,data_test) # vertical
```

## Step 5: Select the variables (columns) with means and standagrd derivation

I use "grepl" to select the variables (columns) with means and standagrd derivation, as follows:

```r
index <- names(data)=="Subject" | grepl("mean\\(\\)",names(data))|
    grepl("std\\(\\)",names(data)) | names(data)=="Activity"
data_select <- data[,index,with=FALSE]
```

## Step 6: Creates a second, independent tidy data set with the average of each variable for each activity and each subject

Next I creates a second, independent tidy data set with the average of each variable for each activity and each subject. The function "aggregate" can implement this. More specifically,

* It splits data_select into 180 groups distinguished by 30 subjects and 6 activities
* It applies the function "mean" on each variables (columns) of each group
* It aggregates the result together


```r
index <- names(data_select)!="Subject" & names(data_select)!="Activity"
data_summary <- aggregate(data_select[,index,with=FALSE],
                          list(data_select$Subject,data_select$Activity), mean)
```

I also rename some labels of the variables.

```r
setnames(data_summary,old=c("Group.1","Group.2"),new=c("Subject","Activity"))
```

Eventually, the data looks like the following:

```r
head(data_summary)
```

```
##   Subject Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
## 1       1  WALKING         0.2773308       -0.01738382        -0.1111481
## 2       2  WALKING         0.2764266       -0.01859492        -0.1055004
## 3       3  WALKING         0.2755675       -0.01717678        -0.1126749
## 4       4  WALKING         0.2785820       -0.01483995        -0.1114031
## 5       5  WALKING         0.2778423       -0.01728503        -0.1077418
## 6       6  WALKING         0.2836589       -0.01689542        -0.1103032
##   tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z tGravityAcc-mean()-X
## 1       -0.2837403       0.11446134       -0.2600279            0.9352232
## 2       -0.4236428      -0.07809125       -0.4252575            0.9130173
## 3       -0.3603567      -0.06991407       -0.3874120            0.9365067
## 4       -0.4408300      -0.07882674       -0.5862528            0.9639997
## 5       -0.2940985       0.07674840       -0.4570214            0.9726250
## 6       -0.2965387       0.16421388       -0.5043242            0.9580675
##   tGravityAcc-mean()-Y tGravityAcc-mean()-Z tGravityAcc-std()-X
## 1          -0.28216502         -0.068102864          -0.9766096
## 2          -0.34660709          0.084727087          -0.9726932
## 3          -0.26198636         -0.138107866          -0.9777716
## 4          -0.08585403          0.127764113          -0.9838265
## 5          -0.10044029          0.002476236          -0.9793484
## 6          -0.21469485          0.033188883          -0.9777799
##   tGravityAcc-std()-Y tGravityAcc-std()-Z tBodyAccJerk-mean()-X
## 1          -0.9713060          -0.9477172            0.07404163
## 2          -0.9721169          -0.9720728            0.06180807
## 3          -0.9623556          -0.9520918            0.08147459
## 4          -0.9679632          -0.9629681            0.07835291
## 5          -0.9615855          -0.9645808            0.08458888
## 6          -0.9642486          -0.9572050            0.06995859
##   tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z tBodyAccJerk-std()-X
## 1           0.028272110         -4.168406e-03           -0.1136156
## 2           0.018249268          7.895337e-03           -0.2775305
## 3           0.010059149         -5.622646e-03           -0.2686796
## 4           0.002956024         -7.676793e-04           -0.2970426
## 5          -0.016319410          8.321594e-05           -0.3028910
## 6          -0.016483172         -7.389312e-03           -0.1327848
##   tBodyAccJerk-std()-Y tBodyAccJerk-std()-Z tBodyGyro-mean()-X
## 1          0.067002501           -0.5026998        -0.04183096
## 2         -0.016602236           -0.5860904        -0.05302582
## 3         -0.044961959           -0.5294861        -0.02564052
## 4         -0.221165132           -0.7513914        -0.03179826
## 5         -0.091039743           -0.6128953        -0.04889199
## 6          0.008088974           -0.5757775        -0.02550962
##   tBodyGyro-mean()-Y tBodyGyro-mean()-Z tBodyGyro-std()-X
## 1        -0.06953005         0.08494482        -0.4735355
## 2        -0.04823823         0.08283366        -0.5615503
## 3        -0.07791509         0.08134859        -0.5718696
## 4        -0.07269053         0.08056772        -0.5009167
## 5        -0.06901352         0.08154355        -0.4908775
## 6        -0.07444625         0.08388088        -0.4460210
##   tBodyGyro-std()-Y tBodyGyro-std()-Z tBodyGyroJerk-mean()-X
## 1       -0.05460777        -0.3442666            -0.08999754
## 2       -0.53845367        -0.4810855            -0.08188334
## 3       -0.56379326        -0.4766964            -0.09523982
## 4       -0.66539409        -0.6626082            -0.11532156
## 5       -0.50462203        -0.3187006            -0.08884084
## 6       -0.33170227        -0.3831393            -0.08788911
##   tBodyGyroJerk-mean()-Y tBodyGyroJerk-mean()-Z tBodyGyroJerk-std()-X
## 1            -0.03984287            -0.04613093            -0.2074219
## 2            -0.05382994            -0.05149392            -0.3895498
## 3            -0.03878747            -0.05036161            -0.3859230
## 4            -0.03934745            -0.05511669            -0.4923411
## 5            -0.04495595            -0.04826796            -0.3576814
## 6            -0.03623090            -0.05395973            -0.1826009
##   tBodyGyroJerk-std()-Y tBodyGyroJerk-std()-Z tBodyAccMag-mean()
## 1            -0.3044685            -0.4042555         -0.1369712
## 2            -0.6341404            -0.4354927         -0.2904076
## 3            -0.6390880            -0.5366641         -0.2546903
## 4            -0.8074199            -0.6404541         -0.3120506
## 5            -0.5714381            -0.1576825         -0.1583387
## 6            -0.4163902            -0.1666844         -0.1668407
##   tBodyAccMag-std() tGravityAccMag-mean() tGravityAccMag-std()
## 1        -0.2196886            -0.1369712           -0.2196886
## 2        -0.4225442            -0.2904076           -0.4225442
## 3        -0.3284289            -0.2546903           -0.3284289
## 4        -0.5276791            -0.3120506           -0.5276791
## 5        -0.3771787            -0.1583387           -0.3771787
## 6        -0.2667342            -0.1668407           -0.2667342
##   tBodyAccJerkMag-mean() tBodyAccJerkMag-std() tBodyGyroMag-mean()
## 1             -0.1414288           -0.07447175          -0.1609796
## 2             -0.2814242           -0.16415099          -0.4465491
## 3             -0.2800093           -0.13991636          -0.4664118
## 4             -0.3667009           -0.31691896          -0.4977922
## 5             -0.2883330           -0.28224228          -0.3559331
## 6             -0.1951170           -0.07060296          -0.2812078
##   tBodyGyroMag-std() tBodyGyroJerkMag-mean() tBodyGyroJerkMag-std()
## 1         -0.1869784              -0.2987037             -0.3253249
## 2         -0.5530199              -0.5479120             -0.5577982
## 3         -0.5615107              -0.5661352             -0.5673716
## 4         -0.5531161              -0.6813040             -0.7301464
## 5         -0.4921768              -0.4445325             -0.4891997
## 6         -0.3656029              -0.3212905             -0.3647083
##   fBodyAcc-mean()-X fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAcc-std()-X
## 1        -0.2027943       0.089712726        -0.3315601       -0.3191347
## 2        -0.3460482      -0.021904810        -0.4538064       -0.4576514
## 3        -0.3166140      -0.081302435        -0.4123741       -0.3792768
## 4        -0.4267194      -0.149399633        -0.6310055       -0.4472349
## 5        -0.2877826       0.009460378        -0.4902511       -0.2975174
## 6        -0.1879343       0.140781622        -0.4985202       -0.3452277
##   fBodyAcc-std()-Y fBodyAcc-std()-Z fBodyAccJerk-mean()-X
## 1       0.05604001       -0.2796868            -0.1705470
## 2      -0.16921969       -0.4552221            -0.3046153
## 3      -0.12403083       -0.4229985            -0.3046944
## 4      -0.10179945       -0.5941983            -0.3588834
## 5       0.04260268       -0.4830600            -0.3449548
## 6       0.10169964       -0.5504746            -0.1509429
##   fBodyAccJerk-mean()-Y fBodyAccJerk-mean()-Z fBodyAccJerk-std()-X
## 1           -0.03522552            -0.4689992           -0.1335866
## 2           -0.07876408            -0.5549567           -0.3143131
## 3           -0.14050859            -0.5141373           -0.2965966
## 4           -0.27955339            -0.7289916           -0.2973261
## 5           -0.18105555            -0.5904966           -0.3213903
## 6           -0.07537423            -0.5414386           -0.1926947
##   fBodyAccJerk-std()-Y fBodyAccJerk-std()-Z fBodyGyro-mean()-X
## 1          0.106739857           -0.5347134         -0.3390322
## 2         -0.015332952           -0.6158982         -0.4297135
## 3         -0.005614988           -0.5435291         -0.4378458
## 4         -0.209900006           -0.7723591         -0.3733845
## 5         -0.054521360           -0.6334300         -0.3726687
## 6          0.031445068           -0.6086244         -0.2396507
##   fBodyGyro-mean()-Y fBodyGyro-mean()-Z fBodyGyro-std()-X
## 1         -0.1030594         -0.2559409        -0.5166919
## 2         -0.5547721         -0.3966599        -0.6040530
## 3         -0.5615263         -0.4181262        -0.6151214
## 4         -0.6884601         -0.6013811        -0.5426468
## 5         -0.5139517         -0.2131270        -0.5293928
## 6         -0.3413784         -0.2035755        -0.5153239
##   fBodyGyro-std()-Y fBodyGyro-std()-Z fBodyAccMag-mean() fBodyAccMag-std()
## 1       -0.03350816        -0.4365622         -0.1286235        -0.3980326
## 2       -0.53304695        -0.5598566         -0.3242894        -0.5771052
## 3       -0.56888867        -0.5458964         -0.2900315        -0.4563731
## 4       -0.65465777        -0.7164585         -0.4508046        -0.6511726
## 5       -0.50268338        -0.4203671         -0.3049925        -0.5196369
## 6       -0.33200871        -0.5122092         -0.2013866        -0.4216831
##   fBodyBodyAccJerkMag-mean() fBodyBodyAccJerkMag-std()
## 1                -0.05711940               -0.10349240
## 2                -0.16906435               -0.16409197
## 3                -0.18676452               -0.08985199
## 4                -0.31858781               -0.32045870
## 5                -0.26948166               -0.30568538
## 6                -0.05540142               -0.09649997
##   fBodyBodyGyroMag-mean() fBodyBodyGyroMag-std()
## 1              -0.1992526             -0.3210180
## 2              -0.5307048             -0.6517928
## 3              -0.5697558             -0.6326433
## 4              -0.6092856             -0.5939372
## 5              -0.4842628             -0.5897415
## 6              -0.3296811             -0.5106483
##   fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std()
## 1                  -0.3193086                 -0.3816019
## 2                  -0.5832493                 -0.5581046
## 3                  -0.6077516                 -0.5490870
## 4                  -0.7243274                 -0.7577681
## 5                  -0.5480536                 -0.4556653
## 6                  -0.3665005                 -0.4080789
```

```r
#tail(data_summary)
```

## Step 7: Write the new data set into a txt file


```r
write.table(data_summary, "./Data_Clean.txt", sep="\t", row.name=FALSE)
```
