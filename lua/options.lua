-- Start from Neovim's defaults; add an option here only when its absence is felt.

-- Leader must be set before any mapping that uses it is defined.
vim.g.mapleader = " "

vim.o.colorcolumn = "+1"
vim.o.swapfile = false

vim.filetype.add({
  filename = {
    gitconfig = "git_config",
  },
  extension = {
    -- Deface overrides (Solidus/Spree) are ERB templates.
    deface = "eruby.html",
  },
})
