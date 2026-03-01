return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<CR>"] = {} -- Remove the original <CR> mapping
      opts.keymap["<S-CR>"] = { "accept", "fallback" }

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      -- Extend the default list to include 'avante' if not already present
      if not vim.tbl_contains(opts.sources.default, "avante") then
        table.insert(opts.sources.default, "avante")
      end
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.avante = {
        module = "blink-cmp-avante",
        name = "Avante",
        opts = {
          -- options for blink-cmp-avante
        },
      }
      return opts
    end,
  },
}
