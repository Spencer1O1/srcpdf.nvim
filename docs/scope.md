# Scope

This repo is the `.tex` ↔ PDF glue. [pdfreader.nvim](https://github.com/r-pletnev/pdfreader.nvim) is the viewer.

## What we build

- Resolve `foo.tex` → sibling `foo.pdf` (and the reverse)
- A keymap that toggles the current window between those two
- Optionally compile the `.tex` before opening the PDF
- Redraw the pdfreader buffer after a compile if the page is stale

## What we do not build

- Rasterizing pages
- Kitty / Sixel / Chafa display
- Page next/prev, zoom, TOC, bookmarks (pdfreader)
- A VimTeX replacement — if VimTeX is already compiling, we may only view/toggle

## Success

From `main.tex`, one keymap shows `main.pdf` as a rendered page in the same window. The same keymap returns to the `.tex`.
