-- init
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- keymap
vim.keymap.set('n', '<Space>f', '<Cmd>NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', ':qq<CR>', ':qa<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-p>', '"+p', { noremap = true })

vim.cmd([[
	" TABLINE
	" set showtabline=0
	" set tabline=%r\ %m\ %t\ %y\ L:\%L\ W: set tabline+=%{wordcount()[\"words\"]}\ PC:\%p%%
	" highlight tablinefill cterm=none ctermbg=none ctermfg=lightcyan

	" STATUSLINE
	" set laststatus=2 " set laststatus=2
	" set statusline=%{strftime('%H:%M\ ')}
	" set statusline=%r\ %m\ %t\ %y\ L:\%l/%L\ W:
	" set statusline+=%{wordcount()[\"words\"]}\ PC:\%p%%\ 
	" set statusline+=%5.(%l,%c%V%)
	" highlight statusline cterm=none ctermbg=none ctermfg=cyan
	" set rulerformat+=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)

  autocmd VimEnter * NvimTreeOpen
	set cursorline cursorlineopt=number
	set nu rnu
	set autoindent noexpandtab tabstop=2 shiftwidth=2
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	'thecodinglab/nvim-vlang',
	'norcalli/nvim-colorizer.lua',
	'lewis6991/gitsigns.nvim',
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end,
	},
	{ 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
	{ 'Everblush/nvim', name = 'everblush', },
	{ 'numToStr/Comment.nvim', opts = {}, lazy = false, },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "svelte", "javascript", "html", "v" },
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },  
			})
    end
	 },
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
	{
    'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
	}
})

require("ibl").setup({ indent = { char = "▏" } })
require('gitsigns').setup()
require('colorizer').setup()
require('lualine').setup()

require('everblush').setup({
	transparent_background = true,
	nvim_tree = { contrast = false },
	override = {
		NvimTreeWinSeparator = { fg = "#23272c" },
		LineNr = { fg = "gray" },
		CursorLineNr = { fg = "white" }
	}
})

vim.cmd('colorscheme everblush')
