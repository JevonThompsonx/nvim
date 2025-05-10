require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
    "bash",
    "python",
    "c",
    "cpp",
    "rust",
    "go",
    -- Add other languages you want to be installed automatically at startup.
    -- Using "all" can also work but might install many parsers you don't need.
  },

  -- This is crucial for automatically installing new parsers
  -- when you open a filetype for which a parser isn't installed.
  auto_install = true,

  -- If true, parsers listed in `ensure_installed` will be installed synchronously during startup.
  -- Can make startup slower if many parsers are missing.
  sync_install = false,

  highlight = {
    enable = true,
    -- You can add other highlight settings here
  },
  indent = {
    enable = true,
  },
  -- Add other modules and their configurations if you use them
}
