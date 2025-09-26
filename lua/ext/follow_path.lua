local patterns = {
 "([%w%._%-/\\:]+%.%w+):line (%d+)",
 "([%w%._%-/\\:]+%.%w+):(%d+):(%d+)"
}
local function follow_path(precise)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- local line = vim.api.nvim_get_current_line()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, row - 1, row + 2, false)
    local line = table.concat(lines)

    local b = nil
    local e = nil
    local path = ""
    local lineno = ""
    local colno = ""
    local found = false

    b, e = 0, 0
    for _, pattern in ipairs(patterns) do
        while true do
            b, e, path, lineno, colno = string.find(line, pattern, b + 1)
            if b == nil or e == nil then break end
            if not precise then
                found = true
                break
            end
            if b <= col and col <= e then
                found = true
                break
            end
            if b > col then break end
            b = e
        end
        if found then break end
        b, e = 0, 0
    end
    if found then
        if vim.fn.filereadable(path) == 0 then
            print('File is not readable ' .. vim.fn.fnameescape(path))
        else
            local linenum = tonumber(lineno)
            local colnum = 0
            if colno ~= nil then
                colnum = tonumber(colno)
            end
            vim.cmd("edit " .. vim.fn.fnameescape(path))
            vim.api.nvim_win_set_cursor(0, {linenum, colnum})
            vim.cmd("norm zz")
        end
    else
        print('Nothing has been found')
    end
end
vim.keymap.set('n', '<Leader>fp',function()
    follow_path(false)
end, { noremap = true })
vim.keymap.set('n', '<Leader>fP',function()
    follow_path(true)
end, { noremap = true })
