project = paper
engine = xelatex
backend = bibtex

all: paper clean

elsevier:
	quarto add quarto-journals/elsevier --no-prompt

asce:
	quarto add juliantao/quarto-asce --no-prompt

wiley:
	quarto add ramiromagno/wiley-njd --no-prompt

authors-block:
	quarto add kapsner/authors-block --no-prompt

geotechnique:
	quarto add haiiliin/quarto-geotechnique --no-prompt

emerald:
	quarto add haiiliin/quarto-emerald --no-prompt

nature:
	quarto add christopherkenny/nature --no-prompt

critic-markup:
	quarto add mloubout/critic-markup --no-prompt

wordcount:
	quarto add andrewheiss/quarto-wordcount --no-prompt

deps: elsevier asce wiley authors-block critic-markup wordcount

paper:
	quarto render --output-dir outputs

%:
	quarto render --output-dir outputs --to $*

# make release-<version>
release-%:
	mkdir -p releases/$*
	quarto render paper.md --output-dir releases/$*
	cp *.bib *.bst *.cls *.sty *.tex releases/$*/ || true
	mv releases/$*/paper.tex releases/$*/$(project).tex || true
	cp paper.md releases/$*/$(project).md
	echo $* > releases/VERSION

# make diff previous=<previous release> current=<current release>
diff:
	cd releases/$(current) && latexdiff --graphics-markup=both --math-markup=whole --config SCALEDELGRAPHICS=1 ../$(previous)/$(project).tex $(project).tex > $(project)-diff-$(previous)-$(current).tex
	mkdir -p releases/$(current)/temp/
	mkdir -p releases/$(current)/temp/figures/
	cp releases/$(current)/*.* releases/$(current)/temp/ || true
	cp releases/$(current)/figures/* releases/$(current)/temp/figures/ || true
	cp -n releases/$(previous)/figures/* releases/$(current)/temp/figures/ || true
	cd releases/$(current)/temp && $(engine) -interaction=nonstopmode $(project)-diff-$(previous)-$(current) || true
	cd releases/$(current)/temp && $(backend)                         $(project)-diff-$(previous)-$(current) || true
	cd releases/$(current)/temp && $(engine) -interaction=nonstopmode $(project)-diff-$(previous)-$(current) || true
	cd releases/$(current)/temp && $(engine) -interaction=nonstopmode $(project)-diff-$(previous)-$(current) || true
	cp releases/$(current)/temp/$(project)-diff-$(previous)-$(current).pdf releases/$(current)
	rm -rf releases/$(current)/temp/

clean:
	git clean -Xdf
