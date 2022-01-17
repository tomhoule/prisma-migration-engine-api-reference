source $stdenv/setup

mkdir -p $out

cat ./methods/*.toml | dasel -r toml -w json . > $out/api.json;

codegen
