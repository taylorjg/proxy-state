local template = require "resty.template"

local M = {}

local stats = {}

function M.addTargetStats()
    local target = ngx.var.arg_target
    if target then
        local status = ngx.status
        local targetStats = stats[target]
        if targetStats then
            targetStats.count = targetStats.count + 1
            if targetStats[status] then
            else
                targetStats[status] = targetStats[status] + 1
            end
        else
            stats[target] = {}
            stats[target].count = 1
            stats[target][status] = 1
        end
    end
end

function M.getAllStats()
    template.render("view.html", { stats = stats })
end

return M