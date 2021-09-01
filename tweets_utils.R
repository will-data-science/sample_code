##
## Brand Tweets Analysis
##
## Data Set - 300 Tweets about McDonald's, 300 about Wendy's
##
## Goal: Explore data and find any useful insights from consumers
##

library(tm)
library(stringr)

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