-- The filetypes and languages LazyVim checked; lspconfig's default list also covers plain text, typst, asciidoc and more.
---@type vim.lsp.Config
return {
  filetypes = { "bib", "context", "gitcommit", "html", "markdown", "org", "plaintex", "rnoweb", "rst", "tex" },
  settings = {
    ltex = {
      enabled = {
        "bibtex",
        "context",
        "context.tex",
        "gitcommit",
        "html",
        "latex",
        "markdown",
        "org",
        "restructuredtext",
        "rsweave",
      },
    },
  },
}
