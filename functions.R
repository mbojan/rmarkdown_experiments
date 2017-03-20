
out_format <- function() {
  knitr::opts_knit$get("rmarkdown.pandoc.to")
}

to_html <- function()
  identical(out_format(), "html")

to_pdf <- function()
  identical(out_format(), "latex")

to_slidy <- function()
  identical(out_format(), "slidy")

to_word <- function()
  identical(out_format(), "docx")





# anytable ---------------------------------------------




anytable <- function(
  x, 
  ...
  ) {
  fmt <- out_format()
  fun <- switch(
    fmt,
    latex = "anytable_latex",
    html = "anytable_html"
    )
  do.call(fun, c(list(x=x), list(...)))
}


anytable_latex <- function(  x,    ... ) {
  args <- list(...)
  if(!is.null(args$rnames)) {
    vnames <- setdiff(names(x), args$rnames)
    x <- structure(x[,vnames], row.names=x[,args$rnames])
    args$rnames <- NULL
  }
  args$file <- ""
  args$assignment <- FALSE
  args$booktabs <- TRUE
  if(!is.null(args$caption)) {
    args$label <- paste0("tab:", args$label)
  }
  
  fun <- get("latex", asNamespace("Hmisc"))
  
  out <- capture.output(
    do.call(fun, c(list(object=x), args) )
  )
  cat(out[-1], sep="\n")
}



anytable_html <- function(  x,   ...) {
  args <- list(...)
  args$rnames <- FALSE
  if(!is.null(args$cgroup))
    args$cgroup <- c("", args$cgroup)
  if(!is.null(args$n.cgroup))
    args$n.cgroup <- c(1, args$n.cgroup)
  args$compatibility <- "html"
  
  fun <- get("htmlTable", asNamespace("htmlTable"))
  
  
  if(!is.null(args$caption)) {
    cat(paste0(
      "Table: ",
      "(\\#tab:", args$label, ")",
      args$caption,
      "\n\n"
    ) )
    args$caption <- NULL
    args$label <- NULL
  }
  
  do.call(fun, c(list(x=x), args))
}
