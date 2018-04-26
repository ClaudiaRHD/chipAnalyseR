#' checks for bwtool binary
#' @description Takes inserted path to bwtool and checks if bwtool is already installed.
#' @param bw_path The path to directory where bwtool is installed on the computer. Default value is NULL.
#' @import ggplot2
#' @import data.table
#' @import cowplot

#check if bwtool is available on computer
check_bw = function(bw_path = NULL){

  if(is.null(bw_path)){

    bw_path = 'bwtool'

    if(Sys.which(names = bw_path) == ""){

      stop("bwtool could not be found. Please download bwtool: https://github.com/CRG-Barcelona/bwtool/wiki ")
    } else{
      if(file.exists(bw_path)){
        message("bwtool found in sys")
      } else{
        stop("bwtool could not be found. Please download bwtool: https://github.com/CRG-Barcelona/bwtool/wiki ")
      }
    }
  }else{
    bw_path = paste0(bw_path, 'bwtool')
    if (file.exists(bw_path )){
      message("inserted bwpath is correct. bwtool found")
    } else {
      stop(paste0("bwtool could not be found in ", bw_path,". Please download bwtool: https://github.com/CRG-Barcelona/bwtool/wiki"))
    }
  }

  return(bw_path)
}
