
#Setup the repo (this is one in oregon)
r <- getOption("repos")
r["CRAN"] <- "https://ftp.osuosl.org/pub/cran"
options(repos=r)

#BiocManager needed to install the GenomicAlignments
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("GenomicAlignments")

#Install each of the packages
install.packages('data.table')
install.packages('dplyr')
install.packages('ggplot2')
install.packages('glmnet')
install.packages('glmtlp')
install.packages('plotROC')
install.packages('sparklyr')
install.packages('stringr')
install.packages('tictoc')

