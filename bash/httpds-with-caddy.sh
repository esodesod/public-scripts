#!/bin/sh

# Create the Caddyfile
cat <<EOT > /tmp/Caddyfile
localhost
root * /myfiles
file_server browse
EOT

# Start the container
docker run --rm -it -p 80:80 -p 443:443 \
    -v /tmp/Caddyfile:/etc/caddy/Caddyfile \
    -v $PWD:/myfiles \
    caddy
