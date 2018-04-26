#' Create a temporary bed file.
#' @description Create a temporary bed file for the following functions. 
#' @param bed A file in bed format. Default value is NULL.
#' @param op_dir The path to the operation directory currently used. Default value is NULL.

#create temporary bed-file
make_bed = function (bed = NULL, op_dir = NULL ){

  if(is.null(bed)){
    stop("no bed file available")
  }

  if(!file.exists(bed)){
    stop(paste0(bed, ' does not exist!'))
  }

  tem=paste0( basename(bed), '.txt')

  if(is.null(op_dir)){
    op_dir = getwd()
  }

  tem = paste0(op_dir, '/', tem)
  tem_r = data.table::fread(input = bed, header = FALSE)
  tem_f = tem_r[,1:3]
  data.table::fwrite(x = tem_f, file = tem, sep = '\t', quote = FALSE, row.names = FALSE, col.names = FALSE)
  return(tem)
}
