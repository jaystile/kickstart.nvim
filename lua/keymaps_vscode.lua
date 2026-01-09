-- Map :bd to VSCode's close tab command
vim.api.nvim_set_keymap('n', ':bd', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>', { noremap = true, silent = true })

-- Maps :vb to show open buffers
vim.api.nvim_set_keymap('n', '<leader>vb', '<Cmd>call VSCodeNotify("workbench.action.showAllEditors")<CR>', { noremap = true, silent = true })

-- fuzzy file open
vim.api.nvim_set_keymap('n', '<leader>sf', '<Cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', { noremap = true, silent = true })

-- map to find in files
vim.api.nvim_set_keymap('n', '<leader>sg', '<Cmd>call VSCodeNotify("workbench.action.findInFiles")<CR>', { noremap = true, silent = true })

-- Open the file explorer with `\`
vim.api.nvim_set_keymap('n', '\\', '<Cmd>call VSCodeNotify("workbench.view.explorer")<CR>', { noremap = true, silent = true })
