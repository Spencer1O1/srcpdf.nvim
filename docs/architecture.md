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

`:PdfOpen` writes the buffer, rebuilds if the source hash changed, then opens
the PDF. `:PdfBuild` stops after that rebuild. A `.pdf` buffer is only opened,
never compiled. Neovim stays on the source.

1. **Pair** — configured `sources` ↔ `out/<stem>.pdf`
2. **Hash** — `out/<stem>.srcsha` from the last successful build. Skip compile
   when the PDF exists and the source still matches.
3. **Compile** — toolchain from the extension; PDF and aux files go in `out/`.
   Missing tools: one warning + install command, then stop.
4. **Open** — `vim.ui.open` (`:PdfOpen` only)

```
lua/srcpdf/
  init.lua          public API: setup, open, build, pdf_path
  config.lua        options
  pair.lua          source ↔ out/<stem>.pdf + .srcsha
  notify.lua        user messages
  open.lua          write → hash → compile? → (viewer)
  compile/          plan a command by extension
    tex.lua         LaTeX
    docs.lua        Markdown / HTML
    tools.lua       executable + install line
  health.lua
```
