read_data_sets <- function(raw_data_location) {
    require(dplyr)
    
    inertial_signals_dir <- "Inertial Signals"
    
    mkname <- function(loc, pfx, name, sfx, subdir=NA) {
        vec <- if (is.na(subdir)) {
            c(loc, "/", pfx, "/", name, sfx)
        } else {
            c(loc, "/", pfx, "/", subdir, "/", name, sfx)
        }
        paste(vec, sep="", collapse="")
    }
    
    pfxs <- c("train", "test")
    names <- c("body_acc", "body_gyro", "total_acc");
    dirs <- c("x", "y", "z")
    
    l <<- list()
    
    for (name in names) {
        for (dir in dirs) {
            i <- 0
            for (pfx in pfxs) {
                n <- paste(c(name, "_", dir), sep="", collapse="")
                s <- paste(c("_", pfx, ".txt"), sep="", collapse="")
                loc <- mkname(raw_data_location, pfx, n, s, subdir=inertial_signals_dir)
                
                if (i == 0) {
                    l[[n]] <<- tbl_df(read.table(loc))
                } else {
                    df <- read.table(loc)
                    l[[n]] <<- merge(l[[n]], tbl_df(df), all=TRUE)
                }
                i <- 1
            }
        }
    }
    
}


