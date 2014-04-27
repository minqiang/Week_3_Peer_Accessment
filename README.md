Week_3_Peer_Accessment
======================

This repo consists of the following:
1. run_analysis.R

2. tidydata.txt (output of first part of run_analysis.R)


The following is a brief description of run_analysis.R:

Part 1:

1. read in features (561 of them), activities (6 of them)

2. read in test data: X_test (measurements of 561 features)
                      subject_test (subject tested)
                      y_test (activities for each measurement)
   2947 observations.

3. read in train data: X_train, subject_train, y_train
   7352 observations.

4. merge test and train data sets to form new data frame
    all.data. It contains the merged X, y, and subject
   10299 observations.

5. The column names of all.data are modified to be descriptive
   names. In particular, the activitities are no longer labled 
   as numeric values. Instead, descritive character names 
   are given.

6. From all.data, a subset tidy.data is constructed which
   contains only means and std's of observations. There are 
   altogether 66 such columns.

7. tidy.data is then written to a file tidydata.txt.

Part 2:

1. tidy.data is melted. subject and activities are taken as id's,
   and the rest 66 columns are taken as measure.vars.

2. The melted tidy.data (named m) is processed using dcast.
   The averages of 66 columns are computed according to subject,
   activity, as well as interations of subject and activity.
   The resulting three data sets are:
   -- subject.mean: 30 obs, 67 columns (66 measurements)
   -- activity.mean: 6 obs, 67 columns
   -- interaction.mean: 180 obs, 67 columns