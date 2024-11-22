project = paper

all: paper clean

deps:
	quarto add quarto-journals/elsevier --no-prompt
	quarto add juliantao/quarto-asce --no-prompt
	quarto add ramiromagno/wiley-njd --no-prompt
	quarto add mvuorre/quarto-preprint --no-prompt

paper:
	quarto render --output-dir outputs

%:
	quarto render --output-dir outputs --to $*

# make release-<version>
release-%:
	mkdir -p releases/$*
	quarto render --output-dir releases/$*
	cp *.bib releases/$*/ || true
	cp *.bst releases/$*/ || true
	cp *.cls releases/$*/ || true
	cp *.sty releases/$*/ || true
	cp *.tex releases/$*/ || true
	mv releases/$*/paper.tex releases/$*/$(project).tex || true
	cp paper.md releases/$*/$(project).md

# make diff previous=<previous release> current=<current release>
diff:
	cd releases/$(current) && latexdiff --disable-citation-markup --graphics-markup=none ../$(previous)/$(project).tex $(project).tex > $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && bibtex  $(project)-diff-$(previous)-$(current).aux
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex

clean:
	git clean -Xdf
