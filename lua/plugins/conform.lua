-- Editing: format on save with the tools each project declares, LSP for the rest. Neovim formats only through the
-- LSP and no mini module formats, so the ERB tools need a formatter runner.
vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

local util = require("conform.util")

-- vim.b.autoformat wins over vim.g.autoformat, so one buffer can opt out while the rest keep formatting.
local function enabled(buf)
  local value = vim.b[buf].autoformat
  if value == nil then
    value = vim.g.autoformat
  end
  return value ~= false
end

local function read(dir, name)
  local file = dir and io.open(vim.fs.joinpath(dir, name))
  if not file then
    return ""
  end
  local content = file:read("*a")
  file:close()
  return content
end

local function has_erb_lint(buf)
  return vim.fs.root(buf, ".erb_lint.yml") ~= nil
end

-- No YAML parser in Neovim: look for `enabled: true` among the indented lines under the top-level `formatter:` key.
local function has_herb_format(buf)
  local in_formatter = false
  for line in vim.gsplit(read(vim.fs.root(buf, ".herb.yml"), ".herb.yml"), "\n") do
    if line:match("^[^%s#]") then
      in_formatter = line:match("^formatter:") ~= nil
    elseif in_formatter and line:match("^%s+enabled:%s*true%f[^%w_]") then
      return true
    end
  end
  return false
end

local function has_erb_formatter(buf)
  return read(vim.fs.root(buf, "Gemfile.lock"), "Gemfile.lock"):find("%serb%-formatter %(") ~= nil
end

local function has_config(buf, prefixes)
  return vim.fs.root(buf, function(name)
    for _, prefix in ipairs(prefixes) do
      if vim.startswith(name, prefix) then
        return true
      end
    end
    return false
  end) ~= nil
end

local function client_named(name)
  return function(client)
    return client.name == name
  end
end

-- One formatter per JS/TS file, picked from the project's configs: two of them fight over quotes and commas.
local function javascript(buf)
  if has_config(buf, { "eslint.config.", ".eslintrc" }) then
    return { filter = client_named("eslint") }
  elseif has_config(buf, { "prettier.config.", ".prettierrc" }) then
    return { "prettier", lsp_format = "never" }
  end
  return { filter = client_named("vtsls") }
end

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    -- Each ERB tool runs only when the project declares it, so the LSP never formats ERB.
    eruby = { "herb_format", "erb_format", "erb_lint", lsp_format = "never" },
    javascript = javascript,
    javascriptreact = javascript,
    typescript = javascript,
    typescriptreact = javascript,
    -- ruby_lsp already formats with rubocop when the Gemfile has it; the rubocop server is there for diagnostics.
    ruby = { filter = client_named("ruby_lsp") },
  },
  formatters = {
    herb_format = {
      command = util.from_node_modules("herb-format"),
      cwd = function(_, ctx)
        return vim.fs.root(ctx.buf, ".herb.yml")
      end,
      condition = function(_, ctx)
        return has_herb_format(ctx.buf)
      end,
    },
    -- A project with no ERB tooling of its own still gets erb-format, as before.
    erb_format = {
      condition = function(_, ctx)
        return has_erb_formatter(ctx.buf) or not (has_erb_lint(ctx.buf) or has_herb_format(ctx.buf))
      end,
    },
    -- erb_lint can't read stdin, so conform hands it a temp copy of the buffer next to the file.
    erb_lint = {
      command = "erb_lint",
      args = { "--autocorrect", "$FILENAME" },
      stdin = false,
      -- Exit 1 means offenses it couldn't fix; the fixes it made are still good.
      exit_codes = { 0, 1 },
      condition = function(_, ctx)
        return has_erb_lint(ctx.buf)
      end,
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
