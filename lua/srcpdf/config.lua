local M = {}

M.defaults = {
	--- Extensions that pair with `outdir/<stem>.pdf`.
	sources = { "tex", "md", "html", "htm" },
	outdir = "out",
}

local current = vim.deepcopy(M.defaults)

function M.get()
	return current
end

function M.setup(opts)
	current = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
