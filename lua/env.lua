local M = {}
M.at_work = function()
    local lines = vim.fn.systemlist('hostname');

    return lines[1]:find('BNM01') ~= 0
end
return M
