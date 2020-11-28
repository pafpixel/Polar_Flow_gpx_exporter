# Functions for json - to gpx converter

##############  Main-function that takes care of the comple data processing from disk to disk ############## 
convertJson <- function(file, input_path, output_path) {

  if (str_detect( tolower(file), "json")) {
    # if json
    polar_object <- readPolarJson(file, input_path)
    
  } else if (str_detect( tolower(file), "htm")){
    # if html
    polar_object <- readPolarHtml(file, input_path)
    
  } else {
    stop("Error: Input file must be html or json", call.=FALSE)
  }
  
  gpx_string <- convertPolarObject(polar_object, file)
  writeGpxToDisk(gpx_string, file, output_path)
}

############## Reader for the Polar-Json-Object ############## 
# Returns parsed json object
readPolarJson <- function(file, input_path) {
  polar_object <- read_json(paste0(args[1],"/",file))
  return(polar_object)
}


############## Reader for the Polar html of session overview ############## 
readPolarHtml <- function(file, input_path){
  polar_flow_html <- readLines(paste0(args[1],"/",file))
  
  data_json  <- polar_flow_html[str_detect(polar_flow_html,'"samples\":')]
  coord_json <- substr(data_json,
                       str_locate(data_json,'"samples\":')[1,1]+10,
                       str_locate(data_json,'],"club":')[1,1])
  
  coord_object <- parse_json(coord_json)
}


############## converts the polarobject into a gpx-style xml-string ############## 
convertPolarObject <- function(polar_object, file) {
  gpx_header <-   '<?xml version="1.0" encoding="UTF-8"?>\n<gpx version="1.1" creator="bs">\n'
  gpx_metadata <- paste0("<metadata>\n<name>",file,"</name>\n",
                         "<author>\n<name>bs</name>\n</author>\n‚",
                         "<time>", Sys.time(),"</time>\n","</metadata>\n")
  gpx_segstart <- paste0('<trk>','<name>',file,'</name>\n', '<trkseg>\n')
  gpx_footer <- '</trkseg>\n</trk>\n</gpx>'
  
  # All other meta-information of objects seen so far is NULL, so waypoints is the only interesting thing.
  wp_strings <- list()
  
  if (!is.null(polar_object$gpsRoute)){
    # For objects extracted from favorites
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
    
  } else if (!is.null(polar_object$exercises)) {
    # skip sports like indoor cycling without track
    # For objects from the official polar data export
    if (!is.null(polar_object$exercises[[1]]$samples$recordedRoute)) {
      for(i in 1:length(polar_object$exercises[[1]]$samples$recordedRoute)){
        current_wp <- polar_object$exercises[[1]]$samples$recordedRoute[[i]]
        wp_string <- paste0(
          '<trkpt lat="', format(round(current_wp$latitude,8),nsmall = 8),
          '" lon="', format(round(current_wp$longitude,8),nsmall = 8),'">\n',
          "<ele>", round(current_wp$altitude, digits = 4), "</ele>\n",
          "<time>",current_wp$dateTime,"</time>\n",
          "</trkpt>\n"
        )
        wp_strings[[i]] <- wp_string
      }
    } #else {next}
    
  } else {
    # For objects extracted from session html
    for(i in 1:length(polar_object)){
      current_wp <- polar_object[[i]]
      wp_string <- paste0(
        '<trkpt lat="', format(round(polar_object[[i]][[1]]$lat,8),nsmall = 8),
        '" lon="', format(round(polar_object[[i]][[1]]$lon,8),nsmall = 8),'">\n',
        "<time>",as.POSIXct(polar_object[[1]][[2]] / 1000, origin="1970-01-01"),"</time>\n",
        "</trkpt>\n"
      )
      wp_strings[[i]] <- wp_string
    }
  }
  
  
  
  gpx_string <- paste0(gpx_header, 
                       gpx_metadata, 
                       gpx_segstart, 
                       paste(wp_strings , collapse = ""),
                       gpx_footer)
  
  return(gpx_string)
}


############## Writer function to write gpx to disk ############## 
writeGpxToDisk <- function(gpx_string, file, output_path) {
  filename <- paste(output_path,
                    "/" ,
                    str_replace_all(file,pattern = c(".json" = ".gpx", ".html"= ".gpx", ".htm"= ".gpx")),
                    sep = "")
  cat(gpx_string, file = filename, sep = "")
}

