-- TODO: Check snacks picker support in future releases and remove native prompt and select ui

-- Switch worktree via the native selector (vim.ui.select).
local function switch_worktree()
	local out = vim.fn.systemlist({ "git", "worktree", "list" })
	if vim.v.shell_error ~= 0 then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end
	local items = {}
	for _, line in ipairs(out) do
		if not line:match("%(bare%)") then
			local path = line:match("^(%S+)") -- exact path git reports (what switch needs)
			local branch = line:match("%[(.-)%]")
			if path then
				items[#items + 1] = { path = path, label = string.format("%-30s %s", branch or "(detached)", path) }
			end
		end
	end
	if #items == 0 then
		vim.notify("No worktrees found", vim.log.levels.WARN)
		return
	end
	vim.ui.select(items, {
		prompt = "Switch git worktree",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			require("git-worktree").switch_worktree(choice.path)
		end
	end)
end

-- Create a worktree via native prompts.
local function create_worktree()
	vim.ui.input({ prompt = "New worktree path: " }, function(path)
		if not path or path == "" then
			return
		end
		vim.ui.input({ prompt = "Branch: " }, function(branch)
			if not branch or branch == "" then
				return
			end
			require("git-worktree").create_worktree(path, branch)
		end)
	end)
end

return {
	"polarmutex/git-worktree.nvim",
	version = "^2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local hooks = require("git-worktree.hooks")
		hooks.register(hooks.type.SWITCH, hooks.builtins.update_current_buffer_on_switch)
	end,
	keys = {
		{ "<leader>gw", switch_worktree, desc = "Git worktree switch" },
		{ "<leader>gW", create_worktree, desc = "Git worktree create" },
	},
}
