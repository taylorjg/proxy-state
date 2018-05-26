FROM openresty/openresty:trusty
COPY conf/nginx.conf /usr/local/openresty/nginx/conf
COPY conf.d/default.conf /etc/nginx/conf.d
COPY lua/*.lua /usr/local/openresty/nginx/
COPY lualib/*.lua /usr/local/openresty/lualib/
COPY html/*.html /usr/local/openresty/nginx/html/
RUN sudo /usr/local/openresty/luajit/bin/luarocks install lua-resty-template
