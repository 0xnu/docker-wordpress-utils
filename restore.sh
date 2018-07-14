#!/usr/bin/env bash
# WordPress Docker Restore

if [ -z "$1" ]; then
  echo "Using matchrecap_com.tar"
else
  echo "Downloading from S3"
  aws s3 cp $1 matchrecap_com.tar
fi

tar -xzf matchrecap_com.tar
docker-compose up restore