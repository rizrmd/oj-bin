#!/bin/sh
set -eu
version=$1
target=$2
binary=$3
out_dir=$4
mkdir -p "$out_dir"
out_dir=$(CDPATH= cd -- "$out_dir" && pwd)
package_dir=$(mktemp -d)
trap 'rm -rf "$package_dir"' EXIT HUP INT TERM
# Do not strip: OJ's embedded runtime needs exported Node-API symbols.
cp "$binary" "$package_dir/oj"
cp LICENSE "$package_dir/LICENSE"
printf 'OJ %s\nUpstream: https://github.com/lovablelabs/oj\nSource: crates.io oj %s (cargo install --locked)\nTarget: %s\nBuilder: %s\n' "$version" "$version" "$target" "$(rustc --version)" > "$package_dir/BUILD-INFO.txt"
cp THIRD-PARTY-NOTICES.md "$package_dir/"
cp -R licenses "$package_dir/licenses"
asset="oj-$version-$target.tar.gz"
tar -czf "$out_dir/$asset" -C "$package_dir" .
(cd "$out_dir" && if command -v sha256sum >/dev/null 2>&1; then sha256sum "$asset"; else shasum -a 256 "$asset"; fi) > "$out_dir/$asset.sha256"
