#' Plot the average of the condition group against the difference of the binary logarithm of the two conditions
#' @description Compare the mean of area under the curve signal for data sets according to the inserted conditions. The conditions are adjusted to the anno-file where the conditions for all data sets are collated. Plots the average of both inserted conditions against the difference of the binary logarithm of the two conditions.
#' @param aucpi A data.table. Output of "auc_pi" function. Default value is NULL.
#' @param anno A data.frame with the assignment of the bigWig files to the conditions. Default value is NULL.
#' @param cond A character vector with two conditions according to the anno data.frame and the bigWig files which should be compared.
#' @export

plot_MA = function(aucpi= NULL, anno = NULL, cond = NULL){

  #check aucpi input
  if(is.null(aucpi)){
    stop("no aucpi inserted")
  }
  if(length(aucpi) < 5){
    stop(paste("aucpi does not have the right size"))
  }

  #check anno input
  if(is.null(anno)){
    stop("no anno available")
  } else {
    if(!file.exists(anno)){
    stop(paste0(anno, ' does not exist!'))
    }
  }

  #check cond input
  if(is.null(cond)){
    stop("no conditions (cond) inserted")
  }
  if(!length(cond)==2){
    stop("cond has to be of length 2")
  }
  
  anno = read.table(file = anno, header=TRUE)
  colnames(anno)[1:2] = c('samples', 'condition') #make a constant column name for annotation table
  #anno.conditions = names(table(anno$condition)) #how many conditions
  anno.conditions = unique(anno$condition) #how many conditions
  message('Available levels:')
  print(anno.conditions)
  avg_values = lapply(anno.conditions, function(x){
                      xsamples = anno[anno$condition %in% x, "samples"]
                      rowMeans(aucpi[,xsamples, with = FALSE], na.rm = TRUE)
                  })
  avg_values = data.table::as.data.table(avg_values)
  aucpi = cbind(aucpi, avg_values)
  colnames(aucpi)[(length(aucpi)-1):length(aucpi)] = paste0(anno.conditions, '_avg') 

  #aucpi$conditon_1 = rowMeans(aucpi[,anno[anno$condition %in% anno.conditions[1], "samples"], with = FALSE], na.rm = TRUE)
  #aucpi$conditon_2 = rowMeans(aucpi[,anno[anno$condition %in% anno.conditions[2], "samples"], with = FALSE], na.rm = TRUE)


  condi = paste0(cond, '_avg')
  aucpiav = aucpi
  for(y in 1:2){
    for(i in 5:length(aucpi)){
      if(condi[y] %in% colnames(aucpi)[[i]]){
        condav = aucpi[[i]]
        aucpiav = cbind(aucpiav, condav)
      }
    }
  }

  colnames(aucpiav)[(length(aucpi)+1):length(aucpiav)]= c("cond1_av", "cond2_av")

  aucpiav$cond_av = rowMeans(aucpiav[,cond1_av:cond2_av], na.rm=TRUE)

  aucpiav$log2_fc2 = log2(aucpiav$cond2_av+1)-log2(aucpiav$cond1_av+1)
  
  aucpiav = aucpiav[order(log2_fc2),]
  
  sp = ggplot(data = aucpiav, aes(x= log2(cond_av+1), y= log2_fc2))+ geom_point(color = "black") + labs(x=paste("Average [log2]"), y= "log2 fold change")+ggtitle(paste(cond[1],"vs", cond[2]))+theme(axis.text.x = element_text(size=9)) 
  sp = sp + stat_density_2d(aes(fill = ..level..), geom="polygon", alpha = 0.2) + scale_fill_gradient(low="black", high="red") + cowplot::theme_cowplot(font_size = 12, line_size = 1)  + theme(legend.position = 'none')                                                                                                                                                                                                                                                  
  sp = sp + geom_hline(aes(yintercept = 0, colour = 'red'))
  #labs(x=paste("Average of", cond[1], "and", cond[2], "[log2]")
  print(sp)

  message("Done.")
  #return(aucpiav)

}
