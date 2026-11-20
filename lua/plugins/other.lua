-- Navigate code: Rails alternate files (component and template, extension and spec). Neither Neovim nor mini has
-- project-aware alternates.
vim.pack.add({ "https://github.com/rgroli/other.nvim" }, { confirm = false })

require("other-nvim").setup({
  mappings = {
    "rails",
    {
      pattern = "app/components/(.*)/(.*)_component.rb",
      target = "app/components/%1/%2_component/%2_component.html.erb",
      context = "component",
    },
    {
      pattern = "app/components/(.*)/.*_component/(.*)_component.html.erb",
      target = "app/components/%1/%2_component.rb",
      context = "component",
    },
    {
      pattern = "app/extensions/(.*)/(.*)_extension.rb",
      target = "spec/%1/%2_spec.rb",
      context = "test",
    },
    {
      pattern = "spec/(.*)/(.*)_spec.rb",
      target = "app/extensions/%1/%2_extension.rb",
    },
  },
  rememberBuffers = false,
})

vim.keymap.set("n", "<leader>oo", "<cmd>Other<cr>", { desc = "Alternate file" })
vim.keymap.set("n", "<leader>os", "<cmd>OtherSplit<cr>", { desc = "Alternate file in a split" })
vim.keymap.set("n", "<leader>ov", "<cmd>OtherVSplit<cr>", { desc = "Alternate file in a vsplit" })
