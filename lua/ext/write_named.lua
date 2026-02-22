local function write_named()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "modified")
       and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("write")
      end)
    end
  end
end

vim.api.nvim_create_user_command("WriteNamed", write_named, {})
