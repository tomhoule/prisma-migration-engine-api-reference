mkdir -p $out
echo $API_JSON | jq > $out/api.json
