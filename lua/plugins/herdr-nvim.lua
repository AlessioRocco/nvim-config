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

-- Safe to call again: the sidebar daemon calls setup() on VimEnter and keeps the maps set here.
require("herdr-nvim").setup({ prefix = "<leader>a", keymaps = true })
