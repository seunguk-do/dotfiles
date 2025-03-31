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

if vim.env.TMUX ~= nil then
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = { "tmux", "load-buffer", "-w", "-" },
      ["*"] = { "tmux", "load-buffer", "-w", "-" },
    },
    paste = {
      ["+"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" },
      ["*"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" },
    },
    cache_enabled = 0,
  }
else
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
end

vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_python_lsp = "basedpyright"

if vim.fn.has("termguicolors") == 1 then
  vim.opt.t_BE = vim.api.nvim_replace_termcodes([[<Esc>[?2004h]], true, true, true)
  vim.opt.t_BD = vim.api.nvim_replace_termcodes([[<Esc>[?2004l]], true, true, true)
  vim.opt.t_PS = vim.api.nvim_replace_termcodes([[<Esc>[200~]], true, true, true)
  vim.opt.t_PE = vim.api.nvim_replace_termcodes([[<Esc>[201~]], true, true, true)
end
