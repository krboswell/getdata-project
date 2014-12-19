read_data_sets <- function(raw_data_location) {
    inertial_signals_dir <- "Inertial Signals"
    train_pfx <- "train"
    train_sfx <- "_train.txt"
    test_pfx <- "test"
    test_sfx <- "_test.txt"
    
    loc <- mkname(raw_data_location, train_pfx, "body_acc_x", train_sfx, subdir=inertial_signals_dir)
    train_body_acc_x <- read.table(loc)
}

mkname <- function(loc, pfx, name, sfx, subdir=NA) {
    if (is.na(subdir)) {
        c(loc, "/", pfx, "/", name, sfx)
    } else {
        c(loc, "/", pfx, "/", subdir, "/", name, sfx)
    }
}
