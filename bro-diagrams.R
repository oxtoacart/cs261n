library(ggplot2)

#fields          ts         uid       id.orig_h    id.orig_p    id.resp_h    id.resp_p    proto     service    duration    orig_bytes    resp_bytes    conn_state    local_orig    missed_bytes    history      orig_pkts    orig_ip_bytes    resp_pkts    resp_ip_bytes    tunnel_parents
broNames <-   c("ts",      "uid",    "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "proto",  "service", "duration", "orig_bytes", "resp_bytes", "conn_state", "local_orig", "missed_bytes", "history",   "orig_pkts", "orig_ip_bytes", "resp_pkts", "resp_ip_bytes", "tunnel_parents")
#types           time       string    addr         port         addr         port         enum      string     interval    count         count         string        bool          count           string       count        count            count        count            table[string]
broClasses <- c("numeric", "factor", "factor",    "factor",    "factor",    "factor",    "factor", "factor",  "numeric",  "integer",    "integer",    "character",  "logical",    "integer",      "character", "integer",   "integer",       "integer",   "integer",       "character")

y <- (read.table('non-goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))$duration
png("diagrams/flowduration.png")
qplot(y, geom="histogram", main="Flow duration", binwidth=2) + xlab("duration")
dev.off()

y <- (read.table('goog.log', col.names=broNames, colClasses=broClasses, na.strings=c("-")))$duration
png("diagrams/flowduration-google.png")
qplot(y, geom="histogram", main="Flow duration (Google only)", binwidth=2) + xlab("duration")
dev.off()
