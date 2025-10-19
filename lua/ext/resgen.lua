local function file_exists(path)
    return vim.loop.fs_stat(path) ~= nil
end

local function resgen(args)
    local resx = vim.fn.expand("%");
    local resx_folder = vim.fn.fnamemodify(resx, ":h");
    local class_name = vim.fn.fnamemodify(resx, ":t:r")
    local cs_name = class_name .. ".Designer.cs"
    local cs_path = resx_folder .. "\\" .. cs_name
    local resources = resx_folder .. "\\" .. class_name .. ".resources"

    local namespace = nil
    if file_exists(cs_path) then
        local lines = vim.fn.readfile(cs_path)
        for _, line in ipairs(lines) do
            _, _, namespace = string.find(line, "namespace ([%w%p]+)")
            if namespace ~= nil then
                break
            end
        end

        if namespace == nil then
            print("%.Designer.cs file exists, but can't find namespace")
            return
        end
    else
        namespace = args.args
        if namespace == nil or namespace == "" then
            print("Unable to resolve namespace. %.Designer.cs doesn't exist. " ..
                "Pass namespace as an argument")
            return
        end
    end

    local cmd = "!resgen " .. resx
    cmd = cmd .. " " .. "/str:cs," .. namespace .."," .. class_name .. "," .. cs_path
    cmd = cmd .. " " .. "/publicClass"
    vim.cmd(cmd);

    vim.fn.delete(resources)
end

vim.api.nvim_create_user_command("Resgen", resgen, { nargs = "*" })

vim.api.nvim_create_user_command("ResgenDefaultText", function()
    local text = [[<?xml version="1.0" encoding="utf-8"?>
<root>
    <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
        <xsd:element name="root" msdata:IsDataSet="true">
        </xsd:element>
    </xsd:schema>
    <resheader name="resmimetype">
        <value>text/microsoft-resx</value>
    </resheader>
    <resheader name="version">
        <value>1.3</value>
    </resheader>
    <resheader name="reader">
        <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
    </resheader>
    <resheader name="writer">
        <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
    </resheader>
</root>]]
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.split(text, "\n", { plain = true })
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
end, {})

vim.api.nvim_create_user_command("ResgenAddString", function()
    local text = [[<data name="" xml:space="preserve">
    <value></value>
  </data>]]
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.split(text, "\n", { plain = true })
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
    vim.api.nvim_win_set_cursor(0, { row, col + 11 })
end, {})
