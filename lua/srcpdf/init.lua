local M = {}

function M.setup(opts)
	require("srcpdf.config").setup(opts)
end

function M.pdf_path(path)
	return require("srcpdf.pair").pdf_path(path)
end

function M.open()
	require("srcpdf.open").open()
end

function M.build()
	require("srcpdf.open").build()
end

return M
