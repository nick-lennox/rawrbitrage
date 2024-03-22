#!/bin/bash

parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  "$1" |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

print_config() {
    local config="
Program Configuration

Arb % Threshold: $config_arb_threshold
Live: $config_live
Strict URL Availability: $config_strict_url_availability
"
    echo "$config" | boxes -d stone -p a2v1
}

display_arb_bet() {
    local market=$1
    local percentage=$2
    local home_bet_name=$3
    local away_bet_name=$4
    local home_price=$5
    local away_price=$6
    local home_sportsbook=$7
    local away_sportsbook=$8

    local info="
Arb %: $percentage
Market: $market
$home_sportsbook | $home_bet_name | $home_price
$away_sportsbook | $away_bet_name | $away_price
"
    echo "$info" | boxes -d stone -p a2v1
}

eval $(parse_yaml config.yaml)
print_config 
while true; do
    echo -e "\nFetching up-to-date arb data..."
    if [[ "$config_live" == "true" ]]; then
        source requests/live_arb.sh
    else
        source requests/prematch_arb.sh
    fi

    # json_res=$(cat output_live.json)

    # echo "$json_res" > output_live.json

    for entry in $(echo "$json_res" | jq -r '.data[] | @base64'); do
        _jq() {
            echo ${entry} | base64 --decode | jq -r ${1}
        }
        percentage=$(_jq '.percentage')

        # percentage should be above configurable threshold, if not ignore the arb bet
        if (( $(echo "$percentage > $config_arb_threshold" | bc -l) )); then
            _extract_urls_from_deep_link_map() {
                local deep_link_map=$1
                local my_sportsbooks=("FanDuel" "DraftKings" "BetMGM" "TonyBet" "Kutt" "Caesars")
                local url

                # Extract and compare keys from deep link map against sportsbooks list
                for key in $(jq -r 'keys[]' <<< "$deep_link_map"); do
                    # Ensure available sportsbook is one we have, and ensure there is a desktop URL
                    if [[ " ${my_sportsbooks[@]} " =~ " $key " ]] && [[ $(jq -r --arg key "$key" '.[$key].desktop // empty' <<< "$deep_link_map") ]]; then
                        url=$(jq -r --arg key "$key" '.[$key].desktop' <<< "$deep_link_map")
                        echo "$key|$url"  # Concatenate key and URL with a separator (e.g., pipe)
                    fi
                done
            }


            home_betting_info=$(_extract_urls_from_deep_link_map "$(_jq '.home_deep_link_map')")
            away_betting_info=$(_extract_urls_from_deep_link_map "$(_jq '.away_deep_link_map')")
            IFS='|' read -r home_sportsbook home_betting_url <<< "$home_betting_info"
            IFS='|' read -r away_sportsbook away_betting_url <<< "$away_betting_info"

            if [[ -n $home_betting_url && -n $away_betting_url ]]; then
                market=$(_jq '.market')
                home_bet_name=$(_jq '.home_bet_name')
                away_bet_name=$(_jq '.away_bet_name')
                home_price=$(_jq '.home_price')
                away_price=$(_jq '.away_price')
                display_arb_bet "$market" "$percentage" "$home_bet_name" "$away_bet_name" "$home_price" "$away_price" "$home_sportsbook" "$away_sportsbook"
                read -p "Open in Browser? (Y/N): " confirm
                if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                    xdg-open "$home_betting_url" "$away_betting_url" &>/dev/null || open "$home_betting_url" "$away_betting_url" &>/dev/null
                    echo "Opening URLs..."
                fi
            fi
        fi
    done
    echo "Iterated through all entries. Fetching again in 10s"
    sleep 10
done
