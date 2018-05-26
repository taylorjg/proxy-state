local template = require "resty.template"

local Proxy = {}

local stats = {}

function Proxy.addRequestStats()
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

function Proxy.getAllStats()
    
    ngx.log(ngx.INFO, "[Proxy] inside Proxy.getAllStats()")
    for target, targetStats in pairs(stats) do
        ngx.log(ngx.INFO, string.format("[Proxy] target: %s; count: %s", target, targetStats.count))
    end

    template.render("proxystats.html", { message = "Hello, World!" })
end

return Proxy
