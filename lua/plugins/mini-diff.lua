-- Hunk signs in the gutter against the index, with ]h/[h and gh/gH (apply/reset) from the defaults.
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "▁" },
  },
})

vim.keymap.set("n", "<leader>go", function()
  MiniDiff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })
