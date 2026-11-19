return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  -- keys = {
  --   {
  --     "<leader>cf",
  --     function()
  --       require("conform").format({ async = true, lsp_format = "fallback" })
  --     end,
  --     mode = "",
  --     desc = "[C]ode [F]ormat buffer",
  --   },
  -- },
  opts = {
    -- notify_on_error = false,
    format_on_save = true,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      html = { "prettier" },
      css = { "prettier" },
      javascript = { "prettier" },
      htmldjango = { "djlint" },
      sh = { "shfmt" },
      qml = { "qmlformat" },
    },
  },
}
