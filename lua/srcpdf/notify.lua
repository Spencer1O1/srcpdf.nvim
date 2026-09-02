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

---@param text string
---@return string
local function tex_bang_errors(text)
	local lines = vim.split(text, "\n", { plain = true })
	local out = {}
	for i, line in ipairs(lines) do
		if line:match("^!") then
			out[#out + 1] = line
			for j = i + 1, math.min(i + 4, #lines) do
				if lines[j]:match("^l%.") then
					out[#out + 1] = lines[j]
					break
				end
			end
		end
	end
	return table.concat(out, "\n")
end

--- Prefer TeX `!` errors over latexmk's generic footer.
---@param result vim.SystemCompleted
---@param pdf? string
---@return string
function M.compile_error(result, pdf)
	local blob = (result.stderr or "") .. "\n" .. (result.stdout or "")
	local extracted = tex_bang_errors(blob)
	if extracted == "" and pdf then
		local log = pdf:gsub("%.pdf$", ".log")
		if vim.fn.filereadable(log) == 1 then
			extracted = tex_bang_errors(table.concat(vim.fn.readfile(log), "\n"))
		end
	end
	if extracted ~= "" then
		return extracted
	end
	if blob:match("%S") then
		return M.clip(blob)
	end
	return "compile failed"
end

return M
