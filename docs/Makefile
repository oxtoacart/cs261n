all: related-work.pdf paper.pdf

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clean:
	rm -f related-work.pdf paper.pdf *.aux *.bbl *.log *.blg

.PHONY: all clean
