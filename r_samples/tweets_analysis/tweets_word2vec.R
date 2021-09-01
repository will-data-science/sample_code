library(wordVectors)
library(magrittr)
library(data.table)
library(readxl)

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
## Corpus Creation
##

wendysCorpus = Corpus(VectorSource(wendysCleanDT$tweet))
mcdonaldsCorpus = Corpus(VectorSource(mcdonaldsCleanDT$tweet))

##
## Prep for Word Vectors
##

temp = c()
for (i in seq(wendysCorpus)){temp[i] <- wendysCorpus[[i]][1]$content}

