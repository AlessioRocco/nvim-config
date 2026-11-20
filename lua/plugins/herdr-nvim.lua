-- Send comments to the AI: comment a line or selection and send it to the agent in Herdr. Neither Neovim nor mini talks
-- to Herdr's agents. Herdr installs and updates the plugin itself, so it goes on the runtimepath, not in vim.pack.

-- The newest install: the directory name is a hash that changes on every Herdr update, and two can coexist.
local function installed_dir()
  local data = vim.env.XDG_DATA_HOME or vim.fs.normalize("~/.local/share")
  local pattern = vim.fs.joinpath(data, "herdr-nvim", "app", "*", "lua", "herdr-nvim", "init.lua")
  local newest, newest_mtime
  for _, init in ipairs(vim.fn.glob(pattern, true, true)) do
    local dir = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(init)))
    local mtime = vim.uv.fs_stat(dir).mtime.sec
    if not newest_mtime or mtime > newest_mtime then
      newest, newest_mtime = dir, mtime
    end
  end
  return newest
end

-- The sidebar daemon puts its own copy on the runtimepath with --cmd, before this file runs.
if not vim.api.nvim_get_runtime_file("lua/herdr-nvim/init.lua", false)[1] then
  local dir = installed_dir()
  -- No Herdr on this machine: nothing to send comments to.
  if not dir then
    return
  end
  vim.opt.runtimepath:append(dir)
end

local herdr = require("herdr-nvim")
-- The plugin keeps its default maps only for backward compatibility. The sidebar daemon calls setup() again on
-- VimEnter: keymaps stays false and the plugin leaves alone maps it didn't set.
herdr.setup({ keymaps = false })

vim.keymap.set("x", "<leader>ac", herdr.comment_selection, { desc = "Comment selection for the AI" })
vim.keymap.set("n", "<leader>ac", herdr.comment_line, { desc = "Comment line for the AI" })
vim.keymap.set("n", "<leader>al", herdr.list_comments, { desc = "List AI comments" })
vim.keymap.set("n", "<leader>as", function()
  herdr.send_all({ submit = false })
end, { desc = "Paste comments in the agent's prompt" })
vim.keymap.set("n", "<leader>aS", function()
  herdr.send_all({ submit = true })
end, { desc = "Submit comments to the agent" })
vim.keymap.set("x", "<leader>ai", herdr.ref_selection, { desc = "Reference selection at the agent's cursor" })
vim.keymap.set("n", "<leader>ai", herdr.ref_line, { desc = "Reference line at the agent's cursor" })
