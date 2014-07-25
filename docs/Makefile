INKSCAPE = inkscape

all: meek.pdf

meek.pdf: meek.tex meek.bib clients-meek.pdf fronting.pdf architecture.pdf browser-architecture.pdf wire-sequential.pdf wire-parallel.pdf

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

clean:
	rm -f meek.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
