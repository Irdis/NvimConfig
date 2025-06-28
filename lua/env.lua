local M = {}
M.at_work = function()
    local lines = vim.fn.systemlist('hostname');
    return lines[1]:find('BNM01') ~= nil
end
return M
