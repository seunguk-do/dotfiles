return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          mason = true, -- Set to true if you want to install via mason
          autostart = true,
          settings = {
            basedpyright = {
              analysis = {
                diagnosticSeverityOverrides = "none",
                typeCheckingMode = "off",
                inlayHints = {
                  variableTypes = false,
                  callArgumentNames = false,
                  functionReturnTypes = false,
                  genericTypes = false,
                },
              },
            },
          },
        },
        pyright = {
          mason = false,
          autostart = false,
        },
      },
    },
  },
}

