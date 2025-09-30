-- Ensure key LSP plugins load (NvChad ships them; we just make sure)
return {
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

