# chipAnalyseR
An useful R package for ChIP-seq data analysis and visualisation.

**!STILL IN DEVELOPMENT!**

## Installation
```r
devtools::install_github(repo = 'ClaudiaRHD/chipAnalyser')
```

## Usage
### What you can do with chipAnalyseR 
#### Visualisation
* Profile plot
* Heat map
    * ordered by row mean average
    * ordered by row mean of one selected matrix
    * clustered by kmeans of one selected matrix
* Peak annotation plotchipAnalyseR::plot_hm(mat = BRD4_mat)
* MA plot
* RNA Polymerase 2 pausing index

<<<<<<< HEAD
#### **Example plots**
##### **Profile plot**
```r
> BRD4_mat = chipAnalyseR::get_matrix(bed = "GSM2634756_U87_BRD4_peaks.narrowPeak", bw_files = c("GSM2634756_U87_BRD4.bw", "GSM2634758_U87_BRD4_dBET_2h.bw", "GSM2634757_U87_BRD4_dBET_24h.bw"), bw_path = "/R/", op_dir = "/R/GSE99171_RAW/",up = 2500, down = 2500, pos = '', binsize = 10, numcores = 6)
> chipAnalyseR::plot_profile(mat_sum = BRD4_mat, opt = 'mean')
```
< img src= "https://user-images.githubusercontent.com/34287600/39582290-f1175e9a-4eed-11e8-9d46-69cb1326c8b6.png" height= "90" width ="240"/>


##### **Heat map**
```r
> BRD4_mat = chipAnalyseR::get_matrix(bed = "GSM2634756_U87_BRD4_peaks.narrowPeak", bw_files = c("GSM2634756_U87_BRD4.bw", "GSM2634758_U87_BRD4_dBET_2h.bw", "GSM2634757_U87_BRD4_dBET_24h.bw"), bw_path = "/R/", op_dir = "/R/GSE99171_RAW/",up = 2500, down = 2500, pos = '', binsize = 10, numcores = 6)
> chipAnalyseR::plot_hm(mat = BRD4_mat)
```
![](https://user-images.githubusercontent.com/34287600/39585110-4e43cbd4-4ef4-11e8-9e47-50f4411c0fc1.png)

##### **MA plot**
```r
> BRD4_auc = chipAnalyseR::auc_pi(bed = "GSM2634756_U87_BRD4_peaks.narrowPeak", bw_files = c("GSM2634756_U87_BRD4.bw", "GSM2634758_U87_BRD4_dBET_2h.bw", "GSM2634757_U87_BRD4_dBET_24h.bw"), bw_path = "/R/", op_dir = "/R/GSE99171_RAW/", numcores = 6)
```
![](https://user-images.githubusercontent.com/34287600/39582756-ed8720fc-4eee-11e8-9aa8-bee2ac04a41c.png)

##### **Peak annotation plot**
```r
> chipAnalyseR::peak_annos(p_anno = c("GSM2634756_U87_BRD4_peaks.narrowPeak.anno", "GSM2634758_U87_BRD4_dBET_2h_peaks.narrowPeak.anno"), state2color = "seg.txt")
```
![](https://user-images.githubusercontent.com/34287600/39582847-1c05d61c-4eef-11e8-8b0f-dd9e6e038e08.png)

##### **RNA Polymerase 2 pausing index**
```r
> pol2_index = chipAnalyseR::pol2_index(gm = "/media/tempData/claudia/R/sig/hg19_refflat_1k.tsv", bw_files = c("GSM2634756_U87_BRD4.bw", "GSM2634757_U87_BRD4_dBET_24h.bw"), bw_path = "/R/", op_dir = "/R/GSE99171_RAW/", filter = TRUE, numcores = 6 )
> chipAnalyseR::plot_pol2i(pol2_table = pol2_index)
```
![](https://user-images.githubusercontent.com/34287600/39582498-65b2d4dc-4eee-11e8-9ce2-168a91597340.png)
=======

>>>>>>> c354d8c292888acf4f7d5f9f0feffa080fb93be6
