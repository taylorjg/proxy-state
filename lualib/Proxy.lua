local template = require "resty.template"
local cjson = require "cjson"

local M = {}

local stats = {}

function createTargetStats(latency, status)
    local targetStats = {}
    targetStats.count = 1
    targetStats.avg_latency_ms = latency
    targetStats.http_status = {};
    targetStats.http_status["2XX"] = 0
    targetStats.http_status["3XX"] = 0
    targetStats.http_status["4XX"] = 0
    targetStats.http_status["5XX"] = 0
    incrementHttpStatusCount(targetStats.http_status, status)
    return targetStats
end

function incrementHttpStatusCount(http_status, status)
    if status >= 200 and status < 300 then
        http_status["2XX"] = http_status["2XX"] + 1
    elseif status >= 300 and status < 400 then
        http_status["3XX"] = http_status["3XX"] + 1
    elseif status >= 400 and status < 500 then
        http_status["4XX"] = http_status["4XX"] + 1
    else
        http_status["5XX"] = http_status["5XX"] + 1
    end
end

function M.addTargetStats()
    local target = ngx.var.arg_target
    if target then
        local status = ngx.status
        local latency = 1000 * (tonumber(ngx.var.upstream_response_time) or 0)
        local targetStats = stats[target]
        if targetStats then
            local oldCount = targetStats.count
            local newCount = oldCount + 1
            targetStats.count = newCount
            local avg = (targetStats.avg_latency_ms * oldCount + latency) / newCount
            local avgToTwoDecimalPlaces = tonumber(string.format("%.2f", avg))
            targetStats.avg_latency_ms = avgToTwoDecimalPlaces
            incrementHttpStatusCount(targetStats.http_status, status)
        else
            stats[target] = createTargetStats(latency, status)
        end
    end
end

-- TODO: how to return correctly ordered http_status tables ?
function M.getAllStats()
    if ngx.var.arg_format == "json" then
        ngx.header.content_type = "application/json";
        ngx.say(cjson.encode(stats))
    else
        template.render("view.html", { stats = stats })
    end
end

return M
