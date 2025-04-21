-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>vg', '<cmd>Neotree reveal float git_status<CR>', desc = '[V]iew [G]it modified', silent = true },
    { '<leader>vb', '<cmd>Neotree reveal float buffers<CR>', desc = '[V]iew [B]uffers', silent = true },
    { '<leader>vt', '<cmd>Neotree reveal float<CR>', desc = '[V]iew [T]ree', silent = true },
    { '\\', '<cmd>Neotree reveal float<CR>', desc = 'View Tree, silent = true' },
  },
  opts = {
    filesystem = {
      use_libuv_file_watcher = true,
      window = {
        position = 'float',
      },
    },
  },
}
