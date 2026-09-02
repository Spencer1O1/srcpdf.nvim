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

local function pdf_rel(pdf)
	return vim.fs.joinpath(vim.fn.fnamemodify(pdf, ":h:t"), vim.fn.fnamemodify(pdf, ":t"))
end

---@param path string
---@return string|nil
local function file_sha256(path)
	local f = io.open(path, "rb")
	if not f then
		return nil
	end
	local data = f:read("*a")
	f:close()
	if type(data) ~= "string" then
		return nil
	end
	return vim.fn.sha256(data)
end

---@param source string
---@return string|nil
local function read_hash(source)
	local path = pair.output_hash(source)
	if vim.fn.filereadable(path) == 0 then
		return nil
	end
	local lines = vim.fn.readfile(path)
	local hash = lines[1] and vim.trim(lines[1]) or ""
	if hash == "" then
		return nil
	end
	return hash
end

---@param source string
local function write_hash(source)
	local hash = file_sha256(source)
	if not hash then
		return
	end
	vim.fn.writefile({ hash }, pair.output_hash(source))
end

---@param source string
---@param pdf string
---@return boolean
local function needs_rebuild(source, pdf)
	if vim.fn.filereadable(pdf) == 0 then
		return true
	end
	local current = file_sha256(source)
	if not current then
		return true
	end
	return current ~= read_hash(source)
end

---@param source string
---@param pdf string
---@param result vim.SystemCompleted
---@param should_open boolean
local function after_compile(source, pdf, result, should_open)
	if result.code ~= 0 then
		notify.compile(notify.compile_error(result, pdf), vim.log.levels.ERROR)
		return
	end
	if vim.fn.filereadable(pdf) == 0 then
		notify.compile("Compile finished but " .. pdf .. " is missing", vim.log.levels.ERROR)
		return
	end
	write_hash(source)
	if should_open then
		open_pdf(pdf)
		notify.compile("Opened " .. pdf_rel(pdf))
	else
		notify.compile("Built " .. pdf_rel(pdf))
	end
end

---@param pdf string
---@param should_open boolean
local function use_existing(pdf, should_open)
	if should_open then
		open_pdf(pdf)
		notify.compile("Opened " .. pdf_rel(pdf))
		return
	end
	notify.compile("Up to date " .. pdf_rel(pdf))
end

---@param opts { open: boolean }
local function run(opts)
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		notify.send("Current buffer has no file", vim.log.levels.WARN)
		return
	end

	local ext = pair.extension(current)

	if ext == "pdf" then
		if not opts.open then
			return
		end
		if vim.fn.filereadable(current) == 0 then
			notify.send("Missing " .. current, vim.log.levels.WARN)
			return
		end
		open_pdf(current)
		return
	end

	if not pair.is_source_ext(ext) then
		notify.send(
			"Not a source or PDF (." .. table.concat(config.get().sources, " .") .. ")",
			vim.log.levels.WARN
		)
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	local pdf = pair.output_pdf(current)
	if not needs_rebuild(current, pdf) then
		use_existing(pdf, opts.open)
		return
	end

	local plan, warning = compile.plan(current)
	if not plan then
		if warning then
			notify.send(warning.message .. "\n" .. warning.install, vim.log.levels.WARN)
		else
			notify.send("No compiler for ." .. ext, vim.log.levels.WARN)
		end
		return
	end

	notify.compile("Compiling…")
	vim.system(plan.argv, { cwd = plan.cwd, text = true }, function(result)
		vim.schedule(function()
			after_compile(current, pdf, result, opts.open)
		end)
	end)
end

function M.open()
	run({ open = true })
end

function M.build()
	run({ open = false })
end

return M
