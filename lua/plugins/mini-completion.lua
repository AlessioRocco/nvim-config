-- Completion as you type: the LSP's items where a server attaches, buffer words (<C-n>) only when it has none, so a
-- word never shows twice. Snippets expand with vim.snippet; mini.snippets isn't needed for the LSP ones.
require("mini.completion").setup()

-- Tells servers what mini.completion handles (resolving imports, snippets, signature help); before lua/lsp.lua
-- enables them.
vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
