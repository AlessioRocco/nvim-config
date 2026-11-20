-- Servers come from Nix, or from a project's devenv for the Ruby ones; the configs come from nvim-lspconfig's lsp/
-- and the overrides from after/lsp/. Each server maps to the executable its cmd runs.
local servers = {
  bashls = "bash-language-server",
  cssls = "vscode-css-language-server",
  docker_language_server = "docker-language-server",
  eslint = "vscode-eslint-language-server",
  html = "vscode-html-language-server",
  jsonls = "vscode-json-language-server",
  ltex_plus = "ltex-ls-plus",
  lua_ls = "lua-language-server",
  marksman = "marksman",
  rubocop = "rubocop",
  ruby_lsp = "ruby-lsp",
  tailwindcss = "tailwindcss-language-server",
  vtsls = "vtsls",
  yamlls = "yaml-language-server",
}

-- A server whose executable is missing stays off: vim.lsp.enable() would log an error on every matching buffer.
for name, exe in vim.spairs(servers) do
  if vim.fn.executable(exe) == 1 then
    vim.lsp.enable(name)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("avim-lsp-attach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- Neovim maps grn, gra, grr, gri, grt, gO and K; gd is the one LazyVim habit kept on top of them.
    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    end
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  signs = true,
  -- Messages only for the cursor line, so a file full of warnings stays readable.
  virtual_text = { current_line = true },
})
