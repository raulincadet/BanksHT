######################################################
### Downloading all xls and xlsx files related to  ###
### of banks financial reports (source: BRH)       ###
######################################################


######################################################
## List of related files from the web page from BRH ##
library(XML)

url <- "https://www.brh.ht/supervision-bancaire/rapports-statistiques-2/"
pageContent <- readLines(url)
Links <- getHTMLLinks(pageContent)
xlsFiles <- grep("\\.xls", Links)
df_xls<-Links[xlsFiles]   # list of xls files
####
xlsFiles <- grep("\\.xlsx", Links)
df_xlsx<-Links[xlsFiles]  # list of xlsx files

files=c(unlist(df_xls),unlist(df_xlsx)) # list of all xls and xlsx files


#################################################
###        Download the files                 ###
f_filesNames<-function(x){ # function to names the files
  y=stringi::stri_split(x,regex="[/]")
  return(y[[1]][length(y[[1]])])
}
f_filesNames(files[12])
#######

for (i in 1:length(files)) {
  download.file(url=files[i], destfile=f_filesNames(files[i]), mode="wb")
}



