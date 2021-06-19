# Github actions runs this script

let API_KEY = a0f0c1fcd74af119f6874df35d3d49c7
let ROOT_URL = "https://api.the-odds-api.com/v3" # show nu url parse
let SPORTS_PATTERN = "sports"
let ODDS_PATTERN = "odds"
let BOOKIES = "winamax unibet pmu"
let FILE_NAME = "response.json"
let FILE_NAME_ODDS = "response" + "_odds" + ".json"
# echo $"($ROOT_URL)/($SPORTS_PATTERN)/?apiKey=($API_KEY)" # debug 

def main [] {
    retrieve_sports_into_table!
    retrieve_odds_into_table! h2h
    get_sports! $FILE_NAME | autoview
    get_max_odd! $FILE_NAME_ODDS | each { echo $"($it) is the maximum odd among all bookies" }
    get_min_odd! $FILE_NAME_ODDS | each { echo $"($it) is the minimum odd among all bookies" }
    get_average_odd! $FILE_NAME_ODDS | each { echo $"($it) is the average odd among all bookies" }
    get_median_odd! $FILE_NAME_ODDS | each { echo $"($it) is the median odd among all bookies" }
    # for i in BOOKIES; retrives max,min,median,..
}

def retrieve_sports_into_table! [FILENAME?: string] {
    ^curl $"($ROOT_URL)/($SPORTS_PATTERN)/?apiKey=($API_KEY)" | wrap data | save $FILE_NAME
}

def retrieve_odds_into_table! [FILENAME?: string, MKT: string] {
    fetch $"($ROOT_URL)/($SPORTS_PATTERN)/?apiKey=($API_KEY)&sport=upcoming&region=us&mkt=($MKT)" | wrap data | save $FILE_NAME_ODDS
}

def get_max_odd! [REQUEST: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | get odds | get totals | get odds } | math max
}

def get_min_odd! [REQUEST: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | get odds | get totals | get odds } | math min
}

def get_average_odd! [REQUEST: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | get odds | get totals | get odds } | math avg
}

def get_median_odd! [REQUEST: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | get odds | get totals | get odds } | math median
}

def get_max_odd_by_bookie! [SITE_KEY: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | where $it.site_key == $"($SITE_KEY)" | get odds | get totals | get odds } | math max
}

def get_min_odd_by_bookie! [SITE_KEY: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | where $it.site_key == $"($SITE_KEY)" | get odds | get totals | get odds } | math min
}

def get_average_odd_by_bookie! [SITE_KEY: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | where $it.site_key == $"($SITE_KEY)" | get odds | get totals | get odds } | math avg
}

def get_median_odd_by_bookie! [SITE_KEY: string] {
    retrieve_odds_into_table! $REQUEST | get data | get sites | each { echo $it | where $it.site_key == $"($SITE_KEY)" | get odds | get totals | get odds } | math median
}

def consult_json_data [DATA: string] {
    open $DATA | from json | get data | each { echo $it.key } | autoview
}

def consult_json_data_by_key [DATA: string, SPORT_KEY: string] {
    open $DATA | from json | get data | each { echo $it.key | where $it =~ $"($SPORT_KEY)" } | autoview
}

retrieve_odds_into_table! basketball_nba h2h
# curl https://api.the-odds-api.com/v3/sports/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7?all=true | from json | get data | save data.json

get_sports! 
# upcoming allows to retrieve all sports 
open response.json | from json | get data | each { echo $it.key }

# Count column items
❯ open response_odds.json | get data | pivot | length 
6
# Cpunt row items
❯ open response_odds.json | get data | length
23

❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math median
1.92
❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math median
1.91

❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math avg
2.355909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909091
# without unibet : all books (we can see avg is better with unibet bookie)
❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math avg
2.07765306122448979591836734693877551020408163265306122448979591836734693877551020408163265306122449

❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math max
12.0
❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math max
12.0
# Same result, so unibet own the max odd value

❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math min
1.04
❯ fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math min
1.04 
# Same result, so unibet own the min odd value


fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | each { echo $"($it.points);($it.odds);($it.position)"  } }