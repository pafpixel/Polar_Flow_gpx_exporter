#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# for_dev:
args = c("input", "output")

require("jsonlite")

# Functions
source("functions.R")


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
  print(file)
  convertJson(file, 
              input_path = paste0(args[1],"/"), 
              output_path = paste0(args[2],"/")
              )
}


