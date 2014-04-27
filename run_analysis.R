############################################################################################################ 
# 
# Part 1: creating a tidy data set which merged training and test data, and contains only means and std's.
# 
##############################################################################################################

#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, "HAR.zip")

#unzip the file to local computer

setwd("C:/Minqiang/CourseRA/Getting_and_Cleaning_Data_Leek//Week_3/UCI HAR Dataset/")

# features has length 561
features.frame <- read.csv("features.txt", sep="", header=F)
features <- data.frame(features.frame$V2)
names(features) <- "feature"
head(features); tail(features)
# feature
# 1 tBodyAcc-mean()-X
# 2 tBodyAcc-mean()-Y
# 3 tBodyAcc-mean()-Z
# 4  tBodyAcc-std()-X
# 5  tBodyAcc-std()-Y
# 6  tBodyAcc-std()-Z
# feature
# 556 angle(tBodyAccJerkMean),gravityMean)
# 557     angle(tBodyGyroMean,gravityMean)
# 558 angle(tBodyGyroJerkMean,gravityMean)
# 559                 angle(X,gravityMean)
# 560                 angle(Y,gravityMean)
# 561                 angle(Z,gravityMean)

# activities has length 6:
(activities.frame <- read.csv("activity_labels.txt", header=F, sep=""))
activities <- data.frame(activities.frame$V2)
names(activities) <- "activity"
head(activities)
# activity
# 1            WALKING
# 2   WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4            SITTING
# 5           STANDING
# 6             LAYING

# X_test is the raw data with 2947 observations. The columns are the features,
# indexed by the vector features.
X_test <- read.csv("test/X_test.txt", header=F, sep="")
dim(X_test)
# [1] 2947  561
#
# y is a vector of length 2947, corresponding to the rows in X_test
# y is the activitives index, taking values in the variable activities.
y_test <- read.csv("test/y_test.txt", header=F, sep="")
#
# subject_test is a vector of length 2947, corresponding to the rows in X_test
# subject_test indexes the subjects taking the tests
subject_test <- read.csv("test/subject_test.txt", header=F, sep="")

# We load similarly the training data set below
X_train <- read.csv("train/X_train.txt", header=F, sep="")
y_train <- read.csv("train/y_train.txt", header=F, sep="")
subject_train <- read.csv("train/subject_train.txt", header=F, sep="")

# We now vertically merge the two data sets. We need to merge three variables:
# X, y, and subject
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)



# it is convenient to combine all three data frames into just one
all.data <- data.frame(subject, y, X)
# we also need to assign descriptive names to all.data
names(all.data) <- c("subject", "activity", as.character(features$feature))

# we now take a look at the columns with mean() and std() in the names
grep("mean\\(\\)|std\\(\\)", features$feature, value=T)
# [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"           "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
# [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
# [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
# [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
# [17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
# [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"           "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
# [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
# [29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
# [33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
# [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
# [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"           "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
# [45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
# [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
# [53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
# [57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
# [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
# [65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"  
(indices <- grep("mean\\(\\)|std\\(\\)", features$feature))
# [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85  86 121 122 123 124 125 126 161 162 163 164 165 166 201 202 214 215 227 228
# [37] 240 241 253 254 266 267 268 269 270 271 345 346 347 348 349 350 424 425 426 427 428 429 503 504 516 517 529 530 542 543
# length(indices)
# [1] 66

# We now take a subset of all.data according to the indices. Notice we 
# have added y and subject to all.data, so indices are shifted by 2
tidy.data <- all.data[ , c(1,2, indices+2)]
#
# we now change the activity labels from numeric to descriptive names
tidy.data$activity <- factor(tidy.data$activity, labels=activities$activity)
#
# We can take a look at sub.data. Notice that the row names and column names are now descriptive :)
head(tidy.data[, 1:6])
#   subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
# 1       1 STANDING         0.2885845       -0.02029417        -0.1329051       -0.9952786
# 2       1 STANDING         0.2784188       -0.01641057        -0.1235202       -0.9982453
# 3       1 STANDING         0.2796531       -0.01946716        -0.1134617       -0.9953796
# 4       1 STANDING         0.2791739       -0.02620065        -0.1232826       -0.9960915
# 5       1 STANDING         0.2766288       -0.01656965        -0.1153619       -0.9981386
# 6       1 STANDING         0.2771988       -0.01009785        -0.1051373       -0.9973350

