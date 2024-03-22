json_res=$(curl -s 'https://oddsjam.com/api/backend/arbitrage' \
  -H 'authority: oddsjam.com' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'cookie: stateData=eyJuYW1lIjoiTUEiLCJsYWJlbCI6Ik1hc3NhY2h1c2V0dHMifQ%3D%3D.lAo11CcmILCsx2uTzRWWIxZJT1nPXSzxur8Dz%2FsUurQ; _ga=GA1.1.1659874266.1711120803; _session=eyJvYXV0aDI6c3RhdGUiOiI3Yzk5ZTFlNi04MGQxLTQ5NmQtODVkZS04ZDkwOWVlNmVhN2MifQ%3D%3D.7xDY0g2SktizG1mvfeB9kaM1lcY%2F%2ByCGcKID8uPCVx0; access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzEzNTQwMTUxLCJqdGkiOiIzZjE3OTFjMTMxODU0MjE5Yjc0ZjBlYmUwZTA5OTZkYyIsInVzZXJfaWQiOjYxMjgxMn0.uxdqRo5N7r6D986Xp7usawLoqdmO4Zzb7qFvQ26Rngs; _clck=htor4y%7C2%7Cfka%7C0%7C1542; ajs_anonymous_id=51cdc2e4-092d-4dc1-8048-4d0b8e2bb499; ajs_user_id=nicklenn618@gmail.com; _gcl_au=1.1.1941865511.1711120955; uwguid=WEBLS-f976c343-e910-4a07-a3f2-0a7fb356136e; intercom-id-xgkfzdmt=5a97f607-5bde-462f-a8cb-8832941c1486; intercom-device-id-xgkfzdmt=02c966b0-166b-4359-abf4-153af8648b41; HeardAboutUs=Y; cf_clearance=oyah2rnr9pQKZyM5zxs0AMl82tf7uAvg8CVi9Cxnwv0-1711136042-1.0.1.1-WskjdhgOuqkUV74sUWfUqd1j8rw06HSQ8pa.UFrLpwyl0koqXurwq7loMoCqh1.n7Kg7ubEWZluZk2xBspfZLw; _clsk=1nlet8s%7C1711136386869%7C6%7C1%7Cm.clarity.ms%2Fcollect; intercom-session-xgkfzdmt=RE5xWG9uSHF0ckVYYzFSSnlmTUVETXh2SWFqZDgvSDh1K05tTWZYWnY1dkx6eXpzQ2hjQ3h5T0R3RU5PV1lHUC0td2UyYndHTVhDQlNDek5VdW9VTjRFdz09--546699496aca09cca3b3bdec75eb6cb568777b78; _ga_S7ZD38WYXD=GS1.1.1711136038.4.1.1711136398.0.0.0' \
  -H 'origin: https://oddsjam.com' \
  -H 'pragma: no-cache' \
  -H 'referer: https://oddsjam.com/betting-tools/arbitrage?tab=live' \
  -H 'sec-ch-ua: "Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'signature: pnxZ9MB+dAn8CWXnqbnuKADipqWX9gogOMFiBS1vuBI=' \
  -H 'timestamp: 1711136398.322' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
  --data-raw '{"sportsbooks":["BetMGM","BetOpenly","Caesars","DraftKings","ESPN BET","FanDuel","Fanatics","Fliff","Kutt","888sport","Action 24/7","BET99","Bally Bet","BetAnySports","BetDEX","BetDSI (Superbook)","BetOnline","BetRivers","BetRivers (New York)","BetUK","BetUS","BetVictor","Betano","Betfair Exchange","Betfred","Betly","Betly (Tennessee)","Betsafe","Betway (Arizona)","Betway (Canada)","Betway (Ohio)","Betway (Virginia)","Bodog","BookMaker","BoomBet","Borgata","Bovada","Caesars (Tennessee)","Casumo","Circa Sports","Circa Vegas","ClutchBet","Coral","DRF","Dafabet","Desert Diamond","FanDuel (Ontario)","FireKeepers","Four Winds","Golden Nugget","Golden Nugget (Michigan)","Golden Nugget (New Jersey)","Hard Rock","Ladbrokes","Ladbrokes (Australia)","LeoVegas","Mise-o-jeu","MyBookie","Neds","NorthStar Bets","Novig","Pinnacle","Pinny","Play Alberta","Play Eagle","PlayNow","PointsBet (Australia)","PointsBet (Illinois)","PointsBet (Iowa)","PointsBet (Kansas)","PointsBet (Maryland)","PointsBet (New Jersey)","PointsBet (Ontario)","PowerPlay","Proline","Prophet Exchange","Resorts World Bet","SBK","SX Bet","SaharaBets","Sky Bet","Smarkets","Sports Interaction","Sporttrade","Sporttrade (Colorado)","Stake","SugarHouse","SuperBook","Suprabets","TAB (New Zealand)","TABtouch","Tipico","TonyBet","TwinSpires","Unibet","Unibet (Australia)","Unibet (United Kingdom)","William Hill","Wind Creek","WynnBET (Michigan)","WynnBET (New York)","Xbet","bet365","betPARX","bwin","partypoker","theScore"],"live":true,"state":"MA","page":1}' \
  --compressed)

# export json_res
