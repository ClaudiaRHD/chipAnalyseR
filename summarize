#' Calculates mean or median for every region in a bed file.
#' @description  Calculates mean or median for every region in a bed file. Takes output of "get_matrix" function as mat_list. Returns list for every inserted bigWig file with the mean or median value for every region according to the adjustments made in "get_matrix" function.
#' @param mat_list A list with average values of region around a peak. Output of "get_matrix" function. Default value is NULL.
#' @param opt Option how the values of mat_list should be summarized. Possible options are 'mean' or 'median'. Default value is mean.


summarize = function(mat_list , opt = 'mean'){

  #checking opt input
  alopts = c('mean','median')
  if( !opt %in% alopts){
    stop(paste("Please choose one of the following options: mean, median. mean is set by default."))
  }

  mat_sum = lapply(seq_along(1:(length(x = mat_list) - 5)), function(i){
                        x = mat_list[[i]]
                        apply(x[,7:ncol(x)], 2, opt, na.rm = TRUE)
                      })

  names(mat_sum) = names(mat_list[1:(length(mat_list)-5)])

  return(mat_sum)
}
