-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   delimeters.lua                                     :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2023/01/13 10:12:09 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 10:12:09 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local delimeters = {
	HASHES = { "#", "#" },
	SLASHES = { "/*", "*/" },
	SEMICOLONS = { ";;", ";;" },
	PARENS = { "(*", "*)" },
	DASHES = { "--", "--" },
	PERCENTS = { "%%", "%%" },
}

---@alias ft_nvim.Delimeters
---|`delimeters.HASHES`
---|`delimeters.SLASHES`
---|`delimeters.SEMICOLONS`
---|`delimeters.PARENS`
---|`delimeters.DASHES`
---|`delimeters.PERCENTS`
---Common header delimeters between filetypes

---Language delimeters
---@type table<string, ft_nvim.Delimeters>
local languages_delimeters = {
	default = delimeters.HASHES,
	c = delimeters.SLASHES,
	cpp = delimeters.SLASHES,
	css = delimeters.SLASHES,
	dockerfile = delimeters.HASHES,
	go = delimeters.SLASHES,
	groovy = delimeters.SLASHES,
	haskell = delimeters.DASHES,
	dosini = delimeters.SEMICOLONS,
	java = delimeters.SLASHES,
	javascript = delimeters.SLASHES,
	javascriptreact = delimeters.SLASHES,
	latex = delimeters.PERCENTS,
	less = delimeters.SLASHES,
	lua = delimeters.DASHES,
	make = delimeters.HASHES,
	objc = delimeters.SLASHES,
	ocaml = delimeters.PARENS,
	perl = delimeters.HASHES,
	php = delimeters.SLASHES,
	text = delimeters.HASHES,
	python = delimeters.HASHES,
	r = delimeters.HASHES,
	ruby = delimeters.HASHES,
	rust = delimeters.SLASHES,
	scss = delimeters.SLASHES,
	sh = delimeters.HASHES,
	bash = delimeters.HASHES,
	sql = delimeters.HASHES,
	swift = delimeters.SLASHES,
	typescript = delimeters.SLASHES,
	typescriptreact = delimeters.SLASHES,
	yaml = delimeters.HASHES,
}

return languages_delimeters
