files=test

render=Rscript -e 'rmarkdown::render("$<", output_format="$(render_output_format)", output_file="$@")' | tee $(@:=.log)
render_output_format=

knitr=Rscript -e 'knitr::knit("$<", output="$@")'

pandoc_flags=
pandoc=pandoc $(pandoc_flags) -o $@ $< 


all: test.pdf test-book.pdf test.html test-2.html


# %.docx %.pdf %-book.pdf %.html %-2.html: %.Rmd
# 	$(render)

%.pdf: %.Rmd
	$(render)

%-book.pdf: %.Rmd
	$(render)

%.html: %.Rmd
	$(render)

%-2.html: %.Rmd
	$(render)

%.docx: %.Rmd
	$(render)


%.docx: render_output_format=word_document

%.pdf: render_output_format=pdf_document

%-book.pdf: render_output_format=bookdown::pdf_book

%.html: render_output_format=html_document

%-2.html: render_output_format=bookdown::html_document2


all: render_output_format=all




.PHONY: all


