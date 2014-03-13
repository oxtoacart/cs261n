library(ggplot2)

#fields          ts         uid       id.orig_h    id.orig_p    id.resp_h    id.resp_p    proto     service    duration    orig_bytes    resp_bytes    conn_state    local_orig    missed_bytes    history      orig_pkts    orig_ip_bytes    resp_pkts    resp_ip_bytes    tunnel_parents
broNames <-   c("ts",      "uid",    "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "proto",  "service", "duration", "orig_bytes", "resp_bytes", "conn_state", "local_orig", "missed_bytes", "history",   "orig_pkts", "orig_ip_bytes", "resp_pkts", "resp_ip_bytes", "tunnel_parents")
#types           time       string    addr         port         addr         port         enum      string     interval    count         count         string        bool          count           string       count        count            count        count            table[string]
broClasses <- c("numeric", "factor", "factor",    "factor",    "factor",    "factor",    "factor", "factor",  "numeric",  "integer",    "integer",    "character",  "logical",    "integer",      "character", "integer",   "integer",       "integer",   "integer",       "character")

nongoog <- (read.table('non-goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))
goog <- (read.table('goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))

meek <- (read.table('meek.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))
meek <- meek[meek$id.resp_p==443,]

y <- nongoog$duration
png("diagrams/flowduration.png")
qplot(y, geom="histogram", main="Flow duration", binwidth=2) + xlab("duration")
dev.off()

y <- (nongoog$resp_ip_bytes) / (nongoog$orig_ip_bytes)
png("diagrams/ratio.png")
qplot(y, geom="histogram", main="Downstream/Upstream Ratio", binwidth=2) + xlab("ratio")
dev.off()

y <- goog$duration
png("diagrams/flowduration-google.png")
qplot(y, geom="histogram", main="Flow duration (Google only)", binwidth=2) + xlab("duration")
dev.off()

y <- (goog$resp_ip_bytes) / (goog$orig_ip_bytes)
png("diagrams/ratio-google.png")
qplot(y, geom="histogram", main="Downstream/Upstream Ratio (Google only)", binwidth=2) + xlab("duration")
dev.off()

y <- meek$duration
png("diagrams/flowduration-meek.png")
qplot(y, geom="histogram", main="Flow duration (meek)", binwidth=2) + xlab("duration")
dev.off()

y <- (meek$resp_ip_bytes) / (meek$orig_ip_bytes)
png("diagrams/ratio-meek.png")
qplot(y, geom="histogram", main="Downstream/Upstream Ratio (meek)", binwidth=2) + xlab("ratio")
dev.off()
