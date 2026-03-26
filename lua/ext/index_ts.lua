local function index_ts()
    local current_file = vim.fn.expand("%:p")
    local folder = vim.fn.fnamemodify(current_file, ":h")
    local index_path = folder .. "/index.ts"

    local handle = vim.loop.fs_scandir(folder)
    if not handle then
        print("index_ts: cannot scan folder " .. folder)
        return
    end

    local exports = {}
    while true do
        local name, ftype = vim.loop.fs_scandir_next(handle)
        if not name then break end
        if ftype == "file" and name:match("%.ts$") and name ~= "index.ts" then
            local stem = name:gsub("%.ts$", "")
            table.insert(exports, "export * from './" .. stem .. "';")
        end
    end

    table.sort(exports)

    if #exports == 0 then
        print("index_ts: no .ts files found in " .. folder)
        return
    end

    local lines = table.concat(exports, "\n") .. "\n"
    local f = io.open(index_path, "w")
    if not f then
        print("tsindex: cannot write " .. index_path)
        return
    end
    f:write(lines)
    f:close()

    print("tsindex: wrote " .. index_path .. " (" .. #exports .. " exports)")

    local current_name = vim.fn.fnamemodify(current_file, ":t")
    if current_name == "index.ts" then
        vim.cmd("edit!")
    end
end

vim.api.nvim_create_user_command("IndexTs", index_ts, {})
