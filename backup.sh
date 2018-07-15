#!/usr/bin/env bash
# WordPress Docker Backup

# ebff8761783f = running container name
# 5cf41cc99d14 = backup name

docker commit -p ebff8761783f wordpress_backup &&
docker commit -p 5cf41cc99d14 mariadb_backup
echo "Creating backup of your wordpress site and database."

docker save -o ~/wordpress_backup.tar wordpress_backup &&
docker save -o ~/mariadb_backup.tar mariadb_backup
echo "Saving your containers as a tar file."