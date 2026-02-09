# one_click_run.R
# One-click setup and execution for CLIF_PFvsSF_Performance
# Repository: https://github.com/Common-Longitudinal-ICU-data-Format/CLIF_PFvsSF_Performance

cat("=" , rep("=", 70), "=\n", sep = "")
cat("CLIF PF vs SF Performance Analysis - One-Click Setup\n")
cat("=", rep("=", 70), "=\n", sep = "")

# Clear environment
rm(list = ls())

# Set working directory to script location (if using RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Function to install and load packages
install_and_load <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(paste("Installing", pkg, "...\n"))
      install.packages(pkg, dependencies = TRUE, repos = "https://cloud.r-project.org/")
      library(pkg, character.only = TRUE)
    } else {
      cat(paste("✓", pkg, "already installed\n"))
      library(pkg, character.only = TRUE)
    }
  }
}

# List required packages based on the repository
required_packages <- c(
  "rmarkdown"    # R Markdown support
)

# Install and load packages
cat("\n[1/4] Checking and installing required packages...\n")
install_and_load(required_packages)

# Create necessary directories
cat("\n[2/4] Setting up R Markdown directory...\n")
dirs_to_create <- c("markdown_output")
for (dir_name in dirs_to_create) {
  if (!dir.exists(dir_name)) {
    dir.create(dir_name, recursive = TRUE)
    cat(paste("  Created directory:", dir_name, "\n"))
  } else {
    cat(paste("  ✓ Directory exists:", dir_name, "\n"))
  }
}

# Source main analysis scripts
cat("\n[3/4] Running analysis scripts...\n")

# Check which R scripts exist and source them
r_scripts <- list.files(pattern = "\\.R$", ignore.case = TRUE)
r_scripts <- r_scripts[r_scripts != "one_click_run.R"]  # Exclude this script

if (length(r_scripts) > 0) {
  cat(paste("  Found", length(r_scripts), "R script(s) to execute\n"))
  for (script in r_scripts) {
    cat(paste("\n  Executing:", script, "\n"))
    tryCatch({
      source(script)
      cat(paste("  ✓ Completed:", script, "\n"))
    }, error = function(e) {
      cat(paste("  ✗ Error in", script, ":", e$message, "\n"))
    })
  }
} else {
  cat("  No additional R scripts found in root directory\n")
}

# Check for RMarkdown files
cat("\n  Searching for R Markdown files...\n")
rmd_files <- list.files(path = ".", pattern = "\\.Rmd$", ignore.case = TRUE, recursive = TRUE, full.names = TRUE)

if (length(rmd_files) > 0) {
  cat(paste("  Found", length(rmd_files), "R Markdown file(s):\n"))
  for (rmd_file in rmd_files) {
    cat(paste("    -", rmd_file, "\n"))
  }
  
  cat("\n  Rendering R Markdown files...\n")
  for (rmd_file in rmd_files) {
    cat(paste("  Rendering:", rmd_file, "...\n"))
    tryCatch({
      rmarkdown::render(rmd_file, output_dir = "markdown_output")
      cat(paste("  ✓ Completed:", rmd_file, "\n"))
    }, error = function(e) {
      cat(paste("  ✗ Error rendering", rmd_file, ":", e$message, "\n"))
    })
  }
} else {
  cat("  No R Markdown files found\n")
}
# Final summary
cat("\n", rep("=", 72), "\n", sep = "")
cat("Setup Complete!\n")
cat(rep("=", 72), "\n", sep = "")
cat("\nNext steps:\n")
cat("1. Ensure your CLIF data files are in the 'data/' directory\n")
cat("2. Check the 'markdown_output/' for results\n")
cat("3. Review any error messages above\n")
cat("\nFor more information, see the repository README:\n")
cat("https://github.com/Common-Longitudinal-ICU-data-Format/CLIF_PFvsSF_Performance\n")
cat("\n")

# Session info for reproducibility
cat("\nSession Information:\n")
print(sessionInfo())