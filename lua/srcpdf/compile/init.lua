local docs = require("srcpdf.compile.docs")
local pair = require("srcpdf.pair")
local tex = require("srcpdf.compile.tex")

local M = {}

---@class srcpdf.Warning
---@field message string
---@field install string

---@class srcpdf.CompilePlan
---@field argv string[]
---@field cwd string

---@class srcpdf.CompileCtx
---@field cwd string
---@field name string
---@field outdir string
---@field pdf string

--- What to run to build out/<stem>.pdf, or a warning if we cannot.
---@param path string
---@param outdir? string
---@return srcpdf.CompilePlan|nil
---@return srcpdf.Warning|nil
function M.plan(path, outdir)
	local cfg = require("srcpdf.config").get()
	outdir = outdir or cfg.outdir
	local cwd = vim.fn.fnamemodify(path, ":h")
	local out_abs = vim.fs.joinpath(cwd, outdir)
	vim.fn.mkdir(out_abs, "p")
	---@type srcpdf.CompileCtx
	local ctx = {
		cwd = cwd,
		name = vim.fn.fnamemodify(path, ":t"),
		outdir = out_abs,
		pdf = pair.output_pdf(path, outdir),
	}

	local ext = pair.extension(path)
	if ext == "tex" then
		return tex.plan(ctx)
	end
	if ext == "md" then
		return docs.plan_md(ctx)
	end
	if ext == "html" or ext == "htm" then
		return docs.plan_html(ctx)
	end
	return nil, nil
end

return M
