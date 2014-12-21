# CodeBook

This document describes the variables, the data, and any transformations or work performed in order 
to clean up the data according to commonly accepted tidy data principles.

## Information About The Data

The data being analyzed is called the Human Activity Recognition Using Smartphones Data Set. 
It is a data set collected during experiments where a group of 30 volunteers each performed six different
activities (walking, walking upstairs, walking downstairs, sitting, standing, and lying) while wearing a 
smartphone (Samsung Galaxy S II) on their waists. The experimenters captured 3-axial linear acceleration and 3-axial
angular velocity at a constant rate of 50Hz from phones' embedded accelerometers and gyroscopes. The data sets were
randomly divided where 70% of the volunteers were used to collect training data while the other 30% were used
to generate the test data.

The sensor signals were further pre-processed by applying noise filters and subsequently sampled
in fixed-width, sliding windows. The sensor acceleration signal was separated using a low-pass, Butterworth filter
into body acceleration and gravity components. The gravitation force was assumed to have only low-frequency compenents 
and was therefore filtered with a 0.3 Hz cut-off frequency. From each window, a vector of features was obtained by calculating
variables from the time and frequency domains.

### Source Of the Data

The data may be obtained from the [UCI website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
where this [ZIP](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) file is located.

### Data Description and Details

All of the original data is located in the `data/raw` subdirectory.  The ZIP file downloaded from the UCI website was unzipped
in this directory.  And, since none of the data in the `Inertial Signal` subdirectories 
(`data/raw/test/Inertial Signal` and `data/raw/train/Inertial Signal`) are necessary to perform our analysis, these directories
were removed to save some disk space. If these data are deemed necessary in the future, the ZIP may be downloaded and unzipped
in this directory again. The following table lists and describes all of the files in the raw data set that are necessary to perform
our analysis.

### Description of Files Contained in the Raw Data Set

| Reference     | Location                   | Type  | Description                                                                                                            |
|---------------|----------------------------|-------|------------------------------------------------------------------------------------------------------------------------|
| **1**         | `activity_labels.txt`      | File  | Links the class labels with their activity name (i.e. WALKING, WALKING\_UPSTAIRS, etc).                                |
| **2**         | `features.txt`             | File  | Lists of all of the features.                                                                                          |
| **3**         | `features\_info.txt`       | File  | Shows information about the variables used on the feature vector.                                                      |
| **4**         | `test/subject\_test.txt`   | File  | Test data set.                                                                                                         |
| **5**         | `test/X\_test.txt`         | File  | Test data labels.                                                                                                      |
| **6**         | `test/y\_test.txt`         | File  | Test subject activity data.                                                                                            |
| **7**         | `train/subject\_train.txt` | File  | Training data set.                                                                                                     |
| **8**         | `train/X\_train.txt`       | File  | Training data labels.                                                                                                  |
| **9**         | `train/y\_train.txt`       | File  | Training subject activity data.                                                                                        |

## The Data Transformation

The transformation of the raw data to a tidy data set is accomplished via an R-script.  The scripts contents are in `run_analysis.R`
which accomplishes the transformation in 5 steps. The 5 steps are listed and described below.

1. Merge the training **[7,8,9]** and test data sets **[4,5,6]** to create a single data set.
2. Extract only the mean and standard deviation for each measurement.
3. Apply the activity labels **[1]** to the merged y-data set **[6,9]**.
4. Appropriately label the data set with descriptive variable names.
5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

### Script details

The R-script implements the steps listed above in order to accomplish transformation of the raw data into a tidy data set. This
section provides some implementation details as to how the steps were accomplished.

- First, all similar data is merged using the `rbind()` function. In essence, **[4]** and **[7]** were merged together, **[5]** and **[8]** were merged together, and **[6]** and **[9]** were merged together.
- Second, all columns that do not represent a mean or a standard deviation of a measure are excluded and the remaining columns are appropriately labeled using **[2]**. Features named `*-meanFreq()` are excluded because there aren't corresponding standard deviation measurements for these values, so I believed them to be out of scope for this analysis.
- Third, activity labels are taken from **[1]** and applied to the merged y-data set **[6,9]**.
- Fourth, the merged subject data **[4,7]** set is properly labeled and then all of the data is then merged into a single data set using `cbind()`.
- Lastly, a new data set is generated by using functions from the `dplyr` package to group the data by *subject* and *activity* and then applying the mean to each of the measures. The result of which is then written to `data/tidy/averages_dplyr.txt`.

### Variables

The following table lists the important variables in the script and what they represent.

| Variable Name                            | Description                                                                                                         |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| x\_train                                 | The training data extracted from `X_train.txt`                                                                      |
| y\_train                                 | The training data labels extracted from `y_train.txt`                                                               |
| s\_train                                 | The training subject activity data extracted from `subject_train.txt`                                               |
| x\_test                                  | The testing data extracted from `X_test.txt`                                                                        |
| y\_test                                  | The testing data labels extracted from `y_test.txt`                                                                 |
| s\_test                                  | The testing subject activity data extracted from `subject_test.txt`                                                 |
| x\_data                                  | *x\_train* and *x\_test* merged together with `rbind()`                                                             |
| y\_data                                  | *y\_train* and *y\_test* merged together with `rbind()`                                                             |
| s\_data                                  | *s\_train* and *s\_test* merged together with `rbind()`                                                             |
| all\_features                            | Features extracted from `features.txt`                                                                              |
| feature\_columns                         | Column numbers of all mean and standard deviation measures in the data set                                          |
| activities                               | Activity names extracted from `activity_labels.txt`                                                                 |
| all\_data                                | *x\_data*, *y\_data*, and *s\_data* merged together with cbind()                                                    |
| averages\_dplyr                          | *all\_data* grouped by *subject* and *activity* and then summarized by applying the mean to each measurement column |
