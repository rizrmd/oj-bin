# Third-party notices

These are redistribution builds of OJ, not a fork of its implementation.
OJ is Copyright (c) 2026 Raphael Amorim and Lovable Labs Incorporated and is
provided under the MIT license included in this archive.

OJ statically links third-party Rust libraries and an embedded V8/Deno runtime.
Their source, license declarations, and notices are available in the exact
crate versions pinned by the upstream release's `Cargo.lock`:

- OJ source distribution: https://crates.io/crates/oj/0.2.2
- Upstream: https://github.com/lovablelabs/oj
- Rusty V8 and V8: https://github.com/denoland/rusty_v8 (MIT and BSD-style licenses)
- Deno: https://github.com/denoland/deno (MIT)
- Rolldown: https://github.com/rolldown/rolldown (MIT)
- Oxc: https://github.com/oxc-project/oxc (MIT)

Builds use `cargo install oj --version 0.2.2 --locked` without source changes.
