## Set the working directory as the directory of the current script main.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
## Unzip "data.zip"
unzip("data.zip",exdir="./data")

## Finding the best hospital in a state

source("best.R")
best("TX", "heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")
best("BB", "heart attack")
best("NY", "hert attack")

## Ranking hospitals by outcome in a state

source("rankhospital.R")
rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)

## Ranking hospitals in all states

source("rankall.R")
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)
