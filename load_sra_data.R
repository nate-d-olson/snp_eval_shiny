# Generating data frame with sra data
#loading files
get_data <- function () {
  files <- grep("csv",list.files(path = "sra_list"), value = T)
  sra_df <- ldply(str_c("sra_list/",files, sep = ""),read.csv,stringsAsFactors=F,header=T)
  
  # removing NA columns
  sra_df <- sra_df[,colSums(is.na(sra_df))<nrow(sra_df)]
  
  # removing non-whole genome sequencing datasets
  sra_df <- sra_df[!(sra_df$LibraryStrategy %in% c("MeDIP-Seq","ChIP-Seq")),]
  sra_df <- sra_df[sra_df$LibrarySelection != "PCR",]
  
  # Excluding Ecoli MV straings
  sra_df <- sra_df[!grepl("MV",sra_df$ScientificName),]
  
  # removing columns not needed for summary table
  sra_df <- subset(sra_df, select = -c(ReleaseDate, LoadDate, size_MB, spots, bases, spots_with_mates, avgLength, AssemblyName, Experiment, SRAStudy, BioProject, Study_Pubmed_id, Tumor,TaxID, Submission, Consent, RunHash, ReadHash, LibrarySource, InsertSize, InsertDev,BioSample,LibraryName, LibraryStrategy, LibrarySelection, ProjectID, Platform,LibraryLayout,SampleName))
  sra_df$Dataset <- sra_df$download_path #str_c("[",sra_df$Run,"]","(",sra_df$download_path,")", sep = "")
  sra_df$Run <- NULL; sra_df$download_path <- NULL
  
  return(sra_df)
}