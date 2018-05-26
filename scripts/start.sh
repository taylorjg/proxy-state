docker run \
    --rm \
    --detach \
    --env "PORT=80" \
    --publish 8282:80 \
    --name proxy-state \
    proxy-state
