#!/usr/bin/env bash
# WordPress Docker Backup

# root_wordpress_1 = wordpress container name
# root_mysql_1 = mysql/mariadb container name

docker run --rm --volumes-from root_wordpress_1 -v $(pwd)/backup:/backup/ ubuntu tar -cvf /backup/matchrecap_com.tar /var/www/html/ &&
docker exec root_mysql_1 sh -c 'exec mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' > $(pwd)/backup/matchrecap_com.sql &&


if [ -z "$1" ]; then
  echo "Made matchrecap_com.tar and matchrecap_com.sql"
else
  echo "Uploading to S3"
  aws s3 mv matchrecap_com.tar matchrecap_com.sql $1
fi

#rm -rf backup/*
