all: diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
	diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
	diagrams/syninterval-out.png diagrams/syninterval-google-out.png \
	diagrams/syninterval-out-log.png diagrams/syninterval-google-out-log.png \
	diagrams/flowduration.png diagrams/flowduration-goog.png

table.dat: gentable traces/lbl.https.non-goog.dpriv traces/lbl.https.goog.dpriv
	./gentable > "$@"

traces/%: traces/%.gz
	gzip -dk "$<"

goog.log: traces/lbl.https.goog.dpriv
	bro -r traces/lbl.https.goog.dpriv
	mv conn.log goog.log

non-goog.log: traces/lbl.https.non-goog.dpriv
	bro -r traces/lbl.https.non-goog.dpriv
	mv conn.log non-goog.log

diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
diagrams/syninterval-out.png diagrams/syninterval-google-out.png \
diagrams/syninterval-out-log.png diagrams/syninterval-google-out-log.png \
diagrams/flowduration.png diagrams/flowduration-goog.png: diagrams.R table.dat non-goog.log goog.log
	Rscript diagrams.R

.PHONY: all
.SECONDARY: table.dat
