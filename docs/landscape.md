# Existing PDF plugins

Yes. A PDF plugin for Vim already exists — several, in two different families.

There is no dominant in-editor PDF viewer the way Zathura or `less` dominate their niches. Most options are either “dump the PDF to text” or small Neovim experiments that rasterize pages into the terminal.

## Text dump (classic Vim)

These treat a PDF as a read-only text buffer. No typesetting. Works anywhere.

| Plugin | What it does |
| --- | --- |
| [makerj/vim-pdf](https://github.com/makerj/vim-pdf) | Auto-converts `.pdf` with `pdftotext` on open |
| [rhysd/open-pdf.vim](https://github.com/rhysd/open-pdf.vim) | `:Pdf`, caches the extracted text |
| [basola21/PDFview](https://github.com/basola21/PDFview) | Neovim + Telescope + `pdftotext` pages |
| One-liner autocmd | `pdftotext -layout % -` into the buffer |

A lot of people also just `:!zathura %` or let [VimTeX](https://github.com/lervag/vimtex) open an external viewer after compile. That is still the standard LaTeX workflow.

## Rasterized pages (Neovim + terminal graphics)

These compile a page to an image and show it in Neovim. Quality depends on Kitty / Ghostty / Sixel, usually via `image.nvim` or snacks.

| Plugin | Rasterizer | Display | Notes |
| --- | --- | --- | --- |
| [r-pletnev/pdfreader.nvim](https://github.com/r-pletnev/pdfreader.nvim) | poppler + ImageMagick | snacks / Kitty | Bookmarks, TOC, text fallback |
| [tianbaiting/pdfbuffer.nvim](https://github.com/tianbaiting/pdfbuffer.nvim) | `pdftoppm` | `image.nvim`, Chafa fallback | Closest to “viewer in the buffer” |
| [propilideno/buffer-preview.nvim](https://github.com/propilideno/buffer-preview.nvim) | `pdftoppm` / `pdftocairo` | `image.nvim` | Hijacks `:e file.pdf`; also pptx/odp |
| [joshheyse/mupager.nvim](https://github.com/joshheyse/mupager.nvim) | mupager binary | Kitty graphics | Dedicated pager, not a Lua rasterizer |
| [StefanBartl/pdfport.nvim](https://github.com/StefanBartl/pdfport.nvim) | several extractors | buffer / float / terminal / system | More “get PDF content out” than a viewer |

[3rd/image.nvim](https://github.com/3rd/image.nvim) is not a PDF viewer. It is the graphics layer most of the raster plugins sit on.

## What this means for us

We are not discovering a missing category. We would be entering a crowded, mostly young Neovim field.

The honest reasons to build anyway:

- Own a small, PDF-first viewport we can hang a LaTeX compile hook on later.
- Learn the rasterize → window → page-nav loop instead of wrapping someone else’s plugin.
- Keep Chafa as a fallback, not the product — `pdfbuffer.nvim` already does that pairing.

The honest reasons not to:

- `:e paper.pdf` already works in `pdfreader.nvim` / `pdfbuffer.nvim` / `buffer-preview.nvim`.
- VimTeX + Zathura is a better LaTeX preview if leaving Neovim is acceptable.
- Speaking Kitty/Sixel ourselves would be a waste; that problem is solved.
