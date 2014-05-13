all: meek.pdf

meek.pdf: meek.tex meek.bib clients-meek.pdf

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clients-meek.pdf: clients-meek.R clients-meek.csv
	Rscript clients-meek.R

clean:
	rm -f meek.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
