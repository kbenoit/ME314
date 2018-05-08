library(RCurl)
library(maps)
library(ggplot2)
library(jsonlite)

#sign in with OAuth
library(twitteR)

setup_twitter_oauth('ZOHJIRAwnw23FhvFWyUg','HTfEcEmRRDcx0ZsJ5CHOcmPc84AfDOp5VvIXwt0oY','778251283-ZkDTfl3IbIFZFXlVokA6Gpc19TZPyov3wucZ0XaB','8vgPnpEWP3qhvILmTLXVb9RslwcEwVVeKOo4KCYHOY')

#search all public tweets containing the terms 'text' and 'analysis' and return a maximum of 50 results
results <- searchTwitter('text analysis', n=50)

#transform the results object into a data frame for inspection
df <- as.data.frame(t(sapply(results, as.data.frame)))

#get information about a user
us <- getUser(df$screenName[[2]])
usdf <- as.data.frame(us)

#plot user location on a map

# these lines use the google geocoding API to return co-ordinates from a user location
loc <- curlEscape(usdf$location)

#construct a url request
url <- paste("http://maps.googleapis.com/maps/api/geocode/json?address=",loc,"&sensor=true", sep="")

#send the request
data.url <- getURL(url)

#read the JSON response into R
resp <- fromJSON(data.url)$results
df <- as.data.frame(resp)

#read the latitude and longitude parts of the result
long <- df$geometry.location.lng[[1]]
lat <- df$geometry.location.lat[[1]]


#plot a map of the world
world<-map_data('world')
sf<-data.frame(long=long,lat=lat)
p <- ggplot(legend=FALSE) +
  geom_polygon( data=world, aes(x=long, y=lat,group=group)) +
    theme(panel.background = element_blank()) +
    theme(panel.grid.major = element_blank()) +
    theme(panel.grid.minor = element_blank()) +
    theme(axis.text.x = element_blank(),axis.text.y = element_blank()) +
    theme(axis.ticks = element_blank()) +
  xlab("") + ylab("")

plot(p)
# add the user location
p <- p + geom_point(data=sf,aes(long,lat),colour="green",size=4)
plot(p)