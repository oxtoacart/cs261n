library(ggplot2)

col.names <- c("t", "src", "dst", "dir", "iplen", "datalen", "syn")

# http://www.cookbook-r.com/Graphs/Facets_%28ggplot2%29/#modifying-facet-label-text
label = function(variable, value) {
	if (as.character(variable) != "source") {
		stop()
	}
	value <- as.character(value)
	value[value == "lbl"] <- "LBL Google HTTPS"
	value[value == "tbb"] <- "meek on App Engine"
	return(value)
}

x <- cbind(read.table("../traces/lbl.https.goog.dpriv.tcp.log", col.names=col.names), google=T, source="lbl")
x <- rbind(x, cbind(read.table("../traces/lbl.https.non-goog.dpriv.tcp.log", col.names=col.names), google=F, source="lbl"))
x <- rbind(x, cbind(read.table("../traces/meek_tbb_extension_tcp.pcap.tcp.log", col.names=col.names), google=T, source="tbb"))

# Print the heavy hitters.
t <- table(x[x$google & x$source=="lbl", ]$datalen)
(t[order(t, decreasing=TRUE)] / sum(t))[1:15]
t <- table(x[x$google & x$source=="tbb", ]$datalen)
(t[order(t, decreasing=TRUE)] / sum(t))[1:15]

binwidth = 5

p <- ggplot(x[x$google, ], aes(datalen))
p <- p + geom_histogram(aes(y=..density..), binwidth=binwidth)
p <- p + xlab("TCP payload length") + ylab("Fraction of TCP segments")
p <- p + scale_y_continuous(labels = function(y) binwidth * y)
p <- p + facet_grid(source ~ ., labeller = label)
ggsave("datalen.pdf", width=4, height=4, units="in")
