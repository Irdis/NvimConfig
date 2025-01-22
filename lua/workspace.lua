local current_path = string.lower(vim.fn.getcwd())
local htfs = "c:\\repo\\hazeltree\\main\\htfs"
local white = "c:\\repo\\hazeltree\\whiteapi"
if current_path == htfs then
    local build_targets = { 
        "Applications.sln",  
        "Applications\\Hazeltree.Collateral.API\\Tests\\MarginCall.Business.IntegrationTests\\MarginCall.Business.IntegrationTests.csproj"
    }
    local build_target = 1
    local current_target = build_targets[build_target]

    vim.keymap.set('n', '<Leader>ct', function()
        build_target = math.fmod(build_target, table.getn(build_targets))  + 1
        current_target = build_targets[build_target]
        print(build_target .. " " .. current_target)
        vim.opt.makeprg = 'c:\\Repo\\hazeltree\\setup\\build.bat' .. ' ' .. current_target
    end, { noremap = true })

    vim.opt.makeprg = 'c:\\Repo\\hazeltree\\setup\\build.bat' .. ' ' .. current_target
    vim.opt.errorformat = '%E%f(%l\\,%c): %trror %m,%-G%.%#'
elseif current_path == white then 
    local build_targets = { 
        "WhiteApi.sln",  
    }
    local build_target = 1
    local current_target = build_targets[build_target]

    vim.opt.makeprg = 'c:\\Repo\\hazeltree\\setup\\build.bat' .. ' ' .. current_target
    vim.opt.errorformat = '%E%f(%l\\,%c): %trror %m,%-G%.%#'
else
    vim.cmd [[
        let dotnet_show_project_file = v:false
        let dotnet_errors_only = v:true
        compiler! dotnet
    ]]
end
