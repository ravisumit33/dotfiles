return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				-- Sidekick's terminal is its own implementation (not Snacks.terminal)
				-- and hardcodes wrap=false. Override it here to avoid unwanted
				-- horizontal scroll from imprecise trackpad swipes.
				win = {
					wo = { wrap = true },
				},
				tools = {
					copilot = {
						cmd = {
							"copilot",
							"--banner",
							"--autopilot",
							"--allow-all-tools",
							"--reasoning-effort",
							"high",
						},
					},
				},
			},
		},
		keys = {
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus({ name = "copilot" })
				end,
				desc = "Sidekick Focus",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ name = "copilot" })
				end,
				desc = "Sidekick Toggle CLI",
			},
		},
	},
}
