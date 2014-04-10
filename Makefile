MAIN= memoire

all: $(MAIN).pdf clean

$(MAIN).pdf: $(MAIN).tex
	# the way cool kids do it
	rubber -d $(MAIN)

	# classic toolchain, outputs more info
	#pdflatex $(MAIN)
	#bibtex $(MAIN)
	#pdflatex $(MAIN)
	#pdflatex $(MAIN)

$(MAIN).ps: $(MAIN).dvi
	dvips -Ppdf -f < $(MAIN).dvi > $(MAIN).ps 2> /dev/null

figures:
	#dot -Tpdf -ofigures/specialisation.pdf figures/specialisation.dot
	#convert figures/hybride.png figures/hybride.pdf

clean:
	rm -f *~ textes/*~ textes/*.aux $(MAIN).dvi $(MAIN).log $(MAIN).lot $(MAIN).lof $(MAIN).toc *.aux $(MAIN).aux $(MAIN).blg Text/*.bak $(MAIN).bbl *.bak $(MAIN).blg $(MAIN).out $(MAIN).toc $(MAIN).tpt $(MAIN).bst $(MAIN).lof

.PHONY: figures memoire.pdf
