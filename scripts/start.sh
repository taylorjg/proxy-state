docker run \
    --rm \
    --detach \
    --publish 8282:80 \
    --name proxy-state \
    proxy-state
