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

	local conflicted = false
	if not is_dir then
		local dir = vim.fn.fnamemodify(path, ":h")
		local unmerged = vim.fn.systemlist({ "git", "-C", dir, "ls-files", "-u", "--", path })
		conflicted = vim.v.shell_error == 0 and #unmerged > 0
	end

	-- Throwaway tab to give codediff a usable current buffer.
	if is_dir then
		-- Folder: nothing to focus. Empty buffer + window-local cwd inside the folder.
		vim.cmd("tabnew")
		vim.cmd("lcd " .. vim.fn.fnameescape(path))
	elseif conflicted then
		-- Conflict: merge mode resolves the repo from the path itself, so an empty buffer.
		vim.cmd("tabnew")
	else
		-- File: load it so codediff resolves the repo from it AND pre-focuses it.
		vim.cmd("tabnew " .. vim.fn.fnameescape(path))
	end
	local throwaway_tab = vim.api.nvim_get_current_tabpage()
	local throwaway_buf = vim.api.nvim_get_current_buf()

	if conflicted then
		-- merge mode is SYNCHRONOUS: its tab is already open and focused.
		vim.cmd("CodeDiff merge " .. vim.fn.fnameescape(vim.fn.resolve(path)))
	else
		-- explorer mode is ASYNC: we're still on the throwaway tab.
		-- Leave the throwaway so it can be deleted.
		vim.cmd("CodeDiff")
		vim.api.nvim_set_current_tabpage(lazygit_tab)
	end

	-- Cleanup throwaway_tab
	close_tab(throwaway_tab)
	if
		(is_dir or conflicted)
		and vim.api.nvim_buf_is_valid(throwaway_buf)
		and vim.api.nvim_buf_get_name(throwaway_buf) == ""
	then
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
