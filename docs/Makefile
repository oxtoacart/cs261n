all: meek.pdf

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clean:
	rm -f meek.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
