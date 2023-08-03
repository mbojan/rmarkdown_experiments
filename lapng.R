
# Produce PNG with LaTeX output -------------------------------------------

library(whisker)

template <- paste(
  "\\documentclass{article}",
  "\\pagestyle{empty}",
  "\\begin{document}",
  "{{{body}}}",
  "\\end{document}",
  sep="\n"
)

l <- list(
  body = "
\\begin{tabular}{ll}
\\hline
1 & 2 \\\\
\\hline
1 & 2 \\\\
3 & 4 \\\\
\\hline
\\end{tabular}
  "
)

f <- whisker.render(template, data=l)
fname <- tempfile()

writeLines(f, fname)


# Make pdf
system2("latexmk", c(
  "-pdf", 
  paste("-outdir", dirname(fname), sep="="),
  fname)
  )

# Crop
system2("pdfcrop", paste0(fname, ".pdf"))

# Image magick
system2("convert", c(
  "-density 500",
  paste0(fname, "-crop.pdf"),
  paste0("PNG32:", fname, ".png")
)
)

file.show(paste0(fname, ".png"))




# Make dvi
system2("latexmk", c(
  "-dvi", 
  paste("-outdir", dirname(fname), sep="="),
  fname)
)

system2("dvipng", c(
  "-T tight",
  paste0(fname, ".dvi")
)
)

file.show(paste0(fname, ".png"))
