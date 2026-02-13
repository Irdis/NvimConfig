vim.api.nvim_create_user_command('RelPath', function()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local path = vim.trim(line)

  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ':p:h')

  local combined = current_dir .. '/' .. path
  local abs_path = vim.fn.fnamemodify(combined, ':p')
  abs_path = vim.fn.simplify(abs_path)

  local rel_path = vim.fn.fnamemodify(abs_path, ':.')
  rel_path = rel_path:gsub('/', '\\')

  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, {rel_path})
end, { desc = 'Convert path to relative to cwd' })
--[[
    ..\ext\rel_path.lua
]]--
