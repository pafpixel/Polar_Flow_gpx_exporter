# Functions for json - to gpx converter

# Main-function that takes care of the comple data processing from disk to disk
convertJson <- function(file, input_path, output_path) {
  polar_object <- readPolarJson(file, input_path)
  gpx_string <- convertPolarObject(polar_object, file)
  writeGpxToDisk(gpx_string, file, output_path)
}

# Reader for the Polar-Json-Object
# Returns parsed json object
readPolarJson <- function(file, input_path) {
  polar_object <- read_json(paste0(args[1],"/",file))
  return(polar_object)
}

# converts the polarobject into a gpx-style xml-string
convertPolarObject <- function(polar_object, file) {
  gpx_header <-   '<?xml version="1.0" encoding="UTF-8"?>\n<gpx version="1.1" creator="bs">\n'
  gpx_metadata <- paste0("<metadata>\n<name>",file,"</name>\n",
                         "<author>\n<name>bs</name>\n</author>\n‚",
                         "<time>", Sys.time(),"</time>\n","</metadata>\n")
  gpx_segstart <- paste0('<trk>','<name>',file,'</name>\n', '<trkseg>\n')
  gpx_footer <- '</trkseg>\n</trk>\n</gpx>'
  
  # All other meta-information of objects seen so far is NULL, so waypoints is the only interesting thing.
  wp_strings <- list()
  timestamp <- Sys.time()
  
  for(i in 1:length(polar_object$gpsRoute$waypoints)){
    current_wp <- polar_object$gpsRoute$waypoints[[i]]
    wp_string <- paste0(
      '<trkpt lat="', format(round(current_wp$latitude,8),nsmall = 8),
      '" lon="', format(round(current_wp$longitude,8),nsmall = 8),'">\n',
      "<ele>", round(current_wp$altitude, digits = 4), "</ele>\n",
      "<time>",timestamp+i,"</time>\n",
      "</trkpt>\n"
    )
    wp_strings[[i]] <- wp_string
  }
  
  gpx_string <- paste0(gpx_header, 
                       gpx_metadata, 
                       gpx_segstart, 
                       paste(wp_strings , collapse = ""),
                       gpx_footer)
  
  return(gpx_string)
}

writeGpxToDisk <- function(gpx_string, file, output_path) {
  filename <- paste(output_path,"/" ,substr(file, 1, nchar(file)-4), "gpx", sep = "")
  cat(gpx_string, file = filename, sep = "")
}

