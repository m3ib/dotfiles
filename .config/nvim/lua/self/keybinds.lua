local wk = require("which-key")

local builtin = require("telescope.builtin")
local conform = require("conform")
local oil = require("oil")
local gitsigns = require("gitsigns")

local scratchBufName = "ScratchBuffer"
local scratchBufNum = -1

wk.add({
  -- Misc
  { "<ESC>", "<cmd>nohl<CR>" },
  { "<C-s>", "<cmd>w<CR>" },
  { "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
  { "<leader>e", oil.toggle_float, desc = "Toggle Oil" },
  { "<leader>r", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-Tree" },
  { "<leader>l", "<cmd>Lazy<CR>", desc = "Lazy" },
  {
    "<leader><leader>",
    function()
      -- local buf = vim.fn.bufnr(scratchBufName)
      if scratchBufNum == -1 then
        scratchBufNum = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(scratchBufNum, scratchBufName)
        vim.keymap.set("n", "<ESC>", "<cmd>close<CR>", {
          buffer = scratchBufNum,
        })
      end

      -- if a window is already opened, close it
      local winId = vim.fn.bufwinid(scratchBufNum)
      if winId ~= -1 then
        vim.api.nvim_win_close(winId, true)
        return
      end

      -- otherwise, make a new one
      local ratio = 2 / 3
      local w, h = math.floor(vim.o.columns * ratio), math.floor(vim.o.lines * ratio)
      local opts = {
        relative = "editor",
        width = w,
        height = h,
        col = (vim.o.columns - w) / 2,
        row = (vim.o.lines - h) / 2,
      }
      local win = vim.api.nvim_open_win(scratchBufNum, 0, opts)
      -- vim.api.nvim_set_option_value("winhl", "Normal:MyHighlight", { win = win })
    end,
    desc = "Toggle Scratch Buffer",
  },
  -- Quiting & Saving
  { "<leader>qq", "<cmd>qa!<CR>", desc = "Quit All (force)" },
  { "<leader>qu", "<cmd>suspend<CR>", desc = "Suspend" },
  { "<leader>qw", "<cmd>wqa<CR>", desc = "Quit All (saving)" },
  {
    "<leader>qs",
    "<cmd>wqa | mksession" .. vim.fn.expand("~/.nvim/") .. vim.fn.getcwd():match("([^/]+)$") .. ".vim" .. "<CR>",
    desc = "Write, quit & save session (saving)",
  },
  -- Telescope
  { "<leader>f", group = "Find" },
  { "<leader>p", builtin.find_files, desc = "Telescope Find File" },
  { "<leader>fb", builtin.buffers, desc = "Telescope Find Buffer" },
  { "<leader>f.", builtin.resume, desc = "Telescope Repeat search" },
  { "<leader>/", builtin.live_grep, desc = "Grep Files" },
  { "<leader>fk", builtin.keymaps, desc = "Telescope Find Keymap" },
  { "<leader>fh", builtin.help_tags, desc = "Telescope Find Help" },
  { "<leader>fc", builtin.colorscheme, desc = "Telescope Find Colorscheme" },
  { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Telescope Find Todos" },
  -- Code
  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Code Diagnostic" },
  {
    "<leader>cD",
    function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    desc = "Code Diagnostic",
  },
  { "<leader>cl", vim.diagnostic.setloclist, desc = "Open Diagnostic List" },
  { "<leader>cf", conform.format, desc = "Code Format" },
  -- Buffers
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", "<cmd>bnext<CR>", desc = "Buffer Next" },
  { "<leader>bp", "<cmd>bprevious<CR>", desc = "Buffer Previous" },
  { "<leader>bd", "<cmd>bd<CR>", desc = "Buffer Delete" },
  { "<leader>bo", "<cmd>buf #<CR>", desc = "Buffer Go to Other" },
  -- delete all buffers before and after this one
  {
    "<leader>bO",
    function()
      local current_buf = vim.api.nvim_get_current_buf()
      vim
        .iter(vim.api.nvim_list_bufs())
        :filter(function(buf)
          return vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf
        end)
        :each(function(buf)
          vim.api.nvim_buf_delete(buf, {})
        end)
    end,
    desc = "Buffer Close others",
  },
  { "<S-l>", "<cmd>bnext<CR>", desc = "Buffer Next" },
  { "<S-h>", "<cmd>bprevious<CR>", desc = "Buffer Previous" },
  { "]b", "<cmd>bnext<CR>", desc = "Buffer Next" },
  { "[b", "<cmd>previous<CR>", desc = "Buffer Previous" },
  -- Terminal
  { "<leader>t", group = "Terminal" },
  { "<leader>tt", "<cmd>terminal<CR>a", desc = "Open Terminal New Buffer" },
  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>gs", "<cmd>Neotree float git_status<CR>", desc = "Git Status" },
  { "<leader>gS", builtin.git_stash, desc = "Git Stash" },
  { "<leader>gc", builtin.git_commits, desc = "Git Commits" },
  { "<leader>gl", gitsigns.blame_line, desc = "Git Blame line" },
  { "<leader>gL", gitsigns.blame, desc = "Git Blame file" },
  { "<leader>gbs", gitsigns.stage_buffer, desc = "Git Buffer Stage" },
  { "<leader>gbr", gitsigns.reset_buffer, desc = "Git Buffer Reset" },
  { "<leader>gbR", gitsigns.reset_buffer, desc = "Git Buffer Reset (index)" },
  { "<leader>ghp", gitsigns.preview_hunk_inline, desc = "Git Hunk preview under cursor" },
  { "<leader>ghs", gitsigns.stage_hunk, desc = "Git Hunk Stage" },
  { "<leader>ghr", gitsigns.reset_hunk, desc = "Git Hunk Reset" },
  {
    "]g",
    function()
      gitsigns.nav_hunk("next")
    end,
    desc = "Next Git Hunk",
  },
  {
    "[g",
    function()
      gitsigns.nav_hunk("prev")
    end,
    desc = "Previous Git Hunk",
  },
  {
    "]G",
    function()
      gitsigns.nav_hunk("last")
    end,
    desc = "Last Git Hunk",
  },
  {
    "[G",
    function()
      gitsigns.nav_hunk("first")
    end,
    desc = "First Git Hunk",
  },
  { "<leader>ghv", gitsigns.select_hunk, desc = "Git Select Hunk under cursor" },
  -- Window
  { "<leader>w", proxy = "<C-w>", desc = "Window" },
  { "<C-h>", "<C-w>h" },
  { "<C-j>", "<C-w>j" },
  { "<C-k>", "<C-w>k" },
  { "<C-l>", "<C-w>l" },
})
