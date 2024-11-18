all: paper clean

fetch:
	quarto add quarto-journals/elsevier --no-prompt
	quarto add juliantao/quarto-asce --no-prompt
	quarto add ramiromagno/wiley-njd --no-prompt
	quarto add mvuorre/quarto-preprint --no-prompt

paper:
	quarto render --output-dir outputs

# make release-<version>
release-%:
	mkdir -p releases/$*
	quarto render --output-dir releases/$*
	cp releases/$*/_tex/*.* releases/$*/ || true
	mv releases/$*/index.tex releases/$*/paper-$*.tex

# make diff previous=<previous release> current=<current release>
diff:
	cd releases/$(current) && latexdiff ../$(previous)/paper-$(previous).tex paper-$(current).tex > paper-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex paper-diff-$(previous)-$(current).tex
	cd releases/$(current) && bibtex  paper-diff-$(previous)-$(current).aux
	cd releases/$(current) && xelatex paper-diff-$(previous)-$(current).tex
	cd releases/$(current) && xelatex paper-diff-$(previous)-$(current).tex

clean:
	rm -rf .quarto Arial Helvetica Lato MinionPro MyriadPro NewcenturySchoolBk paper_files Stix Univers *.otf *.pag *.spl *.ttf
