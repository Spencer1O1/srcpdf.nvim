local M = {}

local defaults = {
	--- Extensions that pair with a sibling `.pdf` of the same stem.
	sources = { "tex" },
}

local config = vim.deepcopy(defaults)

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "srcpdf" })
end

---@param path string
---@return string
local function extension(path)
	return vim.fn.fnamemodify(path, ":e"):lower()
end

---@param ext string
---@return boolean
local function is_source_ext(ext)
	for _, source in ipairs(config.sources) do
		if ext == source then
			return true
		end
	end
	return false
end

--- PDF to open for this path: sibling of a source, or the file itself if it is a PDF.
---@param path string
---@return string|nil
function M.pdf_path(path)
	if path == nil or path == "" then
		return nil
	end
	local ext = extension(path)
	if ext == "pdf" then
		return path
	end
	if is_source_ext(ext) then
		return vim.fn.fnamemodify(path, ":r") .. ".pdf"
	end
	return nil
end

function M.open()
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		notify("Current buffer has no file", vim.log.levels.WARN)
		return
	end

	local pdf = M.pdf_path(current)
	if not pdf then
		notify("Not a source or PDF buffer", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(pdf) == 0 then
		notify("Missing " .. pdf, vim.log.levels.WARN)
		return
	end

	local ok, err = pcall(vim.ui.open, pdf)
	if not ok then
		notify("Could not open " .. pdf .. (err and (": " .. tostring(err)) or ""), vim.log.levels.ERROR)
	end
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
