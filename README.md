# srcpdf.nvim

Turn the file you are writing into a PDF and open it.

`:PdfOpen` compiles the current buffer to `out/<stem>.pdf` and hands it to the
system viewer. You keep editing the source — the PDF is just a preview.

One command covers the usual PDF sources:

| You write | srcpdf builds a PDF with |
| --- | --- |
| `.tex` | latexmk, tectonic, or pdflatex (papers, math) |
| `.md` | pandoc + weasyprint (documentation) |
| `.html` | weasyprint (documentation) |

Requires Neovim 0.10+.

## Install

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "Spencer1O1/srcpdf.nvim",
  ft = { "tex", "plaintex", "markdown", "html" },
  opts = {},
  keys = {
    { "<leader>p", function() require("srcpdf").open() end, desc = "Open PDF" },
  },
}
```

The plugin does not set a keymap. Bind `:PdfOpen` or `require("srcpdf").open()`
yourself.

## Tools

Install only what you compile. `:checkhealth srcpdf` reports what is missing
and the install command.

```bash
# LaTeX
sudo apt install latexmk texlive

# Markdown + HTML
sudo apt install pandoc weasyprint
```

On macOS, `brew install latexmk pandoc weasyprint` (plus a TeX distribution).

Add `out/` to the project's `.gitignore`. Compiler junk and the PDF all land
there.

## Usage

From `notes.tex`, `notes.md`, or `notes.html`:

1. `:PdfOpen` writes the buffer if it is modified
2. Compiles into `out/`
3. Opens `out/notes.pdf` with `vim.ui.open`

If a compiler is missing, you get one warning and an install line. A leftover
PDF is not opened.

Examples: [`examples/hello.tex`](examples/hello.tex),
[`examples/hello.md`](examples/hello.md),
[`examples/hello.html`](examples/hello.html).

## Setup

`setup()` is optional. Defaults:

```lua
require("srcpdf").setup({
  sources = { "tex", "md", "html", "htm" },
  outdir = "out",
})
```

| Option | Default | Meaning |
| --- | --- | --- |
| `sources` | `tex`, `md`, `html`, `htm` | Extensions that pair with `outdir/<stem>.pdf` |
| `outdir` | `"out"` | Directory next to the source for the PDF and aux files |

## Commands and API

| | |
| --- | --- |
| `:PdfOpen` | Compile (if needed) and open the PDF |
| `require("srcpdf").open()` | Same |
| `require("srcpdf").pdf_path(path)` | `out/<stem>.pdf` for a source, or `path` if it is already a PDF |
| `:checkhealth srcpdf` | Toolchain status |
| `:help srcpdf` | Full help |

## What this is not

- An in-terminal PDF renderer
- A VimTeX replacement
- SyncTeX or multi-file project layout

See [docs/architecture.md](docs/architecture.md) for the compile pipeline and
module map.
