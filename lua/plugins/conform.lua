-- Editing: format on save with stylua, shfmt and erb_format then erb_lint, LSP for the rest. Neovim formats only
-- through the LSP and no mini module formats, so the ERB chain needs a formatter runner.
vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

-- vim.b.autoformat wins over vim.g.autoformat, so one buffer can opt out while the rest keep formatting.
local function enabled(buf)
  local value = vim.b[buf].autoformat
  if value == nil then
    value = vim.g.autoformat
  end
  return value ~= false
end

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    eruby = { "erb_format", "erb_lint" },
  },
  formatters = {
    -- erb_lint can't read stdin, so conform hands it a temp copy of the buffer next to the file.
    erb_lint = {
      command = "erb_lint",
      args = { "--autocorrect", "$FILENAME" },
      stdin = false,
      -- Exit 1 means offenses it couldn't fix; the fixes it made are still good.
      exit_codes = { 0, 1 },
    },
  },
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(buf)
    if enabled(buf) then
      -- erb_lint boots Ruby, which doesn't fit in conform's default 1s.
      return { timeout_ms = 3000 }
    end
  end,
})

local function toggle(scope)
  local buf = vim.api.nvim_get_current_buf()
  if scope == "b" then
    vim.b[buf].autoformat = not enabled(buf)
  else
    vim.g.autoformat = vim.g.autoformat == false
    vim.b[buf].autoformat = nil
  end
  local state = enabled(buf) and "on" or "off"
  vim.notify(("Format on save %s (%s)"):format(state, scope == "b" and "buffer" or "global"))
end

vim.keymap.set("n", "<leader>uf", function()
  toggle("g")
end, { desc = "Toggle format on save" })
vim.keymap.set("n", "<leader>uF", function()
  toggle("b")
end, { desc = "Toggle format on save (buffer)" })
