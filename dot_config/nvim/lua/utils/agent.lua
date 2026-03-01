local M = {}

local function session_name()
  local root = require("lazyvim.util").root.get()
  local hash = vim.fn.sha256(root):sub(1, 8)
  return "agent-" .. hash
end

function M.open()
  local session = session_name()

  require("snacks").terminal("tmux new-session -A -s " .. session .. " agent", {
    win = {
      position = "right",
      width = 0.4,
      border = "left",
    },
  })
end

return M
