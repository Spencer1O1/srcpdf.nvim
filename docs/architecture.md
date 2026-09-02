# Architecture

```
.tex   ── latexmk / tectonic / pdflatex ──┐
.md    ── pandoc → HTML ──┐               ├──► out/foo.pdf
.html  ───────────────────┴ weasyprint ───┘
                                               │
                                          vim.ui.open
                                               ▼
                                       system PDF viewer
```

`.md` and `.html` are documentation. They never use a TeX engine.

`:PdfOpen` writes the buffer, compiles into `out/`, then opens the PDF.
Neovim stays on the source.

1. **Pair** — configured `sources` ↔ `out/<stem>.pdf`
2. **Compile** — toolchain from the extension; PDF and aux files go in `out/`.
   Missing tools: one warning + install command, then stop.
3. **Open** — `vim.ui.open`

```
lua/srcpdf/
  init.lua          public API: setup, open, pdf_path
  config.lua        options
  pair.lua          source ↔ out/<stem>.pdf
  notify.lua        user messages
  open.lua          write → compile → viewer
  compile/          plan a command by extension
    tex.lua         LaTeX
    docs.lua        Markdown / HTML
    tools.lua       executable + install line
  health.lua
```
