-- Start from Neovim's defaults; add an option here only when its absence is felt.

-- Leader must be set before any mapping that uses it is defined.
vim.g.mapleader = " "

vim.o.colorcolumn = "+1"
vim.o.swapfile = false
-- Yanks, deletes and puts go through the system clipboard.
vim.o.clipboard = "unnamedplus"
-- Treesitter folds every function; start with all of them open.
vim.o.foldlevel = 99
-- A project's .nvim.lua runs once :trust allows it, for per-project exceptions like its formatters.
vim.o.exrc = true

-- mini.completion's recommended value plus fuzzy: no item preselected, so <CR> stays a newline. No "popup": its own
-- info window shows the item's docs.
vim.o.completeopt = "menuone,noselect,fuzzy"

vim.filetype.add({
  filename = {
    gitconfig = "git_config",
  },
  extension = {
    -- Deface overrides (Solidus/Spree) are ERB templates.
    deface = "eruby.html",
  },
})
