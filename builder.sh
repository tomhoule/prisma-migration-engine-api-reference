mkdir -p $out
echo $API_JSON | jq > $out/api.json

export API_JSON=`echo $API_JSON | jq`

codegen
