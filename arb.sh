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
Fetch Interval: ${config_fetch_interval}s
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
        chmod +x requests/live_curl.sh
        json_res=$(./requests/live_curl.sh)
        if [[ "$config_write_response_to_file" == "true" ]]; then
            echo "$json_res" | jq '.' > live_response.json
        fi
    else
        chmod +x requests/prematch_curl.sh
        json_res=$(./requests/prematch_curl.sh)
        if [[ "$config_write_response_to_file" == "true" ]]; then
            echo "$json_res" | jq '.' > prematch_response.json
        fi
    fi
    
    for entry in $(echo "$json_res" | jq -r '.data[] | @base64'); do
        _jq() {
            echo ${entry} | base64 --decode | jq -r ${1}
        }
        percentage=$(_jq '.percentage')

        # percentage should be above configurable threshold, if not ignore the arb bet
        if (( $(echo "$percentage > $config_arb_threshold" | bc -l) )); then
            _extract_urls_from_deep_link_map() {
                local deep_link_map=$1
                local my_sportsbooks=("FanDuel" "DraftKings" "BetMGM" "TonyBet" "Kutt" "Caesars" "ESPN BET")
                local url

                # for key in $(jq -r 'keys[]' <<< "$deep_link_map"); do
                #     # Check if the key is in the list of sportsbooks and if a desktop URL exists
                #     if [[ " ${my_sportsbooks[@]} " =~ " $key " ]] && [[ $(jq -r --arg key "$key" '.[$key].desktop // empty' <<< "$deep_link_map") ]]; then
                #         url=$(jq -r --arg key "$key" '.[$key].desktop' <<< "$deep_link_map")
                #         echo "$key|$url"
                #     fi
                # done
                jq -r 'keys[]' <<< "$deep_link_map" | while IFS= read -r key; do
                    # Check if the key is in the list of sportsbooks and if a desktop URL exists
                    if echo "${my_sportsbooks[@]}" | grep -q -F -w "$key" && jq -e ".\"$key\".desktop" <<< "$deep_link_map" >/dev/null; then
                        url=$(jq -r ".\"$key\".desktop" <<< "$deep_link_map")
                        echo "$key|$url"
                    fi
                done
            }



            home_betting_info=$(_extract_urls_from_deep_link_map "$(_jq '.home_deep_link_map')")
            away_betting_info=$(_extract_urls_from_deep_link_map "$(_jq '.away_deep_link_map')")

            # set IFS to pipe and read in multiple values (sportsbook name & url)
            IFS='|' read -r home_sportsbook home_betting_url <<< "$home_betting_info"
            IFS='|' read -r away_sportsbook away_betting_url <<< "$away_betting_info"

            market=$(_jq '.market')
            home_bet_name=$(_jq '.home_bet_name')
            away_bet_name=$(_jq '.away_bet_name')
            home_price=$(_jq '.home_price')
            away_price=$(_jq '.away_price')

            # depending on config games should only be shown if there are two associated URLs
            if [[ "$config_strict_url_availability" == "true" && -n "$home_betting_url" && -n "$away_betting_url" ]]; then
                display_arb_bet "$market" "$percentage" "$home_bet_name" "$away_bet_name" "$home_price" "$away_price" "$home_sportsbook" "$away_sportsbook"
                read -p "Open in Browser? (Y/N): " confirm
                if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
                    xdg-open "$home_betting_url" "$away_betting_url" &>/dev/null || open "$home_betting_url" "$away_betting_url" &>/dev/null
                    echo "Opening URLs..."
                fi
            else
                display_arb_bet "$market" "$percentage" "$home_bet_name" "$away_bet_name" "$home_price" "$away_price" "$home_sportsbook" "$away_sportsbook"
                read -p "Continue? (Y/N): " confirm
                if [[ $confirm == [nN] ]]; then
                    exit 1
                fi
            fi
        fi
    done
    echo "Iterated through all entries. Fetching again in 10s"
    sleep $config_fetch_interval
done
