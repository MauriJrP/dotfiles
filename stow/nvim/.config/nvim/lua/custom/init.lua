-- custom/init.lua

local autocmd = vim.api.nvim_create_autocmd

-- Auto-open nvim-tree when starting nvim without args or with a directory
-- autocmd({ "VimEnter" }, {
--   callback = function(data)
--     -- if a file is passed, don't open tree
--     if vim.fn.argc() > 0 then
--       return
--     end
--
--     -- open the tree
--     require("nvim-tree.api").tree.open()
--   end,
-- })

-- if vim.fn.isdirectory(data.file) == 1 then
--   require("nvim-tree.api").tree.open()
-- end

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_open = require("nvim-tree.api").tree.is_visible()
    if tree_open and #vim.api.nvim_list_wins() == 1 then
      vim.cmd("qall")
    end
  end,
})

-- Format on demand
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, { desc = "Format buffer" })

