-- a/i text objects: mini's defaults (q quotes, b brackets, f calls, a arguments, t tags, ...) plus g, the buffer.
require("mini.ai").setup({
  -- As in LazyVim, so a text object finds its target farther than mini's default 50 lines.
  n_lines = 500,
  custom_textobjects = {
    g = require("mini.extra").gen_ai_spec.buffer(),
  },
})
