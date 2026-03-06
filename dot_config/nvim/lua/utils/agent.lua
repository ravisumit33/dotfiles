local M = {}

-- Snacks.terminal.toggle identifies terminals by cmd + cwd + count. LazyVim's
-- root.get() resolves the root from the current buffer, so when focus is on the
-- terminal buffer (which has no file path) it falls back to cwd and produces a
-- different root than the original file buffer. That changes both the tmux
-- session name in the cmd string and the cwd, causing Snacks to create a new
-- terminal instead of toggling the existing one. Caching the root on first
-- invocation (when a file buffer is focused) ensures the terminal identity
-- stays stable across subsequent toggle calls from either buffer.
local cached_root = nil
local cached_session = nil

local function get_root()
  if not cached_root then
    cached_root = require("lazyvim.util").root.get()
  end
  return cached_root
end

local function session_name()
  if not cached_session then
    local root = get_root()
    local hash = vim.fn.sha256(root):sub(1, 8)
    cached_session = "agent-" .. hash
  end
  return cached_session
end

function M.open()
  local root = get_root()
  local session = session_name()

  require("snacks").terminal.toggle("tmux new-session -A -s " .. session .. " agent", {
    cwd = root,
    win = {
      position = "right",
      width = 0.4,
      border = "left",
    },
  })
end

return M
