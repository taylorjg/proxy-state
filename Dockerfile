FROM openresty/openresty:trusty
COPY lua/*.lua /usr/local/openresty/nginx/
