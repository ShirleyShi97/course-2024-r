# Data and model paths
data_path <- "data/"
model_path <- "data/models/"
# ==== parsing pdfs ====

# where to put raw pdf files
pdf_path <- "Data/pdfs/raw/" 

# where to put parsed pdf files (in csv format)
pdf_parsed_path <- "Data/pdfs/parsed/"

# number of CPU cores to use for parsing
n_cores <- 4 

# create nessesary folders
dir.create(data_path, recursive = TRUE, showWarnings = FALSE)
dir.create(model_path, recursive = TRUE, showWarnings = FALSE)
dir.create(pdf_path, recursive = TRUE, showWarnings = FALSE)
dir.create(pdf_parsed_path, recursive = TRUE, showWarnings = FALSE)

# ==== training word2vec model ====
