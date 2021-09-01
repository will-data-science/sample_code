##
## Brand Tweets Analysis
##
## Data Set - 300 Tweets about McDonald's, 300 about Wendy's
##
## Goal: Explore data and find any useful insights from consumers
##

library(tm)
library(ngram)
library(ggplot2)
library(RColorBrewer)
library(wordcloud)
library(glmnet)
library(tidyverse) # data manipulation & plotting
library(stringr) # text cleaning and regular expressions
library(tidytext)
library(readxl)
library(data.table)

##
## Data Ingestion and Prep
##
dataTweets = read_excel("data/tweets.xlsx")
wendysDT = data.table(tweet = dataTweets$`Wendy's Verbatims`)#, mcdonalds = dataTweets$`McDonald's Verbatims`)
mcdonaldsDT = data.table(tweet = dataTweets$`McDonald's Verbatims`)

##
## Data Cleaning
##


#
# Function 1: getCleanTweets
# 
# Input: dt - a data.table containing a column of strings named 'tweet'
#
# Output: cleanCorpus - same corpus of texts with data cleaned up

getCleanTweets = function(dt) {
  retDT = copy(dt)
  stopwordsRegex = paste0("\\b(", paste(stopwords("english"), collapse ="|"), ")\\b")
  
  retDT[, tweet := str_to_lower(tweet)]
  retDT[, tweet := str_remove_all(tweet, "[[:punct:]]")]
  # Remove common pluaral words that appear in this vertical
  retDT[, tweet := str_replace_all(tweet, "donalds", "donald")]
  retDT[, tweet := str_replace_all(tweet, "frostys|frosties", "frosty")]
  retDT[, tweet := str_replace_all(tweet, "cofees", "coffee")]
  retDT[, tweet := str_replace_all(tweet, "pies", "pie")]
  retDT[, tweet := str_replace_all(tweet, "drinks", "drinks")]
  retDT[, tweet := str_replace_all(tweet, "ice cream", "icecream")]
  retDT[, tweet := str_remove_all(tweet, stopwordsRegex)]
  
  return(retDT)
}

wendysCleanDT = getCleanTweets(wendysDT)
mcdonaldsCleanDT = getCleanTweets(mcdonaldsDT)

# Remove brand name from tweets about that brand since it will dominate
wendysCleanDT[, tweet := str_remove_all(tweet, "wendys|wendy")]
mcdonaldsCleanDT[, tweet := str_remove_all(tweet, "mcdonalds|mcdonald|mc donalds|mc donald")]

##
## Corpus & DTM Creation
##

wendysCorpus = Corpus(VectorSource(wendysCleanDT$tweet))
mcdonaldsCorpus = Corpus(VectorSource(mcdonaldsCleanDT$tweet))

wendysDTM = TermDocumentMatrix(wendysCorpus)
mcdonaldsDTM = TermDocumentMatrix(mcdonaldsCorpus)

##
## Exploratory Analysis 
##

#
# Function 2 - getFrequencies
#
# Input - dtm : Document Term Matrix from tweets
#
# Output - freqDT

getFrequencies = function(dtm) {
  asMatrix = as.matrix(dtm)
  rowSums = sort(rowSums(asMatrix), decreasing = TRUE)
  freqDT = data.table(word = names(rowSums), freq = rowSums)
  
  return(freqDT)
}

wendysFreq = getFrequencies(wendysDTM)
mcdonaldsFreq = getFrequencies(mcdonaldsDTM)

# Top Terms
head(wendysFreq)
head(mcdonaldsFreq)

# Word Clouds for Visualization
set.seed(13)
wordcloud(words = wendysFreq$word,
          freq = wendysFreq$freq,
          min.freq = 1,
          max.words = 200,
          random.order = FALSE,
          rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))

set.seed(13)
wordcloud(words = mcdonaldsFreq$word,
          freq = mcdonaldsFreq$freq,
          min.freq = 1,
          max.words = 200,
          random.order = FALSE,
          rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))

