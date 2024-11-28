return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "hyprlang", "corn", "rust", "nix", "lua", "javascript", "html", "css", "c" },
			sync_install = false,
			highlight = {
				enable = true,
				disable = { "nix", "lua", "rust" },
			},
			indent = { enable = true },
		})
	end,
}
