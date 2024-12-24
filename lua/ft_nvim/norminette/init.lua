---@class ft_nvim.NorminetteConfig
---@field enabled? boolean
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

---@type ft_nvim.NorminetteConfig
local default_opts = {
	enabled = true,
	cmd = "norminette",
}

local function bufcontent()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	lines[#lines + 1] = "" -- Add a newline at the end
	return table.concat(lines, "\n")
end

local function filetype()
	local ext = vim.fn.expand("%:e")
	return ext == "h" and "--hfile" or "--cfile"
end

---@type fun(opts: ft_nvim.NorminetteConfig): boolean
local function setup_nvim_lint(opts)
	if not package.loaded["lint"] then
		return false
	end

	require("lint").linters.norminette = {
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
	}
	return true
end

return {
	---@type fun(opts: ft_nvim.NorminetteConfig)
	setup = function(opts)
		opts = vim.tbl_extend("force", default_opts, opts or {})

		vim.validate({
			enabled = { opts.enabled, "boolean", true },
			cmd = { opts.cmd, "string", true },
			condition = { opts.condition, "function", true },
		})

		if not opts.enabled then
			return
		end

		if not setup_nvim_lint(opts) then
			vim.notify("Error: missing required dependency: nvim-lint", vim.log.levels.ERROR, {
				title = "ft_nvim",
			})
			return
		end

		require("ft_nvim.norminette.autocmds").setup(opts)
		require("ft_nvim.norminette.commands").setup()
	end,
}
