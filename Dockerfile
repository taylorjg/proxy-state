FROM openresty/openresty:trusty
COPY lua/hellolua.lua /usr/local/openresty/nginx
