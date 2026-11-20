-- mini.nvim first so later files can enable its modules, then the colorscheme so every plugin after it sees its
-- highlights; the rest load in alphabetical order, so adding a plugin is adding a file.
local first = { "mini", "colorscheme" }

for _, name in ipairs(first) do
  require("plugins." .. name)
end

local dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
local rest = {}
for file, kind in vim.fs.dir(dir) do
  local name = file:match("^(.+)%.lua$")
  if kind == "file" and name and name ~= "init" and not vim.list_contains(first, name) then
    table.insert(rest, name)
  end
end
table.sort(rest)

for _, name in ipairs(rest) do
  require("plugins." .. name)
end
