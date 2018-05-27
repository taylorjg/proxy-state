FROM openresty/openresty:trusty
COPY conf.d/default.conf /etc/nginx/conf.d
COPY lualib/*.lua /usr/local/openresty/lualib/
COPY html/*.html /usr/local/openresty/nginx/html/
RUN sudo /usr/local/openresty/luajit/bin/luarocks install lua-resty-template
