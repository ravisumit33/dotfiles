return {
	{
		"esmuellert/codediff.nvim",
		config = function(_, opts)
			require("codediff").setup(opts)
			-- Requirement: word-level diff highlights need white fg for readability on dark tokyonight.
			-- Problem: codediff resolves highlight groups by extracting only `bg`, then recreates the
			-- groups itself — stripping any `fg` we set beforehand.
			-- Solution: override the groups after setup() so our `fg` is the final value used for rendering.
			vim.api.nvim_set_hl(0, "CodeDiffCharInsert", { bg = "#1f8c40", fg = "#ffffff" })
			vim.api.nvim_set_hl(0, "CodeDiffCharDelete", { bg = "#a8253a", fg = "#ffffff" })
		end,
		opts = {
			highlights = {
				char_insert = "#1f8c40",
				char_delete = "#a8253a",
			},
			diff = {
				conflict_result_position = "center",
			},
		},
	},
}
