# srcpdf.nvim

Open the sibling `.pdf` of a source file in the system PDF viewer. Stay in the source buffer.

v1 pairs `.tex`. Other sources (Markdown, …) are the same sibling rule: add their extension to `sources`.

Does not compile. If the PDF is missing, it says so.

The git checkout is still `~/nvim-pdf`. The plugin name is `srcpdf.nvim`.

## Install

This repo is the plugin. The local consumer is `dotfiles/nvim/lua/spencerls/plugins/srcpdf.lua`.

```lua
{
  dir = vim.fn.expand("~/nvim-pdf"),
  name = "srcpdf.nvim",
  opts = {},
}
```

Uses `vim.ui.open` (`xdg-open` / `open` / Windows default). No Kitty, Ghostty, ImageMagick, or pdfreader.

## Usage

Try `examples/hello.tex` (sibling `hello.pdf`).

- `:PdfOpen` from a `.tex` file opens `hello.pdf` in the native viewer
- Bind it yourself; the plugin does not set a keymap:

```lua
vim.keymap.set("n", "<leader>p", require("srcpdf").open, { desc = "Open sibling PDF" })
```
