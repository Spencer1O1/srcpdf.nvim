local config = require("srcpdf.config")

local M = {}

---@param path string
---@return string
function M.extension(path)
	return vim.fn.fnamemodify(path, ":e"):lower()
end

---@param ext string
---@return boolean
function M.is_source_ext(ext)
	for _, source in ipairs(config.get().sources) do
		if ext == source then
			return true
		end
	end
	return false
end

--- Absolute path of the generated PDF for this source.
---@param path string
---@param outdir? string
---@return string
function M.output_pdf(path, outdir)
	outdir = outdir or config.get().outdir
	return vim.fs.joinpath(
		vim.fn.fnamemodify(path, ":h"),
		outdir,
		vim.fn.fnamemodify(path, ":t:r") .. ".pdf"
	)
end

--- PDF to open: `outdir/<stem>.pdf` for a source, or the file itself if it is a PDF.
---@param path string
---@return string|nil
function M.pdf_path(path)
	if path == nil or path == "" then
		return nil
	end
	local ext = M.extension(path)
	if ext == "pdf" then
		return path
	end
	if M.is_source_ext(ext) then
		return M.output_pdf(path)
	end
	return nil
end

return M
