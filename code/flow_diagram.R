library(DiagrammeR)
library(dplyr)

# Your consort_table data
project_location <- '~/Library/CloudStorage/OneDrive-JohnsHopkins/Research Projects/CLIF/CLIF_Projects/CLIF_PF-to-SF/federated_summary_analysis'
consort_data <- read.csv(paste0(project_location, '/tables/consort_overall.csv')) 

#Prepare Data
consort_data <- consort_data |>
  filter(!step=='N Encounters for Adults In Registry During Study Time Frame',
         !step=='n, Undefined oxygenation (no eligible SF)')

consort_labels <- consort_data %>%
  mutate(
    short_label = c(
      "Admitted to Hospital via ED",
      "Respiratory Support >24h In First 7 Days",
      "FiO2 Recorded in 1st 24 Hours",
      "No Tracheostomy at Vent Initiation",
      "Not Do-Not-Intubate",
      "Eligible PF/SF Ratios",
      "Respiratory Failure Before 2025",
      "Final Cohort"
    ),
    node_id = c("A", "B", "C", "D", "E", "F", "G", "I"),
    exc_id = c("EX0", "EX1", "EX2", "EX3", "EX4", "EX5", "EX6", "EX7"),
    included_fmt = format(included, big.mark = ","),
    included_fmt=trimws(included_fmt),
    excluded_fmt = format(excluded, big.mark = ","),
    excluded_fmt = trimws(excluded_fmt),
    label = paste0(short_label, "\nn=",included_fmt),
    exc_label = paste0("Excluded: n=",excluded_fmt),
    # Mark which are main flow vs exclusion criteria
    type = c("main", "main", "exclusion", "exclusion", "exclusion", 
             "exclusion", "exclusion", "main")
  )

#Extra Row
consort_extra <- consort_labels |>
  filter(short_label=='Respiratory Failure Before 2025') |>
  mutate(short_label = c("Eligible Encounters"),
  node_id = c("H"),
  exc_id = c("EX8"),
  included_fmt = format(included, big.mark = ","),
  included_fmt=trimws(included_fmt),
  excluded_fmt = format(excluded, big.mark = ","),
  excluded_fmt = trimws(excluded_fmt),
  label = paste0(short_label, "\nn=",included_fmt),
  exc_label = paste0("Excluded: n=",excluded_fmt),
  # Mark which are main flow vs exclusion criteria
  type = c("main")
  )
consort_labels <- consort_labels |>
  rbind(consort_extra)

# Main flow nodes (A, B, H, I)
main_node_defs <- consort_labels %>%
  filter(type == "main") %>%
  mutate(node_str = paste0(node_id, " [label='", label, "', shape=box, style=filled, fillcolor='#B3E5FC', fontname=Arial, fontsize=11, fontweight=bold]")) %>%
  pull(node_str) %>%
  paste(collapse = "\n  ")

# Exclusion criteria nodes (C, D, E, F, G)
exc_node_defs <- consort_labels %>%
  filter(type == "exclusion") %>%
  mutate(exc_str = paste0(node_id, " [label='", label, "\n(Excluded:n=",excluded_fmt,")', shape=box, style=filled, fillcolor='#FFCDD2', fontname=Arial, fontsize=9]")) %>%
  pull(exc_str) %>%
  paste(collapse = "\n  ")

# Add extra exclusion node between H and I
duplicates_excluded <- consort_labels$excluded_fmt[consort_labels$node_id == "I"]
dup_exc_node <- paste0("DUP [label='1 Encounter Randomly Selected per Patient\n Excluded:\nn=",duplicates_excluded,"', shape=box, style=filled, fillcolor='#FFCDD2', fontname=Arial, fontsize=9]")

# Create main flow edges: A -> B -> H -> DUP -> I
main_edges <- "A -> B -> H -> DUP -> I"

# Create edges from B to exclusion criteria (C, D, E, F, G)
exc_edges_from_b <- consort_labels %>%
  filter(type == "exclusion") %>%
  mutate(edge_str = paste0("B -> ", node_id)) %>%
  pull(edge_str) %>%
  paste(collapse = "\n  ")

# Dashed edges from exclusions to H
exc_edges_to_h <- consort_labels %>%
  filter(type == "exclusion") %>%
  mutate(edge_str = paste0(node_id, " -> H [style=invis]")) %>%
  pull(edge_str) %>%
  paste(collapse = "\n  ")

# Combine into grViz string
diagram_str <- paste0("
digraph CONSORT {
  graph [rankdir=TB, bgcolor=white, margin=0.5, splines=ortho]
  node [shape=box, style=filled, fontname=Arial]
  
  # Main flow nodes
  ", main_node_defs, "
  
  # Exclusion criteria nodes
  ", exc_node_defs, "
  
  # Extra exclusion node
  ", dup_exc_node, "
  
  # Main flow edges
  ", main_edges, "
  
  # Edges from Resp Support to exclusion criteria
  ", exc_edges_from_b, "
  
  # Dashed edges from exclusions to Eligible Patient Encounters
  ", exc_edges_to_h, "
}
")

# Create and display the diagram
consort_diagram <- grViz(diagram_str)
consort_diagram

#Save# 2. Convert to SVG, then save as png
tmp = DiagrammeRsvg::export_svg(consort_diagram)
tmp = charToRaw(tmp) # flatten
rsvg::rsvg_png(tmp, 
               file=paste0(project_location, '/graphs/consort_diagram.png')) # saved graph as png in current working directory

rsvg::rsvg_pdf(tmp, 
               file=paste0(project_location, '/graphs/consort_diagram.pdf'))
