local toggle_key = "<C-,>"
local auto_mode_key = "<C-.>"

return {
	"coder/claudecode.nvim",
	keys = {
		{ toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Toggle Claude", mode = { "n", "x" } },
		{ auto_mode_key, "<cmd>ClaudeCode --enable-auto-mode<cr>", desc = "Claude Auto Mode", mode = { "n", "x" } },
	},
	opts = {
		terminal_cmd = "claude --model opus",
		focus_after_send = true,
		terminal = {
			snacks_win_opts = {
				keys = {
					claude_hide = {
						toggle_key,
						function(self)
							self:hide()
						end,
						mode = "t",
						desc = "Hide Claude",
					},
					claude_hide_auto = {
						auto_mode_key,
						function(self)
							self:hide()
						end,
						mode = "t",
						desc = "Hide Claude",
					},
				},
			},
		},
	},
}
