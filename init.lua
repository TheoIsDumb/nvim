-- init
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- options
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- keymap
vim.keymap.set('n', '<Space>f', '<Cmd>NvimTreeToggle<CR>', { silent = true }) -- toggle nvim-tree
vim.keymap.set('n', ':qq<CR>', ':qa<CR>', { noremap = true, silent = true }) -- close everything
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true }) -- line-by-line traversal through paragraphs
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true }) -- same
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true }) -- yank to system register
vim.keymap.set('n', '<C-p>', '"+p', { noremap = true }) -- paste from system register

-- stolen from primeagen
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv") -- interactive text movement in visual mode
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'n', "nzzzv")
vim.keymap.set('n', 'N', "Nzzzv")

-- old tabline-statusline config
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
]])

-- lazy.nvim init
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

-- lazy.nvim plugins setup
require("lazy").setup({
	'thecodinglab/nvim-vlang',
	'norcalli/nvim-colorizer.lua',
	'lewis6991/gitsigns.nvim',
	{ 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
	{ 'Everblush/nvim', name = 'everblush', },
	{ 'numToStr/Comment.nvim', opts = {}, lazy = false, },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
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
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' }
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'L3MON4D3/LuaSnip' },
  },
	{
    "williamboman/mason.nvim",
    opts = {
      ui = {
				border = "rounded",
				icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = ""
        }
			},
    },
  },
  'williamboman/mason-lspconfig.nvim',
})

-- plugins setup
require("ibl").setup({ indent = { char = "▏" } })
require('gitsigns').setup()
require('colorizer').setup()
require('lualine').setup()

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
  },
})

-- theme setup
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

-- completion keybinds
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
