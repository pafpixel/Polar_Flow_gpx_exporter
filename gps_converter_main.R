#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# require("jsonlite")
# require("stringr")

if(!require("jsonlite"))install.packages("jsonlite")
if(!require("stringr"))install.packages("stringr")

# Functions
source("functions.R")

######################
# test if there is at least one argument (input): if not, return an error
if (length(args)==0) {
  stop("At least an input-folder must be provided.n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = args[1]
}

if(!dir.exists(args[1])) {
  stop("Input folder does not exist.n", call.=FALSE)
}

if(!dir.exists(args[2])) {
  stop("Output folder does not exist.n", call.=FALSE)
}


###### List files
files <- list.files(paste0(args[1],"/"), full.names = F)

# Do conversion
for(file in files) {
  print(paste0("converting: ", file))
  convertJson(file, 
              input_path = paste0(args[1],"/"), 
              output_path = paste0(args[2],"/")
              )
}

print(paste0("Finished converting ",length(files)," files"))


