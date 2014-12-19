create_tidy_data <- function(data) {
    means <- sapply(data[complete.cases(data), ], function(x) mean(as.numeric(x)))[3:length(data)]
    
    means
}
