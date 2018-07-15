#!/usr/bin/env bash
# WordPress Docker Restore

docker load -i wordpress_backup.tar &&
docker load -i mariadb_backup.tar &&
docker run --restart=always --privileged --name wordpress -td -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 wordpress_backup &&
docker run --restart=always --privileged --name mariadb -i -t -td -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 3306 mariadb_backup &&
docker stop mariadb &&
docker rm mariadb &&
docker-compose up -d
echo "Fucking done! Go and check your site!"
