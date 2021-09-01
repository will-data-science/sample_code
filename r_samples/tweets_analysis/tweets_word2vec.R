library(wordVectors)
library(magrittr)
library(data.table)
library(readxl)

source("sample_code/r_samples/tweets_analysis/tweets_utils.R")

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
wendysCleanDT[, tweet := str_replace_all(tweet, "wendys", "wendy")]
mcdonaldsCleanDT[, tweet := str_replace_all(tweet, "mcdonalds", "mcdonald")]

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
for (i in seq(mcdonaldsCorpus)){temp[i + length(wendysCorpus)] <- mcdonaldsCorpus[[i]][1]$content}
writeLines(temp, file("data/brand_tweets.txt"))

##
## Train Word Models
##

# Source https://github.com/bmschmidt/wordVectors/blob/master/vignettes/introduction.Rmd

modelFile = "data/tweets_vectors.bin"
if (!file.exists(modelFile)) {
  model = train_word2vec("data/brand_tweets.txt",
                               "data/tweets_vectors.bin",
                               vectors = 200,
                               threads = 4,
                               window = 12,
                               iter = 50,
                               negative_samples=0)
} else {
  model = read.vectors(modelFile)
}

##
## Analyze with model
##

# Determine Terms Most Closely Related to Brand

closest_to(model, "mcdonald")
closest_to(model, "wendy")

# Cluster Like Terms

centers = 10
clustering = kmeans(model, centers = centers, iter.max = 40)

set.seed(10)
sapply(sample(1:centers, 10), function(n) {
  names(clustering$cluster[clustering$cluster == n][1:10])
})

# Dendrogram of like Terms

restaurants = c("mcdonald", "wendy")
termSet = unlist(lapply(restaurants, 
                  function(restaurant) {
                    nearestWords = closest_to(model, model[[restaurant]],20)
                    nearestWords$word
                  }))

subset = model[[termSet, average=F]]

plotData = hclust(as.dist(cosineDist(subset, subset)))
plot(plotData)


