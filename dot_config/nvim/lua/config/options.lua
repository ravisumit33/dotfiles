-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.wrap = true
vim.opt.diffopt:append("algorithm:histogram,linematch:60") -- intra-line word diff (powers diffview enhanced_diff_hl)
