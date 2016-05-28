---
title: "CodeBook"
author: "Mohit Kumar"
date: "May 28, 2016"
output: html_document
---



#### Data for the project was downloaded from the site:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

#### Data was obtained from the site: 
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The run_analysis.R script performs the following task to clean the data:

**Step 1:** Read X_train.txt, Y_train.txt and subject_train.txt from the "./data/train" folder and store them in train, train_activities and train_subjects variables respectively.
Read X_test.txt, Y_test.txt and subject_test.txt from the "./data/test" folder and store them in test, test_activities and test_subjects variables respectively.
*Few rows and columns of the loaded datasets are shown here.*

```r
head(train[,1:5])
```

```
##   V1 V1.1      V1.2          V2         V3
## 1  1    5 0.2885845 -0.02029417 -0.1329051
## 2  1    5 0.2784188 -0.01641057 -0.1235202
## 3  1    5 0.2796531 -0.01946716 -0.1134617
## 4  1    5 0.2791739 -0.02620065 -0.1232826
## 5  1    5 0.2766288 -0.01656965 -0.1153619
## 6  1    5 0.2771988 -0.01009785 -0.1051373
```

```r
head(train_activities)
```

```
##   V1
## 1  5
## 2  5
## 3  5
## 4  5
## 5  5
## 6  5
```

```r
head(train_subjects)
```

```
##   V1
## 1  1
## 2  1
## 3  1
## 4  1
## 5  1
## 6  1
```

```r
head(test[,1:5])
```

```
##   V1 V1.1      V1.2          V2          V3
## 1  2    5 0.2571778 -0.02328523 -0.01465376
## 2  2    5 0.2860267 -0.01316336 -0.11908252
## 3  2    5 0.2754848 -0.02605042 -0.11815167
## 4  2    5 0.2702982 -0.03261387 -0.11752018
## 5  2    5 0.2748330 -0.02784779 -0.12952716
## 6  2    5 0.2792199 -0.01862040 -0.11390197
```

```r
head(test_activities)
```

```
##   V1
## 1  5
## 2  5
## 3  5
## 4  5
## 5  5
## 6  5
```

```r
head(test_subjects)
```

```
##   V1
## 1  2
## 2  2
## 3  2
## 4  2
## 5  2
## 6  2
```
**Step 2:** Merge the test to train sets to generate  data frame, merge_train_test.

```r
merge_train_test <- rbind(train, test)
head(merge_train_test[,1:5])
```

```
##   V1 V1.1      V1.2          V2         V3
## 1  1    5 0.2885845 -0.02029417 -0.1329051
## 2  1    5 0.2784188 -0.01641057 -0.1235202
## 3  1    5 0.2796531 -0.01946716 -0.1134617
## 4  1    5 0.2791739 -0.02620065 -0.1232826
## 5  1    5 0.2766288 -0.01656965 -0.1153619
## 6  1    5 0.2771988 -0.01009785 -0.1051373
```

**Step 3:** Read the features.txt and extracts only the measurements on the mean and standard deviation for each measurement and store it in the variable required_features .Clean the column names of the subset. We remove the "()" symbol in the names, as well as substitute "-mean", "-std","t" and "f" with "Mean", "Standard", "Time" and "Freq" respectively.

```r
head(required_features)
```

```
## [1] 1 2 3 4 5 6
```

```r
head(required_features_names)
```

```
## [1] "TimeBodyAccmeanX" "TimeBodyAccmeanY" "TimeBodyAccmeanZ"
## [4] "TimeBodyAccstdX"  "TimeBodyAccstdY"  "TimeBodyAccstdZ"
```

**Step 4:** Read the activity_labels.txt and apply descriptive activity names to name the activities in the dataset:
"walking" "walkin_gupstairs" "walking_downstairs" "sitting" "standing" "laying"

Also appropriate labels to the data set with descriptive variable names is applied.

```r
colnames(merge_train_test) <- c("subject", "activity", required_features_names)
merge_train_test$activity <- factor(merge_train_test$activity, levels = activity_labels[,1], labels = activity_labels[,2])
merge_train_test$subject <- as.factor(merge_train_test$subject)
```

