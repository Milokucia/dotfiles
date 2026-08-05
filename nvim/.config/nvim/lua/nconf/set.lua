-- Indentation
vim.opt.tabstop = 4        
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Cleaner listchars -- eol clutter is noisy in practice
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "~", nbsp = "+" }

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.colorcolumn = "88"  -- Python black default, good visual guide

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"  -- unnamedplus syncs with system clipboard on Linux

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Performance
vim.opt.updatetime = 50        -- faster CursorHold, better LSP experience
vim.opt.timeoutlen = 300       -- faster which-key if you use it

-- splits open naturally
vim.opt.splitright = true
vim.opt.splitbelow = true

-- No automatic comment insertion
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Return to last edit position when reopening a file
vim.cmd([[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])
