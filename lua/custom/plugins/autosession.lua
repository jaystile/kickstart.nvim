-- https://github.com/rmagatti/auto-session
-- autosession should save a session file in the directory and restore the set
-- of files that you were working on. This was brought in to allow exiting and
-- entering a project and restoring where you left off with regards to open files.
return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- log_level = 'debug',
  },
}
