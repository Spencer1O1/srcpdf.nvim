# Scope

This repo is source → PDF glue. The viewer is whatever the OS already uses for `.pdf` files. The plugin is `srcpdf.nvim`.

## What we build

- Pair a source file with a sibling `.pdf` (same stem, same directory)
- Open that PDF in the system viewer (`vim.ui.open`)
- Stay in the source buffer
- Optionally compile the source before opening (later)

v1 source: `.tex`. Later sources (Markdown, …) are more entries in `sources`, not a new plugin.

## What we do not build

- An in-terminal PDF renderer
- pdfreader / Kitty / Ghostty / Chafa / ImageMagick integration
- A VimTeX replacement

## Success

From `main.tex`, one keymap opens `main.pdf` in the native PDF viewer. Neovim stays on the `.tex`.
