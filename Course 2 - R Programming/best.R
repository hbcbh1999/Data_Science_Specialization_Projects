best <- function(state, outcome) {
  ## Read outcome data
  ## Check that state and outcome are valid
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
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
  
  y <- as.numeric(x.state[,s])
  
  x.state.comp <- x.state[!is.na(y),]
  y <- y[!is.na(y)]
  
  i <- which.min(y)
  x.state.comp[i,"Hospital.Name"]
}