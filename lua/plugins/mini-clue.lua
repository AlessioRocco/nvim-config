-- Key hints, to remember the leader maps.
local clue = require("mini.clue")

local leader = function(keys, desc)
  return {
    { mode = "n", keys = "<Leader>" .. keys, desc = desc },
    { mode = "x", keys = "<Leader>" .. keys, desc = desc },
  }
end

clue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
  },
  clues = {
    leader("a", "+AI"),
    leader("f", "+Files"),
    leader("g", "+Git"),
    leader("o", "+Other"),
    leader("s", "+Search"),
    leader("u", "+Toggle"),
    leader("<Tab>", "+Tabs"),
    clue.gen_clues.g(),
    clue.gen_clues.z(),
    clue.gen_clues.square_brackets(),
    clue.gen_clues.windows(),
    clue.gen_clues.registers(),
    clue.gen_clues.marks(),
  },
  window = { delay = 300 },
})
