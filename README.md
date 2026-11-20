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

## Plugins

`vim.pack` installs the plugins on the first start, at the revisions in `nvim-pack-lock.json`. The lockfile is
committed, so a fresh clone gets the same revisions.

- **Add**: create `lua/plugins/<name>.lua` calling `vim.pack.add`, then configuring the plugin. `lua/plugins/init.lua`
  picks it up on the next start.
- **Update**: run `:lua vim.pack.update()`, read the changes, `:write` to apply them or `:quit` to discard them, then
  commit `nvim-pack-lock.json`.
- **Remove**: delete the plugin's file, `:restart`, run `:lua vim.pack.del({ "<name>" })`, then commit
  `nvim-pack-lock.json`.

See `AGENTS.md` for the rules a change has to follow.
