rankall <- function(outcome, num = "best") {
  ## Read outcome data
  ## Check that state and outcome are valid
  ## For each state, find the hospital of the given rank
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  
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
  
  data <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")
  ## Note: must contain colClasses = "character", otherwise the data type will be factor
  
  # st.list <- split(data[,"State"],data[,"State"])
  # st.list <- names(st.list)
  
  # st.list <- table(data[,"State"])
  
  x <- split(data,data[,"State"])
  
  st.list <- character(0)
  hsp.list <- character(0)
  for (i in 1:length(x)) {
    
    x.state <- x[[i]]
    
    x.state[,s] <- as.numeric(x.state[,s])
    
    y.state <- x.state[order(x.state[,s], x.state[,"Hospital.Name"], na.last=NA),]
    
    st <- y.state[1,"State"]
    st.list[st] <- y.state[1,"State"]
    
    if (num == "best") {
      hsp.list[st] <- y.state[1,"Hospital.Name"]
    }
    else if (num == "worst") {
      l = nrow(y.state)
      hsp.list[st] <- y.state[l,"Hospital.Name"]
    }
    else {
      l = nrow(y.state)
      if (num <= l & num >= 1) {
        hsp.list[st] <- y.state[num,"Hospital.Name"]
      }
      else {
        hsp.list[st] <- NA
      }
    }
    
  }
  
  data.frame(hospital = hsp.list, state = st.list)
  
  # y <- sapply(x[order(x[,s], x[,"Hospital.Name"], na.last=NA),])
  # 
  # getrank <- function(y) {
  #   if (num == "best") {
  #     z <- y[1,c("Hospital.Name","State")]
  #   }
  #   else if (num == "worst") {
  #     l = nrow(y)
  #     z <- y[l,c("Hospital.Name","State")]
  #   }
  #   else {
  #     l = nrow(y)
  #     if (num <= l & num >= 1) {
  #       z <- y[num,c("Hospital.Name","State")]
  #     }
  #     else {
  #       z <- NA
  #     }
  #   }
  #   z
  # }
  # 
  # z <- sapply(y,getrank)
  
}