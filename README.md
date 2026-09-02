# nvim-pdf

Toggle the current window between a `.tex` file and its sibling `.pdf`. [pdfreader.nvim](https://github.com/r-pletnev/pdfreader.nvim) renders the PDF.

Does not compile. If the PDF is missing, it says so.

## Install

```lua
{
  dir = "/home/spencerls/nvim-pdf", -- or "you/nvim-pdf" once this is a remote
  name = "nvim-pdf",
  dependencies = {
    "r-pletnev/pdfreader.nvim",
  },
  opts = {},
}
```

pdfreader needs snacks.nvim, Telescope, ImageMagick, Ghostscript, and poppler. Kitty or Ghostty for a real page.

## Usage

- `:TexPdfToggle` from `foo.tex` or `foo.pdf`
- Optional buffer-local keymap:

```lua
require("nvim-pdf").setup({
  keymap = "<leader>tp",
})
```
