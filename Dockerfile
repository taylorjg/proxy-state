FROM openresty/openresty:trusty
RUN sudo /usr/local/openresty/luajit/bin/luarocks install lua-resty-template
COPY lua/*.lua /usr/local/openresty/nginx/
COPY lualib/*.lua /usr/local/openresty/lualib/
COPY html/*.html /usr/local/openresty/nginx/html/
