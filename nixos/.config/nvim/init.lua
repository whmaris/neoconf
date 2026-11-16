-- Cơ bản
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.wrap = false
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.updatetime = 250
o.clipboard = "unnamedplus"
o.mouse = "a"

-- Giao diện
require("catppuccin").setup({ flavour = "mocha" })
vim.cmd.colorscheme("catppuccin")
require("lualine").setup({ options = { theme = "catppuccin" } })
require("which-key").setup()

-- Treesitter (grammar do Nix cung cấp, chỉ cần bật highlight)
vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})

-- Telescope
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Tìm file" })
vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Tìm nội dung" })
vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffer" })
vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Help" })

-- File explorer
require("oil").setup()
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })

-- Git, autopairs
require("gitsigns").setup()
require("nvim-autopairs").setup()

-- Autocomplete
require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
  },

  completion = {
    menu = {
      auto_show = true,
    },
    documentation = {
      auto_show = true,
    },
  },
})

-- LSP
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.enable({ "nil_ls", "lua_ls", "ts_ls", "html", "cssls", "tailwindcss" })

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Đến định nghĩa")
    map("gD", vim.lsp.buf.declaration, "Đến khai báo")
    map("<leader>rn", vim.lsp.buf.rename, "Đổi tên")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>d", vim.diagnostic.open_float, "Xem lỗi")
  end,
})

-- Format khi lưu
require("conform").setup({
  formatters_by_ft = { nix = { "nixfmt" } },
  format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
})

-- Phím tắt chung
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Lưu" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Thoát" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
