return {
  {
    "mason-org/mason.nvim",
    ensure_installed = {
      "stylua",
      "shfmt",
      "tex-fmt",
      "pyrefly",
      "ruff_format",
    }
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        pyrefly = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                reportMissingImports = "none",
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
        python = {"ruff_format"},
      },
    },
  },
}
