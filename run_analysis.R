## This file contains the main driver method for converting the raw Human 
## Activity Recognition Using Smartphones Data Set (obtained from 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)
## to a single, tidy, data set.

## This function is the main driver for converting the HAR raw data set to a
## tidy data set.
##

run_analysis <- function() {
    
    require(dplyr)
    
    #------------------------------------------------------------------------
    # 1. Merge the training and test sets to create one data set.
    #------------------------------------------------------------------------
    
    # Read the training data sets.
    x_train <- read.table("data/raw/train/X_train.txt")
    y_train <- read.table("data/raw/train/y_train.txt")
    s_train <- read.table("data/raw/train/subject_train.txt")
    
    # Read the test data sets.
    x_test <- read.table("data/raw/test/X_test.txt")
    y_test <- read.table("data/raw/test/y_test.txt")
    s_test <- read.table("data/raw/test/subject_test.txt")
    
    # Merge the training and test data sets together.
    x_data <- rbind(x_train, x_test)
    y_data <- rbind(y_train, y_test)
    s_data <- rbind(s_train, s_test)
    
    #------------------------------------------------------------------------
    # 2. Extract only the mean and standard deviation for each measurement.
    #------------------------------------------------------------------------
    
    # Read the features vector.
    all_features <- read.table("data/raw/features.txt")
    
    # Extract the mean and standard deviation feature column indexes.
    feature_columns <- grep("-(mean|std)\\(\\)", all_features[, 2])
    
    # Subset the X data
    x_data <- x_data[, feature_columns]
    
    # Set column names.
    names(x_data) <- all_features[feature_columns, 2]
    
    #------------------------------------------------------------------------
    # 3. Apply the activity labels to the y data set.
    #------------------------------------------------------------------------
    
    # Read the activity labels data.
    activities <- read.table("data/raw/activity_labels.txt")
    
    # Replace activity identifiers with equivalent labels.
    y_data[, 1] <- activities[y_data[, 1], 2]
    
    names(y_data) <- "activity"

    #------------------------------------------------------------------------
    # 4. Finish labeling the data sets and bring all of them together into
    #    a single data set.
    #------------------------------------------------------------------------
    
    # Apply label to the subject data.
    names(s_data) <- "subject"
    
    # Bring all of the data together into a single data set.
    all_data <- cbind(x_data, y_data, s_data)
    
    #------------------------------------------------------------------------
    # 5. Create a separate, tidy data set with the average of each variable
    #    for each activity and each subject.
    #------------------------------------------------------------------------
    
    all_df <- tbl_df(all_data)
    averages_dplyr <- all_df %>% 
        group_by(subject, activity) %>%
        summarise_each(funs(mean))
    
    write.table(averages_dplyr, "data/tidy/averages_dplyr.txt", row.name=FALSE)
}
