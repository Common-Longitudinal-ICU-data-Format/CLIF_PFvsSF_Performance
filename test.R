# run_all.R
# Sequential script for CLIF PF vs SF Performance Analysis with progress

cat("========================================================================\n")
cat("CLIF PF vs SF Performance Analysis\n")
cat("========================================================================\n\n")

# Function to install and load packages
install_and_load <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  } else {
    library(pkg, character.only = TRUE)
  }
}

# Install required packages
cat("[Setup] Installing/loading required packages...\n")
install_and_load("rmarkdown")

# Create output directory
if (!dir.exists("markdown_output")) {
  dir.create("markdown_output", recursive = TRUE)
  cat("[Setup] Created directory: markdown_output\n\n")
}

# Define R Markdown files
rmd_files <- c(
  "code/00_pf_sf_local_cohort_id.Rmd",
  "code/01_pf_sf_local_analysis.Rmd"
)

# Progress bar function
show_progress <- function(message, current, total, width = 40) {
  pct <- current / total
  filled <- round(width * pct)
  bar <- paste0(
    "[",
    paste(rep("=", filled), collapse = ""),
    ifelse(filled < width, ">", ""),
    paste(rep(" ", max(0, width - filled - 1)), collapse = ""),
    "] ",
    sprintf("%3.0f%%", pct * 100),
    " - ", message
  )
  cat("\r", bar, sep = "")
  if (current == total) cat("\n")
  flush.console()
}

# Function to render a single R Markdown file
render_rmd <- function(rmd_file, file_num, total_files) {
  cat("\n========================================================================\n")
  cat(paste("File", file_num, "of", total_files, ":", basename(rmd_file), "\n"))
  cat("========================================================================\n\n")
  
  if (!file.exists(rmd_file)) {
    cat("✗ File not found:", rmd_file, "\n")
    return(FALSE)
  }
  
  # Start rendering
  cat("Starting render...\n")
  start_time <- Sys.time()
  
  result <- tryCatch({
    # Render in a new environment to isolate it
    rmarkdown::render(
      input = rmd_file,
      envir = new.env(),
      quiet = FALSE
    )
  }, error = function(e) {
    cat("\n✗ Error:", e$message, "\n")
    return(NULL)
  }, warning = function(w) {
    cat("\n⚠ Warning:", w$message, "\n")
    return(NULL)
  })
  
  end_time <- Sys.time()
  elapsed <- as.numeric(difftime(end_time, start_time, units = "secs"))
  
  if (!is.null(result)) {
    cat("\n✓ Successfully rendered in", round(elapsed, 1), "seconds\n")
    cat("  Output:", result, "\n")
    return(TRUE)
  } else {
    cat("\n✗ Failed to render\n")
    return(FALSE)
  }
}

# Overall progress
cat("\n")
cat("Overall Progress:\n")
show_progress("Starting...", 0, length(rmd_files))

# Track results
results <- vector("list", length(rmd_files))

# Render each file
for (i in seq_along(rmd_files)) {
  # Update overall progress
  show_progress(paste("Processing file", i), i - 1, length(rmd_files))
  
  # Render the file
  results[[i]] <- render_rmd(rmd_files[i], i, length(rmd_files))
  
  # Clear environment after each file to prevent interference
  # (except for the functions we need)
  rm(list = setdiff(ls(), c("rmd_files", "results", "i", "show_progress", 
                            "render_rmd", "install_and_load")))
  gc()  # Garbage collection
}

# Final overall progress
show_progress("Complete!", length(rmd_files), length(rmd_files))

# Final summary
cat("\n========================================================================\n")
cat("Analysis Complete!\n")
cat("========================================================================\n\n")

# Summary of results
cat("Summary:\n")
for (i in seq_along(rmd_files)) {
  status <- ifelse(results[[i]], "✓ SUCCESS", "✗ FAILED")
  cat(paste("  ", status, "-", basename(rmd_files[i]), "\n"))
}

# List generated files
cat("\nGenerated files:\n")
output_files <- list.files("markdown_output", pattern = "\\.html$", full.names = TRUE)
if (length(output_files) > 0) {
  for (f in output_files) {
    file_size <- file.info(f)$size
    cat(paste("  -", f, paste0("(", round(file_size/1024, 1), " KB)"), "\n"))
  }
} else {
  cat("  (No HTML files found)\n")
}

cat("\nSession Information:\n")
print(sessionInfo())