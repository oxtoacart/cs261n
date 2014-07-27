BRO = bro

all: diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
	diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
	diagrams/syninterval-out.eps diagrams/syninterval-google-out.eps \
	diagrams/syninterval-out-log.eps diagrams/syninterval-google-out-log.eps \
	diagrams/flowduration.eps diagrams/flowduration-google.eps \
	diagrams/ratio.eps diagrams/ratio-google.eps \
	diagrams/connections-google.eps

diagrams:
	mkdir -p $@

table.dat: gentable traces/lbl.https.non-goog.dpriv traces/lbl.https.goog.dpriv traces/meek_tbb_extension_tcp.pcap
	./gentable > "$@"

traces/%: traces/%.gz
	gzip -dk "$<"

goog.log: traces/lbl.https.goog.dpriv
	$(BRO) -r traces/lbl.https.goog.dpriv
	mv conn.log goog.log

non-goog.log: traces/lbl.https.non-goog.dpriv
	$(BRO) -r traces/lbl.https.non-goog.dpriv
	mv conn.log non-goog.log

tbb.log: traces/meek_tbb_extension_tcp.pcap
	$(BRO) -r traces/meek_tbb_extension_tcp.pcap
	mv conn.log tbb.log

diagrams/datalen.png diagrams/datalen-in.png diagrams/datalen-out.png \
diagrams/datalen-google.png diagrams/datalen-google-in.png diagrams/datalen-google-out.png \
diagrams/syninterval-out.eps diagrams/syninterval-google-out.eps \
diagrams/syninterval-out-log.eps diagrams/syninterval-google-out-log.eps: diagrams.R table.dat diagrams
	Rscript diagrams.R

diagrams/flowduration.eps diagrams/flowduration-google.eps diagrams/flowduration-tbb.eps \
diagrams/ratio.eps diagrams/ratio-google.eps \
diagrams/connections-google.eps: bro-diagrams.R non-goog.log goog.log tbb.log
diagrams/connections-google.eps: bro-diagrams.R non-goog.log goog.log diagrams
	Rscript bro-diagrams.R

.PHONY: all
.SECONDARY: table.dat goog.log non-goog.log 
