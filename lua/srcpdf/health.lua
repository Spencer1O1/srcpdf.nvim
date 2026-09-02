local docs = require("srcpdf.compile.docs")
local tex = require("srcpdf.compile.tex")
local tools = require("srcpdf.compile.tools")

local M = {}

local function first_of(bins)
	for _, bin in ipairs(bins) do
		if tools.exe(bin) then
			return bin
		end
	end
	return nil
end

function M.check()
	vim.health.start("srcpdf")
	vim.health.ok("Opens PDFs with the system viewer (vim.ui.open)")

	local latex = first_of({ "latexmk", "tectonic", "pdflatex" })
	if latex then
		vim.health.ok("LaTeX: " .. latex)
	else
		local warning = tex.missing()
		vim.health.warn(warning.message, { warning.install })
	end

	if tools.exe("pandoc") then
		vim.health.ok("Markdown: pandoc")
	else
		local warning = docs.md_missing()
		vim.health.warn(warning.message, { warning.install })
	end

	local engine = docs.html_engine()
	if engine then
		vim.health.ok("HTML PDF engine: " .. engine)
	else
		local warning = docs.html_missing()
		vim.health.warn(warning.message, { warning.install })
	end
end

return M
