# Repos

Two repos, two jobs.

| Repo | Role |
| --- | --- |
| `~/nvim-pdf` (plugin: `srcpdf.nvim`) | Pair source ↔ `.pdf`, open in the system viewer, later compile |
| `~/dotfiles` | Consumer: lazy spec and keymap |

`~/.config/nvim` is a symlink to `dotfiles/nvim`. The consumer spec is `dotfiles/nvim/lua/spencerls/plugins/srcpdf.lua`.

Do not put user keymaps or lazy.nvim wiring in the plugin. The plugin exposes `:PdfOpen` and `require("srcpdf").open()`.