**Step 5:** Create a second independent tidy data set with the average of each measurement for each activity and each subject. The result is saved as merge_train_test.melted, where as before, the first column contains subject IDs, the second column contains activity names, and then the averages, stored in merge_train_test.mean. There are 30 subjects and 6 activities, thus 180 rows in this data set with averages.

```r
merge_train_test.melted <- melt(merge_train_test, id = c("subject", "activity"))
merge_train_test.mean <- dcast(merge_train_test.melted, subject + activity ~ variable, mean)
head(merge_train_test.mean[,1:4])
```

```
##   subject           activity TimeBodyAccmeanX TimeBodyAccmeanY
## 1       1            WALKING        0.2773308     -0.017383819
## 2       1   WALKING_UPSTAIRS        0.2554617     -0.023953149
## 3       1 WALKING_DOWNSTAIRS        0.2891883     -0.009918505
## 4       1            SITTING        0.2612376     -0.001308288
## 5       1           STANDING        0.2789176     -0.016137590
## 6       1             LAYING        0.2215982     -0.040513953
```

**Step 6:** Write the result out to "ActivityRecognitionUsingSmartphones.txt" file in current working directory.

```r
write.table(merge_train_test.mean, "ActivityRecognitionUsingSmartphones.txt", row.names = FALSE, quote = FALSE)
```

#Structure of the Tidy dataset

```
## 'data.frame':	180 obs. of  81 variables:
##  $ subject                        : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 2 2 2 2 ...
##  $ activity                       : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...
##  $ TimeBodyAccmeanX               : num  0.277 0.255 0.289 0.261 0.279 ...
##  $ TimeBodyAccmeanY               : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
##  $ TimeBodyAccmeanZ               : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
##  $ TimeBodyAccstdX                : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
##  $ TimeBodyAccstdY                : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
##  $ TimeBodyAccstdZ                : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
##  $ TimeGravityAccmeanX            : num  0.935 0.893 0.932 0.832 0.943 ...
##  $ TimeGravityAccmeanY            : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
##  $ TimeGravityAccmeanZ            : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
##  $ TimeGravityAccstdX             : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
##  $ TimeGravityAccstdY             : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
##  $ TimeGravityAccstdZ             : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
##  $ TimeBodyAccJerkmeanX           : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
##  $ TimeBodyAccJerkmeanY           : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
##  $ TimeBodyAccJerkmeanZ           : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
##  $ TimeBodyAccJerkstdX            : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
##  $ TimeBodyAccJerkstdY            : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
##  $ TimeBodyAccJerkstdZ            : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
##  $ TimeBodyGyromeanX              : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
##  $ TimeBodyGyromeanY              : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
##  $ TimeBodyGyromeanZ              : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
##  $ TimeBodyGyrostdX               : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
##  $ TimeBodyGyrostdY               : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
##  $ TimeBodyGyrostdZ               : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
##  $ TimeBodyGyroJerkmeanX          : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
##  $ TimeBodyGyroJerkmeanY          : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
##  $ TimeBodyGyroJerkmeanZ          : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
##  $ TimeBodyGyroJerkstdX           : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
##  $ TimeBodyGyroJerkstdY           : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
##  $ TimeBodyGyroJerkstdZ           : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
##  $ TimeBodyAccMagmean             : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
##  $ TimeBodyAccMagstd              : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
##  $ TimeGravityAccMagmean          : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
##  $ TimeGravityAccMagstd           : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
##  $ TimeBodyAccJerkMagmean         : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
##  $ TimeBodyAccJerkMagstd          : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
##  $ TimeBodyGyroMagmean            : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
##  $ TimeBodyGyroMagstd             : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
##  $ TimeBodyGyroJerkMagmean        : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
##  $ TimeBodyGyroJerkMagstd         : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
##  $ FreqBodyAccmeanX               : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
##  $ FreqBodyAccmeanY               : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
##  $ FreqBodyAccmeanZ               : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
##  $ FreqBodyAccstdX                : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
##  $ FreqBodyAccstdY                : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
##  $ FreqBodyAccstdZ                : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
##  $ FreqBodyAccmeanFreqX           : num  -0.2075 -0.4187 -0.3074 -0.0495 0.0865 ...
##  $ FreqBodyAccmeanFreqY           : num  0.1131 -0.1607 0.0632 0.0759 0.1175 ...
##  $ FreqBodyAccmeanFreqZ           : num  0.0497 -0.5201 0.2943 0.2388 0.2449 ...
##  $ FreqBodyAccJerkmeanX           : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
##  $ FreqBodyAccJerkmeanY           : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
##  $ FreqBodyAccJerkmeanZ           : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
##  $ FreqBodyAccJerkstdX            : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
##  $ FreqBodyAccJerkstdY            : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
##  $ FreqBodyAccJerkstdZ            : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
##  $ FreqBodyAccJerkmeanFreqX       : num  -0.209 -0.377 -0.253 0.257 0.314 ...
##  $ FreqBodyAccJerkmeanFreqY       : num  -0.3862 -0.5095 -0.3376 0.0475 0.0392 ...
##  $ FreqBodyAccJerkmeanFreqZ       : num  -0.18553 -0.5511 0.00937 0.09239 0.13858 ...
##  $ FreqBodyGyromeanX              : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
##  $ FreqBodyGyromeanY              : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
##  $ FreqBodyGyromeanZ              : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
##  $ FreqBodyGyrostdX               : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
##  $ FreqBodyGyrostdY               : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
##  $ FreqBodyGyrostdZ               : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
##  $ FreqBodyGyromeanFreqX          : num  0.0148 -0.1875 -0.1005 0.1892 -0.1203 ...
##  $ FreqBodyGyromeanFreqY          : num  -0.0658 -0.4736 0.0826 0.0631 -0.0447 ...
##  $ FreqBodyGyromeanFreqZ          : num  0.000773 -0.133374 -0.075676 -0.029784 0.100608 ...
##  $ FreqBodyAccMagmean             : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
##  $ FreqBodyAccMagstd              : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
##  $ FreqBodyAccMagmeanFreq         : num  0.1906 -0.0977 0.1192 0.2367 0.2846 ...
##  $ FreqBodyBodyAccJerkMagmean     : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
##  $ FreqBodyBodyAccJerkMagstd      : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
##  $ FreqBodyBodyAccJerkMagmeanFreq : num  0.0938 0.0854 0.0765 0.3519 0.4222 ...
##  $ FreqBodyBodyGyroMagmean        : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
##  $ FreqBodyBodyGyroMagstd         : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
##  $ FreqBodyBodyGyroMagmeanFreq    : num  0.268844 -0.219303 0.349614 -0.000262 -0.028606 ...
##  $ FreqBodyBodyGyroJerkMagmean    : num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
##  $ FreqBodyBodyGyroJerkMagstd     : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
##  $ FreqBodyBodyGyroJerkMagmeanFreq: num  0.191 0.114 0.19 0.185 0.334 ...
```

