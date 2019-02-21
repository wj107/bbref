# play-by-play
Extract play-by-play data from an NBA game directly into an R data frame. All data is from [Basketball-Reference.com](https://www.basketball-reference.com/).  

NOTE: The script allows for quick access to data from a handful of games so that it can be easily analyzed using R.  My intent is NOT to create a script that facilitates data scraping.  Please use this script in accordance with the [terms of use](https://www.sports-reference.com/termsofuse.html) for the Sports Reference website.

To get play-by-play data into an R data frame:  
* Copy all files to your working directory.  
* `source(play_by_play.R)` should create the `play_by_play` function.  
* You can then call `play_by_play(YYYY)` to choose an NBA team from the YYYY season, after which you will identify a specific game from that season's gamelog to download.  Note that play-by-play data is only available for the 2001 season and beyond.

Something doesn't seem right?  Have a question or suggestion?  Feel free to open an issue to communicate anything.

-#####################################################################
-############# BASKETBALL REFERENCE DATA SCRAPING TOOLS
-############# v0.11 -- 10 February 2018
-#####################################################################
----------- A pair of R scripts loading functions to extract and clean selected data from basketball-reference.com for further
----------- analysis.  The first extracts gamelog data for a team over a full season(s), the season extracts box score data 
----------- for a given player over a full season(s).

---------------------------------

---------------v0.11 has:
-----------function "bbplayer", input player name, season(s), logical switch if data will be tagged with player name/season
-----------function "bbteam", input team abbreviation, season(s), logical switch to include opponent's data too,
-----------------(not yet--->)logical switch if data will be tagged with team/season
-----------both scrape, clean, and format data as a data frame.
---------------------------------
---------------v0.11+ needs:
-----------improve tagging -- season, age, time, day of week, natTV, etc. 
-----------better specify data types for each variable, order factors
-----------create a menu to select which data table to extract:  gamelogs, playoff logs, advanced stats, etc
-----------bbteam:  input abbreviations or full team names
-----------long range plan:  turn into a package!! hey-yo CRAN!
