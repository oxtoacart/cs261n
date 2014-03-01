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
