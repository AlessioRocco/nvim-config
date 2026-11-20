-- Blame and line history; it also tracks the branch for the statusline.
require("mini.git").setup()

-- Line the blame split up with the source window and scroll both together, so each line sits next to its commit.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("mini_git_blame", { clear = true }),
  pattern = "MiniGitCommandSplit",
  callback = function(ev)
    if ev.data.git_subcommand ~= "blame" then
      return
    end
    local win_src = ev.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
    vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
  end,
})

vim.keymap.set("n", "<leader>gb", "<Cmd>vertical Git blame -- %<CR>", { desc = "Git blame (file)" })
-- On a file line: its history; on a hash in log/blame output: that commit; on a diff line: the file at that commit.
vim.keymap.set({ "n", "x" }, "<leader>gl", function()
  MiniGit.show_at_cursor()
end, { desc = "Git history at cursor" })
