local tools = require("srcpdf.compile.tools")

local M = {}

--- HTML → PDF. Markdown goes through pandoc first.
--- Never pdflatex / lualatex / tectonic / typst.
---@return string|nil
function M.html_engine()
	if tools.exe("weasyprint") then
		return "weasyprint"
	end
	if tools.exe("wkhtmltopdf") then
		return "wkhtmltopdf"
	end
	return nil
end

---@return srcpdf.Warning
function M.md_missing()
	if not tools.exe("pandoc") then
		return {
			message = "pandoc not found — Markdown PDFs need pandoc.",
			install = tools.install_cmd("pandoc", "pandoc"),
		}
	end
	return {
		message = "No HTML PDF engine — need weasyprint (docs, not LaTeX).",
		install = tools.install_cmd("weasyprint", "weasyprint"),
	}
end

---@return srcpdf.Warning
function M.html_missing()
	return {
		message = "No HTML PDF engine — need weasyprint.",
		install = tools.install_cmd("weasyprint", "weasyprint"),
	}
end

---@param ctx srcpdf.CompileCtx
---@return srcpdf.CompilePlan|nil
---@return srcpdf.Warning|nil
function M.plan_md(ctx)
	if not tools.exe("pandoc") then
		return nil, M.md_missing()
	end
	local engine = M.html_engine()
	if not engine then
		return nil, M.md_missing()
	end
	return {
		argv = { "pandoc", ctx.name, "-o", ctx.pdf, "--pdf-engine=" .. engine },
		cwd = ctx.cwd,
	}
end

---@param ctx srcpdf.CompileCtx
---@return srcpdf.CompilePlan|nil
---@return srcpdf.Warning|nil
function M.plan_html(ctx)
	local engine = M.html_engine()
	if not engine then
		return nil, M.html_missing()
	end
	return {
		argv = { engine, ctx.name, ctx.pdf },
		cwd = ctx.cwd,
	}
end

return M
