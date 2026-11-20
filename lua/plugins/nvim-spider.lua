-- Navigate code: w/e/b stop inside camelCase and snake_case words. Neither Neovim nor mini has subword motions.
vim.pack.add({ "https://github.com/chrisgrieser/nvim-spider" }, { confirm = false })

for _, motion in ipairs({ "w", "e", "b" }) do
  vim.keymap.set({ "n", "o", "x" }, motion, function()
    require("spider").motion(motion)
  end, { desc = "Subword " .. motion })
end
