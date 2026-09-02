local M = {}

---@param cmd string
---@return boolean
function M.exe(cmd)
	return vim.fn.executable(cmd) == 1
end

---@param apt_pkg string
---@param brew_pkg string
---@return string
function M.install_cmd(apt_pkg, brew_pkg)
	if M.exe("brew") then
		return "brew install " .. brew_pkg
	end
	if M.exe("apt") or M.exe("apt-get") then
		return "sudo apt install " .. apt_pkg
	end
	return "sudo apt install " .. apt_pkg .. "  (or: brew install " .. brew_pkg .. ")"
end

return M
