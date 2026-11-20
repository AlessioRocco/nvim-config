-- Picker for files, grep, buffers, recent files, help, symbols and diagnostics. setup() also makes it vim.ui.select,
-- so code actions use it too.
require("mini.pick").setup()

local map = vim.keymap.set
local pick = function(name, local_opts)
  return function()
    MiniPick.registry[name](local_opts)
  end
end

map("n", "<leader><space>", pick("files"), { desc = "Find files" })
map("n", "<leader>ff", pick("files"), { desc = "Find files" })
map("n", "<leader>fg", pick("git_files"), { desc = "Find git files" })
map("n", "<leader>fr", pick("visit_paths"), { desc = "Recent files (cwd)" })
map("n", "<leader>/", pick("grep_live"), { desc = "Grep" })
map("n", "<leader>sg", pick("grep_live"), { desc = "Grep" })
map("n", "<leader>,", pick("buffers"), { desc = "Buffers" })
map("n", "<leader>sh", pick("help"), { desc = "Help pages" })
map("n", "<leader>sd", pick("diagnostic"), { desc = "Diagnostics" })
map("n", "<leader>sD", pick("diagnostic", { scope = "current" }), { desc = "Buffer diagnostics" })
map("n", "<leader>sR", pick("resume"), { desc = "Resume last picker" })

-- Without an attached server vim.lsp.buf only warns "no matching language servers", so these are safe anywhere.
map("n", "<leader>ss", pick("lsp", { scope = "document_symbol" }), { desc = "LSP symbols" })
map("n", "<leader>sS", pick("lsp", { scope = "workspace_symbol_live" }), { desc = "LSP workspace symbols" })
