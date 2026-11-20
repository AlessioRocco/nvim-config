-- erb_lint diagnostics on ERB files, without nvim-lint: one command whose compact output vim.diagnostic.match reads.
-- erb_lint can't read stdin, so it lints the file on disk, after a read or a write.
local ns = vim.api.nvim_create_namespace("avim-erb-lint")

local function lint(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" or vim.fn.executable("erb_lint") == 0 then
    return
  end
  vim.system({ "erb_lint", "--format", "compact", file }, { text = true }, function(out)
    local diagnostics = {}
    for line in vim.gsplit(out.stdout or "", "\n", { trimempty = true }) do
      local diagnostic = vim.diagnostic.match(
        line,
        "^.-:(%d+):(%d+): (.+)$",
        { "lnum", "col", "message" },
        nil,
        { severity = vim.diagnostic.severity.WARN, source = "erb_lint" }
      )
      if diagnostic then
        table.insert(diagnostics, diagnostic)
      end
    end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.diagnostic.set(ns, buf, diagnostics)
      end
    end)
  end)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("avim-erb-lint", { clear = true }),
  pattern = "*.erb",
  callback = function(ev)
    lint(ev.buf)
  end,
})
