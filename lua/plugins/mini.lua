-- Installs mini.nvim, the first place to look when a built-in falls short. Each module gets its own
-- lua/plugins/mini-<module>.lua that calls setup() without adding the plugin again.
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" }, { confirm = false })
