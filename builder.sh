mkdir -p $out
echo $API_JSON | jq > $out/api.json

export API_METHOD_NAMES_JSON=`echo $API_JSON | jq '.methods | keys'`

echo $API_METHOD_NAMES_JSON > $out/mehodNames.json

export TEMPLATES_DIR=$src/templates

# First write the lib.rs
shab $src/templates/lib.rs.shab > $out/lib.rs

# Then write each module
echo $API_METHOD_NAMES_JSON | jq -r '.[]' | \
    while read methodName; do
        export METHOD=`echo $API_JSON | jq .methods.$methodName`;
        export METHOD_NAME=$methodName;
        shab $src/templates/method.rs.shab > $out/$methodName.rs
    done

