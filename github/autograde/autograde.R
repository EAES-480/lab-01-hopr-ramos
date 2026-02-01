# eaes480-lab01-hopr-level1-autograde
# Level 1 autograding: (1) Rmd renders, (2) required objects exist & pass basic checks.

args <- commandArgs(trailingOnly = TRUE)
rmd <- if (length(args) >= 1) args[[1]] else "lab-01-hopr.Rmd"

fail <- function(msg) {
  cat(sprintf("FAIL: %s\n", msg))
  quit(status = 1)
}

if (!file.exists(rmd)) fail(sprintf("Could not find Rmd file: %s", rmd))

# 1) Render (knit) the document
out_html <- sub("\\.Rmd$", ".html", rmd)
suppressPackageStartupMessages({
  if (!requireNamespace("rmarkdown", quietly = TRUE)) fail("Missing package: rmarkdown")
  if (!requireNamespace("knitr", quietly = TRUE)) fail("Missing package: knitr")
})

cat("Rendering Rmd...\n")
tryCatch({
  rmarkdown::render(
    input = rmd,
    output_format = "html_document",
    output_file = out_html,
    quiet = TRUE,
    envir = new.env(parent = globalenv())
  )
}, error = function(e) {
  fail(paste0("Render failed: ", conditionMessage(e)))
})
cat("Render OK.\n")

# 2) Extract and execute code (purl) in a clean environment, then check required objects
cat("Running required-object checks...\n")
tmp_r <- tempfile(fileext = ".R")
knitr::purl(input = rmd, output = tmp_r, quiet = TRUE)

env <- new.env(parent = baseenv())
# Source extracted code; stop on error
tryCatch({
  sys.source(tmp_r, envir = env)
}, error = function(e) {
  fail(paste0("Executing extracted code failed: ", conditionMessage(e)))
})

# Required objects
req <- c("student_name", "student_netid", "hopr_completed_chapters", "reflection_notes")
missing <- req[!vapply(req, exists, logical(1), envir = env, inherits = FALSE)]
if (length(missing) > 0) fail(paste("Missing required object(s):", paste(missing, collapse = ", ")))

# Type/contents checks
student_name <- get("student_name", envir = env)
student_netid <- get("student_netid", envir = env)
hopr_completed_chapters <- get("hopr_completed_chapters", envir = env)
reflection_notes <- get("reflection_notes", envir = env)

if (!is.character(student_name) || length(student_name) != 1) fail("student_name must be a length-1 character string.")
if (nchar(trimws(student_name)) < 3) fail("student_name looks empty. Please fill it in.")

if (!is.character(student_netid) || length(student_netid) != 1) fail("student_netid must be a length-1 character string.")
if (nchar(trimws(student_netid)) < 2) fail("student_netid looks empty. Please fill it in.")

if (!is.numeric(hopr_completed_chapters) && !is.integer(hopr_completed_chapters)) fail("hopr_completed_chapters must be a numeric/integer vector.")
if (length(hopr_completed_chapters) == 0) fail("hopr_completed_chapters is empty. Put the chapters you completed (e.g., 1:8).")

# Must include 1:8 (order doesn't matter)
needed <- 1:8
if (!all(needed %in% hopr_completed_chapters)) {
  missing_ch <- needed[!(needed %in% hopr_completed_chapters)]
  fail(paste("hopr_completed_chapters is missing chapter(s):", paste(missing_ch, collapse = ", ")))
}

if (!is.character(reflection_notes) || length(reflection_notes) != 1) fail("reflection_notes must be a length-1 character string (can be empty).")

cat("All checks passed.\n")
quit(status = 0)