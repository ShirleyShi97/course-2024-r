prep_inputs <- function() {
  library(tools)
  # goto data location
  setwd(
    "/Users/shirleyshi/course/The-Role-of-Corporate-Culture-in-Bad-Times/data"
  )

  # read all csv_files
  csv_files <- list.files(
    path = paste(getwd(), "/pdfs/parsed", sep = ""), # 待优化
    pattern = "*.csv", recursive = TRUE, full.names = TRUE,
    include.dirs = TRUE
  )

  # prepare var to store data
  all_transcripts <- read.csv(csv_files[1])
  # df = Title,ROUND......text
  #      aaa,QA,textext
  #    ....
  all_transcripts$"call_title_date" <- NA
  # df = Title,ROUND......text,call_title_date
  #      aaa,QA,textext
  #    ....
  all_transcripts <- all_transcripts[0, !names(all_transcripts) == "Title"]

  # df = ROUND......text,call_title_date
  #

  for (single_call_csv in csv_files) {
    # read silgle csv into df
    call_csv_dataframe <- read.csv(single_call_csv)

    # 插入一列名为call_title_date,内容是当前csv的文件名不含扩展
    call_csv_dataframe$"call_title_date" <-
      tools::file_path_sans_ext(basename(single_call_csv))

    # 删除名为 Title的列
    # 实际操作是，将所有列提取出来，除了 Title 列以外，并装回原变量里
    call_csv_dataframe <-
      call_csv_dataframe[, !names(call_csv_dataframe) == "Title"]
    # concat call_csv_dataframe to all_transcripts
    all_transcripts <- rbind(all_transcripts, call_csv_dataframe)
  }
  # 以"call_title_date", "ROUND", "Paragraph"为顺序进行排列
  all_transcripts <-
    all_transcripts[
      order(
        all_transcripts$call_title_date,
        all_transcripts$ROUND,
        all_transcripts$Paragraph
      ),
    ]

  # 新增一个列，名为 Paragraph_ID 每列的内容是对应列的 call_title_date--ROUND--Paragraph
  # 举例："Bank7 Corp., Q1 2020 Earnings Call, Apr 30, 2020 2020-04-30--QA--7"
  all_transcripts$"Paragraph_ID" <-
    paste(
      all_transcripts$"call_title_date",
      "--",
      all_transcripts$"ROUND",
      "--",
      all_transcripts$"Paragraph",
      sep = ""
    )

  # 将metadata_clean装载为DF
  # only use US earnings calls (hand-collected and checked)
  cleaned_meta <-
    read.csv(
      paste(getwd(), "/meta_data_cleaned.csv", sep = "")
    )

  # 新增一个列，名为 call_title_date每列的内容是对应列的 call_title拼接日期
  cleaned_meta$"call_title_date" <-
    paste(
      cleaned_meta$"call_title",
      " ",
      # date_EST 形如 4/9/20，转换为2020-04-09

      cleaned_meta$"date_EST",
      sep = ""
    )


  # 将 cleaned_meta 中，call_title_data 值重复的条目删掉
  # cleaned_meta <- duplicated(cleaned_meta$"call_title_date")
  # 待完善


  # 新增一个列，include_sample ，值为1
  cleaned_meta$"include_sample" <- 1

  # 仅取call_title_date 和 include_sample 两列，组成一个序列
  cleaned_meta <- cleaned_meta[, c("call_title_date", "include_sample")]

  # 挑选all_transcripts中call_title_date 相等的列，将对应的include_sample值填入
  all_transcripts <- merge(
    x = all_transcripts,
    y = cleaned_meta,
    by = "call_title_date"
  )
  return(all_transcripts)
}

# 用于输出文件的函数
output_input <- function(all_transcripts_param) {
  write.table(all_transcripts["Paragraph_ID"],
    file = "document_ids.txt",
    quote = FALSE,
    append = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )
  write.table(all_transcripts["text"],
    file = "documents.txt",
    quote = FALSE,
    append = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )
}

# 调用刚才定义的函数
all_transcripts <- prep_inputs()
output_input(all_transcripts)
