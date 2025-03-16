--[[
https://github.com/toppair/peek.nvim

Opens Firefox and displays the markdown.
> It did not automatically execute. Required:
> `npm install -g deno; deno task --quiet build:fast`

Note: this stopped working at one point and neither chromium nor firefox
 could be launched from the command line. Required a restart of the laptop.
--]]
return {

  'toppair/peek.nvim',
  event = { 'VeryLazy' },
  build = 'deno task --quiet build:fast',
  config = function()
    require('peek').setup {
      -- whether to automatically load preview when
      auto_load = true,
      -- entering another markdown buffer

      close_on_bdelete = true,
      -- close preview window on buffer delete

      -- enable syntax highlighting, affects performance
      syntax = true,

      -- 'dark' or 'light'
      theme = 'dark',

      update_on_change = true,

      -- 'webview', 'browser', string or a table of strings
      -- app = 'browser',
      app = 'firefox',

      filetype = { 'markdown' }, -- list of filetypes to recognize as markdown

      -- relevant if update_on_change is true
      -- start throttling when file exceeds this
      throttle_at = 200000,

      -- amount of bytes in size
      -- minimum amount of time in milliseconds
      throttle_time = 'auto',
      -- that has to pass before starting new render
    }
    vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
    vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
  end,
}
