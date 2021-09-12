# Examples

```nushell
# load functions
nu odds-api-ctl.nu

# sample request to retrieve sports in basketball_nba section
retrieve_odds_into_table! basketball_nba h2h

# Upcoming allows to retrieve all sports 
open response.json | from json | get data | each { echo $it.key }

# Count column items
open response_odds.json | get data | pivot | length 
> 6
# Count row items
open response_odds.json | get data | length
> 23

# Get median odd for unibet bookie
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math median
> 1.92
# Similar result for all bookies
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math median
> 1.91

# Get average odd for unibet bookie
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math avg
> 2.355909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909091
# Get avg odd for all bookies (we can see avg is better with unibet bookie)
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math avg
> 2.07765306122448979591836734693877551020408163265306122448979591836734693877551020408163265306122449

# Get max odd for unibet bookie
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math max
> 12.0
# Same result for all bookies, so unibet own the max odd value
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math max
> 12.0

# Get min odd for unibet bookie
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | get odds } | math min
> 1.04
# Same result for all bookies, so unibet own the min odd value
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | get odds | get totals | get odds } | math min
> 1.04 

# Complex request
fetch https://api.the-odds-api.com/v3/odds/?apiKey=a0f0c1fcd74af119f6874df35d3d49c7&sport=upcoming&region=us&mkt=totals | get 
data | get sites | each { echo $it | where $it.site_key == "unibet" | get odds | get totals | each { echo $"($it.points);($it.odds);($it.position)"  } }
```