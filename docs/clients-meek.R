library(ggplot2)
library(scales)
colClasses <- c(date="Date")
data <- read.csv("clients-meek.csv", colClasses=colClasses)

# Fill in missing dates with NA.
# https://stackoverflow.com/questions/6058677/how-to-create-na-for-missing-data-in-a-time-series/6059113#6059113
daterange <- seq(min(data$date), max(data$date), "1 day")
data <- data.frame(date=daterange, clients=data$clients[match(daterange, data$date)])
# Exclude today, because it reflects a not-yet-settled value.
p <- ggplot(data[data$date >= as.Date("2014-08-01") & data$date < Sys.Date(), ], aes(x=date, y=clients))
p <- p + geom_bar(stat="identity", width=1.1)
p <- p + xlab(NULL) + ylab("Mean concurrent users")
p <- p + scale_x_date(labels=date_format("%b %Y"))
p <- p + scale_y_continuous(labels=comma)
p <- p + theme(axis.text=element_text(size=7), axis.title=element_text(size=8), axis.title.x=element_blank())
ggsave("clients-meek.pdf", p, width=4, height=1.4, units="in")

# p <- p + geom_vline(xintercept=as.numeric(as.Date(c("2014-02-18", "2014-04-11", "2014-04-18", "2014-04-25", "2014-05-07", "2014-05-08"))), color="red")
# 2014-02-18 [tor-qa] Please test experimental bundles with meek transport (3.5.2.1-meek-1)
# https://lists.torproject.org/pipermail/tor-qa/2014-February/000340.html
# 2014-04-11 [tor-qa] 3.5.4-meek-1 (meek bundles with browser TLS camouflage)
# https://lists.torproject.org/pipermail/tor-qa/2014-April/000390.html
# 2014-04-18 [tor-dev] Please try 3.5.4-meek-1 bundles (covert HTTPS pluggable transport)
# https://lists.torproject.org/pipermail/tor-dev/2014-April/006718.html
# 2014-04-25 [tor-dev] Q&A for meek pluggable transport tomorrow, 25 April, 18:30 UTC, #tor-dev
# https://lists.torproject.org/pipermail/tor-dev/2014-April/006763.html
# 2014-05-07 tor1 decommissioning
# 2014-05-08 [tor-qa] 3.6.1-meek-1 bundles
# https://lists.torproject.org/pipermail/tor-qa/2014-May/000410.html
