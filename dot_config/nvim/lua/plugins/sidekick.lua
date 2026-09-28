return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
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
