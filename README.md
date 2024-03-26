# rawrbitrage

This is a simple shell script I use to scan potential arbitrage bets on OddsJam. Personally I like making money; I don't like staring at OddsJam all day. 

The script will scan OddsJam on a configurable interval for potential arbitrage bets that fit the criteria of the configuration. If it finds a match, it will prompt the user to open the sportsbook URLs in their default browser.

## Installation

Requires a couple packages if you don't have them already
- [jq](https://jqlang.github.io/jq/)
- [boxes](https://boxes.thomasjensen.com/)

## Running Locally

The script requires you have an OddsJam trial. The data utilized by this script is aggregated by OddsJam, and we are simply using their service to create a more efficient interface for getting bets placed quickly.

 Go to [OddsJam](https://oddsjam.com/betting-tools/arbitrage), go to Chrome dev tools -> Network, copy the `arbitrage` POST req as cURL command and paste it into `prematch_arb.sh` (unless you're copying the live odds request, then paste into `live_arb.sh`).

Access token provisioning will probably be automated in the future, but tbh this is a personal tool so I just wanted to get setup quickly. 

```bash
./arb.sh
```

Configurable items are found in `config.yaml`
| Variable      | Description | Default 
| ----------- | ----------- | ----------- |
| `arb_threshold`      | The minimum arb % required to raise the bet to the user | 0.1 |
| `fetch_interval`   | Fetch the latest odds from OddsJam every `fetch_interval` seconds | 10 |
| `live`   | If true, the script will only fetch live games arb bets from OddsJam. Otherwise it will be pre-match bets only. | false |
| `strict_url_availability`   | Only flag bets that have a one-click link associated to both sides of the line (WIP). | true |
| `write_response_to_file`   | Will write the JSON response from OddsJam, used for testing purposes. Slowdowns incurred when enabled. | false |