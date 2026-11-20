-- lazygit in a floating terminal; no plugin needed, and lazygit keeps its own theme from ~/.config/lazygit/config.yml.
local M = {}

function M.open()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit is not on $PATH", vim.log.levels.ERROR)
    return
  end

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  })

  -- Open in the repository of the current file, so it works when the cwd is elsewhere.
  local root = vim.fs.root(0, ".git") or vim.uv.cwd()
  vim.fn.jobstart({ "lazygit" }, {
    term = true,
    cwd = root,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      -- Pick up files lazygit changed (discarded hunks, checkouts).
      vim.cmd.checktime()
    end,
  })
  vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>gg", M.open, { desc = "Lazygit" })

return M
