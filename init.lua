-- Cache compiled Lua modules to cut startup time.
vim.loader.enable()

require("options")
require("keymaps")
require("autocmds")
require("plugins")
