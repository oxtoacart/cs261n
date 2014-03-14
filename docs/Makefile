all: paper.pdf

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clean:
	rm -f paper.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
