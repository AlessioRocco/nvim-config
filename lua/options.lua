-- Start from Neovim's defaults; add an option here only when its absence is felt.

-- Leader must be set before any mapping that uses it is defined.
vim.g.mapleader = " "

vim.o.colorcolumn = "+1"
vim.o.swapfile = false
-- Treesitter folds every function; start with all of them open.
vim.o.foldlevel = 99

-- Built-in completion as you type: words from the open buffers, plus the LSP where one attaches (lua/lsp.lua).
vim.o.autocomplete = true
-- No item preselected, so <CR> stays a newline; "popup" shows the item's docs next to the menu.
vim.o.completeopt = "menuone,noselect,popup,fuzzy"

vim.filetype.add({
  filename = {
    gitconfig = "git_config",
  },
  extension = {
    -- Deface overrides (Solidus/Spree) are ERB templates.
    deface = "eruby.html",
  },
})
