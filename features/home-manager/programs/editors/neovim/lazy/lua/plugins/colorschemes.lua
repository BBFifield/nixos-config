return {
	{
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		"Mofiqul/dracula.nvim",
		"folke/tokyonight.nvim",
		"projekt0n/github-nvim-theme",
		"rebelot/kanagawa.nvim",
		"eldritch-theme/eldritch.nvim",
		"slugbyte/lackluster.nvim",
		"Mofiqul/vscode.nvim",
		"craftzdog/solarized-osaka.nvim",
		"sainnhe/gruvbox-material",
	},
	-- {
	-- 	"rachartier/tiny-devicons-auto-colors.nvim",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	config = function(_, opts)
	-- 		local theme_colors
	-- 		if NewfieVim:get_plugin_info("base16_vim").enabled then
	-- 			theme_colors = require("base16-colorscheme").colors
	-- 		elseif NewfieVim:get_plugin_info("tinted_vim").enabled then
	-- 			theme_colors = require("tinted-vim").colors
	-- 		end
	--
	-- 		require("tiny-devicons-auto-colors").setup({
	-- 			colors = theme_colors,
	-- 		})
	-- 	end,
	-- },
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}
