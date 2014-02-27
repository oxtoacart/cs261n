table.dat: gentable traces/lbl.https.non-goog.dpriv traces/lbl.https.goog.dpriv
	./gentable > "$@"

traces/%: traces/%.gz
	gzip -dk "$<"
