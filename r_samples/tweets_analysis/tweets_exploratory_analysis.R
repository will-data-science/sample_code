##
## Brand Tweets Analysis
##
## Data Set - 300 Tweets about McDonald's, 300 about Wendy's
##
## Goal: Explore data and find any useful intial insights from consumers
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

source("sample_code/r_code_samples/tweets_utils.R")

##
## Data Ingestion and Prep
##
dataTweets = read_excel("data/tweets.xlsx")
wendysDT = data.table(tweet = dataTweets$`Wendy's Verbatims`)
mcdonaldsDT = data.table(tweet = dataTweets$`McDonald's Verbatims`)

##
## Data Cleaning
##

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

