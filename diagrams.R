x <- read.delim("table.dat")
x <- x[order(x$t),]

min.datalen <- min(x$datalen)
max.datalen <- max(x$datalen)

png("diagrams/datalen.png")
hist(x$datalen, max.datalen - min.datalen + 1)
dev.off()

png("diagrams/datalen-in.png")
hist(x[x$dir=="IN",]$datalen, max.datalen - min.datalen + 1)
dev.off()

png("diagrams/datalen-out.png")
hist(x[x$dir=="OUT",]$datalen, max.datalen - min.datalen + 1)
dev.off()

png("diagrams/datalen-google.png")
hist(x[x$google,]$datalen, max.datalen - min.datalen + 1)
dev.off()

png("diagrams/datalen-google-in.png")
hist(x[x$google & x$dir=="IN",]$datalen, max.datalen - min.datalen + 1)
dev.off()

png("diagrams/datalen-google-out.png")
hist(x[x$google & x$dir=="OUT",]$datalen, max.datalen - min.datalen + 1)
dev.off()

syn.out <- x[x$syn & x$dir=="OUT",]
# For each source address, get the first differences of the timestamps of its
# sent SYNs, then collect all the lists of differences in one big list.
intervals <- Reduce(append, lapply(levels(syn.out$src), function(src) {
	diff(syn.out[syn.out$src==src,]$t)
}))
png("diagrams/syninterval-out.png")
hist(intervals)
dev.off()

syn.google.out <- x[x$syn & x$dir=="OUT" & x$google,]
intervals <- Reduce(append, lapply(levels(syn.google.out$src), function(src) {
	diff(syn.google.out[syn.google.out$src==src,]$t)
}))
png("diagrams/syninterval-google-out.png")
hist(intervals)
dev.off()
