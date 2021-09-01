##
## Brand Tweets Analysis
##
## Data Set - 300 Tweets about McDonald's, 300 about Wendy's
##
## Goal: Determine some sort of sentiment score for each brand
##      to give insights in consumer thoughts
##

library(tidytext)

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
## Sentiment Analysis
##

brands = c("mcdonalds", "wendys")
brandTweets = list(mcdonaldsCleanDT$tweet, wendysCleanDT$tweet)
series = tibble()

for (i in seq_along(brands)) {
  cleaned = tibble(chapter = seq_along(brandTweets[[i]]),
                   text = brandTweets[[i]]) %>%
    unnest_tokens(word, text) %>%
    mutate(brandName = brands[i]) %>%
    select(brandName, everything())
  
  series = rbind(series, cleaned)
}
series$brandTweet = factor(series$brandName, levels = rev(brands))

# Plot Sentiment by Tweet
series %>%
  group_by(brandName) %>% 
  mutate(index = chapter) %>% 
  inner_join(get_sentiments("bing")) %>%
  count(brandName, index = index , sentiment) %>%
  ungroup() %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative,
         book = factor(brandName, levels = brands)) %>%
  ggplot(aes(index, sentiment, fill = brandName, colour = "blue")) +
  geom_bar(alpha = 0.5, stat = "identity", show.legend = FALSE) +
  facet_wrap(~ brandName, ncol = 2, scales = "free_x")


tweetsSentiment = series %>%
  group_by(brandName) %>% 
  mutate(index = chapter) %>% 
  inner_join(get_sentiments("bing")) %>%
  count(brandName, index = index , sentiment) %>%
  ungroup() %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative,
         brand = factor(brandName, levels = brands))

# Get individual sentiment scores by brand
sentimentWendys = tweetsSentiment[ which(tweetsSentiment$brand=="wendys"), ]
sentimentMcDonalds = tweetsSentiment[ which(tweetsSentiment$brand=="mcdonalds"), ]

# Sum up total sentiment of each brand
sum(sentimentMcDonalds$sentiment)
sum(sentimentWendys$sentiment)
