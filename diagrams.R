library(ggplot2)

col.names <- c("t", "src", "dst", "dir", "iplen", "datalen", "syn")

x <- cbind(read.table("traces/lbl.https.goog.dpriv.tcp.log", col.names=col.names), google=T, source="lbl")
x <- rbind(x, cbind(read.table("traces/lbl.https.non-goog.dpriv.tcp.log", col.names=col.names), google=F, source="lbl"))
x <- rbind(x, cbind(read.table("traces/meek_tbb_extension_tcp.pcap.tcp.log", col.names=col.names), google=T, source="tbb"))

x <- x[order(x$t),]

lbl = x[x$source=="lbl",]

png("diagrams/datalen.png")
qplot(lbl$datalen, geom="histogram", main="TCP payload length", binwidth=2) + xlab("length")  

dev.off()

png("diagrams/datalen-in.png")
qplot(lbl[lbl$dir=="IN",]$datalen, main="TCP payload length (incoming)", binwidth=2) + xlab("length") 
dev.off()

png("diagrams/datalen-out.png")
qplot(lbl[lbl$dir=="OUT",]$datalen, main="TCP payload length (outgoing)", binwidth=2) + xlab("length") 
dev.off()

png("diagrams/datalen-google.png")
qplot(lbl[lbl$google,]$datalen, main="TCP payload length (Google only)", binwidth=2) + xlab("length") 
dev.off()

png("diagrams/datalen-google-cdf.png")
qplot(lbl[lbl$google,]$datalen, stat="ecdf", geom="step", xlim=range(lbl$datalen), ylim=c(0,1), main="TCP payload length CDF (Google only)") + xlab("Length (Bytes)") + ylab("Probability") 
dev.off()

png("diagrams/datalen-google-in.png")
qplot(lbl[lbl$google & lbl$dir=="IN",]$datalen, main="TCP payload length (incoming, Google only)", binwidth=2) + xlab("length") 
dev.off()

png("diagrams/datalen-google-out.png")
qplot(lbl[lbl$google & lbl$dir=="OUT",]$datalen, main="TCP payload length (outgoing, Google only)", binwidth=2) + xlab("length") 
dev.off()

png("diagrams/datalen-tbb.png")
qplot(x[x$source=="tbb",]$datalen, main="TCP payload length (TBB meek)", binwidth=2) + xlab("Length") 
dev.off()

png("diagrams/datalen-tbb-cdf.png")
qplot(x[x$source=="tbb",]$datalen, stat="ecdf", geom="step", xlim=range(lbl$datalen), ylim=c(0,1), main="TCP payload length CDF (Alexa 500 with TBB)") + xlab("Length (Bytes)") + ylab("Probability") 
dev.off()

syn.out <- lbl[lbl$syn & lbl$dir=="OUT",]
# For each source address, get the first differences of the timestamps of its
# sent SYNs, then collect all the lists of differences in one big list.
intervals <- Reduce(append, lapply(levels(syn.out$src), function(src) {
	diff(syn.out[syn.out$src==src,]$t)
}))
postscript("diagrams/syninterval-out.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs", binwidth=2) + xlab("time elapsed between SYNs") 
dev.off()
postscript("diagrams/syninterval-out-log.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs", binwidth=0.02) + xlab("time elapsed between SYNs")+ scale_x_log10(breaks=c(0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000)) 
dev.off()

syn.google.out <- lbl[lbl$syn & lbl$dir=="OUT" & lbl$google,]
intervals <- Reduce(append, lapply(levels(syn.google.out$src), function(src) {
	diff(syn.google.out[syn.google.out$src==src,]$t)
}))
postscript("diagrams/syninterval-google-out.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=2) + xlab("time elapsed between SYNs") 
dev.off()
postscript("diagrams/syninterval-google-out-log.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=0.02) + xlab("time elapsed between SYNs")+ scale_x_log10(breaks=c(0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000)) 
dev.off()
