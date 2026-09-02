local M = {}

local defaults = {
	--- Buffer-local normal-mode lhs on `.tex` / `.pdf` files. `nil` skips binding.
	keymap = nil,
}

local config = vim.deepcopy(defaults)

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "nvim-pdf" })
end

---@param path string
---@return string
local function extension(path)
	return vim.fn.fnamemodify(path, ":e"):lower()
end

--- Sibling path: `foo.tex` ↔ `foo.pdf`. `nil` if the buffer is neither.
---@param path string
---@return string|nil
function M.sibling(path)
	if path == nil or path == "" then
		return nil
	end
	local ext = extension(path)
	local stem = vim.fn.fnamemodify(path, ":r")
	if ext == "tex" then
		return stem .. ".pdf"
	end
	if ext == "pdf" then
		return stem .. ".tex"
	end
	return nil
end

local function redraw_pdfreader()
	pcall(function()
		vim.cmd.PDFReader({ args = { "redrawPage" } })
	end)
end

function M.toggle()
	local current = vim.api.nvim_buf_get_name(0)
	if current == "" then
		notify("Current buffer has no file", vim.log.levels.WARN)
		return
	end

	local other = M.sibling(current)
	if not other then
		notify("Not a .tex or .pdf buffer", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(other) == 0 then
		notify("Missing " .. other, vim.log.levels.WARN)
		return
	end

	vim.cmd.edit(other)

	if extension(other) == "pdf" then
		redraw_pdfreader()
	end
end

local function bind_keymap(bufnr)
	if type(config.keymap) ~= "string" or config.keymap == "" then
		return
	end
	vim.keymap.set("n", config.keymap, M.toggle, {
		buffer = bufnr,
		silent = true,
		desc = "Toggle TeX / PDF",
	})
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", defaults, opts or {})

	if type(config.keymap) == "string" and config.keymap ~= "" then
		local group = vim.api.nvim_create_augroup("NvimPdfKeymap", { clear = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function(ev)
				if M.sibling(vim.api.nvim_buf_get_name(ev.buf)) then
					bind_keymap(ev.buf)
				end
			end,
		})
		if M.sibling(vim.api.nvim_buf_get_name(0)) then
			bind_keymap(0)
		end
	end
end

return M
