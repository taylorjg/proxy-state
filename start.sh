docker run --rm --detach --volume `pwd`/conf.d:/etc/nginx/conf.d --publish 8282:80 --name proxy-state openresty/openresty:trusty
