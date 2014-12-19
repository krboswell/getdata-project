merge_data_sets <- function(data_loc) {
    
    mkname <- function(loc, name, pfx=NA) {
        if (is.na(pfx)) {
            paste(c(loc, "/", name, ".txt"), sep="", collapse="")
        } else {
            paste(c(loc, "/", pfx, "/", name, "_", pfx, ".txt"), sep="", collapse="")
        }
    }
    
    f_names <- as.character(read.table(mkname(data_loc, "features"))[, 2])
    
    d_pfxs <- c("train", "test")
    
    gres <- grep("(?:mean\\(\\)|std\\(\\))", f_names)
    num_columns <- length(gres)
    
    l = as.list(c(NA, NA))
    for (i in 1:2) {
        # read X table
        x_loc <- mkname(data_loc, "X", pfx=d_pfxs[i])
        df <- read.table(x_loc)
        colnames(df) <- f_names
        df <- df[, gres]
        
        # read y vector
        y_loc <- mkname(data_loc, "y", pfx=d_pfxs[i])
        labels <- read.table(y_loc)[, 1]
        labels_idx <- num_columns + 1
        
        # read subject vector
        subject_loc <- mkname(data_loc, "subject", pfx=d_pfxs[i])
        subjects <- read.table(subject_loc)[, 1]
        subjects_idx <- num_columns + 2
        
        df <- cbind(df, labels, subjects)[, c(labels_idx, subjects_idx, 1:length(gres))]
        
        l[[i]] <- df
    }
    
    rbind(l[[1]], l[[2]])
}
