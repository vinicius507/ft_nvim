local Header = require("ft_nvim.header.header")
local delimeters = require("ft_nvim.header.delimeters")

local header_height = 11

---@type fun(bufnr: number): table
local function bufmetadata(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", {
		buf = bufnr,
	})

	return {
		filename = vim.fn.fnamemodify(filename, ":t"),
		created_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
		updated_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
		delimeters = delimeters[filetype] or delimeters.default,
	}
end

return {
	---@type fun(bufnr: number, opts: ft_nvim.HeaderConfig)
	insert = function(bufnr, opts)
		local meta = bufmetadata(bufnr)
		local header = vim.tbl_extend("force", meta, {
			username = opts.username,
			email = opts.email,
			created_by = opts.username,
			updated_by = opts.username,
		})
		local lines = Header.serialize(header)

		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
	end,
	---@type fun(bufnr: number, opts: ft_nvim.HeaderConfig, insert_on_empty?: boolean)
	update = function(bufnr, opts, insert_on_empty)
		local meta = bufmetadata(bufnr)
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, header_height + 1, false)
		local header = Header.fromlines(lines)
		local end_line = header and header_height + 1 or 0

		if not header and not insert_on_empty then
			return
		end

		local update_meta = {
			filename = meta.filename,
			updated_at = meta.updated_at,
			updated_by = opts.username,
		}
		header = vim.tbl_extend("keep", update_meta, header or {
			username = opts.username,
			email = opts.email,
			created_at = meta.created_at,
			created_by = opts.username,
			delimeters = meta.delimeters,
		})
		lines = Header.serialize(header)
		vim.api.nvim_buf_set_lines(bufnr, 0, end_line, false, lines)
	end,
}
