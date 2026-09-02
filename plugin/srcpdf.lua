if vim.g.loaded_srcpdf then
	return
end
vim.g.loaded_srcpdf = true

vim.api.nvim_create_user_command("PdfOpen", function()
	require("srcpdf").open()
end, { desc = "Compile the current file to PDF and open it" })

vim.api.nvim_create_user_command("PdfBuild", function()
	require("srcpdf").build()
end, { desc = "Compile the current file to PDF without opening it" })
