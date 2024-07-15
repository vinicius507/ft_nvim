return {
	---@type fun(opts: ft_nvim.HeaderConfig)
	setup = function(opts)
		local header = require("ft_nvim.header.header")
		local upsert = function()
			local bufnr = vim.api.nvim_get_current_buf()

			if header.buf_has_header(bufnr) then
				header.update(bufnr, opts)
				return
			end
			header.insert(bufnr, opts)
		end

		vim.api.nvim_create_user_command("FtHeader", upsert, {
			desc = "Upsert École 42 header",
		})
	end,
}
