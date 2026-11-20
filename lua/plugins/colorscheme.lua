-- Catppuccin Macchiato, the same palette as the terminal and hunk; neither the built-in schemes nor mini.base16 ship it.
vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }, { confirm = false })

require("catppuccin").setup({ flavour = "macchiato" })
vim.cmd.colorscheme("catppuccin")
