#Working Directory
cd ~/Library/CloudStorage/OneDrive-JohnsHopkins/Research\ Projects/CLIF/CLIF_Projects/CLIF_PF-to-SF/CLIF_PFvsSF_Performance

#Convert the Desired File into Rscript
Rscript -e "knitr::purl('code/02_pf_sf_central_federated_analysis.Rmd', output = 'code/02_analysis.R', documentation = 1)"

#Run the Federated File
caffeinate Rscript -e "source('code/02_analysis.R', echo = TRUE)" > "$HOME/Library/CloudStorage/OneDrive-JohnsHopkins/Research Projects/CLIF/CLIF_Projects/CLIF_PF-to-SF/federated_summary_analysis/log/02_federated_log.log" 2>&1
