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
- `lua/lsp.lua` enables the language servers found on `$PATH`, adds `gd` and sets up diagnostics.
- `after/lsp/` overrides a server's config. The configs themselves come from the `lsp/` files of
  [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), installed as a plugin and never `require`d.

## Language servers

Nix puts the servers on `$PATH`; there's no Mason. `ruby_lsp` and `rubocop` come from each project's devenv, so start
`avim` from inside it. A server whose executable isn't on `$PATH` at startup stays off. To add one, add its name and
executable to the `servers` table in `lua/lsp.lua`, and an `after/lsp/<name>.lua` only if lspconfig's defaults need
changing.

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
