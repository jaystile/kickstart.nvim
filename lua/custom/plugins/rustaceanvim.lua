return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      -- tools = { },
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- you can also put keymaps in here
          vim.keymap.set(
            'n',
            'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions. It is much prettier.
            function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end,
            { silent = true, buffer = bufnr }
          )
          vim.keymap.set(
            'n',
            'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions. It is much prettier.
            function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end,
            { silent = true, buffer = bufnr }
          )

          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          --['rust-analyzer'] = {
          --  procMacro = {
          --    ignored = {
          --      leptos_macro = { 'server' },
          --    },
          --  },
          --},
        },
      },
      -- DAP configuration
      -- dap = { },
    }
  end,
}
