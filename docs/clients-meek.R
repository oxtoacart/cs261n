library(ggplot2)
library(scales)
colClasses <- c(date="Date")
data <- read.csv("clients-meek.csv", colClasses=colClasses)

# Fill in missing dates with NA.
# https://stackoverflow.com/questions/6058677/how-to-create-na-for-missing-data-in-a-time-series/6059113#6059113
daterange <- seq(min(data$date), max(data$date), "1 day")
data <- data.frame(date=daterange, clients=data$clients[match(daterange, data$date)])
ggplot(data, aes(x=date, y=clients)) + geom_line() + xlab("Date") + ylab("Mean concurrent users") + scale_x_date(labels=date_format("%b %Y")) + scale_y_continuous(breaks=0:10, minor_breaks=NA) + theme(axis.text=element_text(size=8), axis.title=element_text(size=8))
ggsave("clients-meek.pdf", width=5, height=2, units="in")
