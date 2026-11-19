# AGENTS.md

My own Neovim 0.12 config, run as `NVIM_APPNAME=avim`. It exists to navigate code, review the changes of a branch, and
send comments to the AI. A feature that serves none of the three doesn't go in.

## Rules

1. Built-in Neovim feature first (`vim.pack`, `vim.lsp.config`/`vim.lsp.enable`, completion, commenting,
   `nvim.difftool`, `nvim.undotree`, ...).
2. If that's not enough, a `mini.nvim` module (`nvim-mini/mini.nvim` is one `vim.pack` entry).
3. Any other plugin only when neither covers it, with a one-line comment at the top of its file saying which job it
   serves and why the first two weren't enough.

- Plain Lua files. Nix gives the `nvim` binary, the `~/.config/avim` symlink, the `avim` alias and the tools on
  `$PATH`, and generates nothing in this repo.
- No Mason. Language servers, linters and formatters come from Nix and are found on `$PATH`. Prefer pure-Lua plugins:
  prebuilt binaries downloaded by plugins usually don't run on NixOS.
- One file per plugin under `lua/plugins/`; it calls `vim.pack.add` for its own plugin, then configures it. Don't
  edit other plugins' files unless the change needs it.
- Every keymap gets a `desc`.
- Format Lua with `stylua` (`stylua.toml`).
- Code, comments, commits and PR text in English. Comments say why, in a line, not what.
- Check 0.12 APIs in `:help` rather than from memory.

## Running a worktree in isolation

`~/.config/avim` points at the main checkout, so `NVIM_APPNAME=avim nvim` runs main, not your worktree. Use a
scratch XDG tree:

```sh
S=/tmp/avim-<name>; mkdir -p $S/config $S/data $S/state $S/cache; ln -sfn "$PWD" $S/config/avim
env NVIM_APPNAME=avim XDG_CONFIG_HOME=$S/config XDG_DATA_HOME=$S/data XDG_STATE_HOME=$S/state XDG_CACHE_HOME=$S/cache \
  nvim --headless "+lua print('ok')" +qa
```

Plugins install under `$S/data`; `nvim-pack-lock.json` is written in the worktree and is committed. Before calling a
change done, check in the scratch tree: a clean `nvim --headless +qa` (twice, the second after plugins are
installed), `:checkhealth` for what you touched, and a headless Lua check that the feature is there.
