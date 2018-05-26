ngx.log(ngx.INFO, "[proxystats]")
ngx.say("stats")

proxy = require "Proxy"
proxy.getAllStats()
