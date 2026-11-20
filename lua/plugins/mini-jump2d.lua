-- Jump labels on s: type a character, then the label of the spot, in any visible window.
require("mini.jump2d").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  view = { dim = true },
  mappings = { start_jumping = "" },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end, { desc = "Jump to character" })
