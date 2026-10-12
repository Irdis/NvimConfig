local BUILD_TYPE  = "Cloud_CloudCollateralApiNetCore"
local DEPLOY_TYPE = "Cloud_Tms_CloudBuildDeployV125"
local TC_BASE     = "https://tc.hazeltree.com"

local DEPLOYS = {
    { name = "qa10", branch = "feature/red/55781-acadia-subs-vol2", lab = "QA10-WA1" },
}

local function queue(payload, what)
    local token = vim.env.TC_TOKEN
    local body = vim.fn.json_encode(payload)

    local cmd = {
        "curl", "-sS", "-X", "POST",
        TC_BASE .. "/app/rest/buildQueue",
        "-H", "Authorization: Bearer " .. token,
        "-H", "Content-Type: application/json",
        "-H", "Accept: application/json",
        "-d", body,
    }

    vim.notify("Triggering " .. what .. " …")

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
            local href      = decoded.webUrl or (TC_BASE .. (decoded.href or ""))
            vim.notify(
                string.format("Build #%s queued  state=%s\n%s", build_id, state, href),
                vim.log.levels.INFO
            )
        end)
    end)
end

local function trigger(tag)
    queue({
        buildType  = { id = BUILD_TYPE },
        branchName = "refs/tags/" .. tag,
    }, "build for tag: " .. tag)
end

local function run_deploy(branch, lab)
    queue({
        buildType  = { id = DEPLOY_TYPE },
        branchName = branch,
        properties = { property = { { name = "FullServerName", value = lab } } },
    }, "deploy of " .. branch .. " to " .. lab)
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

local function tag_push_and_build(tag)
    vim.cmd("G tag " .. tag)
    vim.cmd("G push origin " .. tag)
    vim.cmd("TcBuild " .. tag)
end

vim.api.nvim_create_user_command("TagAndBuild", function(args)
    tag_push_and_build(vim.trim(args.args))
end, { nargs = 1, desc = "G tag <tag> | G push origin <tag> | TcBuild <tag>" })

vim.api.nvim_create_user_command("RunDeploy", function(args)
    if #args.fargs ~= 2 then
        vim.notify("Usage: RunDeploy <branch> <lab>", vim.log.levels.ERROR)
        return
    end
    run_deploy(args.fargs[1], args.fargs[2])
end, { nargs = "+", desc = "Trigger TeamCity CloudBuildDeploy for <branch> on <lab>" })

require("ext/simple_select").register("n",
    "<Leader>ds",
    "Deploy",
    DEPLOYS,
    function() return nil end,
    function(d) return string.format("%s - lab:%s, branch:%s", d.name, d.lab, d.branch) end,
    function(d) run_deploy(d.branch, d.lab) end)
