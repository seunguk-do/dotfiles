return {
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
        ruff = {},
      },
    },
  },
}
