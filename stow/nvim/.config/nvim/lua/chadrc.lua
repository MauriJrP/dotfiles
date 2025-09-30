---@type ChadrcConfig
local M = {}

M.ui = { theme = "catppuccin" }

-- Run after plugins are ready
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- (still load any other custom code if you want)
    pcall(require, "custom.init")
    pcall(require, "custom.lsp")

    -- Open nvim-tree on start (no file) or when starting on a dir
    -- local ok, api = pcall(require, "nvim-tree.api")
    -- if not ok then return end
    --
    -- local argc = vim.fn.argc()
    -- if argc == 0 then
    --   vim.schedule(function() api.tree.open() end)
    --   return
    -- end
    --
    -- local argv = vim.fn.argv()
    -- if argc == 1 and vim.fn.isdirectory(argv[1]) == 1 then
    --   vim.cmd.cd(argv[1])
    --   vim.schedule(function() api.tree.open() end)
    -- end
  end,
})

-- (optional) M.mappings = require "custom.mappings"
M.plugins  = {
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  -- optional: better TS server (vtsls)
  { "yioneko/nvim-vtsls" },
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow"
  },
}

return M

