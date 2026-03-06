return {
  "folke/snacks.nvim",
  opts = {
    styles = {
      -- Trackpad swipes are rarely perfectly vertical, causing unwanted
      -- horizontal scroll. Override wrap=true on dashboard and terminal
      -- so only vertical scrolling happens. For terminal, Neovim resets
      -- wrap=false when a terminal channel is opened (termopen/jobstart),
      -- so wo alone doesn't stick on first creation — we re-apply it in
      -- on_win via vim.schedule.
      dashboard = {
        wo = { wrap = true },
      },
      terminal = {
        wo = { wrap = true },
        on_win = function(self)
          vim.schedule(function()
            if self:valid() then
              vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = self.win })
            end
          end)
        end,
        keys = {
          gw = {
            function()
              vim.wo.wrap = not vim.wo.wrap
            end,
            desc = "Toggle wrap",
            mode = "n",
          },
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          ignored = false,
          hidden = false,
          cycle = true,
          auto_close = true,
          follow = true,
          layout = {
            { preview = true },
            layout = {
              box = "horizontal",
              width = 0.8,
              height = 0.8,
              {
                box = "vertical",
                border = "rounded",
                title = "{source} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", border = "rounded", width = 0.7, title = "{preview}" },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<c-/>",
      function()
        Snacks.terminal("zsh", {
          win = { position = "float" },
        })
      end,
      mode = { "n", "t" },
      desc = "Toggle Terminal Floating",
    },
    {
      "<c-e>",
      function()
        local file = vim.fn.expand("%:p")

        -- Detect hidden (path contains "/.")
        local is_hidden = file:match("/%.") ~= nil

        -- Detect gitignored (only if inside git repo)
        local is_ignored = false
        if vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") ~= "" then
          is_ignored = vim.fn.system({ "git", "check-ignore", file }) ~= ""
        end

        Snacks.picker.explorer({
          focus = file,
          ignored = is_ignored,
          hidden = is_hidden,
        })
      end,
      desc = "Smart File Explorer",
    },
  },
}
