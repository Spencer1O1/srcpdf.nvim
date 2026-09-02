local M = {}

function M.check()
	vim.health.start("srcpdf")
	vim.health.ok("Opens sibling PDFs with the system viewer (vim.ui.open)")
end

return M
