-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make line numbers default
vim.opt.number = true

-- Enable break indent
vim.opt.breakindent = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
