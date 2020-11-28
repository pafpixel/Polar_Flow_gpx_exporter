Currently it is not possible to export your favorite tracks or tracks from your hsitory from flow.polar.com.

You can however 
* add tracks from your history to your favorits
* extract a json-string from your favorite routes on flow.polar.com with 500 gps-waypoints.

**How To:**
* Got to Favorites
* Click on the desired item
* Your browser sends a request to: 
* Reponse is a jsonobject which you can save and use as input for this converter.



You need to specify the inputfolder and the outputfolder when running the script.
If no output folder is specified, the files are saved in the input folder.

**Run the converter:**

    Rscript --vanilla gps_converter_main.R input output


Coming next:
* Directly exporting track from your history

Open questions:
* Any ideas how to get a list of all your Favorit-IDs?
