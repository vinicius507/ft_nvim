---@class ft_nvim.NorminetteConfig
---@field enabled boolean
---@field cmd? string
---@field condition? fun(): boolean
---
---Example:
---@code
---require("ft_nvim.norminette").setup({
---	enabled = true,
---	cmd = "norminette",
---	condition = function()
---		local filepath = vim.fn.expand("%:p")
---		if not filepath:match("42sp") then
---			return false
---		end
---		return vim.bo.filetype == "c"
---	end,
---})
---@endcode

local function bufcontent()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	lines[#lines + 1] = "" -- Add a newline at the end
	return table.concat(lines, "\n")
end

local function filetype()
	local ext = vim.fn.expand("%:e")
	return ext == "h" and "--hfile" or "--cfile"
end

---@type fun(opts: ft_nvim.NorminetteConfig)
local function setup_nvim_lint(opts)
	local ok, lint = pcall(require, "lint")

	if not ok then
		error("Missing required dependency: 'nvim-lint'")
	end

	lint.linters.norminette = {
		cmd = opts.cmd,
		args = { filetype, bufcontent, "--filename" },
		ignore_exitcode = true,
		name = "Norminette",
		stream = "stdout",
		parser = require("lint.parser").from_pattern(
			"(%w+): ([^%s]+) +%(line: +(%d+), col: +(%d+)%):\t(.*)",
			{ "severity", "code", "lnum", "col", "message" },
			{
				Notice = vim.diagnostic.severity.WARN,
				Error = vim.diagnostic.severity.ERROR,
			}
		),
		condition = function()
			local ext = vim.fn.expand("%:e")

			-- NOTE: Only run on C and H files. Neovim considers .h files as having the cpp filetype
			if ext ~= "c" and ext ~= "h" then
				return false
			end
			if vim.w.normeignore then
				return false
			end
			return opts.condition()
		end,
	}
	table.insert(lint.linters_by_ft.c, "norminette")
	table.insert(lint.linters_by_ft.cpp, "norminette")
end

return {
	---@type fun(opts: ft_nvim.NorminetteConfig)
	setup = function(opts)
		if not opts.enabled then
			return
		end

		setup_nvim_lint(opts)

		require("ft_nvim.norminette.autocmds").setup(opts)
		require("ft_nvim.norminette.commands").setup()
	end,
	---@type fun(opts: unknown): boolean
	validate = function(opts)
		if type(opts) ~= "table" then
			return false
		end

		if opts.enabled ~= nil and type(opts.enabled) ~= "boolean" then
			return false
		end

		if opts.cmd ~= nil and type(opts.cmd) ~= "string" then
			return false
		end

		if opts.condition ~= nil and type(opts.condition) ~= "function" then
			return false
		end

		return true
	end,
}
