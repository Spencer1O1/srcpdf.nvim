local M = {}

---@param msg string
---@param level? integer
---@param opts? table
function M.send(msg, level, opts)
	opts = opts or {}
	opts.title = "srcpdf"
	vim.notify(msg, level or vim.log.levels.INFO, opts)
end

---@param msg string
---@param level? integer
function M.compile(msg, level)
	M.send(msg, level, { id = "srcpdf.compile" })
end

--- Keep notify readable; latexmk logs are huge.
---@param text string
---@param max_lines? integer
---@return string
function M.clip(text, max_lines)
	max_lines = max_lines or 12
	local lines = vim.split(vim.trim(text), "\n", { plain = true, trimempty = true })
	if #lines <= max_lines then
		return table.concat(lines, "\n")
	end
	return table.concat(vim.list_slice(lines, #lines - max_lines + 1), "\n")
end

return M
