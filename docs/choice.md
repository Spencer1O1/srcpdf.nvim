# Choosing among the three Neovim PDF plugins

These are not three implementations of the same idea. Pick the **job** first, then the plugin.

| Plugin | Job | How you open a PDF | Maturity |
| --- | --- | --- | --- |
| [pdfreader.nvim](https://github.com/r-pletnev/pdfreader.nvim) | Paper / ebook **reader** | `:e file.pdf` | Most established: releases, ~58 stars, since 2025 |
| [pdfbuffer.nvim](https://github.com/tianbaiting/pdfbuffer.nvim) | PDF **viewport** (page, zoom, refresh) | `:PdfBufferOpen [path]` | Personal tool: 2 stars, one-day burst |
| [buffer-preview.nvim](https://github.com/propilideno/buffer-preview.nvim) | Generic **buffer hijacker** | `:e file.pdf` | Mid: ~17 stars, multi-format |

Yes, pdfreader is more established. That matters if we are *using* a plugin rather than borrowing its internals.

## Actual UX we want

A keymap that toggles the current window between a source file (`foo.tex` now, later `foo.md`) and `foo.pdf`.

Not a side-by-side preview. The `.tex` buffer goes away, the PDF view takes its place, and the same keymap brings the source back.

That is the `:e file.pdf` model. pdfreader and buffer-preview both do it. pdfbuffer’s explicit `:PdfBufferOpen` was the better fit for “source stays, viewport beside it” — which we are not building.

The toggle itself is small:

```lua
-- sketch, not shipped
-- .tex → sibling .pdf, .pdf → sibling .tex
-- optionally compile first; optionally :PDFReader redrawPage
```

The plugin only has to make `:e foo.pdf` look like a page, not like binary garbage.

## Why pdfreader wins this job

- Opening a PDF *is* the view. That is the toggle.
- Most established of the three (releases, more users, longer life).
- Text fallback if Kitty / Ghostty is missing.
- Reader extras (TOC, bookmarks, page jump) are useful once you are *in* the PDF, not dead weight.

Cost: snacks.nvim, Telescope, ImageMagick, Ghostscript, poppler. `q` is zoom-out, not quit — the toggle keymap must be our own.

## Why not the other two *for this*

- **pdfbuffer** matches a split viewport we no longer want. Least established. Keep as a reference if we ever build our own.
- **buffer-preview** also hijacks `:e`, but PDF is one backend next to pptx/sqlite. Same open model, less of a reader, less established than pdfreader.

## Trial

1. Install pdfreader. Open a real PDF with `:e`.
2. Bind a toggle: current `%.tex` ↔ `%.pdf` (same window).
3. Recompile, toggle back to the PDF. Does the page update, or do we need `redrawPage`?
4. Confirm Kitty/Ghostty (or accept text mode).

If that feels like 80%, we write the keymap (and maybe a compile-then-toggle) instead of a fourth viewer.
