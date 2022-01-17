for filename in ./methods/*; do 
    echo $filename; 
    nix eval --impure --raw --expr "builtins.toJSON (import $filename {})" > $filename.json
done
