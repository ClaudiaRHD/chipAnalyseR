#' Create Pie Chart with peak annotations
#' @description Creates a pie chart with peak annotations of entered file. 
#' @param p_anno File with peakID and corresponding Annotation. Default value is NULL.
#' @export

peak_anno = function(p_anno = NULL, state2color = NULL ){
  
  if(is.null(p_anno)){
    stop("no p_anno file available")
  }  

  message("creating temporary peak annotation file...")
  tem_pa= paste0( basename(p_anno), '.txt')
  
  message("reading peak annotation file...")
  anno = data.table::fread(input = p_anno, header = TRUE)
  anno_s = strsplit(x = anno[,Annotation], split = " ")
  anno$name = sapply(X = anno_s, '[[',1)
  
  if(!is.null(state2color)){
    seg = data.table::fread(input = state2color, header = TRUE)
    if(ncol(seg) < 3){
      colr = RColorBrewer::brewer.pal(n = 8, name = 'Dark2')
    }
    
    for(i in 1: nrow(seg)){
      anno$name = gsub(pattern = seg[i,1], replacement = seg[i,2], x = anno$name)
    }
    #colr=as.character(seg[,3])
  }else{
    colr = RColorBrewer::brewer.pal(n = 8, name = 'Dark2')
  }

  colr = RColorBrewer::brewer.pal(n = 8, name = 'Dark2')
  message("count annotation frequency and order them...")
  pa = anno[,.N, name]
  pa = pa [order(pa[,2]),]
  
  pa$pct = round(pa$N/sum(pa$N)*100,digits = 2) 
  
  
  #pa$color = merge(pa[,], seg[,c('name','color')], by='name')
  
  
 #return(colr)
  
  message("creating pie chart...")
  pie(x = pa$N, labels =paste(pa$name, "( N=",pa$N,",", pa$pct,"%)") , main = paste("Peak Annotations of ", basename(p_anno)),
        col = colr, density = 60, init.angle = 180, border = "grey60", clockwise = FALSE, cex =0.6, cex.main=1)
  message("Pie chart done.")
}      
      