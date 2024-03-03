
library(tools)

prep_inputs <- function(x) {
  
  # goto data location
  setwd("/Users/shirleyshi/course/The-Role-of-Corporate-Culture-in-Bad-Times/data")
  csv_files <- list.files(
    path = paste(getwd(), "/pdfs/parsed", sep = ""),
    pattern = "*.csv", recursive = TRUE, full.name = TRUE,
    include.dirs = TRUE)
  
  all_QA <- list()
  all_Presentation <- list()
  all_transcripts <- list()

  for (single_call_csv in csv_files) {
    # read single csv into df
    call_csv_dataframe <- read.csv(single_call_csv)
    #create call primary id as call_title_data
    call_csv_dataframe$"call_title_date" <-
      tools::file_path_sans_ext(single_call_csv)
    #删除名为Title的列
    call_csv_dataframe <-
      call_csv_dataframe[, !names(call_csv_dataframe) == "Title"]
    
    all_transcripts <- all_transcripts[[length(all_transcripts)+1]] <- call_csv_dataframe
  }
  print(all_transcripts)


  return(csv_files)
}

prep_inputs()