# We now write tidy.data to a .txt file for the purpose of uploading.
# This file will open very nicely in Excel
write.table(tidy.data, file="./tidydata.txt", sep="\t")







############################################################################### 
# 
# Part 2: taking averages of features with respect to subject or/and activity
# 
################################################################################

library(reshape2)
id <- names[1:2]
measure.vars <- names[3:68]
m <- melt(tidy.data, id=id, measure.vars = measure.vars)


# The instruction is NOT clear at all as to exactly what we need to do.
# I am not sure if we should take average for each subject, for each activity, or for each combination 
# of subject and activity. So I am doing them all!!!!
subject.mean <- dcast(m, subject ~ variable, mean)
head(subject.mean[,1:6])
# subject tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1       1         0.2656969       -0.01829817        -0.1078457       -0.5457953       -0.3677162
# 2       2         0.2731131       -0.01913232        -0.1156500       -0.6055865       -0.4289630
# 3       3         0.2734287       -0.01785607        -0.1064926       -0.6234136       -0.4800159
# 4       4         0.2741831       -0.01480815        -0.1075214       -0.6052117       -0.5099294
# 5       5         0.2791780       -0.01548335        -0.1056617       -0.5076910       -0.4027249
# 6       6         0.2723766       -0.01756970        -0.1159945       -0.5050861       -0.3684037
dim(subject.mean)
#[1] 30 67
# subject.mean has 30 rows, with each row corresponds to one test subject. 
# It has 67 columns. The first column is the subject factor, the rest 66 columns are averages of each feature.


activity.mean <- dcast(m, activity ~ variable, mean)
activity.mean[,1:6]
#          activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1            WALKING         0.2763369       -0.01790683        -0.1088817       -0.3146445      -0.02358295
# 2   WALKING_UPSTAIRS         0.2622946       -0.02592329        -0.1205379       -0.2379897      -0.01603251
# 3 WALKING_DOWNSTAIRS         0.2881372       -0.01631193        -0.1057616        0.1007663       0.05954862
# 4            SITTING         0.2730596       -0.01268957        -0.1055170       -0.9834462      -0.93488056
# 5           STANDING         0.2791535       -0.01615189        -0.1065869       -0.9844347      -0.93250871
# 6             LAYING         0.2686486       -0.01831773        -0.1074356       -0.9609324      -0.94350719
# activity.mean has 6 rows for 6 different activities. Like subject.mean, it has 67 columns.


interaction.mean <- dcast(m, interaction(activity, subject) ~ variable, mean)
dim(interaction.mean)
# [1] 180  67
# there are 180 rows, due to 30 subjects and 6 activitites.
head(interaction.mean[,1:6])
#   interaction(activity, subject) tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1                      WALKING.1         0.2773308      -0.017383819        -0.1111481      -0.28374026      0.114461337
# 2             WALKING_UPSTAIRS.1         0.2554617      -0.023953149        -0.0973020      -0.35470803     -0.002320265
# 3           WALKING_DOWNSTAIRS.1         0.2891883      -0.009918505        -0.1075662       0.03003534     -0.031935943
# 4                      SITTING.1         0.2612376      -0.001308288        -0.1045442      -0.97722901     -0.922618642
# 5                     STANDING.1         0.2789176      -0.016137590        -0.1106018      -0.99575990     -0.973190056
# 6                       LAYING.1         0.2215982      -0.040513953        -0.1132036      -0.92805647     -0.836827406
tail(interaction.mean[,1:6])
# interaction(activity, subject) tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 175                     WALKING.30         0.2764068      -0.017588039       -0.09862471      -0.34639428      -0.17355002
# 176            WALKING_UPSTAIRS.30         0.2714156      -0.025331170       -0.12469749      -0.35050448      -0.12731116
# 177          WALKING_DOWNSTAIRS.30         0.2831906      -0.017438390       -0.09997814      -0.05777032      -0.02726281
# 178                     SITTING.30         0.2683361      -0.008047313       -0.09951545      -0.98362274      -0.93785700
# 179                    STANDING.30         0.2771127      -0.017016389       -0.10875621      -0.97755943      -0.89165453
# 180                      LAYING.30         0.2810339      -0.019449410       -0.10365815      -0.97636252      -0.95420182
write.table(interaction.mean, file="./averages.txt", sep="\t")
