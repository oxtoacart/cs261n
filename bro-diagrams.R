library(ggplot2)
library(grid)
theme_set(theme_bw(base_size = 24))

#fields          ts         uid       id.orig_h    id.orig_p    id.resp_h    id.resp_p    proto     service    duration    orig_bytes    resp_bytes    conn_state    local_orig    missed_bytes    history      orig_pkts    orig_ip_bytes    resp_pkts    resp_ip_bytes    tunnel_parents
broNames <-   c("ts",      "uid",    "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "proto",  "service", "duration", "orig_bytes", "resp_bytes", "conn_state", "local_orig", "missed_bytes", "history",   "orig_pkts", "orig_ip_bytes", "resp_pkts", "resp_ip_bytes", "tunnel_parents")
#types           time       string    addr         port         addr         port         enum      string     interval    count         count         string        bool          count           string       count        count            count        count            table[string]
broClasses <- c("numeric", "factor", "factor",    "factor",    "factor",    "factor",    "factor", "factor",  "numeric",  "integer",    "integer",    "character",  "logical",    "integer",      "character", "integer",   "integer",       "integer",   "integer",       "character")

nongoog <- (read.table('non-goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))
goog <- (read.table('goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))
tbb <- (read.table('tbb.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))

y <- nongoog$duration
postscript("diagrams/flowduration.eps")
qplot(y, geom="histogram", binwidth=2) + xlab("duration") 
#+ theme(text = element_text(size = rel(5))) 
dev.off()

y <- (nongoog$resp_ip_bytes) / (nongoog$orig_ip_bytes)
postscript("diagrams/ratio.eps")
qplot(y, geom="histogram", main="Downstream/Upstream Ratio", binwidth=2) + xlab("ratio") 
#+ theme(text = element_text(size = rel(5)))
dev.off()

y <- goog$duration
postscript("diagrams/flowduration-google.eps")
qplot(y, geom="histogram", main="Flow duration (Google only)", binwidth=2) + xlab("duration") 
#+ theme(text = element_text(size = rel(5)))
dev.off()

postscript("diagrams/flowduration-google-cdf.eps")
qplot(y, ecdf(y)(y), geom="step", ylim=c(0,1), main="Flow duration CDF (Google)") + xlab("length (sec)") + ylab("probability")
#+ theme(text = element_text(size = rel(5)))
dev.off()

y <- tbb$duration
postscript("diagrams/flowduration-tbb.eps")
qplot(y, geom="histogram", main="Flow duration (TBB)", binwidth=2) + xlab("duration") 
#+ theme(text = element_text(size = rel(5)))
dev.off()

postscript("diagrams/flowduration-tbb-cdf.eps")
qplot(y, ecdf(y)(y), geom="step", ylim=c(0,1), main="Flow duration CDF (Alexa 500 with TBB)") + xlab("length (sec)") + ylab("probability")  
#+ theme(axis.title = element_text(size = rel(2)), axis.text = element_text(size = rel(2)), plot.title = element_text(size = rel(2)), axis.ticks.margin = unit(10, "lines"))
dev.off()

y <- (goog$resp_ip_bytes) / (goog$orig_ip_bytes)
postscript("diagrams/ratio-google.eps")
qplot(y, geom="histogram", main="Downstream/Upstream Ratio (Google only)", binwidth=2) + xlab("ratio")#  + theme(text = element_text(size = rel(5)))
dev.off()

y <- table(goog$id.orig_h)
postscript("diagrams/connections-google.eps")
hist(y,breaks=1000,main="Connections per user in 10 mins", xlab="Connections", cex.lab=1.5, cex.axis=1.5, cex.main=2, cex.sub=1.5)  
dev.off()

