# avim

My Neovim config, built on Neovim 0.12 with `vim.pack` and native LSP. I use it less to write code and more to review
it, so it serves three jobs: navigate code, review the changes of a branch, send comments to the AI. A feature that
serves none of the three doesn't go in.

It's my default editor: Nix sets `NVIM_APPNAME=avim` globally, so `nvim`, `$EDITOR` and the Herdr sidebar all load
it. Nix also provides the `nvim` binary, the `~/.config/avim` symlink to this checkout and the tools on `$PATH`.
Everything else is plain Lua in this repo.

## Layout

- `init.lua` enables the module loader and requires the files below.
- `lua/options.lua`, `lua/keymaps.lua`, `lua/autocmds.lua` hold the editor settings.
- `lua/plugins/` has one file per plugin, each installing its own plugin with `vim.pack.add`.
- `lua/lazygit.lua` opens lazygit in a floating terminal.
- `lua/erb_lint.lua` shows `erb_lint` offenses as diagnostics on ERB files.
- `lua/lsp.lua` enables the language servers found on `$PATH`, adds `gd` and sets up diagnostics.
- `after/lsp/` overrides a server's config. The configs themselves come from the `lsp/` files of
  [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), installed as a plugin and never `require`d.

## Language servers

Nix puts the servers on `$PATH`; there's no Mason. `ruby_lsp` and `rubocop` come from each project's devenv, so start
`avim` from inside it. A server whose executable isn't on `$PATH` at startup stays off. To add one, add its name and
executable to the `servers` table in `lua/lsp.lua`, and an `after/lsp/<name>.lua` only if lspconfig's defaults need
changing.

## Treesitter

Highlighting, folds and indentation come from treesitter, started by a `FileType` autocmd in
`lua/plugins/treesitter.lua`. [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch)
only installs the parsers and ships the queries. It compiles them with `tree-sitter` and `gcc` from `$PATH` into
`~/.local/share/avim/site/parser`. The parsers in the `install` list are installed at startup; any other one the first
time a file of its type opens. Updating the plugin with `vim.pack.update()` rebuilds them.

## Navigation

