all: diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
	diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png

table.dat: gentable traces/lbl.https.non-goog.dpriv traces/lbl.https.goog.dpriv
	./gentable > "$@"

traces/%: traces/%.gz
	gzip -dk "$<"

diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png: table.dat
	Rscript diagrams.R

.PHONY: all
