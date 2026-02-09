# one_click_run.R
# One-click setup and execution for CLIF_PFvsSF_Performance
# Repository: https://github.com/Common-Longitudinal-ICU-data-Format/CLIF_PFvsSF_Performance

cat("=" , rep("=", 70), "=\n", sep = "")
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
# Check for RMarkdown files
# Render specific RMarkdown files
cat("\n  Rendering R Markdown files...\n")

# List the specific .Rmd files you want to render (in order)
rmd_files_to_render <- c(
  "code/00_pf_sf_local_cohort_id.Rmd"
  # Add more files as needed
)

for (j in seq_along(rmd_files_to_render)) {
  current_rmd <- rmd_files_to_render[j]
  
  # Check if file exists
  if (!file.exists(current_rmd)) {
    cat(paste("  ⚠ Skipping (file not found):", current_rmd, "\n"))
    next
  }
  
  cat(paste("  [", j, "/", length(rmd_files_to_render), "] Rendering:", current_rmd, "...\n"))
  
  result <- try({
    rmarkdown::render(
      input = current_rmd,
      envir = new.env(),
      quiet = FALSE
    )
  }, silent = TRUE)
  
  if (inherits(result, "try-error")) {
    cat(paste("  ✗ Error rendering", basename(current_rmd), "\n"))
    cat(paste("    Error message:", attr(result, "condition")$message, "\n"))
  } else {
    cat(paste("  ✓ Completed:", basename(current_rmd), "\n"))
    cat(paste("    Output:", result, "\n"))
  }
  cat("\n")
}

#Repeat for Second R Markdown
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
# Check for RMarkdown files
# Render specific RMarkdown files
cat("\n  Rendering R Markdown files...\n")

# List the specific .Rmd files you want to render (in order)
rmd_files_to_render <- c(
  "code/01_pf_sf_local_analysis.Rmd"
  # Add more files as needed
)

for (j in seq_along(rmd_files_to_render)) {
  current_rmd <- rmd_files_to_render[j]
  
  # Check if file exists
  if (!file.exists(current_rmd)) {
    cat(paste("  ⚠ Skipping (file not found):", current_rmd, "\n"))
    next
  }
  
  cat(paste("  [", j, "/", length(rmd_files_to_render), "] Rendering:", current_rmd, "...\n"))
  
  result <- try({
    rmarkdown::render(
      input = current_rmd,
      envir = new.env(),
      quiet = FALSE
    )
  }, silent = TRUE)
  
  if (inherits(result, "try-error")) {
    cat(paste("  ✗ Error rendering", basename(current_rmd), "\n"))
    cat(paste("    Error message:", attr(result, "condition")$message, "\n"))
  } else {
    cat(paste("  ✓ Completed:", basename(current_rmd), "\n"))
    cat(paste("    Output:", result, "\n"))
  }
  cat("\n")
}

# Final summary
cat("\n", rep("=", 72), "\n", sep = "")
cat("Setup Complete!\n")
cat(rep("=", 72), "\n", sep = "")
cat("\nNext steps:\n")
cat("1. Ensure your CLIF data files are in the 'data/' directory\n")
cat("2. Check the 'output/' for results\n")
cat("3. Review any error messages above\n")
cat("\nFor more information, see the repository README:\n")
cat("https://github.com/Common-Longitudinal-ICU-data-Format/CLIF_PFvsSF_Performance\n")
cat("\n")

# Session info for reproducibility
cat("\nSession Information:\n")
print(sessionInfo())