rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  ## Check that state and outcome are valid
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  
  data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  ## Note: must contain colClasses = "character", otherwise the data type will be factor
  
  x <- split(data,data[,"State"])
  x.state <- x[[state]]
  
  if (is.null(x.state)) {
    stop("invalid state")
  }
  
  if (outcome == "heart attack") {
    s <- 11
  }
  else if (outcome == "heart failure") {
    s <- 17
  }
  else if (outcome == "pneumonia") {
    s <- 23
  }
  else {
    stop("invalid outcome")
  }
  
  x.state[,s] <- as.numeric(x.state[,s])
  
  y <- x.state[order(x.state[,s], x.state[,"Hospital.Name"], na.last=NA),]
  
  if (num == "best") {
    z <- y[1,"Hospital.Name"]
  }
  else if (num == "worst") {
    l = nrow(y)
    z <- y[l,"Hospital.Name"]
  }
  else {
    l = nrow(y)
    if (num <= l & num >= 1) {
      z <- y[num,"Hospital.Name"]
    }
    else {
      z <- NA
    }
  }
  z
  
}