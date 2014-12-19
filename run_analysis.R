## This file contains the main driver method for converting the raw Human 
## Activity Recognition Using Smartphones Data Set (obtained from 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)
## to a single, tidy, data set.

## This function is the main driver for converting the HAR raw data set to a
## tidy data set. It invokes several helper methods that aid in the conversion.
##
## Call stack:
## run_analysis()
##   read_data_sets()
##   merge_data_sets()
##   extract_measurements()
##   name_activities()
##   label_data()
##   create_tidy_data()

run_analysis <- function() {
    
    #------------------------------------------------------------------------
    # Local variables.
    #------------------------------------------------------------------------
    
    # The location of the raw data.
    raw_data_loc <- "data/raw"
    
    # The location of the tidy data.
    tidy_data_loc <- "data/tidy"
    
    #------------------------------------------------------------------------
    # Method invocations.
    #------------------------------------------------------------------------
    
    # Read and merge data.
    data <- merge_data_sets(raw_data_loc)
    
    # Create tidy data set.
    create_tidy_data(data)
}
