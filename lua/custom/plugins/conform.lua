-- https://github.com/stevearc/conform.nvim
-- Lightweight yet powerful formatter plugin for Neovim

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>f',
      function()
        require('conform').format { async = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      bash = { 'shfmt', 'shellcheck' },
      elixir = { 'mix' },
      html = { 'prettier' },
      json = { 'jq' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      sh = { 'shfmt', 'shellcheck' },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = 'fallback',
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {
      jq = {
        prepend_args = { '-S' },
      },
      ['markdown-toc'] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find '<!%-%- toc %-%->' then
              return true
            end
          end
        end,
      },
      ['markdownlint-cli2'] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == 'markdownlint'
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Trigger conform on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        require('conform').format { bufnr = args.buf }
      end,
    })
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.md', '*.puml' },
      once = true,
      callback = function(args)
        vim.cmd { cmd = 'terminal', args = { 'java', '-jar', '/opt/plantuml/plantuml.jar', '-tsvg', args.file } }
      end,
    })
  end,
}
