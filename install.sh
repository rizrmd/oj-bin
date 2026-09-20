#!/bin/sh
set -eu

repo=rizrmd/oj-bin
version=${OJ_VERSION:-}
install_dir=${OJ_INSTALL_DIR:-"$HOME/.local/bin"}
fetch() { curl --proto '=https' --tlsv1.2 -fsSL --retry 3 "$1" -o "$2"; }
command -v curl >/dev/null 2>&1 || { echo 'curl is required.' >&2; exit 1; }
if [ -z "$version" ]; then
  version=$(curl --proto '=https' --tlsv1.2 -fsSL --retry 3 "https://api.github.com/repos/$repo/releases/latest" | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -n 1)
fi
version=${version#v}
case "$version" in ''|*[!0-9.]*) echo 'OJ_VERSION must be a numeric release version, e.g. 0.2.2.' >&2; exit 1 ;; esac
case "$(uname -s)" in
  Linux) platform=unknown-linux-gnu ;;
  *) echo 'This installer supports Linux (glibc). See GitHub Releases for available binaries.' >&2; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=x86_64 ;;
  aarch64|arm64) arch=aarch64 ;;
  *) echo 'Supported architectures: x86_64 and arm64.' >&2; exit 1 ;;
esac
asset="oj-$version-$arch-$platform.tar.gz"
url="https://github.com/$repo/releases/download/v$version"
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/oj-install.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
fetch "$url/$asset" "$tmp_dir/$asset"
fetch "$url/$asset.sha256" "$tmp_dir/$asset.sha256"
(
  cd "$tmp_dir"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum -c "$asset.sha256"
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 -c "$asset.sha256"
  else
    echo 'sha256sum or shasum is required to verify the download.' >&2
    exit 1
  fi
)
mkdir "$tmp_dir/unpack"
tar -xzf "$tmp_dir/$asset" -C "$tmp_dir/unpack"
actual=$("$tmp_dir/unpack/oj" --version) || {
  echo 'The binary cannot run on this system. Linux requires glibc 2.35+ and zlib; Alpine/musl is not supported.' >&2
  exit 1
}
[ "$actual" = "oj $version" ] || { echo "Unexpected binary version: $actual" >&2; exit 1; }
mkdir -p "$install_dir"
install -m 755 "$tmp_dir/unpack/oj" "$install_dir/oj"
echo "Installed $actual to $install_dir/oj"
case ":$PATH:" in *":$install_dir:"*) ;; *) echo "Add $install_dir to PATH to run oj from any directory." ;; esac
