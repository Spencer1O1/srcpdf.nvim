if vim.g.loaded_nvim_pdf then
	return
end
vim.g.loaded_nvim_pdf = true

vim.api.nvim_create_user_command("TexPdfToggle", function()
	require("nvim-pdf").toggle()
end, { desc = "Toggle between sibling .tex and .pdf" })
