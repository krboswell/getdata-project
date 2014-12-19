merge_data_sets <- function(data_loc) {
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
            for (i in 1:2) {
                n <- paste(c(name, "_", dir), sep="", collapse="")
                s <- paste(c("_", pfxs[i], ".txt"), sep="", collapse="")
                loc <- mkname(data_loc, pfxs[i], n, s, subdir=inertial_signals_dir)
                
                if (i == 1) {
                    l[[n]] <<- read.table(loc)
                } else {
                    df <- read.table(loc)
                    l[[n]] <<- merge(l[[n]], tbl_df(df), all=TRUE)
                    l[[n]] <<- tbl_df(l[[n]])
                }
            }
        }
    }
}
