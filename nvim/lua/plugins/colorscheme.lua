return {
  -- add onedark
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "dark",
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
