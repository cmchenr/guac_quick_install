docker run -d -p 80:80 -p 443:443 --name nginx-guac-proxy  -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

docker run --name some-guacd -d glyptodon/guacd

mkdir db_init

docker run --rm glyptodon/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./db_init/initdb.sql

docker run --name guac-mysql -v $PWD/db_init:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=cisco123 -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=guac_password -d mysql:5.7

docker run --name some-guacamole --link some-guacd:guacd \
    --link guac-mysql:mysql         \
    -e MYSQL_DATABASE=guacamole_db  \
    -e MYSQL_USER=guacamole_user    \
    -e MYSQL_PASSWORD=guac_password \
    -e VIRTUAL_HOST=guacamole \
    -d -p 8080:8080 glyptodon/guacamole

rm -r db_init
