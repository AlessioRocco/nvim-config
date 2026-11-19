# avim

My Neovim config, built on Neovim 0.12 with `vim.pack` and native LSP. I use it less to write code and more to review
it, so it serves three jobs: navigate code, review the changes of a branch, send comments to the AI. A feature that
serves none of the three doesn't go in.

It runs next to LazyVim as `NVIM_APPNAME=avim` (the `avim` alias). Nix provides the `nvim` binary, the
`~/.config/avim` symlink to this checkout and the tools on `$PATH`. Everything else is plain Lua in this repo.

## Layout

- `init.lua` enables the module loader and requires the files below.
- `lua/options.lua`, `lua/keymaps.lua`, `lua/autocmds.lua` hold the editor settings.
- `lua/plugins/` has one file per plugin, each installing its own plugin with `vim.pack.add`.
- `lsp/` has one file per language server, picked up by `vim.lsp.enable`.

See `AGENTS.md` for the rules a change has to follow.
