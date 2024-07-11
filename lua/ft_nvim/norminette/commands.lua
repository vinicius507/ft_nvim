---@type table<string, ft_nvim.Command>
local cmds = {
	disable = {
		impl = function()
			vim.w.normeignore = true
		end,
	},
	enable = {
		impl = function()
			vim.w.normeignore = false
		end,
	},
	toggle = {
		impl = function()
			if vim.w.normeignore then
				vim.w.normeignore = false
				vim.api.nvim_exec_autocmds("BufWritePost", { group = "Norminette" })
				return
			end
			local ns = vim.api.nvim_get_namespaces().Norminette

			vim.w.normeignore = true
			vim.diagnostic.reset(ns)
		end,
	},
}

---@type fun(lead: string, cmdline: string): table<string>?
local function complete(lead, cmdline)
	local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Norme[!]*%s(%S+)%s(.*)$")

	if subcmd_key and subcmd_arg_lead and cmds[subcmd_key] and cmds[subcmd_key].complete then
		return cmds[subcmd_key].complete(subcmd_arg_lead)
	end

	if cmdline:match("^['<,'>]*Norme[!]*%s+%w*$") then
		local subcommand_keys = vim.tbl_keys(cmds)

		return vim.iter(subcommand_keys)
			:filter(function(key)
				return key:find(lead) ~= nil
			end)
			:totable()
	end
end

return {
	setup = function()
		local handler = function(opts)
			local fargs = opts.fargs
			local subcommand_key = fargs[1]
			local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
			local subcommand = cmds[subcommand_key]

			if not subcommand then
				vim.notify("Norme: Unknown command: " .. subcommand_key, vim.log.levels.ERROR, { title = "42 Nvim" })
				return
			end
			subcommand.impl(args, opts)
		end

		vim.api.nvim_create_user_command("Norme", handler, {
			desc = "Toggle Norme Linting",
			nargs = "+",
			complete = complete,
		})
	end,
}
