files=test

render=Rscript -e 'rmarkdown::render("$<", output_format="$(render_output_format)")'
render_output_format=

knitr=Rscript -e 'knitr::knit("$<", output="$@")'

pandoc_flags=
pandoc=pandoc $(pandoc_flags) -o $@ $< 


%.docx %.pdf %.html: %.Rmd
	$(render)

%.docx: render_output_format=word_document
%.pdf: render_output_format=pdf_document
%.html: render_output_format=html_document

%-knitr.md: %.Rmd
	$(knitr)

%-knitr.docx %-knitr.pdf %-knitr.html: %-knitr.md
	$(pandoc)




.PHONY: all_rmarkdown
all_rmarkdown: $(files:=.Rmd)
	$(render)

all_rmarkdown: render_output_format=all



.PHONY: all_knitr
all_knitr: $(files:=-knitr.pdf) $(files:=-knitr.html) $(files:=-knitr.docx)

