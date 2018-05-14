## Association Rules example
## book data can be found from https://github.com/WinVector/zmPDSwR/tree/master/Bookdata

# load in book purchase transactions
require(arules)
bookbaskets <- read.transactions("bookdata.tsv", format = "single", sep = "\t", cols = c("userid", "title"), rm.duplicates = TRUE)
bookbaskets

# summarize basket sizes
basketSizes <- size(bookbaskets)
summary(basketSizes)

# plot the distribution of basket sizes (log10 scale)
require(ggplot2)
ggplot(data.frame(count = basketSizes)) + 
    geom_density(aes(x = count), binwidth = 1) +
    scale_x_log10()

# which books are people reading?
bookFreq <- itemFrequency(bookbaskets)
bookCount <- (bookFreq / sum(bookFreq)) * sum(basketSizes)
orderedBooks <- sort(bookCount, decreasing = TRUE)
head(orderedBooks, 10)

# restrict dataset to two-book transactions
dim(bookbaskets)
bookbaskets_use <- bookbaskets[basketSizes > 1]
dim(bookbaskets_use)

# mine the rules using the apriori algorithm
rules <- apriori(bookbaskets_use,
                 parameter = list(support = 0.002, confidence = 0.75))
summary(rules)
inspect(head((sort(rules, by = "confidence")), n = 5))

## Note: "lift" compares the frequency of the observed pattern with how often we 
##       would expect to observe the pattern by chance.  Larger "lift" is less
##       likely to occur by chance.