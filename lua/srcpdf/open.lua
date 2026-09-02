local compile = require("srcpdf.compile")
local config = require("srcpdf.config")
local notify = require("srcpdf.notify")
local pair = require("srcpdf.pair")

local M = {}

local function open_pdf(pdf)
	local ok, err = pcall(vim.ui.open, pdf)
	if not ok then
		notify.send("Could not open " .. pdf .. (err and (": " .. tostring(err)) or ""), vim.log.levels.ERROR)
	end
end

---@param pdf string
---@param result vim.SystemCompleted
local function after_compile(pdf, result)
	if result.code ~= 0 then
		local err = result.stderr
		if err == nil or err == "" then
			err = result.stdout or "compile failed"
		end
		notify.compile(notify.clip(err), vim.log.levels.ERROR)
		return
	end
	if vim.fn.filereadable(pdf) == 0 then
		notify.compile("Compile finished but " .. pdf .. " is missing", vim.log.levels.ERROR)
		return
	end
	open_pdf(pdf)
	notify.compile("Opened " .. vim.fs.joinpath(vim.fn.fnamemodify(pdf, ":h:t"), vim.fn.fnamemodify(pdf, ":t")))
end

function M.open()
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		notify.send("Current buffer has no file", vim.log.levels.WARN)
		return
	end

	local pdf = pair.pdf_path(current)
	if not pdf then
		notify.send(
			"Not a source or PDF (." .. table.concat(config.get().sources, " .") .. ")",
			vim.log.levels.WARN
		)
		return
	end

	if pair.extension(current) == "pdf" then
		if vim.fn.filereadable(pdf) == 0 then
			notify.send("Missing " .. pdf, vim.log.levels.WARN)
			return
		end
		open_pdf(pdf)
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	local plan, warning = compile.plan(current)
	if not plan then
		if warning then
			notify.send(warning.message .. "\n" .. warning.install, vim.log.levels.WARN)
		else
			notify.send("No compiler for ." .. pair.extension(current), vim.log.levels.WARN)
		end
		return
	end

	notify.compile("Compiling…")
	vim.system(plan.argv, { cwd = plan.cwd, text = true }, function(result)
		vim.schedule(function()
			after_compile(pdf, result)
		end)
	end)
end

return M
