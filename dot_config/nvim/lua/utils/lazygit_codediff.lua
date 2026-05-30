-- Open codediff for a file/folder, invoked from lazygit. The goal is a clean round trip: show the
-- diff, and when the user closes it (`q`), land back on the tab lazygit lives in.
local M = {}

-- Close a tabpage by closing its windows.
local function close_tab(tabpage)
	if not vim.api.nvim_tabpage_is_valid(tabpage) or tabpage == vim.api.nvim_get_current_tabpage() then
		return
	end
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		pcall(vim.api.nvim_win_close, win, true)
	end
end

function M.open(path)
	local lazygit_tab = vim.api.nvim_get_current_tabpage()
	local is_dir = vim.fn.isdirectory(path) == 1

	-- Throwaway tab to give codediff a usable current buffer.
	if is_dir then
		-- Folder: nothing to focus. Empty buffer + window-local cwd inside the folder.
		vim.cmd("tabnew")
		vim.cmd("lcd " .. vim.fn.fnameescape(path))
	else
		-- File: load it so codediff resolves the repo from it AND pre-focuses it.
		vim.cmd("tabnew " .. vim.fn.fnameescape(path))
	end
	local throwaway_tab = vim.api.nvim_get_current_tabpage()
	local throwaway_buf = vim.api.nvim_get_current_buf()

	vim.cmd("CodeDiff")

	-- Change the current tab from throwaway_tab so that throwaway_tab can be deleted
	vim.api.nvim_set_current_tabpage(lazygit_tab)

	-- Cleanup throwaway_tab
	close_tab(throwaway_tab)
	if is_dir and vim.api.nvim_buf_is_valid(throwaway_buf) and vim.api.nvim_buf_get_name(throwaway_buf) == "" then
		pcall(vim.api.nvim_buf_delete, throwaway_buf, { force = true })
	end

	-- return focus to Lazygit on CodeDiffClose
	vim.api.nvim_create_autocmd("User", {
		pattern = "CodeDiffClose",
		once = true,
		desc = "lazygit-codediff: return to lazygit on close",
		callback = vim.schedule_wrap(function()
			if vim.api.nvim_tabpage_is_valid(lazygit_tab) then
				pcall(vim.api.nvim_set_current_tabpage, lazygit_tab)
			end
		end),
	})

	return ""
end

return M
