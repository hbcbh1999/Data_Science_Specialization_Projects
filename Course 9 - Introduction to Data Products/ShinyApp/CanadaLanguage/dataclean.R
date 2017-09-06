rm(list=ls())
Sys.setlocale(locale="C")

library(data.table)

coord <- fread("data/coordinates.csv", header = TRUE, stringsAsFactors = FALSE)
data <- fread("data/CanadaLanguage.csv", header = FALSE, stringsAsFactors = FALSE)
newname <- c("Geocode","CACode","Division","CMA_CA","Age","Data quality",
             "Total","TotalPercent","TotalChangePercent",
             "ENG","ENGPercent","ENGChangePercent",
             "FRA","FRAPercent","FRAChangePercent",
             "ENGFRA","ENGFRAPercent","ENGFRAChangePercent",
             "NO","NOPercent","NOChangePercent","NA")
setnames(data,newname)
data <- data[-c(1:3),]
data <- data[-c((nrow(data)-63):nrow(data)),]
data[,c("CMA_CA","NA","Data quality"):=NULL]

DivisionCode <- function(s) {
    if (grepl("Rivi",s) && grepl("re-du-Loup",s)) s="Riviere-du-Loup"
    if (grepl("Sept-",s) && grepl("les",s)) s="Sept-Iles"
    if (grepl("Qu",s) && grepl("bec",s)) s="Quebec"
    if (grepl("Trois-Rivi",s) && grepl("res",s)) s="Trois-Rivieres"
    if (grepl("Montr",s) && grepl("al",s)) s="Montreal"
    return(s)
}

ProvinceCode <- function(s) {
    if (s=="Alta.)") s="AB"
    else if (s=="B.C.)") s="BC"
    else if (s=="Man.)") s="MB"
    else if (s=="N.B.)") s="NB"
    else if (s=="N.L.)") s="NL"
    else if (s=="N.S.)") s="NS"
    else if (s=="N.W.T.)") s="NT"
    else if (s=="Ont.)") s="ON"
    else if (s=="P.E.I.)") s="PE"
    else if (s=="Que.)") s="QC"
    else if (s=="Sask.)") s="SK"
    else if (s=="Y.T.)") s="YT"
    return(s)
}

data[,Province:=""]
for(i in 1:nrow(data)){
    s <- data[i,"Division",with=FALSE][[1]] # Read an element of data.table
    if(s=="Canada"){
        data[i, Division := ""]
        data[i, Province := "Canada"]
    } else {
        s2 <- strsplit(s,split=" (",fixed=TRUE)[[1]]
        data[i, Division := DivisionCode(s2[1])]
        data[i, Province := ProvinceCode(s2[2])]
    }
}

summary(as.factor(data$Province))

write.table(data, "data/CanadaLanguage_Clean.csv", sep="\t", row.name=FALSE)

data1 <- merge(data,coord,by=c("Division","Province"))
write.table(data1, "data/CanadaLanguage_Complete.csv", sep="\t", row.name=FALSE)