library(ggplot2)

x <- read.delim("table.dat")
x <- x[order(x$t),]

min.datalen <- min(x$datalen)
max.datalen <- max(x$datalen)

png("diagrams/datalen.png")
qplot(x$datalen, geom="histogram", main="TCP payload length", binwidth=4) + xlab("length")
dev.off()

png("diagrams/datalen-in.png")
qplot(x[x$dir=="IN",]$datalen, main="TCP payload length (incoming)", binwidth=4) + xlab("length")
dev.off()

png("diagrams/datalen-out.png")
qplot(x[x$dir=="OUT",]$datalen, main="TCP payload length (outgoing)", binwidth=4) + xlab("length")
dev.off()

png("diagrams/datalen-google.png")
qplot(x[x$google,]$datalen, main="TCP payload length (Google only)", binwidth=4) + xlab("length")
dev.off()

png("diagrams/datalen-google-in.png")
qplot(x[x$google & x$dir=="IN",]$datalen, main="TCP payload length (incoming, Google only)", binwidth=4) + xlab("length")
dev.off()

png("diagrams/datalen-google-out.png")
qplot(x[x$google & x$dir=="OUT",]$datalen, main="TCP payload length (outgoing, Google only)", binwidth=4) + xlab("length")
dev.off()

syn.out <- x[x$syn & x$dir=="OUT",]
# For each source address, get the first differences of the timestamps of its
# sent SYNs, then collect all the lists of differences in one big list.
intervals <- Reduce(append, lapply(levels(syn.out$src), function(src) {
	diff(syn.out[syn.out$src==src,]$t)
}))
png("diagrams/syninterval-out.png")
qplot(intervals, geom="histogram", main="Interval between SYNs", binwidth=2) + xlab("time elapsed between SYNs")
dev.off()
png("diagrams/syninterval-out-log.png")
qplot(intervals, geom="histogram", main="Interval between SYNs", binwidth=0.02) + xlab("time elapsed between SYNs")+ scale_x_log10(breaks=c(0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000))
dev.off()

syn.google.out <- x[x$syn & x$dir=="OUT" & x$google,]
intervals <- Reduce(append, lapply(levels(syn.google.out$src), function(src) {
	diff(syn.google.out[syn.google.out$src==src,]$t)
}))
png("diagrams/syninterval-google-out.png")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=2) + xlab("time elapsed between SYNs")
dev.off()
png("diagrams/syninterval-google-out-log.png")
qplot(intervals, geom="histogram", main="Interval between SYNs (Google only)", binwidth=0.02) + xlab("time elapsed between SYNs")+ scale_x_log10(breaks=c(0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000))
dev.off()