#Summary of the Tidy dataset

```
##     subject                  activity  TimeBodyAccmeanX
##  1      :  6   WALKING           :30   Min.   :0.2216  
##  2      :  6   WALKING_UPSTAIRS  :30   1st Qu.:0.2712  
##  3      :  6   WALKING_DOWNSTAIRS:30   Median :0.2770  
##  4      :  6   SITTING           :30   Mean   :0.2743  
##  5      :  6   STANDING          :30   3rd Qu.:0.2800  
##  6      :  6   LAYING            :30   Max.   :0.3015  
##  (Other):144                                           
##  TimeBodyAccmeanY    TimeBodyAccmeanZ   TimeBodyAccstdX  
##  Min.   :-0.040514   Min.   :-0.15251   Min.   :-0.9961  
##  1st Qu.:-0.020022   1st Qu.:-0.11207   1st Qu.:-0.9799  
##  Median :-0.017262   Median :-0.10819   Median :-0.7526  
##  Mean   :-0.017876   Mean   :-0.10916   Mean   :-0.5577  
##  3rd Qu.:-0.014936   3rd Qu.:-0.10443   3rd Qu.:-0.1984  
##  Max.   :-0.001308   Max.   :-0.07538   Max.   : 0.6269  
##                                                          
##  TimeBodyAccstdY    TimeBodyAccstdZ   TimeGravityAccmeanX
##  Min.   :-0.99024   Min.   :-0.9877   Min.   :-0.6800    
##  1st Qu.:-0.94205   1st Qu.:-0.9498   1st Qu.: 0.8376    
##  Median :-0.50897   Median :-0.6518   Median : 0.9208    
##  Mean   :-0.46046   Mean   :-0.5756   Mean   : 0.6975    
##  3rd Qu.:-0.03077   3rd Qu.:-0.2306   3rd Qu.: 0.9425    
##  Max.   : 0.61694   Max.   : 0.6090   Max.   : 0.9745    
##                                                          
##  TimeGravityAccmeanY TimeGravityAccmeanZ TimeGravityAccstdX
##  Min.   :-0.47989    Min.   :-0.49509    Min.   :-0.9968   
##  1st Qu.:-0.23319    1st Qu.:-0.11726    1st Qu.:-0.9825   
##  Median :-0.12782    Median : 0.02384    Median :-0.9695   
##  Mean   :-0.01621    Mean   : 0.07413    Mean   :-0.9638   
##  3rd Qu.: 0.08773    3rd Qu.: 0.14946    3rd Qu.:-0.9509   
##  Max.   : 0.95659    Max.   : 0.95787    Max.   :-0.8296   
##                                                            
##  TimeGravityAccstdY TimeGravityAccstdZ TimeBodyAccJerkmeanX
##  Min.   :-0.9942    Min.   :-0.9910    Min.   :0.04269     
##  1st Qu.:-0.9711    1st Qu.:-0.9605    1st Qu.:0.07396     
##  Median :-0.9590    Median :-0.9450    Median :0.07640     
##  Mean   :-0.9524    Mean   :-0.9364    Mean   :0.07947     
##  3rd Qu.:-0.9370    3rd Qu.:-0.9180    3rd Qu.:0.08330     
##  Max.   :-0.6436    Max.   :-0.6102    Max.   :0.13019     
##                                                            
##  TimeBodyAccJerkmeanY TimeBodyAccJerkmeanZ TimeBodyAccJerkstdX
##  Min.   :-0.0386872   Min.   :-0.067458    Min.   :-0.9946    
##  1st Qu.: 0.0004664   1st Qu.:-0.010601    1st Qu.:-0.9832    
##  Median : 0.0094698   Median :-0.003861    Median :-0.8104    
##  Mean   : 0.0075652   Mean   :-0.004953    Mean   :-0.5949    
##  3rd Qu.: 0.0134008   3rd Qu.: 0.001958    3rd Qu.:-0.2233    
##  Max.   : 0.0568186   Max.   : 0.038053    Max.   : 0.5443    
##                                                               
##  TimeBodyAccJerkstdY TimeBodyAccJerkstdZ TimeBodyGyromeanX 
##  Min.   :-0.9895     Min.   :-0.99329    Min.   :-0.20578  
##  1st Qu.:-0.9724     1st Qu.:-0.98266    1st Qu.:-0.04712  
##  Median :-0.7756     Median :-0.88366    Median :-0.02871  
##  Mean   :-0.5654     Mean   :-0.73596    Mean   :-0.03244  
##  3rd Qu.:-0.1483     3rd Qu.:-0.51212    3rd Qu.:-0.01676  
##  Max.   : 0.3553     Max.   : 0.03102    Max.   : 0.19270  
##                                                            
##  TimeBodyGyromeanY  TimeBodyGyromeanZ  TimeBodyGyrostdX  TimeBodyGyrostdY 
##  Min.   :-0.20421   Min.   :-0.07245   Min.   :-0.9943   Min.   :-0.9942  
##  1st Qu.:-0.08955   1st Qu.: 0.07475   1st Qu.:-0.9735   1st Qu.:-0.9629  
##  Median :-0.07318   Median : 0.08512   Median :-0.7890   Median :-0.8017  
##  Mean   :-0.07426   Mean   : 0.08744   Mean   :-0.6916   Mean   :-0.6533  
##  3rd Qu.:-0.06113   3rd Qu.: 0.10177   3rd Qu.:-0.4414   3rd Qu.:-0.4196  
##  Max.   : 0.02747   Max.   : 0.17910   Max.   : 0.2677   Max.   : 0.4765  
##                                                                           
##  TimeBodyGyrostdZ  TimeBodyGyroJerkmeanX TimeBodyGyroJerkmeanY
##  Min.   :-0.9855   Min.   :-0.15721      Min.   :-0.07681     
##  1st Qu.:-0.9609   1st Qu.:-0.10322      1st Qu.:-0.04552     
##  Median :-0.8010   Median :-0.09868      Median :-0.04112     
##  Mean   :-0.6164   Mean   :-0.09606      Mean   :-0.04269     
##  3rd Qu.:-0.3106   3rd Qu.:-0.09110      3rd Qu.:-0.03842     
##  Max.   : 0.5649   Max.   :-0.02209      Max.   :-0.01320     
##                                                               
##  TimeBodyGyroJerkmeanZ TimeBodyGyroJerkstdX TimeBodyGyroJerkstdY
##  Min.   :-0.092500     Min.   :-0.9965      Min.   :-0.9971     
##  1st Qu.:-0.061725     1st Qu.:-0.9800      1st Qu.:-0.9832     
##  Median :-0.053430     Median :-0.8396      Median :-0.8942     
##  Mean   :-0.054802     Mean   :-0.7036      Mean   :-0.7636     
##  3rd Qu.:-0.048985     3rd Qu.:-0.4629      3rd Qu.:-0.5861     
##  Max.   :-0.006941     Max.   : 0.1791      Max.   : 0.2959     
##                                                                 
##  TimeBodyGyroJerkstdZ TimeBodyAccMagmean TimeBodyAccMagstd
##  Min.   :-0.9954      Min.   :-0.9865    Min.   :-0.9865  
##  1st Qu.:-0.9848      1st Qu.:-0.9573    1st Qu.:-0.9430  
##  Median :-0.8610      Median :-0.4829    Median :-0.6074  
##  Mean   :-0.7096      Mean   :-0.4973    Mean   :-0.5439  
##  3rd Qu.:-0.4741      3rd Qu.:-0.0919    3rd Qu.:-0.2090  
##  Max.   : 0.1932      Max.   : 0.6446    Max.   : 0.4284  
##                                                           
##  TimeGravityAccMagmean TimeGravityAccMagstd TimeBodyAccJerkMagmean
##  Min.   :-0.9865       Min.   :-0.9865      Min.   :-0.9928       
##  1st Qu.:-0.9573       1st Qu.:-0.9430      1st Qu.:-0.9807       
##  Median :-0.4829       Median :-0.6074      Median :-0.8168       
##  Mean   :-0.4973       Mean   :-0.5439      Mean   :-0.6079       
##  3rd Qu.:-0.0919       3rd Qu.:-0.2090      3rd Qu.:-0.2456       
##  Max.   : 0.6446       Max.   : 0.4284      Max.   : 0.4345       
##                                                                   
##  TimeBodyAccJerkMagstd TimeBodyGyroMagmean TimeBodyGyroMagstd
##  Min.   :-0.9946       Min.   :-0.9807     Min.   :-0.9814   
##  1st Qu.:-0.9765       1st Qu.:-0.9461     1st Qu.:-0.9476   
##  Median :-0.8014       Median :-0.6551     Median :-0.7420   
##  Mean   :-0.5842       Mean   :-0.5652     Mean   :-0.6304   
##  3rd Qu.:-0.2173       3rd Qu.:-0.2159     3rd Qu.:-0.3602   
##  Max.   : 0.4506       Max.   : 0.4180     Max.   : 0.3000   
##                                                              
##  TimeBodyGyroJerkMagmean TimeBodyGyroJerkMagstd FreqBodyAccmeanX 
##  Min.   :-0.99732        Min.   :-0.9977        Min.   :-0.9952  
##  1st Qu.:-0.98515        1st Qu.:-0.9805        1st Qu.:-0.9787  
##  Median :-0.86479        Median :-0.8809        Median :-0.7691  
##  Mean   :-0.73637        Mean   :-0.7550        Mean   :-0.5758  
##  3rd Qu.:-0.51186        3rd Qu.:-0.5767        3rd Qu.:-0.2174  
##  Max.   : 0.08758        Max.   : 0.2502        Max.   : 0.5370  
##                                                                  
##  FreqBodyAccmeanY   FreqBodyAccmeanZ  FreqBodyAccstdX   FreqBodyAccstdY   
##  Min.   :-0.98903   Min.   :-0.9895   Min.   :-0.9966   Min.   :-0.99068  
##  1st Qu.:-0.95361   1st Qu.:-0.9619   1st Qu.:-0.9820   1st Qu.:-0.94042  
##  Median :-0.59498   Median :-0.7236   Median :-0.7470   Median :-0.51338  
##  Mean   :-0.48873   Mean   :-0.6297   Mean   :-0.5522   Mean   :-0.48148  
##  3rd Qu.:-0.06341   3rd Qu.:-0.3183   3rd Qu.:-0.1966   3rd Qu.:-0.07913  
##  Max.   : 0.52419   Max.   : 0.2807   Max.   : 0.6585   Max.   : 0.56019  
##                                                                           
##  FreqBodyAccstdZ   FreqBodyAccmeanFreqX FreqBodyAccmeanFreqY
##  Min.   :-0.9872   Min.   :-0.63591     Min.   :-0.379518   
##  1st Qu.:-0.9459   1st Qu.:-0.39165     1st Qu.:-0.081314   
##  Median :-0.6441   Median :-0.25731     Median : 0.007855   
##  Mean   :-0.5824   Mean   :-0.23227     Mean   : 0.011529   
##  3rd Qu.:-0.2655   3rd Qu.:-0.06105     3rd Qu.: 0.086281   
##  Max.   : 0.6871   Max.   : 0.15912     Max.   : 0.466528   
##                                                             
##  FreqBodyAccmeanFreqZ FreqBodyAccJerkmeanX FreqBodyAccJerkmeanY
##  Min.   :-0.52011     Min.   :-0.9946      Min.   :-0.9894     
##  1st Qu.:-0.03629     1st Qu.:-0.9828      1st Qu.:-0.9725     
##  Median : 0.06582     Median :-0.8126      Median :-0.7817     
##  Mean   : 0.04372     Mean   :-0.6139      Mean   :-0.5882     
##  3rd Qu.: 0.17542     3rd Qu.:-0.2820      3rd Qu.:-0.1963     
##  Max.   : 0.40253     Max.   : 0.4743      Max.   : 0.2767     
##                                                                
##  FreqBodyAccJerkmeanZ FreqBodyAccJerkstdX FreqBodyAccJerkstdY
##  Min.   :-0.9920      Min.   :-0.9951     Min.   :-0.9905    
##  1st Qu.:-0.9796      1st Qu.:-0.9847     1st Qu.:-0.9737    
##  Median :-0.8707      Median :-0.8254     Median :-0.7852    
##  Mean   :-0.7144      Mean   :-0.6121     Mean   :-0.5707    
##  3rd Qu.:-0.4697      3rd Qu.:-0.2475     3rd Qu.:-0.1685    
##  Max.   : 0.1578      Max.   : 0.4768     Max.   : 0.3498    
##                                                              
##  FreqBodyAccJerkstdZ FreqBodyAccJerkmeanFreqX FreqBodyAccJerkmeanFreqY
##  Min.   :-0.993108   Min.   :-0.57604         Min.   :-0.60197        
##  1st Qu.:-0.983747   1st Qu.:-0.28966         1st Qu.:-0.39751        
##  Median :-0.895121   Median :-0.06091         Median :-0.23209        
##  Mean   :-0.756489   Mean   :-0.06910         Mean   :-0.22810        
##  3rd Qu.:-0.543787   3rd Qu.: 0.17660         3rd Qu.:-0.04721        
##  Max.   :-0.006236   Max.   : 0.33145         Max.   : 0.19568        
##                                                                       
##  FreqBodyAccJerkmeanFreqZ FreqBodyGyromeanX FreqBodyGyromeanY
##  Min.   :-0.62756         Min.   :-0.9931   Min.   :-0.9940  
##  1st Qu.:-0.30867         1st Qu.:-0.9697   1st Qu.:-0.9700  
##  Median :-0.09187         Median :-0.7300   Median :-0.8141  
##  Mean   :-0.13760         Mean   :-0.6367   Mean   :-0.6767  
##  3rd Qu.: 0.03858         3rd Qu.:-0.3387   3rd Qu.:-0.4458  
##  Max.   : 0.23011         Max.   : 0.4750   Max.   : 0.3288  
##                                                              
##  FreqBodyGyromeanZ FreqBodyGyrostdX  FreqBodyGyrostdY  FreqBodyGyrostdZ 
##  Min.   :-0.9860   Min.   :-0.9947   Min.   :-0.9944   Min.   :-0.9867  
##  1st Qu.:-0.9624   1st Qu.:-0.9750   1st Qu.:-0.9602   1st Qu.:-0.9643  
##  Median :-0.7909   Median :-0.8086   Median :-0.7964   Median :-0.8224  
##  Mean   :-0.6044   Mean   :-0.7110   Mean   :-0.6454   Mean   :-0.6577  
##  3rd Qu.:-0.2635   3rd Qu.:-0.4813   3rd Qu.:-0.4154   3rd Qu.:-0.3916  
##  Max.   : 0.4924   Max.   : 0.1966   Max.   : 0.6462   Max.   : 0.5225  
##                                                                         
##  FreqBodyGyromeanFreqX FreqBodyGyromeanFreqY FreqBodyGyromeanFreqZ
##  Min.   :-0.395770     Min.   :-0.66681      Min.   :-0.50749     
##  1st Qu.:-0.213363     1st Qu.:-0.29433      1st Qu.:-0.15481     
##  Median :-0.115527     Median :-0.15794      Median :-0.05081     
##  Mean   :-0.104551     Mean   :-0.16741      Mean   :-0.05718     
##  3rd Qu.: 0.002655     3rd Qu.:-0.04269      3rd Qu.: 0.04152     
##  Max.   : 0.249209     Max.   : 0.27314      Max.   : 0.37707     
##                                                                   
##  FreqBodyAccMagmean FreqBodyAccMagstd FreqBodyAccMagmeanFreq
##  Min.   :-0.9868    Min.   :-0.9876   Min.   :-0.31234      
##  1st Qu.:-0.9560    1st Qu.:-0.9452   1st Qu.:-0.01475      
##  Median :-0.6703    Median :-0.6513   Median : 0.08132      
##  Mean   :-0.5365    Mean   :-0.6210   Mean   : 0.07613      
##  3rd Qu.:-0.1622    3rd Qu.:-0.3654   3rd Qu.: 0.17436      
##  Max.   : 0.5866    Max.   : 0.1787   Max.   : 0.43585      
##                                                             
##  FreqBodyBodyAccJerkMagmean FreqBodyBodyAccJerkMagstd
##  Min.   :-0.9940            Min.   :-0.9944          
##  1st Qu.:-0.9770            1st Qu.:-0.9752          
##  Median :-0.7940            Median :-0.8126          
##  Mean   :-0.5756            Mean   :-0.5992          
##  3rd Qu.:-0.1872            3rd Qu.:-0.2668          
##  Max.   : 0.5384            Max.   : 0.3163          
##                                                      
##  FreqBodyBodyAccJerkMagmeanFreq FreqBodyBodyGyroMagmean
##  Min.   :-0.12521               Min.   :-0.9865        
##  1st Qu.: 0.04527               1st Qu.:-0.9616        
##  Median : 0.17198               Median :-0.7657        
##  Mean   : 0.16255               Mean   :-0.6671        
##  3rd Qu.: 0.27593               3rd Qu.:-0.4087        
##  Max.   : 0.48809               Max.   : 0.2040        
##                                                        
##  FreqBodyBodyGyroMagstd FreqBodyBodyGyroMagmeanFreq
##  Min.   :-0.9815        Min.   :-0.45664           
##  1st Qu.:-0.9488        1st Qu.:-0.16951           
##  Median :-0.7727        Median :-0.05352           
##  Mean   :-0.6723        Mean   :-0.03603           
##  3rd Qu.:-0.4277        3rd Qu.: 0.08228           
##  Max.   : 0.2367        Max.   : 0.40952           
##                                                    
##  FreqBodyBodyGyroJerkMagmean FreqBodyBodyGyroJerkMagstd
##  Min.   :-0.9976             Min.   :-0.9976           
##  1st Qu.:-0.9813             1st Qu.:-0.9802           
##  Median :-0.8779             Median :-0.8941           
##  Mean   :-0.7564             Mean   :-0.7715           
##  3rd Qu.:-0.5831             3rd Qu.:-0.6081           
##  Max.   : 0.1466             Max.   : 0.2878           
##                                                        
##  FreqBodyBodyGyroJerkMagmeanFreq
##  Min.   :-0.18292               
##  1st Qu.: 0.05423               
##  Median : 0.11156               
##  Mean   : 0.12592               
##  3rd Qu.: 0.20805               
##  Max.   : 0.42630               
## 
```
