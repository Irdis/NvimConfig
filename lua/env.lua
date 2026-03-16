local M = {}

M.at_work = function()
    local lines = vim.fn.systemlist('hostname');
    return lines[1]:find('BNM01') ~= nil
end

M.is_linux = function()
    return vim.fn.has("linux") == 1 
end
return M
