---@class ft_nvim.Header
---@field filename string
---@field username string
---@field email string
---@field created_at string
---@field created_by string
---@field updated_at string
---@field updated_by string

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
		return header.created_by
	end,
	updated_by = function(header)
		return header.updated_by
	end,
}

---@type fun(delims: ft_nvim.Delimeters[]): fun(line: string): string
local function set_delimeters(delims)
	return function(line)
		local start_delim, end_delim = delims[1], delims[2]
		line = string.sub(line, string.len(start_delim) + 2, line:len() - string.len(end_delim) - 1)

		return string.format("%s %s %s", start_delim, line, end_delim)
	end
end

---@type fun(header: ft_nvim.Header): string[]
local function serialize(header)
	local lines = TEMPLATE
	local annotated_lines = { 4, 6, 8, 9 }
	local delims = delimeters[vim.bo.filetype] or delimeters.default

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
	lines = vim.tbl_map(set_delimeters(delims), lines)
	table.insert(lines, "")
	return lines
end

---@type fun(lines: string[]): boolean
local function lines_are_header(lines)
	if #lines < 11 then
		return false
	end

	local annotated_lines = { 4, 6, 8, 9 }
	local lines_delimeters = { string.match(lines[1], "^([^%s]+) .* ([^%s]+)$") }

	if #lines_delimeters == 0 then
		return false
	end

	for lineno, template_line in ipairs(TEMPLATE) do
		local line = lines[lineno]
		template_line = set_delimeters(lines_delimeters)(template_line)

		if vim.tbl_contains(annotated_lines, lineno) then
			template_line = string.gsub(template_line, "@[%w_]+%.*", function(match)
				local range = { string.find(template_line, match, 1, true) }
				return string.sub(line, unpack(range))
			end)
		end

		template_line = string.gsub(template_line, "[+*]", "%%%1")

		if not string.match(line, template_line) then
			return false
		end
	end

	return true
end

return {
	---@type fun(bufnr: number, opts: ft_nvim.HeaderConfig)
	insert = function(bufnr, opts)
		local header = {
			filename = vim.fn.expand("%:t"),
			username = opts.username,
			email = opts.email,
			created_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
			created_by = opts.username,
			updated_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
			updated_by = opts.username,
		}
		local lines = serialize(header)

		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
	end,
	---@type fun(bufnr: number, opts: ft_nvim.HeaderConfig)
	update = function(bufnr, opts)
		local header = {}
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, #TEMPLATE, false)

		if not lines_are_header(lines) then
			return
		end

		for lineno, template_line in ipairs(TEMPLATE) do
			local line = lines[lineno]

			for annotation, key in string.gmatch(template_line, "(@([%w_]+)%.*)") do
				key = key:lower()
				local range = { string.find(template_line, annotation) }
				if key == "author" then
					header.username = string.match(line, "(%w+) <.*>")
					header.email = string.match(line, "%w+ <(.*)>")
				else
					---@diagnostic disable-next-line: param-type-mismatch
					header[key] = vim.fn.trim(string.sub(line, unpack(range)))
				end
			end
		end
		header.updated_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S")
		header.updated_by = opts.username
		lines = serialize(header)
		vim.api.nvim_buf_set_lines(bufnr, 0, 12, false, lines)
	end,
}
