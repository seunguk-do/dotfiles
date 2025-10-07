return {
  {
    "neovim/nvim-lspconfig",
    opts = {
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
