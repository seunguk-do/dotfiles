-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.relativenumber = false
opt.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

if vim.fn.has("termguicolors") == 1 then
  -- Neovim has built-in bracketed paste mode support
  vim.opt.paste = false
  vim.opt.pastetoggle = ""

  -- Enable termguicolors properly
  vim.opt.termguicolors = true
end

vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_python_lsp = "pyrefly"
