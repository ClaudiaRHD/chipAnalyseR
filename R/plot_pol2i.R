#' Plot calculated polymerase2 pausing index.
#' @description  Plot calculated polymerase2 pausing index for every gene according to the inserted gene model file in "pol2_index"-function.  With used filter duplicated and overlapping genes can be removed from list as well as non necessary columns. Returns a list (name, geneName, txName, chrom, strand, txStart, txEnd, nr, dr, pi, dif).
#' @param pol2_table List generated with the "pol2_index"-function. Default value is NULL.
#' @export

plot_pol2i = function(pol2_table = NULL){
  if(is.null(pol2_table)){
    stop("no pol2_table inserted")
  }
  table = pol2_table
  legendt = names(table)
  plot(ecdf(table[[1]]$pi), do.points = FALSE, lwd = 2, main= "RNA-Pol2 pausing index", ylab = "cumulative distribution",xlab = "RNA-Pol2 pausing index", xlim = c(0,100))
  lapply(2:length(table), function(x){
    plot(ecdf(table[[x]]$pi), do.points = FALSE, add=TRUE, col= x, lwd = 2 )
  })
  legend( "bottomright",inset = .1, bty = "n", legend = legendt, col = c(1:length(table)), lty = 1, cex = 0.8)
  message("Pol2 index plotting done.")
}

