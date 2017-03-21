

# Catching rmarkdown output format ---------------------




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
  rgroup=NULL,
  n.rgroup=NULL,
  cgroup=NULL,
  n.cgroup=NULL,
  title=deparse(substitute(x)),
  label=NULL,
  caption=NULL,
  ...
  ) {
  fmt <- out_format()
  if(is.null(fmt)) fmt <- "none"
  fun <- switch(
    fmt,
    latex = "anytable_latex",
    html = "anytable_html",
    "i"
    )
  
  i <- function(x, ...) x
  do.call(fun, c(
    list(
      x=x,
      rgroup=rgroup,
      n.rgroup=n.rgroup,
      cgroup=cgroup,
      n.cgroup=n.cgroup,
      title=title,
      label=label,
      caption=caption
    ),
    list(...)
  ) )
}


anytable_latex <- function(  x,    ... ) {
  message("latex")
  args <- list(...)
  if(!is.null(args$rnames)) {
    vnames <- names(x)[ -which( names(x) == args$rnames) ]
    x <- structure(x[,vnames], row.names=x[,args$rnames], names=vnames)
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
  message("html")
  args <- list(...)
  args$rnames <- FALSE
  if(!is.null(args$cgroup))
    args$cgroup <- c("", args$cgroup)
  if(!is.null(args$n.cgroup))
    args$n.cgroup <- c(1, args$n.cgroup)
  args$compatibility <- "html"
  if(!is.null(args$title)) {
    names(x)[1] <- args$title
    args$title <- NULL
  }
  args$align <- c("l", rep("r", ncol(x)-1))
  
  x[is.na(x)] <- ""
  
  fun <- get("htmlTable", asNamespace("htmlTable"))
  
  if(!is.null(args$caption)) {
    args$caption <- paste0(
      "(#tab:", args$label, ")",
      args$caption,
      "\n\n"
    )
  }
  
  do.call(fun, c(list(x=x), args))
}

