local M = {}

function M.register(mode, key, prompt, items, get_selected, format, callback)
    vim.keymap.set(mode, key,function()
        vim.ui.select(items, {
            prompt = prompt,
            format_item = function(item)
                if get_selected() == item then
                    return format(item) .. " (current)"
                end
                return format(item)
            end
        }, function (choice)
            if choice == nil then
                return
            end
            print('Selected ' .. format(choice))
            callback(choice)
        end)
    end, { noremap = true })
end

return M
