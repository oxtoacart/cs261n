related-work.pdf:

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clean:
	rm -f related-work.pdf

.PHONY: clean
