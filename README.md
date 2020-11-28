**Polar Flow GPX Exporter / Converter**

Currently it is not possible to export your favorite tracks from flow.polar.com.

You can however 
* download your session history
* extract a json-string from your favorite routes on flow.polar.com with 500 gps-waypoints.
* extract the complete html of your session (including the data)

**How to download your data**
* Go to account.polar.com and click "download your data"
* You will get a bunch of json files
* Converter will work with your "session" json files

**How To export favorites:**
* Got to Favorites
* Click on the desired item
* Your browser sends a request to: https://flow.polar.com/api/favorites/exerciseTarget/123456789
* 123456789 is the unique ID of your route
* Reponse is a json object which you can save and use as input for this converter.

**How to export Session GPX:**
* Go to the overview of a session, e.g. https://flow.polar.com/training/analysis/123456789
* save page as html (file might be a .htm - that's fine)
* put htm / html in input folder


You need to specify the inputfolder and the outputfolder when running the script.
If no output folder is specified, the files are saved in the input folder.

**Run the converter:**
Run from folder with the gps_converter_main.R and functions.R

    Rscript --vanilla gps_converter_main.R input output

* The Converter will expect a .json or .html file with the structure provided by flow.polar.com
* The converter will skip all files without recorded gps tracks, so ypu can leave them in the folder...

