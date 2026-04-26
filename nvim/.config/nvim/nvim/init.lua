local lualine_theme = require('lualine-black')
--
-- Basic settings
vim.opt.syntax = 'enable'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.showbreak= '↪\\'
vim.opt.clipboard = "unnamedplus"
vim.opt.list = true
vim.opt.scrolloff = 30
vim.opt.swapfile = false
vim.opt.listchars = {
  eol = '↵',
  tab = '···',
  trail = '·',
  extends = '>',
  precedes = '<',
}

vim.cmd.colorscheme "catppuccin-latte"

require('hop').setup()
require('lualine').setup({
  options = {
    theme = 'catppuccin',
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'branch', icon = '' } },
    lualine_c = { { 'filename', file_status = true, path = 1 } }
  },
})

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
}

local opts = { noremap = true, silent = true }
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>w', ':w<CR>', opts)
vim.keymap.set('n', '<leader>c', ':bd<CR>', opts)
vim.keymap.set('n', '<leader>j', ':HopWord<CR>', opts)

vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', opts)
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', opts)
vim.keymap.set('i', '<C-j>', '<Esc>:m .+1<CR>==gi', opts)
vim.keymap.set('i', '<C-k>', '<Esc>:m .-2<CR>==gi', opts)
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

vim.keymap.set('n', '<leader>yf', function()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath)
  vim.notify('Copied filename: ' .. filepath)
end, vim.tbl_extend('keep', opts, { desc = 'Yank file path to clipboard' }))

local function wrap_theme(picker)
  return function()
    picker({
      layout_strategy = "vertical",
      sorting_strategy = "ascending",
      previewer = true,
      layout_config = {
        width = 0.9,
        height = 40,
        preview_cutoff = 1,
      },
     borderchars = {
        prompt  = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
     --   results = { "═", "║", "═", "║", "╠", "╣", "╝", "╚" },
     --   preview = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
     },
    })
  end
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', wrap_theme(builtin.find_files), opts)
vim.keymap.set('n', '<leader>/', wrap_theme(builtin.live_grep), opts)
vim.keymap.set('n', '<leader>sw', wrap_theme(builtin.grep_string), opts)
vim.keymap.set('v', '<leader>sw', wrap_theme(builtin.grep_string), opts)
vim.keymap.set('n', '<leader>b', wrap_theme(builtin.buffers), opts)
vim.keymap.set('n', '<leader>b', wrap_theme(builtin.buffers), opts)

require('pull_request_viewer').setup({
  search_for = "label:Futurama",
})


local plugin_manager_path = "/home/carcara/Code/Go/github.com/alissonbrunosa/old-bessie/old-bessie"
local function execute(subcommand)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buflisted", false)

  vim.cmd('55vsplit')
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.termopen(plugin_manager_path .. " " .. subcommand)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'terminal')
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

vim.api.nvim_create_user_command("PlugInstall", function()
    execute("install")
end, {})


vim.api.nvim_create_user_command("PlugUpdate", function()
  execute("update")
end, {})

vim.api.nvim_create_user_command('PlugFile', function()
  vim.cmd('edit ' .. vim.fn.expand('~/.config/nvim/plugins.json'))
end, {})


local AsyncJob = require('plenary.job')
local function run_async(args, success, error)
  AsyncJob:new({
    command = 'gh',
    args = args,
    on_exit = vim.schedule_wrap(function(_, status)
      if status == 0 then
        vim.notify(success, vim.log.levels.INFO)
      else
        vim.notify(error, vim.log.levels.ERROR)
      end
    end),
  }):start()
end

local cmds = {
  CreatePR = {'pr', 'create', '--fill', '-a', '@me', '-r', 'vinted/futurama-backend'},
  ViewRepo = {'repo', 'view', '--web'},
}

for key, args in pairs(cmds) do
    vim.api.nvim_create_user_command(key, function()
        run_async(args, 'Done!', 'Error!')
    end, {})
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>r", ":GoRename<CR>", { buffer = true, silent = false })
  end,
})
