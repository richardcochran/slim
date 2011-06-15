PAPER = slim

all: $(PAPER).pdf

$(PAPER).pdf: $(PAPER).tex refs.bib
	pdflatex $(PAPER).tex
	bibtex $(PAPER)
	pdflatex $(PAPER).tex
	pdflatex $(PAPER).tex

clean:
	rm -f $(PAPER).aux $(PAPER).bbl $(PAPER).blg $(PAPER).dvi \
	$(PAPER).log $(PAPER).pdf $(PAPER).ps $(PAPER).toc

