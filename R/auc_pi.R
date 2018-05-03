#' Calculate area under the peak
#' @description Takes files in bigWig format and one file in bed format and calculates the area under the curve (peak). Returns a data.table with the results.
#' @param bed A file in bed format. Default value is NULL.
#' @param bw_files One or a character vector with multiple files in bigWig format. Default value is NULL.
#' @param bw_path The path to directory where bwtool is installed on the computer. Default value is NULL.
#' @param op_dir The path to the operation directory currently used. Default value is NULL.
#' @param numcores Number of cores which should be used in parallelised process.Default value is NULL and will be defined as the number of available cores - 1.
#' @import data.table
#' @import parallel
#' @export

auc_pi = function(bed = NULL, bw_files = NULL, bw_path = NULL, op_dir = NULL, numcores = NULL){

  #check for bwtools
  bw_path = check_bw(bw_path = bw_path)

  #check if bw files are inserted
  if(length(bw_files)<1){
    stop("no bw_files inserted")
  }

  #check if all bw files exists
  for(i in 1:length(bw_files)){
    if(!file.exists(bw_files[i])){
      stop(paste0(bw_files[i], ' does not exist!'))
    }
  }

  #make a proper bed file
  bed = make_bed(bed = bed, op_dir = op_dir)

  #set op_dir if not set
  if(is.null(op_dir)){
    op_dir = getwd()
  } else {
    if(!dir.exists(op_dir)){
      dir.create(op_dir)
    }
  }

  #create cluster
  if(is.null(numcores)){
    ncores = parallel::detectCores()-1
  } else{
    ncores = numcores
  }
  cl = parallel::makeCluster(ncores)
  
  #create matrix
  mcmd = paste(bw_path,  'summary -header -with-sum ')
  parLapply(cl,1:length(bw_files), function(x){
    bn = paste0(basename(bw_files[x]), '.txt')
    mcmd2 = paste(mcmd, bed, bw_files[x], ' ', bn)
    system(command = mcmd2, intern = TRUE)
  })

  #creating outputfiles
  output =  paste0(basename(bw_files), '.txt')
  tables = lapply(X = output, FUN = data.table::fread, header= TRUE)
  names(tables) = basename(bw_files)

  del = list.files(path = op_dir, pattern="bw.txt")
  file.remove(del, bed)
  
  #creating id
  for(i in 1: length(tables)){
    tables[[i]]$id = paste(tables[[i]]$'#chrom', tables[[i]]$'start', sep= '_')
  }

  tempdt = tables[[1]]
  if(length(tables) >= 2){
    for (i in 2:length(tables)){
      tempdt = merge(tempdt, tables[[i]][,10:11], by= 'id')
    }
    colnames(tempdt)[11:length(tempdt)] = basename(bw_files)
  } else {
    colnames(tempdt)[10] = bw_files
  }
  
  tempdt[, c("id","num_data", "min", "max", "mean", "median") := NULL]
  stopCluster(cl)
  message("Done.")
  return(tempdt)

}
