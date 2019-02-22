# bbref
Extract various data sets with NBA statistics -- play-by-play data, shot charts for a game, team or player gamelogs for a season -- directly into an R data frame. All data is from [Basketball-Reference.com](https://www.basketball-reference.com/).  

NOTE: The script allows for quick access to data from a handful of games so that it can be easily analyzed using R.  My intent is NOT to create a script that facilitates data scraping.  Please use this script in accordance with the [terms of use](https://www.sports-reference.com/termsofuse.html) for the Sports Reference website.

To find data to extract into an R data frame:  
* Copy all files to your working directory.  
* `source(bbref.R)` should create the `bbref` function.  
* Call `bbref(YYYY)` to extract the desired data.  This will focus on data from the YYYY season; menus will guide you to find the specific team, player, or game data to extract.


Something doesn't seem right?  Have a question or suggestion?  Feel free to open an issue to communicate anything.