- **Picker** ([mini.pick](https://github.com/nvim-mini/mini.nvim), with mini.extra and mini.visits):
  `<leader><space>`/`<leader>ff` files, `<leader>fg` git files, `<leader>fr` recent files of the cwd,
  `<leader>/`/`<leader>sg` grep (`rg`), `<leader>,` buffers, `<leader>sh` help, `<leader>sd`/`<leader>sD`
  diagnostics, `<leader>ss`/`<leader>sS` LSP symbols, `<leader>sR` resume. It's also `vim.ui.select`.
- **Explorer** (mini.files): `-` opens the directory of the current file, `_` the cwd.
- **Jumps**: `s` then a character shows labels in every window (mini.jump2d); `f`/`F`/`t`/`T` cross lines
  (mini.jump).
- **Words**: `w`/`e`/`b` stop inside camelCase and snake_case
  ([nvim-spider](https://github.com/chrisgrieser/nvim-spider)).
- **Tabs**: `<leader><tab><tab>` new, `<leader><tab>d` close, `<leader><tab>]`/`<leader><tab>[` next/previous,
  `<leader><tab>f`/`<leader><tab>l` first/last, `<leader><tab>o` closes the others.
- **Alternate file**: `<leader>oo`, `<leader>os` (split), `<leader>ov` (vsplit), with the Rails preset of
  [other.nvim](https://github.com/rgroli/other.nvim) plus components and extensions.

## Git

- **Hunks** (mini.diff): signs in the gutter against the index. `]h`/`[h` (`]H`/`[H` last/first) move between
  hunks, `gh`/`gH` apply (stage)/reset the hunks of a motion or selection (`ghgh` the one under the cursor),
  `<leader>go` toggles the overlay that shows a hunk's old text inline.
- **Blame and history** (mini.git): `<leader>gb` opens `:Git blame` in a vertical split that scrolls with the file.
  `<leader>gl` shows the history of the line (or selection) under the cursor; on a commit hash it shows that commit.
  `:Git <args>` runs any git command.
- **lazygit**: `<leader>gg` opens it in a floating terminal, in the repository of the current file, and closes it when
  lazygit exits. It reads its theme from `~/.config/lazygit/config.yml`; `lua/lazygit.lua` has the code.

## Comments to the AI

[herdr-nvim](https://herdr.dev) comments code and sends the comments to an agent running in Herdr. Herdr installs it
under `~/.local/share/herdr-nvim/app/<hash>/` and updates it, so it isn't a `vim.pack` entry:
`lua/plugins/herdr-nvim.lua` adds the newest install to the runtimepath, or the copy the Herdr sidebar already put
there, and does nothing on a machine without Herdr.

- `<leader>ac` comments the line or selection, `<leader>al` lists the comments (`<CR>` edits, `d` deletes).
- `<leader>as` pastes the comments in the agent's prompt, `<leader>aS` submits them. Both clear them once sent.
- `<leader>ai` drops a bare `path:line` reference of the line or selection at the agent's cursor.
- `:Herdr comment|list|send|submit|ref` does the same, with a range.

Comments live in memory: a restart loses them.

## UI

- **Statusline** (mini.statusline): mode, branch, diagnostics count, path relative to the cwd, line and column. A
  rebase, merge, cherry-pick, revert or bisect in progress shows next to the branch, as `main|rebase`. No
  tabline: buffers are in the picker (`<leader>,`); `mini.tabline` is the one to add if they're missed.
- **Key hints** (mini.clue): after `<leader>`, `g`, `z`, `[`, `]`, `<C-w>`, `"`/`<C-r>` (registers) and
  `'`/`\`` (marks). The leader groups are `a` AI, `f` files, `g` git, `o` other, `s` search, `u` toggles, `<tab>` tabs.
- **Messages and cmdline**: 0.12's experimental ui2 (`lua/ui2.lua`), with its defaults. No "Press ENTER" prompt:
  long output collapses with a `[+x]` marker, and `g<` opens it in a pager.

## Editing

- **Completion** (mini.completion): the menu opens as you type. Where a language server attaches it lists the
  server's items, with mini.icons' kind icons; words from the open buffers come only when the server has none, so a
  word never shows twice. The item's docs and the signature help open in floating windows (`<C-f>`/`<C-b>` scroll
  them). `<C-n>`/`<C-p>` move, `<C-y>` accepts (and applies imports and snippets, through `vim.snippet`), `<C-e>`
  closes, `<C-Space>` forces it open. No preselection, so `<CR>` is always a newline.
- **Surround** (mini.surround): `;;` add, `;d` delete, `;r` replace, `;f`/`;F` find, `;h` highlight.
- **Text objects** (mini.ai): mini's defaults, such as `q` quotes, `b` brackets, `f` function calls, `a`
  arguments and `t` tags, plus `g` for the whole buffer (`yag`).
- **Comments**: Neovim's `gc`/`gcc`.
- **Format on save** ([conform.nvim](https://github.com/stevearc/conform.nvim)): the project decides. `stylua` for
  Lua, `shfmt` for shell. ERB gets `erb_lint --autocorrect` with an `.erb_lint.yml`, Herb's `herb-format` when
  `.herb.yml` enables its formatter, `erb-format` when `Gemfile.lock` has `erb-formatter` or the project declares no
  ERB tool. JS/TS gets one formatter: `eslint` with an eslint config, else `prettier` with a prettier config, else
  `vtsls`. Ruby: `ruby_lsp` only. The language server for everything else. A formatter that isn't on `$PATH` is
  skipped, so `erb_lint` runs only inside a project's devenv. `<leader>uf` toggles it everywhere, `<leader>uF` for
  the current buffer; `:ConformInfo` shows what would run.
- **Per-project exceptions**: `exrc` is on, so a project's `.nvim.lua` runs once `:trust` allows it.
- **ERB lint**: `erb_lint` diagnostics after a file is read or written, when `erb_lint` is on `$PATH`.

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
