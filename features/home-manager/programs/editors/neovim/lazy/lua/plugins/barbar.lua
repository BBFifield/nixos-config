return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		icons = {
			--separator = { left = "", right = "" },
			--inactive = { separator = { left = "", right = "" } },
			--separator = { left = "", right = "" },
			--inactive = { separator = { left = "", right = "" } },
			--filetype = { custom_colors = true, enabled = true },
			--button = " ",
			--	separator_at_end = false,
			maximum_padding = 1,
			minimum_padding = 1,
			maximum_length = 1,
			--	minimum_padding = 0,
		},

		-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
		-- animation = true,
		-- insert_at_start = true,
		-- …etc.
	},
	config = function(_, opts)
		require("barbar").setup(opts)
		local inactive_buffer_separator_fg = vim.api.nvim_get_hl(0, { name = "lualine_b_normal" }).bg
		local inactive_buffer_separator_bg = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" }).fg

		local current_buffer_separator_fg = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" }).bg
		local current_buffer_separator_bg = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" }).fg

		vim.api.nvim_set_hl(0, "BufferCurrent", { link = "lualine_a_normal" })
		vim.api.nvim_set_hl(0, "BufferCurrentMod", { link = "lualine_a_normal" })
		vim.api.nvim_set_hl(
			0,
			"BufferCurrentSign",
			{ fg = current_buffer_separator_fg, bg = current_buffer_separator_bg }
		)
		vim.api.nvim_set_hl(0, "BufferCurrentIcon", { link = "lualine_a_normal" })
		vim.api.nvim_set_hl(0, "BufferInactive", { link = "lualine_b_normal" })
		--vim.api.nvim_set_hl(0, "BufferCurrentMod", { link = "lualine_a_normal" })
		vim.api.nvim_set_hl(
			0,
			"BufferInactiveSign",
			{ fg = inactive_buffer_separator_fg, bg = inactive_buffer_separator_bg }
		)
		vim.api.nvim_set_hl(0, "BufferInactiveMod", { link = "lualine_b_normal" })
		vim.api.nvim_set_hl(0, "BufferVisible", { link = "lualine_a_normal" })
		vim.api.nvim_set_hl(
			0,
			"BufferVisibleSign",
			{ fg = current_buffer_separator_fg, bg = current_buffer_separator_bg }
		)
		vim.api.nvim_set_hl(
			0,
			"BufferAlternateSign",
			{ fg = current_buffer_separator_fg, bg = current_buffer_separator_bg }
		)
		vim.api.nvim_set_hl(0, "BufferVisibleMod", { link = "lualine_a_normal" })
	end,
}
