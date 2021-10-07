# note on this practical: what he wants:
# need to have a compiled LateX script that'll generate this document - and embellish it as much as you like

# need to make sure that CompileLaTeX.sh ill work if someone else ran it from their computer using FirstExample.tex as an input

# this script compiles LaTeX with Bibtex

#!/bin/bash
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg
