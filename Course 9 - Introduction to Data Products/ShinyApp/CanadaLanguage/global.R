library(data.table)

data <- fread("data/CanadaLanguage_Complete.csv", stringsAsFactors = FALSE)
data[,Total:=as.numeric(Total)]
data[,TotalPercent:=as.numeric(TotalPercent)]
data[,TotalChangePercent:=as.numeric(TotalChangePercent)]
data[,ENG:=as.numeric(ENG)]
data[,ENGPercent:=as.numeric(ENGPercent)]
data[,ENGChangePercent:=as.numeric(ENGChangePercent)]
data[,FRA:=as.numeric(FRA)]
data[,FRAPercent:=as.numeric(FRAPercent)]
data[,FRAChangePercent:=as.numeric(FRAChangePercent)]
data[,ENGFRA:=as.numeric(ENGFRA)]
data[,ENGFRAPercent:=as.numeric(ENGFRAPercent)]
data[,ENGFRAChangePercent:=as.numeric(ENGFRAChangePercent)]
data[,NO:=as.numeric(NO)]
data[,NOPercent:=as.numeric(NOPercent)]
data[,NOChangePercent:=as.numeric(NOChangePercent)]