local name = ngx.var.arg_name or "Anonymous"
ngx.log(ngx.INFO, string.format("[hellolua] name: %s", name))
ngx.say(string.format("Hello, %s!", name))
