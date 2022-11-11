-- options for the lsp for lua
return {
	settings = {

		Lua = {
			diagnostics = {
				globals = { "vim" }, -- adds global vim stuff for dealing with lua so that you dont get loads of errors when working with nvim config
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
