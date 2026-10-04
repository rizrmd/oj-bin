# OJ binaries

Prebuilt binaries for [lovablelabs/oj](https://github.com/lovablelabs/oj), the
Rust-native React dev server and build tool. This repository packages upstream
releases without changing their source. OJ is experimental.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/rizrmd/oj-bin/main/install.sh | sh
```

The installer detects Linux and x86_64/arm64, downloads the matching release,
verifies SHA-256, checks `oj --version`, and installs into `~/.local/bin`.
No Rust compiler, Node.js, or Bun is needed to install or execute the binary.
Application dependencies must still be installed separately.

Pin a version or choose another writable directory:

```sh
curl -fsSL https://raw.githubusercontent.com/rizrmd/oj-bin/main/install.sh -o /tmp/install-oj.sh
OJ_VERSION=0.2.16 OJ_INSTALL_DIR="$HOME/.local/bin" sh /tmp/install-oj.sh
```

Ensure the installation directory is on `PATH`, then run from your app:

```sh
oj --version
oj dev
oj build
```

## Platforms

| Platform | Release target | Requirement |
| --- | --- | --- |
| Linux x86_64 | `x86_64-unknown-linux-gnu` | glibc 2.35+, zlib |
| Linux arm64 | `aarch64-unknown-linux-gnu` | glibc 2.35+, zlib |

Alpine/musl and Windows binaries are not currently published. Each archive
contains `oj`, its upstream license, notices, and build information. Matching
`.sha256` files and a combined `SHA256SUMS` are attached to each release.
Do not fully strip the binary: the embedded runtime needs its exported symbols.

## Publishing

Run the **Release** workflow with an upstream crate version. Two native builds
compile with `cargo install oj --locked`, run a React/Tailwind smoke build with
`node` blocked, and upload archives into a draft release. The final job verifies
all checksums and publishes the release only after every platform succeeds.
The build uses shell tools, Rust, and Bun for installing the smoke fixture's
dependencies; it does not run Node.js.
