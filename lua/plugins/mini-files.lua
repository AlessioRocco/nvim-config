-- File explorer; it also replaces netrw when a directory is opened.
require("mini.files").setup({
  windows = { preview = true, width_focus = 30, width_preview = 100 },
})

vim.keymap.set("n", "-", function()
  local path = vim.api.nvim_buf_get_name(0)
  -- Buffers without a file on disk (scratch, terminal, help from a plugin) fall back to the cwd.
  MiniFiles.open(vim.uv.fs_stat(path) and path or nil, true)
end, { desc = "File explorer (directory of current file)" })

vim.keymap.set("n", "_", function()
  MiniFiles.open(vim.uv.cwd(), true)
end, { desc = "File explorer (cwd)" })
