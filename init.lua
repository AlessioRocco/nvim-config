-- Cache compiled Lua modules to cut startup time.
vim.loader.enable()

require("options")
require("keymaps")
require("autocmds")
require("plugins")
-- After plugins: the server configs come from nvim-lspconfig.
require("lsp")
