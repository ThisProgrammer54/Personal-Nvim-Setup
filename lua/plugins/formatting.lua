return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cpp = { "clang_format" },
      c = { "clang_format" },
    },
    formatters = {
      clang_format = {
        command = "/usr/bin/clang-format",
        args = { "--assume-filename", "$FILENAME" },
        stdin = true,
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
