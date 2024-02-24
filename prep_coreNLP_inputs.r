prep_inputs <- function(x){
    # read all csv_files
    # not complete
    csv_files <- get_csv.files()

    # create list of QA and presentation dfs
    all_QA <- list()
    all_Presentation <- list()

    for(single_csv_file in csv_files){
        single_dataframe = read.csv(single_csv_file)
    
    #  

    }



    return()
}