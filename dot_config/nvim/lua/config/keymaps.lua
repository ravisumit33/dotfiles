-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set({ "n", "t" }, "<c-\\>", function()
-- 	require("utils.agent").open()
-- end, {
-- 	desc = "Agent",
-- })

-- Exit terminal mode without Esc, which terminal apps like Claude rely on.
vim.keymap.set("t", "<C-;>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
