---@class ft_nvim.Header
---@field filename string
---@field username string
---@field email string
---@field created_at string
---@field updated_at string

local delimeters = require("ft_nvim.header.delimeters")
local TEMPLATE = {
	"********************************************************************************",
	"*                                                                              *",
	"*                                                         :::      ::::::::    *",
	"*    @FILENAME..................................        :+:      :+:    :+:    *",
	"*                                                     +:+ +:+         +:+      *",
	"*    By: @AUTHOR................................    +#+  +:+       +#+         *",
	"*                                                 +#+#+#+#+#+   +#+            *",
	"*    Created: @CREATED_AT........ by @CREATED_BY       #+#    #+#              *",
	"*    Updated: @UPDATED_AT........ by @UPDATED_BY      ###   ########.fr        *",
	"*                                                                              *",
	"********************************************************************************",
}

---@alias ft_nvim.FieldKey "filename" | "author" | "created_at" | "updated_at" | "created_by" | "updated_by"

---@type table<ft_nvim.FieldKey, fun(header: ft_nvim.Header): string>
local fields = {
	filename = function(header)
		return header.filename
	end,
	author = function(header)
		return string.format("%s <%s>", header.username, header.email)
	end,
	created_at = function(header)
		return header.created_at
	end,
	updated_at = function(header)
		return header.updated_at
	end,
	created_by = function(header)
		return header.username
	end,
	updated_by = function(header)
		return header.username
	end,
}

---@type fun(header: ft_nvim.Header): string[]
local function serialize(header)
	local lines = TEMPLATE
	local annotated_lines = { 4, 6, 8, 9 }
	local delims = delimeters[vim.bo.filetype] or delimeters.default
	---@type fun(line: string, delim: string[]): string
	local function set_delimeters(line)
		local start_delim, end_delim = delims[1], delims[2]
		line = string.sub(line, start_delim:len() + 2, line:len() - end_delim:len() - 1)

		return string.format("%s %s %s", start_delim, line, end_delim)
	end

	for _, lineno in ipairs(annotated_lines) do
		lines[lineno] = string.gsub(lines[lineno], "(@([%w_]*)%.*)", function(match, key)
			key = key:lower()
			local data = fields[key] and fields[key](header)

			if not data then
				return
			end

			return string.format(
				"%s%s",
				data,
				string.rep(" ", match:len() > data:len() and match:len() - data:len() or 0)
			)
		end)
	end
	lines = vim.tbl_map(set_delimeters, lines)
	table.insert(lines, "")
	return lines
end

return {
	---@type fun(bufnr: number, opts: ft_nvim.HeaderConfig)
	insert = function(bufnr, opts)
		local header = {
			filename = vim.fn.expand("%:t"),
			username = opts.username,
			email = opts.email,
			created_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
			updated_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
		}
		local lines = serialize(header)

		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
	end,
}
