return {
	"Bekaboo/dropbar.nvim",
	enabled = NewfieVim:get_plugin_info("dropbar").enabled,
	-- optional, but required for fuzzy finder support
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	opts = {},
}
