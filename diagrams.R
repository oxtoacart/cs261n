library(ggplot2)

x <- read.delim("table.dat")
x <- x[order(x$t),]

min.datalen <- min(x$datalen)
max.datalen <- max(x$datalen)

postscript("diagrams/datalen.eps")
qplot(x[x$type=="non-google",]$datalen, geom="histogram", main="TCP payload length", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-in.eps")
qplot(x[x$type=="non-google" & x$dir=="IN",]$datalen, main="TCP payload length (incoming)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-out.eps")
qplot(x[x$type=="non-google" & x$dir=="OUT",]$datalen, main="TCP payload length (outgoing)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-google.eps")
qplot(x[x$type=="google",]$datalen, main="TCP payload length (Google only)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-google-cdf.eps")
qplot(x[x$type=="google",]$datalen, ecdf(x[x$type=="google",]$datalen)(x[x$type=="google",]$datalen), geom="step", ylim=c(0,1), main="TCP payload length CDF (Google only)") + xlab("length") + ylab("probability")
dev.off()

postscript("diagrams/datalen-google-in.eps")
qplot(x[x$type=="google" & x$dir=="IN",]$datalen, main="TCP payload length (incoming, Google only)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-google-out.eps")
qplot(x[x$type=="google" & x$dir=="OUT",]$datalen, main="TCP payload length (outgoing, Google only)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-tbb.eps")
qplot(x[x$type=="tbb",]$datalen, main="TCP payload length (TBB meek)", binwidth=2) + xlab("length")
dev.off()

postscript("diagrams/datalen-tbb-cdf.eps")
qplot(x[x$type=="tbb",]$datalen, ecdf(x[x$type=="tbb",]$datalen)(x[x$type=="tbb",]$datalen), geom="step", ylim=c(0,1), main="TCP payload length CDF (Alexa 500 with TBB)") + xlab("length") + ylab("probability")
dev.off()

syn.out <- x[x$syn & x$dir=="OUT",]
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

syn.google.out <- x[x$syn & x$dir=="OUT" & x$type=="google",]
intervals <- Reduce(append, lapply(levels(syn.google.out$src), function(src) {
	diff(syn.google.out[syn.google.out$src==src,]$t)
}))
postscript("diagrams/syninterval-google-out.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=2) + xlab("time elapsed between SYNs")
dev.off()
postscript("diagrams/syninterval-google-out-log.eps")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=0.02) + xlab("time elapsed between SYNs")+ scale_x_log10(breaks=c(0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000))
dev.off()
