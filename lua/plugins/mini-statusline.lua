-- Only what I look at: mode, path relative to the cwd, branch, diagnostics and position.
local statusline = require("mini.statusline")

local function filename()
  if vim.bo.buftype == "terminal" then
    return "%t"
  end
  -- %f keeps the path as typed, which is absolute for files opened from outside the cwd.
  local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
  return (path == "" and "[No Name]" or path:gsub("%%", "%%%%")) .. "%m%r"
end

local function branch()
  local head = (vim.b.minigit_summary or {}).head_name
  return head and (" " .. head) or ""
end

statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { branch(), statusline.section_diagnostics({ trunc_width = 75 }) } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename() } },
        "%=",
        { hl = mode_hl, strings = { "%l:%v" } },
      })
    end,
  },
})
