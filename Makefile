files=tables
suffixes=.pdf -2.pdf .html -2.html .docx

render=Rscript -e 'rmarkdown::render("$<", output_format="$(render_output_format)", output_file="$@")' | tee $(@:=.log)
render_output_format=




all: $(foreach f,$(files),$(addprefix $(f),$(suffixes)))

%.pdf: %.Rmd
	$(render)

%-2.pdf: %.Rmd
	$(render)

%.html: %.Rmd
	$(render)

%-2.html: %.Rmd
	$(render)

%.docx: %.Rmd
	$(render)


%.docx: render_output_format=word_document

%.pdf: render_output_format=pdf_document

%-2.pdf: render_output_format=bookdown::pdf_document2

%.html: render_output_format=html_document

%-2.html: render_output_format=bookdown::html_document2


all: render_output_format=all


.PHONY: all


