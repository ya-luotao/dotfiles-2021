-- Helpers --
local cmd = vim.cmd
local fn = vim.fn
local wo = vim.wo
local bo = vim.bo
local o = vim.o
local g = vim.g

-- Plugins --
cmd [[packadd packer.nvim]]
require('packer').startup(
  function()
    use {'wbthomason/packer.nvim', opt = true}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'junegunn/fzf', dir = '~/.fzf', run = './install --all'}
    use {'junegunn/fzf.vim'}
    use {'dracula/vim', as = 'dracula'}
    use {'windwp/nvim-autopairs'}
    use {'windwp/nvim-ts-autotag'}
    use {'tpope/vim-endwise'}
    use {'shougo/deoplete-lsp'}
    use {'shougo/deoplete.nvim', run = ':UpdateRemotePlugins'}
    use {'tpope/vim-commentary'}
    use {'kyazdani42/nvim-web-devicons'}
    use {'preservim/nerdtree'}
    use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
    use {'jiangmiao/auto-pairs'}
    use {'neovim/nvim-lspconfig'}
    use {'Xuyuanp/nerdtree-git-plugin'}
    use {'ryanoasis/vim-devicons'}
    use {'sheerun/vim-polyglot'}
  end
)

-- Options --

local indent = 2

g.mapleader = ','
g['deoplete#enable_at_startup'] = 1

wo.number = true

bo.expandtab = true
o.expandtab = true

bo.shiftwidth = 2
o.shiftwidth = 2

bo.softtabstop = 2
o.softtabstop = 2

wo.number = true
wo.relativenumber = true

wo.foldmethod = 'expr'
wo.foldexpr = vim.fn['nvim_treesitter#foldexpr']()

o.swapfile = false
o.termguicolors = true
o.splitbelow = true
o.splitright = true
o.incsearch = true
o.ruler = true -- global, show the line and column number of the cursor position.
o.foldlevelstart = 20
o.encoding = "UTF-8"

cmd 'colorscheme dracula'

vim.api.nvim_command('autocmd FileType php setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab')
vim.api.nvim_command('au WinLeave * set nocursorline nocursorcolumn')
vim.api.nvim_command('au WinEnter * set cursorline cursorcolumn')

-- Key Mappings --
vim.api.nvim_set_keymap('n', '<C-N>', ':BufferLineCycleNext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-P>', ':BufferLineCyclePrev<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>d', ':NERDTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':FZF<CR>', { noremap = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

require'nvim-ts-autotag'.setup {}
require'nvim-autopairs'.setup {}
require'bufferline'.setup {}


local nvim_lsp = require('lspconfig')

vim.lsp.handlers['$/progress'] = function() end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "html",  "tsserver", "cssls", "solargraph", "jsonls" }
for _, lsp in ipairs(servers) do

  if lsp == "sorbet" then
    nvim_lsp[lsp].setup {
      cmd = { "srb", "tc", "--lsp", "--disable-watchman" },
      filetypes = { "ruby" },
      root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git")
    }
  else
    nvim_lsp[lsp].setup {}
  end
end
