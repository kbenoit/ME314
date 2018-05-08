#library(devtools)
#install_github("streamR", "pablobarbera", subdir="streamR")
#install.packages('ggplot2')

library(streamR)
library(ROAuth)
library(ggplot2)
library(grid)


library(ROAuth)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "ZOHJIRAwnw23FhvFWyUg"
consumerSecret <- "HTfEcEmRRDcx0ZsJ5CHOcmPc84AfDOp5VvIXwt0oY"
my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
save(my_oauth, file = "my_oauth.Rdata")



load("my_oauth.Rdata")


filterStream("tweetsUSLunch.json", track = c("lunch, sandwich"), locations = c(-125, 25, -66, 50), timeout = 30, 
             oauth = my_oauth)
tweetsLunch <- parseTweets("tweetsUSLunch.json", verbose = FALSE)

tweetsBreakfast <- parseTweets("tweetsUSBreakfast.json", verbose = FALSE)


filterStream("tweetsUSSunrise.json", track = c("sunrise, morning, breakfast"), locations = c(-125, 25, -66, 50),timeout = 30, 
             oauth = my_oauth)
tweetsSunrise <- parseTweets("tweetsUSSunrise.json", verbose = FALSE)


par(mfrow=c(1,1))
tweets.df<-tweetsLunch
map.data <- map_data("world")
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))

tweets.df<-tweetsSunrise
pointsb <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))

ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", 
                            color = "grey20", size = 0.5) + expand_limits(x = map.data$long, y = map.data$lat) + 
  theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
        axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
        panel.grid.major = element_blank(), plot.background = element_blank(), 
        plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + geom_point(data = points, 
        aes(x = x, y = y), size = 2, alpha = 1/5, color = "red")+ geom_point(data = pointsb, 
                                                                             aes(x = x, y = y), size = 2, alpha = 1/5, color = "blue")



filterStream("tweetsA.json", track = c("cubs"), timeout = 130, 
             oauth = my_oauth)
tweetsA <- parseTweets("tweetsA.json", verbose = FALSE)

filterStream("tweetsB.json", track = c("giants"), timeout = 130, 
             oauth = my_oauth)
tweetsB <- parseTweets("tweetsB.json", verbose = FALSE)


par(mfrow=c(1,1))
tweets.df<-tweetsA
map.data <- map_data("world")
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))

tweets.df<-tweetsB
pointsb <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat))

ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", 
                            color = "grey20", size = 0.5) + expand_limits(x = map.data$long, y = map.data$lat) + 
    theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
          axis.title = element_blank(), panel.background = element_blank(), panel.border = element_blank(), 
          panel.grid.major = element_blank(), plot.background = element_blank(), 
          plot.margin = unit(0 * c(-1.5, -1.5, -1.5, -1.5), "lines")) + geom_point(data = points, 
                                                                                   aes(x = x, y = y), size = 2, alpha = 1/5, color = "red")+ geom_point(data = pointsb, 
                                                                                                                                                        aes(x = x, y = y), size = 2, alpha = 1/5, color = "blue")

