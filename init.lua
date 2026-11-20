-- Cache compiled Lua modules to cut startup time.
vim.loader.enable()

require("options")
-- Before anything that can print, so startup messages go through it too.
require("ui2")
require("keymaps")
require("autocmds")
require("lazygit")
require("plugins")
-- After plugins: the server configs come from nvim-lspconfig.
require("lsp")
