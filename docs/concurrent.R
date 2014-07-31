library(ggplot2)

#fields           ts         uid       id.orig_h    id.orig_p    id.resp_h    id.resp_p    proto     service    duration    orig_bytes    resp_bytes    conn_state    local_orig    missed_bytes    history      orig_pkts    orig_ip_bytes    resp_pkts    resp_ip_bytes    tunnel_parents
bro.names <-   c("ts",      "uid",    "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "proto",  "service", "duration", "orig_bytes", "resp_bytes", "conn_state", "local_orig", "missed_bytes", "history",   "orig_pkts", "orig_ip_bytes", "resp_pkts", "resp_ip_bytes", "tunnel_parents")
#types            time       string    addr         port         addr         port         enum      string     interval    count         count         string        bool          count           string       count        count            count        count            table[string]
bro.classes <- c("numeric", "factor", "factor",    "factor",    "factor",    "factor",    "factor", "factor",  "numeric",  "integer",    "integer",    "factor",     "logical",    "integer",      "character", "integer",   "integer",       "integer",   "integer",       "character")

x <- cbind(read.table("../traces/lbl.https.goog.dpriv.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), google=T, source="lbl")
x <- rbind(x, cbind(read.table("../traces/lbl.https.non-goog.dpriv.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), google=F, source="lbl"))
x <- rbind(x, cbind(subset(read.table("../traces/meek_tbb_extension_tcp.pcap.conn.log", col.names=bro.names, colClasses=bro.classes, na.strings=c("-")), id.resp_p==443), google=T, source="tbb"))

# Some RSTOS0 have duration==0, not sure what that's about.
x <- x[!is.na(x$duration), ]

# Get the number of connections open at every timestamp.
# https://stackoverflow.com/questions/20689650/how-to-append-rows-to-an-r-data-frame/20689755#20689755
calc.numconns <- function(x) {
	n <- nrow(x)
	ts <- numeric(2*n)
	orig_h <- character(2*n)
	dconns <- integer(2*n)
	for (i in 1:n) {
		# Connection begin
		ts[2*(i-1) + 1] <- x$ts[i]
		orig_h[2*(i-1) + 1] <- x$id.orig_h[i]
		dconns[2*(i-1) + 1] <- +1
		# Connection end
		ts[2*(i-1) + 2] <- x$ts[i] + x$duration[i]
		orig_h[2*(i-1) + 2] <- x$id.orig_h[i]
		dconns[2*(i-1) + 2] <- -1
	}
	y <- data.frame(ts, orig_h, dconns, scale=length(unique(x$id.orig_h)))
	y$orig_h <- factor(y$orig_h)
	y <- y[order(y$ts), ]
	y$ts <- y$ts - min(y$ts)
	y$weight <- c(diff(y$ts), 0)
	# https://stackoverflow.com/questions/7409138/combining-split-and-cumsum/7409310#7409310
	y$numconns <- with(y, ave(dconns, orig_h, FUN=cumsum))
	y
}

numconns <- cbind(calc.numconns(x[x$google & x$source=="lbl", ]), google=T, source="lbl")
numconns <- rbind(numconns, cbind(calc.numconns(x[!x$google & x$source=="lbl", ]), google=F, source="lbl"))
numconns <- rbind(numconns, cbind(calc.numconns(x[x$google & x$source=="tbb", ]), google=T, source="tbb"))

numconns <- cbind(numconns, alpha=ifelse(numconns$source=="lbl", 0.15, 1.0))
numconns <- cbind(numconns, label=ifelse(numconns$source=="lbl", "LBL Google HTTPS", "meek on App Engine"))

calc.breaks <- function(v) {
	if (v[2] - v[1] < 10) {
		return(seq(0, floor(v[2]), 1))
	} else {
		return(seq(0, floor(v[2]), 10))
	}
}

data <- numconns[numconns$google, ]
p <- ggplot(data=data)
p <- p + scale_y_continuous(breaks=calc.breaks)
p <- p + xlab("Time (seconds)") + ylab("Concurrent connections")
p <- p + facet_wrap(~ label, ncol=1, scales="free")
p <- p + geom_step(aes(ts, numconns, group=orig_h, alpha=data$alpha, colour="coral"))
p <- p + geom_smooth(aes(ts, cumsum(dconns)/scale, weight=weight), size=0.4, colour="black", se=FALSE)
p <- p + theme(axis.text=element_text(size=7), axis.title=element_text(size=8))
p <- p + theme(legend.position="none")
ggsave("concurrent.pdf", width=4, height=3.75, units="in")
