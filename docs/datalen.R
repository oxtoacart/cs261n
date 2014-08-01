library(ggplot2)

col.names <- c("t", "src", "sport", "dst", "dport", "dir", "iplen", "datalen", "syn")

x <- cbind(read.table("../traces/lbl.https.goog.dpriv.tcp.log", col.names=col.names), google=T, source="lbl")
x <- rbind(x, cbind(read.table("../traces/lbl.https.non-goog.dpriv.tcp.log", col.names=col.names), google=F, source="lbl"))
x <- rbind(x, cbind(subset(read.table("../traces/meek_tbb_extension_tcp.pcap.tcp.log", col.names=col.names), dport==443), google=T, source="tbb"))

# Print the heavy hitters.
t <- table(x[x$google & x$source=="lbl", ]$datalen)
(t[order(t, decreasing=TRUE)] / sum(t))[1:10]
t <- table(x[x$google & x$source=="tbb", ]$datalen)
(t[order(t, decreasing=TRUE)] / sum(t))[1:10]

# t <- table(x[x$google & x$source=="lbl" & x$dir=="IN", ]$datalen)
# (t[order(t, decreasing=TRUE)] / sum(t))[1:10]
# t <- table(x[x$google & x$source=="lbl" & x$dir=="OUT", ]$datalen)
# (t[order(t, decreasing=TRUE)] / sum(t))[1:10]
# t <- table(x[x$google & x$source=="tbb" & x$dir=="IN", ]$datalen)
# (t[order(t, decreasing=TRUE)] / sum(t))[1:10]
# t <- table(x[x$google & x$source=="tbb" & x$dir=="OUT", ]$datalen)
# (t[order(t, decreasing=TRUE)] / sum(t))[1:10]

binwidth = 5

x <- cbind(x, label=ifelse(x$source=="lbl", "ResearchLab Google HTTPS", "meek on App Engine"))
x$label <- factor(x$label, levels=c("ResearchLab Google HTTPS", "meek on App Engine"))

p <- ggplot(x[x$google, ], aes(datalen))
p <- p + scale_y_continuous(labels = function(y) binwidth * y)
p <- p + xlab("TCP payload length") + ylab("Fraction of TCP segments")
p <- p + facet_wrap(~ label, ncol=1, scales="fixed")
p <- p + geom_histogram(aes(y=..density..), binwidth=binwidth)
ggsave("datalen.pdf", width=4, height=3.75, units="in")
