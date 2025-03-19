return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false,
          autostart = false,
        },
        basedpyright = {
          mason = true, -- Set to true if you want to install via mason
          autostart = true,
        },
        ruff_lsp = {
          mason = true, -- Set to true if you want to install via mason
          autostart = true,
        },
      },
    },
  },
}
