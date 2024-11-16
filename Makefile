all: paper clean

fetch:
	quarto add quarto-journals/elsevier --no-prompt
	quarto add juliantao/quarto-asce --no-prompt
	quarto add ramiromagno/wiley-njd --no-prompt
	quarto add mvuorre/quarto-preprint --no-prompt

paper:
	quarto render --output-dir outputs

clean:
	rm -rf .quarto Arial Helvetica Lato MinionPro MyriadPro NewcenturySchoolBk paper_files Stix Univers *.otf *.pag *.spl *.ttf
