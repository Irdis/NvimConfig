local function quick_ctags(tagname)
    local tags = vim.fn.taglist('^' .. tagname .. '$')

    if #tags == 0 then
        print("No tags found for: " .. tagname)
    elseif #tags == 1 then
        vim.cmd("tag " .. tagname)
    else
        local qf_entries = {}
        for _, t in ipairs(tags) do
            local pattern = t.cmd:sub(2, -2)
            pattern = pattern
                :gsub("%[", "\\[")
                :gsub("%]", "\\]")
            table.insert(qf_entries, {
                filename = t.filename,
                pattern = pattern,
                text = '',
            })
        end
        vim.fn.setqflist(qf_entries)
        vim.cmd("copen")
    end
end

vim.keymap.set("n", "<leader>t", function()
    local word = vim.fn.expand("<cword>")
    quick_ctags(word)
end)
