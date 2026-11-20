-- Navigate code: the lsp/<server>.lua configs for the servers on $PATH. Neovim ships none and mini has no
-- equivalent; only its lsp/ files are used, never require("lspconfig").
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { confirm = false })
