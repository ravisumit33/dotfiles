local toggle_key = "<C-,>"

return {
  "coder/claudecode.nvim",
  keys = {
    { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Toggle Claude", mode = { "n", "x" } },
  },
  opts = {
    terminal = {
      snacks_win_opts = {
        keys = {
          claude_hide = { toggle_key, function(self) self:hide() end, mode = "t", desc = "Hide Claude" },
        },
      },
    },
  },
}