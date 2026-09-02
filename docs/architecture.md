# Architecture

```
source ── compile (later) ──► foo.pdf
                                 │
                            vim.ui.open
                                 ▼
                         system PDF viewer
```

We own the path + open + maybe compile. The OS owns viewing.

`:PdfOpen` on a source file opens the sibling PDF and does not leave the source buffer. On a `.pdf` buffer it opens that file in the system viewer.

## Our layer

1. **Pair** — configured source extensions (`sources`, v1: `tex`) ↔ sibling `.pdf`.
2. **Open** — `vim.ui.open` on the PDF (`xdg-open`, `open`, or the Windows handler).
3. **Compile** — later. Per-source (latexmk / tectonic, later pandoc).

## Later, not now

- `"md"` in `sources`
- Multi-file projects where the output PDF is not the sibling
- SyncTeX
