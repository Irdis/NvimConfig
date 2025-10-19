local const = require("const")
local current_path = vim.fn.getcwd()

local function normal_make()
    vim.opt.makeprg = 'make'
    vim.opt.errorformat = "%f(%l): %trror C%n: %m,%-G%.%#"
end

local function normal_dotnet()
    vim.cmd [[
        let dotnet_show_project_file = v:false
        let dotnet_errors_only = v:true
        compiler! dotnet
    ]]
end

local function compare_paths(a, b)
    return a:lower() == b:lower()
end

if compare_paths(current_path, const.ht_main) then
    local build_targets = {
        "Applications.sln",
        "Applications\\Hazeltree.Collateral.API\\Tests\\MarginCall.Business.IntegrationTests\\MarginCall.Business.IntegrationTests.csproj",
        "Applications\\Fuzzy\\Tests\\Reconciliation.Fuzzy.IntegrationTests\\Reconciliation.Fuzzy.IntegrationTests.csproj"
    }
    local build_target = 1
    local current_target = build_targets[build_target]

    vim.keymap.set('n', '<Leader>ct', function()
        build_target = math.fmod(build_target, #build_targets)  + 1
        current_target = build_targets[build_target]
        print(build_target .. " " .. current_target)
        vim.opt.makeprg = const.ht_build .. ' ' .. current_target
    end, { noremap = true })

    vim.keymap.set('n', '<Leader>nr', function()
        vim.cmd(':!"' .. const.nuget .. '" restore ' .. current_target)
    end, { noremap = true })

    vim.keymap.set('n', '<Leader>nR', function()
        vim.cmd(':!"' .. const.nuget .. '" restore -Force ' .. current_target)
    end, { noremap = true })

    vim.opt.makeprg = const.ht_build .. ' ' .. current_target
    vim.opt.errorformat = '%E%f(%l\\,%c): %trror %m,%-G%.%#'
elseif compare_paths(current_path, const.ht_white) then
    local build_targets = {
        "WhiteApi.sln",
    }
    local build_target = 1
    local current_target = build_targets[build_target]

    vim.keymap.set('n', '<Leader>nr', function()
        vim.cmd(':!"' .. const.nuget .. '" restore ' .. current_target)
    end, { noremap = true })
    vim.keymap.set('n', '<Leader>nR', function()
        vim.cmd(':!"' .. const.nuget .. '" restore -Force ' .. current_target)
    end, { noremap = true })

    vim.opt.makeprg = const.ht_build .. ' ' .. current_target
    vim.opt.errorformat = '%E%f(%l\\,%c): %trror %m,%-G%.%#'
elseif compare_paths(current_path, const.home_rule110) or
       compare_paths(current_path, const.ht_rule110) then
    vim.keymap.set('n', '<F5>', ':exe "!dotnet run" | exe "!start img_0.bmp"<CR>"')
    normal_dotnet()
elseif compare_paths(current_path, const.swsm)  then
    normal_make()
else
    normal_dotnet()
end
