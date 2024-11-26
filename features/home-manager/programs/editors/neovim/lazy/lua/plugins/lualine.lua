vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local active = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
		local inactive = vim.api.nvim_get_hl(0, { name = "lualine_b_normal" })
		vim.api.nvim_set_hl(
			0,
			"active_buffer_title",
			{ ctermfg = 18, ctermbg = 12, fg = active.fg, bg = active.bg, bold = true }
		)
		vim.api.nvim_set_hl(
			0,
			"inactive_buffer_title",
			{ ctermfg = 12, ctermbg = 18, fg = inactive.fg, bg = inactive.bg }
		)
	end,
})
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
	config = function(_, opts)
		local custom_buffers = require("lualine.components.buffers"):extend()
		local custom_buffers_buffer = require("lualine.components.buffers.buffer"):extend()

		function custom_buffers:init(options)
			custom_buffers.super.init(self, options)
			self.options = vim.tbl_deep_extend("force", self.options, { options })
			self.highlights = {
				active = self:create_hl(self.options.buffers_color.active, "active"),
				inactive = self:create_hl(self.options.buffers_color.inactive, "inactive"),
			}
		end

		function custom_buffers:new_buffer(bufnr, buf_index)
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			buf_index = buf_index or ""
			return custom_buffers_buffer:new({
				bufnr = bufnr,
				buf_index = buf_index,
				options = self.options,
				highlights = self.highlights,
			})
		end

		function custom_buffers_buffer:init(options)
			custom_buffers_buffer.super.init(self, options)
		end

		function custom_buffers_buffer:name()
			local name = custom_buffers_buffer.super.name(self)

			local general = vim.api.nvim_get_hl(0, { name = "lualine_a_replace" })
			local active = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.active })
			local inactive = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.inactive })
			vim.api.nvim_set_hl(
				0,
				"active_modified",
				{ fg = general.bg, bg = active.bg, ctermfg = general.ctermbg, ctermbg = active.ctermbg }
			)
			vim.api.nvim_set_hl(
				0,
				"inactive_modified",
				{ fg = general.fg, bg = inactive.bg, ctermfg = general.ctermfg, ctermbg = inactive.ctermbg }
			)
			vim.api.nvim_set_hl(
				0,
				"separator",
				{ fg = active.bg, bg = inactive.bg, ctermfg = active.ctermbg, ctermbg = inactive.ctermbg }
			)

			if self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
				name = name .. "%#active_modified# ●%*"
			elseif not self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
				name = name .. "%#inactive_modified# ○%*"
			end
			return name
		end

		function custom_buffers_buffer:separator_before()
			if self.current then
				return string.format("%%#separator# %s%%*", self.options.section_separators.right)
			elseif self.aftercurrent then
				return string.format("%%#separator#%s %%*", self.options.section_separators.left)
			else
				return string.format("%%#separator#%s%%*", self.options.component_separators.right)
			end
		end

		local navic
		local barbecue
		local winbar = {}
		local navic_enabled = NewfieVim:get_plugin_info("navic").enabled
		if navic_enabled then
			navic = require("nvim-navic")
			barbecue = require("barbecue.ui")
			winbar = {
				winbar = {
					lualine_c = {
						{
							function()
								return barbecue.update() or ""
							end,
							cond = function()
								return navic.is_available()
							end,
						},
					},
				},
			}
		end

		local tabline = {}
		local barbar_enabled = NewfieVim:get_plugin_info("barbar").enabled
		if barbar_enabled then
			tabline = {
				tabline = {},
			}
		else
			tabline = {
				tabline = {
					lualine_c = {
						{
							custom_buffers,
							show_filename_only = true,
							hide_filename_extension = false,
							show_modified_status = true,
							mode = 0,
							filetype_names = {
								checkhealth = "Check Health",
								TelescopePrompt = "Telescope",
							},
							buffers_color = {
								active = "active_buffer_title",
								inactive = "inactive_buffer_title",
							},
							separator = { left = "", right = "" },
							padding = 0,
							max_length = function()
								return vim.o.columns * 4 / 3
							end,
							symbols = {
								modified = "",
							},
							cond = function()
								return vim.bo.filetype ~= "alpha"
									and vim.bo.filetype ~= "lazy"
									and vim.bo.filetype ~= "TelescopePrompt"
									and vim.bo.filetype ~= "NvimTree"
									and vim.bo.filetype ~= "tfm"
							end,
						},
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							"datetime",
							separator = { left = "", right = "" },
							-- color = { fg = 0 },
							style = "%H:%M",
						},
					},
				},
			}
		end

		local custom_16color = {
			normal = {
				a = { fg = 18, bg = 12, gui = "bold" },
				b = { fg = 12, bg = 18 },
				c = { fg = 8, bg = 0 },
			},
			insert = { a = { fg = 18, bg = 2, gui = "bold" } },
			visual = { a = { fg = 18, bg = 5, gui = "bold" } },
			replace = { a = { fg = 18, bg = 1, gui = "bold" } },
			inactive = {
				a = { fg = 12, bg = 18, gui = "bold" },
				b = { fg = 12, bg = 18 },
				c = { fg = 12, bg = 18 },
			},
		}

		require("lualine").setup(vim.tbl_deep_extend("keep", winbar, tabline, {
			options = {
				icons_enabled = true,
				theme = custom_16color,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "", right = "" } } },
				lualine_b = { { "branch", color = { fg = 5 } } },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { "filetype", "encoding", "fileformat", "progress" },
				lualine_z = { { "location", separator = { left = "", right = "" } } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {},
		}))
	end,
}
