-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- delete not used

vim.keymap.del("n", "<leader>K")
vim.keymap.del("n", "<leader>S")
vim.keymap.del("n", "<leader>,")
vim.keymap.del("n", "<leader>-")

-- Terminal
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
