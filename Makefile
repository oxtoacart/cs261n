BRO = bro

all: diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
	diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
	diagrams/syninterval-out.png diagrams/syninterval-google-out.png \
	diagrams/syninterval-out-log.png diagrams/syninterval-google-out-log.png \
	diagrams/flowduration.png diagrams/flowduration-google.png \
	diagrams/ratio.png diagrams/ratio-google.png \
	diagrams/connections-google.png

diagrams:
	mkdir -p $@

table.dat: gentable traces/lbl.https.non-goog.dpriv traces/lbl.https.goog.dpriv
	./gentable > "$@"

traces/%: traces/%.gz
	gzip -dk "$<"

goog.log: traces/lbl.https.goog.dpriv
	$(BRO) -r traces/lbl.https.goog.dpriv
	mv conn.log goog.log

non-goog.log: traces/lbl.https.non-goog.dpriv
	$(BRO) -r traces/lbl.https.non-goog.dpriv
	mv conn.log non-goog.log

diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
diagrams/syninterval-out.png diagrams/syninterval-google-out.png \
diagrams/syninterval-out-log.png diagrams/syninterval-google-out-log.png: diagrams.R table.dat diagrams
	Rscript diagrams.R

diagrams/flowduration.png diagrams/flowduration-google.png \
diagrams/ratio.png diagrams/ratio-google.png \
diagrams/connections-google.png: bro-diagrams.R non-goog.log goog.log diagrams
	Rscript bro-diagrams.R

.PHONY: all
.SECONDARY: table.dat goog.log non-goog.log 
