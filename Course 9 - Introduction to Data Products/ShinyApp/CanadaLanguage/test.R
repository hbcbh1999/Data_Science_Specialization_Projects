library(leaflet)
library(data.table)
library(ggplot2)

# data <- fread("data/CanadaLanguage_Complete.csv", stringsAsFactors = FALSE)
# ID <- c("Total","TotalPercent","TotalChangePercent",
#         "ENG","ENGPercent","ENGChangePercent",
#         "FRA","FRAPercent","FRAChangePercent",
#         "ENGFRA","ENGFRAPercent","ENGFRAChangePercent",
#         "NO","NOPercent","NOChangePercent")
# data[,lapply(.SD,as.numeric),by=ID]

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

languageBy <- "ENG"
ageBy <- "1"

subdata <- data[data$Age==ageBy & data$Province!="Canada",
                c("Province","Division","Age",languageBy,
                  paste0(languageBy,"Percent"),paste0(languageBy,"ChangePercent"),
                  "latitude","longitude"), 
                with=FALSE]
setnames(subdata,c("Province","Division","Age","LAN","LANPercent","LANChangePercent","latitude","longitude"))
subdata
dim(subdata)

radius <- sqrt(subdata$LAN) * 100
colorData <- subdata$LANPercent

provinceBy <- "NB"
ageBy <- "1"
df <- data[data$Age==ageBy & data$Province == provinceBy,]
dim(df)
DT::datatable(df)