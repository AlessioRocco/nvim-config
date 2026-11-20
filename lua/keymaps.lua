local map = vim.keymap.set

map({ "n", "x", "o" }, "H", "^", { desc = "Start of line" })
map({ "n", "x", "o" }, "L", "$", { desc = "End of line" })

-- Copy to the system clipboard unless a register was given explicitly ("a<leader>fy).
local function copy(text)
  if text == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end
  local reg = vim.v.register == '"' and "+" or vim.v.register
  vim.fn.setreg(reg, text)
  vim.notify("Copied: " .. text)
end

map("n", "<leader>fy", function()
  copy(vim.fn.expand("%:."))
end, { desc = "Copy relative file path" })

map("n", "<leader>fY", function()
  local path = vim.fn.expand("%:.")
  copy(path == "" and "" or path .. ":" .. vim.fn.line("."))
end, { desc = "Copy relative file path and line" })

map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
