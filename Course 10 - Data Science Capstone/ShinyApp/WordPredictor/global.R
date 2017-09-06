library(data.table)

## Read the ngram data

onegram <- fread("data/onegram.csv", header = TRUE, sep = "auto")
setkey(onegram, ngram_full)
twogram <- fread("data/twogram.csv", header = TRUE, sep = "auto")
setkey(twogram, ngram_head)
threegram <- fread("data/threegram.csv", header = TRUE, sep = "auto")
setkey(threegram, ngram_head)
fourgram <- fread("data/fourgram.csv", header = TRUE, sep = "auto")
setkey(fourgram, ngram_head)
fivegram <- fread("data/fivegram.csv", header = TRUE, sep = "auto")
setkey(fivegram, ngram_head)
