INKSCAPE = inkscape

all: fronting.pdf

# Doesn't include {datalen,concurrent,flowduration}.pdf to avoid
# requiring access to traces.
FIGURES = \
	clients-meek.pdf \
	clients-psiphon3.pdf \
	fronting-diagram.pdf \
	meek-architecture.pdf \
	meek-browser-architecture.pdf \
	wire-sequential.pdf \
	wire-parallel.pdf

fronting.pdf: fronting.tex fronting.bib $(FIGURES)

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

%.pdf: %.svg
	inkscape --export-text-to-path --export-pdf=$@ $<

# wget -q -O - https://metrics.torproject.org/stats/clients.csv | sed -n -e '1p;/meek/p' > clients-meek.csv
clients-meek.pdf: clients-meek.R clients-meek.csv
	Rscript clients-meek.R
clients-psiphon3.pdf: clients-psiphon3.R psiphon3-fronted-meek-unique-users-all-regions.csv
	Rscript clients-psiphon3.R
datalen.pdf: datalen.R ../traces/lbl.https.goog.dpriv.tcp.log ../traces/lbl.https.non-goog.dpriv.tcp.log ../traces/meek_tbb_extension_tcp.pcap.tcp.log
	Rscript datalen.R
concurrent.pdf: concurrent.R ../traces/lbl.https.goog.dpriv.conn.log ../traces/lbl.https.non-goog.dpriv.conn.log ../traces/meek_tbb_extension_tcp.pcap.conn.log
	Rscript concurrent.R
flowduration.pdf: flowduration.R ../traces/lbl.https.goog.dpriv.conn.log ../traces/lbl.https.non-goog.dpriv.conn.log ../traces/meek_tbb_extension_tcp.pcap.conn.log
	Rscript flowduration.R

clean:
	rm -f fronting.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
