#' Calculate polymerase2 pausing index for every gene according to the inserted gene model file.
#' @description  Calculate polymerase2 pausing index for every gene according to the inserted gene model file. Returns a list (name, size_tss, sum_tss, size_gb, sum_gb, geneNAme, TxName, chrom ,strand, txStart, txEnd, nr, dr, pi). With used filter duplicated and overlapping genes can be removed from list as well as non necessary columns. Returns a list (name, geneName, txName, chrom, strand, txStart, txEnd, nr, dr, pi, dif).
#' @param gm Gene model. File with information about the transcription start and end position of every gene. Default value is NULL.
#' @param bw_files One or a character vector with multiple files in bigWig format. Default value is NULL.
#' @param bw_path The path to directory where bwtool is installed on the computer. Default value is NULL.
#' @param op_dir The path to the operation directory currently used. Default value is NULL.
#' @param filter Filter which can be used to filter the output list to remove  duplicated and overlapping genes as well as non necessary columns. Default value is TRUE.
#' @return list (name, size_tss, sum_tss, size_gb, sum_gb, geneNAme, TxName, chrom ,strand, txStart, txEnd, nr, dr, pi). IF filter = TRUE : list (name, geneName, txName, chrom, strand, txStart, txEnd, nr, dr, pi, dif)
#' @export

pol2_index = function(gm = NULL, bw_files = NULL, bw_path = NULL, op_dir = NULL, filter= TRUE){
  if(is.null(gm)){
    stop("no gene modes file (gm) inserted ")
  }
  if(!file.exists(gm)){
    stop(paste(gm, " does not exist!"))
  }

  #check for bwtools
  bw_path = check_bw(bw_path = bw_path)


  #set op_dir if not set
  if(is.null(op_dir)){
    op_dir = getwd()
  } else {
    if(!dir.exists(op_dir)){
      dir.create(op_dir)
    }
  }

  tss_pm = paste0( basename(gm), 'tss.txt')
  gb_pm = paste0( basename(gm), 'gb.txt')

  #read gene model file
  gm = data.table::fread(input = gm, header = TRUE)

  #create id
  gm$id = paste(gm$'chrom', gm$'txStart', gm$'txEnd', gm$'name', sep='_')


  #split gmp by strand (+,-)
  gmp = gm[strand %in% '+']
  gmm = gm[strand %in% '-']

  #calculate start and end positions for plus and minus strand
  if(nrow(gmp) > 0){
    gmp[, tss_start := txStart - 50]
    gmp[, tss_end := txStart + 300]
    gmp[, gb_start := txStart +300]
    gmp[, gb_end := txEnd +3000]
  }

  if(nrow(gmm) > 0){
    gmm[, tss_start := txEnd - 300]
    gmm[, tss_end := txEnd + 50 ]
    gmm[, gb_start := txStart -3000 ]
    gmm[, gb_end := txEnd - 300]
  }

  gm = rbind( gmp, gmm)

  #create bed files for tss and gene body
  tss = gm[,.(chrom,tss_start,tss_end,id)]
  gb = gm[,.(chrom,gb_start,gb_end,id)]

  data.table::fwrite(x = tss, file = tss_pm, sep = '\t', quote = FALSE, row.names = FALSE, col.names = FALSE)
  data.table::fwrite(x = gb, file = gb_pm, sep = '\t', quote = FALSE, row.names = FALSE, col.names = FALSE)

  mcmd = paste(bw_path,  'summary -header -with-sum -keep-bed')

  #for tss
  lapply(1:length(bw_files), function(x){
    bn = paste0(basename(bw_files[[x]]), '_TSS.txt')
    mcmd2 = paste(mcmd, tss_pm, bw_files[[x]], bn)
    print(mcmd2)
    system(command = mcmd2)
  })
  output1 =  paste0(basename(bw_files), '_TSS.txt')
  tables_tss = lapply(X = output1, FUN = data.table::fread, header= TRUE)
  names(tables_tss) = basename(bw_files)

  #for gene body
  lapply(1:length(bw_files), function(x){
    bnx = paste0(basename(bw_files[[x]]), '_GB.txt')
    mcmd3 = paste(mcmd, gb_pm, bw_files[[x]], bnx)
    print(mcmd3)
    system(command = mcmd3)
  })
  output2 =  paste0(basename(bw_files), '_GB.txt')
  tables_gb = lapply(X = output2, FUN = data.table::fread, header= TRUE)
  names(tables_gb) = basename(bw_files)

  #remove temporary files from directory
  file.remove(tss_pm, gb_pm, output1, output2)

  #remove unneccessary columns in tss and gene body
  tables_tss = lapply(tables_tss, function(x) x[, c(1:3,6:10):=NULL])
  ncolnames =c( "name", "size_tss", "sum_tss")
  tables_tss = lapply(tables_tss, setNames, nm = ncolnames)

  tables_gb = lapply(tables_gb, function(x) x[, c(1:3,6:10):=NULL])
  ncolnames =c( "name", "size_gb", "sum_gb")
  tables_gb = lapply(tables_gb, setNames, nm = ncolnames)

  #merge tss and gene body data
  for(i in 1: length(tables_tss)){
    tables_tss[[i]] = merge(tables_tss[[i]], tables_gb[[i]],by='name')
  }

  colnames(gm)[1] ='geneName'
  colnames(gm)[2] ='txName'
  colnames(gm)[12] ='name'
  gmf = gm[,c(1:6, 12)]
  table = lapply(tables_tss, function(x) merge(x, gmf, by = 'name'))

  #calculate nr, dr and pi and add columns respectively
  table = lapply(table, function(x) x[, nr:= sum_tss/350])
  table = lapply(table, function(x) x[, dr:= sum_gb/size_gb])
  table = lapply(table, function(x) x[, pi:= nr/dr])

  table = lapply(table, function(x) x[!is.na(sum_tss)])
  table = lapply(table, function(x) x[!is.na(sum_gb)])


  #FILTER
  if(filter==TRUE){

    #order by genename and pi-signal + remove rows with duplicated genenames
    message('Removing shorter tx and duplicated entries..')
    table = lapply(table, function(x) x[order(geneName,pi),][!duplicated(x[,geneName]),][size_gb >=1000][, c('size_tss', 'sum_tss', 'size_gb', 'sum_gb'):=NULL])

    message('Removing overlapped entries..')
    table = lapply(table, function(x){
                      xs = split(x, as.factor(as.character(x$chrom)))
                      xsfixed = lapply(xs, function(chr){
                                    if(nrow(chr) > 1){
                                      chr = chr[order(txStart)]
                                      l2 = chr[1:(nrow(chr)-1), txEnd]
                                      l1 = chr[2:nrow(chr), txStart]
                                      chr$dif = c(0, l1-l2)
                                      chr
                                    }
                                  })
                      xsfixed = data.table::rbindlist(l = xsfixed, fill = TRUE)
                      xsfixed
    })

  table = lapply(table, function(x) x[dif >=3000])
  
  }
  
 return(table)
}