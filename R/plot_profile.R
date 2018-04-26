#' Plot mean or median values of
#' @description Plot mean or median value for every inserted bigWig file for every region according to the adjustments made in "get_matrix" function.
#' @param mar_sum A list A list with average values of region around a peak. Output of "get_matrix" function. "plot_profile" function will take it as input to run "summarize" function. Default value is NULL.
#' @param opt Option how the values of mat_sum should be summarized. Possible options are 'mean' or 'median'. Default value is mean.
#' @return nothing. 
#' @export

plot_profile= function(mat_sum = NULL, opt = 'mean'){
  
  reg = mat_sum$region
  bnsz = mat_sum$binSize
  reg =c(-reg[1]:reg[2])
  breg <- reg[seq(1, length(reg), bnsz)]
  reg = breg[!breg==0]
  
  mat_sum = summarize(mat_list = mat_sum, opt = opt)
  
  x= rep(reg, length(mat_sum))
  #x= rep(c(1:length(mat_sum[[1]])), length(mat_sum))
  df=lapply(X = mat_sum, data.frame)
  mat_sum = data.table::rbindlist(l = df, idcol = 'sample')
  colnames(mat_sum) = c("sample", "value")
  mat_sum = cbind(mat_sum, x)
  
  p = ggplot(data = mat_sum, aes(x=x, y= value, color=sample))+geom_line()+labs(x= "region around peak [bp]")+labs(y= "RPM")
  print(p)
  
}



