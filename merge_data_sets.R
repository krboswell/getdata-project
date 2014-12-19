merge_data_sets <- function(data_loc) {
    require(dplyr)
    
    mkname <- function(loc, name, pfx=NA) {
        if (is.na(pfx)) {
            paste(c(loc, "/", name, ".txt"), sep="", collapse="")
        } else {
            paste(c(loc, "/", pfx, "/", name, "_", pfx, ".txt"), sep="", collapse="")
        }
    }
    
    f_names <- as.character(read.table(mkname(data_loc, "features"))[, 2])
    
    d_pfxs <- c("train", "test")
    
    for (i in 1:2) {
        # read X table
        x_loc <- mkname(data_loc, "X", pfx=d_pfxs[i])
        df <- read.table(x_loc)
        colnames(df) <- f_names
        df <- df[, grep("(?:mean\\(\\)|std\\(\\))", f_names)]
        if (i == 1) {
            p_df <- df
        } else {
            df <- merge(p_df, df, all=TRUE)
            data <- tbl_df(df)
        }
        
        # read y table
        y_loc <- mkname(data_loc, "y", pfx=d_pfxs[i])
        if (i == 1) {
            lbl <- read.table(y_loc)[, 1]
        } else {
            lbl <- c(lbl, read.table(y_loc)[, 1])
        }
        
        # read subject table
        subject_loc <- mkname(data_loc, "subject", pfx=d_pfxs[i])
        if (i == 1) {
            sbj <- read.table(subject_loc)[, 1]
        } else {
            sbj <- c(sbj, read.table(subject_loc)[, 1])
        }
    }
    
    data %>% mutate(label=lbl, subject=sbj)
}
