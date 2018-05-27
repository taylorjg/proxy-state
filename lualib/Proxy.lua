local template = require "resty.template"

local M = {}

local stats = {}

-- TODO: order HTTP status ranges
-- TODO: limit avg_latency_ms to 2 decimal places
-- TODO: refactor to remove duplication
-- TODO: make stats available in JSON format (/proxy/stats?format=json)

function M.addTargetStats()
    local target = ngx.var.arg_target
    if target then
        local status = ngx.status
        local latency = 1000 * (tonumber(ngx.var.upstream_response_time) or 0)
        local targetStats = stats[target]
        if targetStats then
            targetStats.count = targetStats.count + 1
            targetStats.total_latency_ms = targetStats.total_latency_ms + latency
            targetStats.avg_latency_ms = targetStats.total_latency_ms / targetStats.count
            local http_status = targetStats.http_status
            if status >= 200 and status < 300 then
                http_status["2XX"] = http_status["2XX"] + 1
            elseif status >= 300 and status < 400 then
                http_status["3XX"] = http_status["3XX"] + 1
            elseif status >= 400 and status < 500 then
                http_status["4XX"] = http_status["4XX"] + 1
            else
                http_status["5XX"] = http_status["5XX"] + 1
            end
        else
            stats[target] = {}
            local targetStats = stats[target]
            targetStats.count = 1
            targetStats.total_latency_ms = latency
            targetStats.avg_latency_ms = latency
            targetStats.http_status = {};
            local http_status = targetStats.http_status
            http_status["2XX"] = 0
            http_status["3XX"] = 0
            http_status["4XX"] = 0
            http_status["5XX"] = 0
            if status >= 200 and status < 300 then
                http_status["2XX"] = 1
            elseif status >= 300 and status < 400 then
                http_status["3XX"] = 1
            elseif status >= 400 and status < 500 then
                http_status["4XX"] = 1
            else
                http_status["5XX"] = 1
            end
        end
    end
end

function M.getAllStats()
    template.render("view.html", { stats = stats })
end

return M
