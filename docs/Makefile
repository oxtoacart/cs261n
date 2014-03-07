related-work.pdf:

%.pdf: %.tex %.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

clean:
	rm -f related-work.pdf *.aux *.bbl *.log *.blg

.PHONY: clean
