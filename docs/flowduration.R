library(ggplot2)

#fields           ts         uid       id.orig_h    id.orig_p    id.resp_h    id.resp_p    proto     service    duration    orig_bytes    resp_bytes    conn_state    local_orig    missed_bytes    history      orig_pkts    orig_ip_bytes    resp_pkts    resp_ip_bytes    tunnel_parents
bro.names <-   c("ts",      "uid",    "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "proto",  "service", "duration", "orig_bytes", "resp_bytes", "conn_state", "local_orig", "missed_bytes", "history",   "orig_pkts", "orig_ip_bytes", "resp_pkts", "resp_ip_bytes", "tunnel_parents")
#types            time       string    addr         port         addr         port         enum      string     interval    count         count         string        bool          count           string       count        count            count        count            table[string]
bro.classes <- c("numeric", "factor", "factor",    "factor",    "factor",    "factor",    "factor", "factor",  "numeric",  "integer",    "integer",    "factor",     "logical",    "integer",      "character", "integer",   "integer",       "integer",   "integer",       "character")

x <- cbind(read.table("../traces/lbl.https.goog.dpriv.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), google=T, source="lbl")
x <- rbind(x, cbind(read.table("../traces/lbl.https.non-goog.dpriv.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), google=F, source="lbl"))
x <- rbind(x, cbind(subset(read.table("../traces/meek_tbb_extension_tcp.pcap.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), id.resp_p==443), google=T, source="tbb"))

# Read some values off the LBL graph.
print(sprintf("%.1f%%", 100*ecdf(x[x$google & x$source=="lbl", ]$duration)(c(24, 300, 600))))
print(sprintf("%.1f%%", 100*ecdf(x[x$google & x$source=="tbb", ]$duration)(c(24, 300, 600))))

p <- ggplot(x[x$google, ], aes(duration, colour=source))
p <- p + stat_ecdf()
p <- p + scale_x_log10(breaks=c( 1,  5,  10,  24,  60,  120,  180, 240,  300,  600,  900,  1800,  3000, 3600),
                       labels=c("1","5","10","24","60","120","180", "", "300","600","900","1800",   "","3600"))
# https://stackoverflow.com/questions/20167613/ggplot-plotting-cutout-of-cdf-while-maintaining-nomalization-according-to-whole
p <- p + coord_cartesian(xlim=c(5, 3800))
p <- p + xlab("Duration (seconds)") + ylab("Fraction of connections")
p <- p + theme(axis.text=element_text(size=7), axis.title=element_text(size=8))
p <- p + theme(panel.grid.minor.x=element_blank())
p <- p + theme(legend.position="none")
p <- p + annotate("text", x=220, y=0.82, label="LBL Google HTTPS", hjust=1, size=2.5)
p <- p + annotate("text", x=800, y=0.44, label="meek on App Engine", hjust=1, size=2.5)
p <- p + scale_colour_brewer(palette="Set1")
ggsave("flowduration.pdf", width=4, height=3, units="in")
