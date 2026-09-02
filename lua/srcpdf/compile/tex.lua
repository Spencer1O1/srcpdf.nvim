local tools = require("srcpdf.compile.tools")

local M = {}

---@return srcpdf.Warning
function M.missing()
	return {
		message = "No LaTeX compiler — need latexmk, tectonic, or pdflatex.",
		install = tools.install_cmd("latexmk texlive", "latexmk")
			.. "\n"
			.. tools.install_cmd("tectonic", "tectonic"),
	}
end

function M.available()
	return tools.exe("latexmk") or tools.exe("tectonic") or tools.exe("pdflatex")
end

---@param ctx srcpdf.CompileCtx
---@return srcpdf.CompilePlan|nil
---@return srcpdf.Warning|nil
function M.plan(ctx)
	if tools.exe("latexmk") then
		return {
			argv = {
				"latexmk",
				"-pdf",
				"-interaction=nonstopmode",
				"-halt-on-error",
				"-outdir=" .. ctx.outdir,
				ctx.name,
			},
			cwd = ctx.cwd,
		}
	end
	if tools.exe("tectonic") then
		return { argv = { "tectonic", "--outdir", ctx.outdir, ctx.name }, cwd = ctx.cwd }
	end
	if tools.exe("pdflatex") then
		return {
			argv = {
				"pdflatex",
				"-interaction=nonstopmode",
				"-output-directory=" .. ctx.outdir,
				ctx.name,
			},
			cwd = ctx.cwd,
		}
	end
	return nil, M.missing()
end

return M
