local M = {}

M.at_work = function()
    local lines = vim.fn.systemlist('hostname');
    return lines[1]:find('BNM01') ~= nil
end

M.is_linux = function()
    if vim.fn.has("linux") == 1 then
        return true
    end
    return false
end

return M
