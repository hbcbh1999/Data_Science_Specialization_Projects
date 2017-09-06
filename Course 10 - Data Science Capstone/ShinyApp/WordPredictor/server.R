library(data.table)
library(dplyr) # data.table + dplyr code now lives in dtplyr
library(NLP)
library(tm)
library(RWeka)

function(input, output) {
    output$datatable <- DT::renderDataTable({
        ## Stupid backoff algorithm
        
        nmax = 4
        stupid_backoff_score_n <- function(input_ngram, n) {
            if (n == 4) {
                # Subset all rows where just the second key column ngram_head matches input_ngram
                subset <- fivegram[input_ngram]
                subset[, ('normfreq') := subset[, freq] / subset[, sum(freq)]]
            }
            else if (n == 3) {
                # Subset all rows where just the second key column ngram_head matches input_ngram
                subset <- fourgram[input_ngram]
                subset[, ('normfreq') := 0.4 * subset[, freq] / subset[, sum(freq)]]
            }
            else if (n == 2) {
                # Subset all rows where just the second key column ngram_head matches input_ngram
                subset <- threegram[input_ngram]
                subset[, ('normfreq') := 0.4 * 0.4 * subset[, freq] / subset[, sum(freq)]]
            }
            else if (n == 1) {
                # Subset all rows where just the second key column ngram_head matches input_ngram
                subset <- twogram[input_ngram]
                subset[, ('normfreq') := 0.4 * 0.4 * 0.4 * subset[, freq] / subset[, sum(freq)]]
            }
            subset
        }
        
        ## Process the input string
        
        input_ngram <- function(input, n) {
            s <- strsplit(input, split = ' ')[[1]]
            l <- length(s)
            if (n >= l) {
                n = l
            }
            input_ngram <- paste(s[(l - n + 1):l], collapse = ' ')
        }
        
        input_onegram <- input_ngram(input$text, 1)  ## input$text
        input_onegram
        input_twogram <- input_ngram(input$text, 2)  ## input$text
        input_twogram
        input_threegram <- input_ngram(input$text, 3)  ## input$text
        input_threegram
        input_fourgram <- input_ngram(input$text, 4)  ## input$text
        input_fourgram
        
        ## Stupid backoff algorithm
        
        search_fivegram <- stupid_backoff_score_n(input_fourgram, 4)
        search_fivegram <-
            search_fivegram[, c('ngram_tail', 'normfreq')]
        search_words <-
            as.matrix(unique(search_fivegram[, 'ngram_tail']))
        
        search_fourgram <-
            stupid_backoff_score_n(input_threegram, 3)
        search_fourgram <-
            search_fourgram[, c('ngram_tail', 'normfreq')]
        search_fourgram <-
            search_fourgram[!grepl(paste(search_words, collapse = "|"),
                                   search_fourgram$ngram_tail),]
        if (nrow(search_fourgram) > 0) {
            search_words <-
                c(search_words, as.matrix(unique(search_fourgram[, 'ngram_tail'])))
        }
        
        search_threegram <- stupid_backoff_score_n(input_twogram, 2)
        search_threegram <-
            search_threegram[, c('ngram_tail', 'normfreq')]
        search_threegram <-
            search_threegram[!grepl(paste(search_words, collapse = "|"),
                                    search_threegram$ngram_tail),]
        if (nrow(search_threegram) > 0) {
            search_words <-
                c(search_words, as.matrix(unique(search_threegram[, 'ngram_tail'])))
        }
        
        search_twogram <- stupid_backoff_score_n(input_onegram, 1)
        search_twogram <-
            search_twogram[, c('ngram_tail', 'normfreq')]
        search_twogram <-
            search_twogram[!grepl(paste(search_words, collapse = "|"),
                                  search_twogram$ngram_tail),]
        if (nrow(search_twogram) > 0) {
            search_words <-
                c(search_words, as.matrix(unique(search_twogram[, 'ngram_tail'])))
        }
        
        search <-
            rbind(search_fivegram,
                  search_fourgram,
                  search_threegram,
                  search_twogram)
        search <- search[order(-normfreq),]  ## Some minor edits
        search[, normfreq := NULL]  ## Some minor edits
        setnames(search, "ngram_tail", "the next word")  ## Some minor edits
        
        DT::datatable(search)
    })
}
