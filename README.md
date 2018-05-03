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
* Peak annotation plot
* MA plot
* RNA Polymerase 2 pausing index

#### Example plots
**plot_profile()**
![plot_profile example](https://user-images.githubusercontent.com/34287600/39582290-f1175e9a-4eed-11e8-9d46-69cb1326c8b6.png)

---
**plot_MA()**
![brd2_24h_ma](https://user-images.githubusercontent.com/34287600/39582756-ed8720fc-4eee-11e8-9aa8-bee2ac04a41c.png)
---
**peak_annos()**
![brd4_pa](https://user-images.githubusercontent.com/34287600/39582847-1c05d61c-4eef-11e8-8b0f-dd9e6e038e08.png)
---

**plot_pol2i()**
![pol2index](https://user-images.githubusercontent.com/34287600/39582498-65b2d4dc-4eee-11e8-9ce2-168a91597340.png)
