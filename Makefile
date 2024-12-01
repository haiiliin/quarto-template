project = paper

all: paper clean

elsevier:
	quarto add quarto-journals/elsevier --no-prompt

asce:
	quarto add juliantao/quarto-asce --no-prompt

wiley:
	quarto add ramiromagno/wiley-njd --no-prompt

preprint:
	quarto add mvuorre/quarto-preprint --no-prompt

authors-block:
	quarto add kapsner/authors-block --no-prompt

critic-markup:
	quarto add mloubout/critic-markup --no-prompt

deps: elsevier asce wiley preprint authors-block critic-markup

paper:
	quarto render --output-dir outputs

%:
	quarto render --output-dir outputs --to $*

# make release-<version>
release-%:
	mkdir -p releases/$*
	quarto render paper.md --output-dir releases/$*
	cp *.bib releases/$*/ || true
	cp *.bst releases/$*/ || true
	cp *.cls releases/$*/ || true
	cp *.sty releases/$*/ || true
	cp *.tex releases/$*/ || true
	mv releases/$*/paper.tex releases/$*/$(project).tex || true
	cp paper.md releases/$*/$(project).md
	echo $* > releases/VERSION

# make diff previous=<previous release> current=<current release>
diff:
	cd releases/$(current) && latexdiff --graphics-markup=both --math-markup=whole ../$(previous)/$(project).tex $(project).tex > $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && bibtex  $(project)-diff-$(previous)-$(current).aux || true
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex $(project)-diff-$(previous)-$(current).tex

change-%:
	mkdir -p changes
	pandiff releases/$*/paper.md paper.md --output changes/paper.md
	awk '/^---/{flag=!flag} flag' paper.md > changes/_metadata.yml
	cp -r figures *.bib *.lua changes || true

clean:
	git clean -Xdf
