FROM openresty/openresty:trusty
COPY lua/*.lua /usr/local/openresty/nginx/
COPY lualib/*.lua /usr/local/openresty/lualib/
