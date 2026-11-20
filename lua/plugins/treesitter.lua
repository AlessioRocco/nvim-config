-- Navigate and review code: installs treesitter parsers and ships their queries. Neovim bundles only a handful of
-- parsers and mini has no parser installer; highlighting, folds and indent stay Neovim's own via vim.treesitter.start().

-- Parsers must match the plugin's queries, so rebuild them whenever vim.pack updates it.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("avim_treesitter_update", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= "nvim-treesitter" or ev.data.kind ~= "update" then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd("nvim-treesitter")
    end
    require("nvim-treesitter").update()
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { confirm = false })

local ts = require("nvim-treesitter")

-- What I read every day; anything else installs the first time a file of its type opens.
ts.install({
  "bash",
  "css",
  "diff",
  "dockerfile",
  "embedded_template",
  "fish",
  "git_rebase",
  "gitcommit",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "nix",
  "query",
  "ruby",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
})

---@param buf integer
---@param lang string
local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
    return
  end
  vim.treesitter.start(buf, lang)
  -- Only where the language has the query, so filetypes without one keep their own foldexpr/indentexpr.
  if vim.treesitter.query.get(lang, "folds") then
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end
  if vim.treesitter.query.get(lang, "indents") then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available ---@type string[]?
local requested = {} ---@type table<string, true>

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("avim_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then
      return
    end
    if vim.list_contains(ts.get_installed("parsers"), lang) then
      return attach(ev.buf, lang)
    end
    -- get_available() fires the TSUpdate autocmds, so read it once and only when a parser is missing.
    available = available or ts.get_available()
    if vim.list_contains(available, lang) and not requested[lang] then
      -- Once per session: a failed install shouldn't retry on every buffer of that type.
      requested[lang] = true
      ts.install(lang):await(function()
        attach(ev.buf, lang)
      end)
    else
      -- Parsers bundled with Neovim or installed some other way.
      attach(ev.buf, lang)
    end
  end,
})
