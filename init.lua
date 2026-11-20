-- Cache compiled Lua modules to cut startup time.
vim.loader.enable()

require("options")
require("keymaps")
require("autocmds")
require("lazygit")
require("plugins")
-- After plugins: the server configs come from nvim-lspconfig.
require("lsp")
