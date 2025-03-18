--[[
This has been a bear to configure. [Found this configuration](https://github.com/iamcco/markdown-preview.nvim/issues/558#issuecomment-1739832086)

Requires external building:
```
cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app
npm install
```
--]]
return {
  'iamcco/markdown-preview.nvim',
  build = 'cd app && yarn install',
  ft = { 'markdown' },
  lazy = true,
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  config = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_auto_close = true
    vim.g.mkdp_open_to_the_world = false
    vim.g.mkdp_open_ip = '127.0.0.1'
    vim.g.mkdp_port = '8888'
    vim.g.mkdp_browser = 'firefox'
    vim.g.mkdp_echo_preview_url = true
    vim.g.mkdp_page_title = '${name}'

    vim.keymap.set('n', '<leader>tp', '<cmd>MarkdownPreviewToggle<CR>', { desc = '[T]oggle [P]review' })
  end,
}
