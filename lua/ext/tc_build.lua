local BUILD_TYPE = "Cloud_CloudCollateralApiNetCore"
local TC_BASE    = "https://tc.hazeltree.com"

local function trigger(tag)
    local token = vim.env.TC_TOKEN
    local body = vim.fn.json_encode({
        buildType  = { id = BUILD_TYPE },
        branchName = "refs/tags/" .. tag,
    })

    local cmd = {
        "curl", "-sS", "-X", "POST",
        TC_BASE .. "/app/rest/buildQueue",
        "-H", "Authorization: Bearer " .. token,
        "-H", "Content-Type: application/json",
        "-H", "Accept: application/json",
        "-d", body,
    }

    vim.notify("Triggering build for tag: " .. tag .. " …")

    vim.system(cmd, { text = true }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify("curl error:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
                return
            end

            local ok, decoded = pcall(vim.fn.json_decode, result.stdout)
            if not ok then
                vim.notify("Response:\n" .. result.stdout, vim.log.levels.WARN)
                return
            end

            local build_id  = decoded.id
            local state     = decoded.state or "?"
            local href      = TC_BASE .. (decoded.href or "")
            vim.notify(
                string.format("Build #%s queued  state=%s\n%s", build_id, state, href),
                vim.log.levels.INFO
            )
        end)
    end)
end

vim.api.nvim_create_user_command("TcBuild", function(args)
    local tag = vim.trim(args.args)
    if tag ~= "" then
        trigger(tag)
        return
    end
    vim.ui.input({ prompt = "Tag: " }, function(input)
        if input and vim.trim(input) ~= "" then
            trigger(vim.trim(input))
        end
    end)
end, { nargs = "?", desc = "Trigger TeamCity build for a git tag" })
