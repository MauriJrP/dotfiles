-- Reuse NvChad defaults
local ok, nvlsp = pcall(require, "nvchad.configs.lspconfig")
local on_attach = ok and nvlsp.on_attach or function() end
local capabilities = ok and nvlsp.capabilities or vim.lsp.protocol.make_client_capabilities()

-- local lspconfig = require "lspconfig"
-- local nvlsp = require "nvchad.configs.lspconfig"
-- local on_attach = nvlsp.on_attach
-- local capabilities = nvlsp.capabilities

-- ---------- Python ----------
-- Pyright: types, defs, hover, etc.
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = { analysis = { typeCheckingMode = "basic" } },
  },
}
-- Ruff LSP: fast linting/fixes
lspconfig.ruff.setup    { on_attach = on_attach, capabilities = capabilities }

-- ---------- Java ----------
-- JDTLS via lspconfig (basic; good enough for start)
-- jdtls needs a root dir; lspconfig will detect via maven/gradle/git.
lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ---------- JS / TS ----------
-- Prefer VTSLS (faster, smarter) if installed, else tsserver fallback
local has_vtsls = pcall(require, "vtsls")
if has_vtsls then
  lspconfig.vtsls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      typescript = { preferences = { importModuleSpecifier = "non-relative" } },
      javascript = { preferences = { importModuleSpecifier = "non-relative" } },
    },
  }
else
  lspconfig.ts_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

