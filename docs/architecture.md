# Architecture

```
.tex ── compile (ours or VimTeX) ──► foo.pdf
                                         │
                         :e foo.pdf      ▼
                                   pdfreader.nvim
                                   (pages, zoom, TOC)

same keymap: foo.pdf ──► :e foo.tex
```

We own the path + toggle + maybe compile. pdfreader owns everything that happens once a `.pdf` is the current buffer.

## Our layer

1. **Pair** — from `foo.tex` find `foo.pdf`; from `foo.pdf` find `foo.tex`. Same stem, same directory, first slice.
2. **Toggle** — `:e` the other file in the current window. Do not split.
3. **Compile** — later or behind a second keymap. `latexmk` / `tectonic`, or call VimTeX if it is already there.
4. **Refresh** — after compile, `:PDFReader redrawPage` if just `:e` shows a stale page.

## Their layer

pdfreader + snacks + ImageMagick + poppler. We do not reimplement this.

## Later, not now

- Multi-file projects where the output PDF is not the sibling (`main.pdf` vs `chapters/foo.tex`)
- SyncTeX
- Side-by-side source + preview
