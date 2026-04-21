#!/usr/bin/env Rscript

# Pre-render script to generate all Quarto formats (HTML + RevealJS)
# This ensures that RevealJS slides are available when pkgdown builds the site

cat("Pre-rendering Quarto documents to all formats...\n")

# Check if quarto package is available
if (!requireNamespace("quarto", quietly = TRUE)) {
  stop("quarto package is required but not installed. Please install it with: install.packages('quarto')")
}

# Find all .qmd files in vignettes (but exclude data-raw)
qmd_files <- list.files(
  path = "vignettes",
  pattern = "\\.qmd$",
  recursive = TRUE,
  full.names = TRUE
)

if (length(qmd_files) == 0) {
  cat("No Quarto (.qmd) files found in vignettes/\n")
  quit(status = 0)
}

# Render each file to all formats
errors <- character()
for (qmd_file in qmd_files) {
  cat(sprintf("Rendering %s...\n", qmd_file))
  
  # Get the formats defined in the file's YAML
  # We'll render each format separately to avoid hanging issues
  formats_to_render <- c("html", "revealjs", "docx")
  
  for (format in formats_to_render) {
    # Try up to 2 times in case of transient failures
    max_attempts <- 2
    attempt <- 1
    success <- FALSE
    
    while (attempt <= max_attempts && !success) {
      tryCatch({
        if (attempt > 1) {
          cat(sprintf("Retry attempt %d for %s to %s\n", attempt, qmd_file, format))
          Sys.sleep(2)  # Small delay before retry
        }
        # Render to specific format
        quarto::quarto_render(qmd_file, output_format = format, quiet = FALSE)
        cat(sprintf("Successfully rendered %s to %s\n", qmd_file, format))
        success <- TRUE
      }, error = function(e) {
        error_msg <- sprintf("Error rendering %s to %s (attempt %d): %s", qmd_file, format, attempt, e$message)
        cat(error_msg, "\n")
        if (attempt >= max_attempts) {
          errors <<- c(errors, error_msg)
        }
        attempt <<- attempt + 1
      })
      
      if (!success) {
        attempt <- attempt + 1
      }
    }
  }
}

cat("Pre-rendering complete!\n")

# Exit with error if any renders failed
if (length(errors) > 0) {
  cat("\nErrors occurred during rendering:\n")
  cat(paste(errors, collapse = "\n"), "\n")
  quit(status = 1)
}

