#!/usr/bin/env bash

# Try to read the configuration from:
#   1. the working directory
#   2. The user's home directory
# (in that order)
config_file=".s3upload.conf"
if [ -f "$(pwd)/$config_file" ]; then
  source "$(pwd)/$config_file"
elif [ -f "$HOME/$config_file" ]; then
  source "$HOME/$config_file"
fi

# S3UPLOAD_BUCKET=""
# S3UPLOAD_AWS_ACCESS_KEY_ID=""
# S3UPLOAD_AWS_SECRET_ACCESS_KEY=""
# S3UPLOAD_BASE_URL=""
S3UPLOAD_AWS_REGION=${S3UPLOAD_AWS_REGION:-"us-east-1"}

bucket=$S3UPLOAD_BUCKET
key=$S3UPLOAD_AWS_ACCESS_KEY_ID
secret=$S3UPLOAD_AWS_SECRET_ACCESS_KEY

endpoint=""
case "$S3UPLOAD_AWS_REGION" in
us-east-1) endpoint="s3.amazonaws.com"
;;
*)  endpoint="s3-$S3UPLOAD_AWS_REGION.amazonaws.com"
;;
esac

base_url=${S3UPLOAD_BASE_URL:-"https://$endpoint/$bucket"}

mimepattern="[0-9a-zA-Z-]/[0-9a-zA-Z-]"

function timestamp {
  date +"%s"
}

function putS3
{
  path=$1
  file=$(basename "$path")

  filename=$file
  extension="${filename#*.}"
  filename="${filename%%.*}"
  filename="$filename-$(timestamp).$extension"

  content_type=$(file --mime-type -b "${path}")
  if [[ ! "$content_type" =~ $mimepattern ]]
  then
    content_type="application/octet-stream"
  fi

  aws_path="/"
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  cache_control="public, max-age=315360000"

  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$filename"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${secret}" -binary | base64)

  curl -X PUT -T "$path" \
    -H "Host: $endpoint" \
    -H "Date: $date" \
    -H "Cache-Control: $cache_control" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${key}:$signature" \
    "https://$endpoint/$bucket$aws_path$filename"

  case "$?" in
    0) echo "$base_url$aws_path$filename"
    ;;
    *) echo "Uh oh. Something went terribly wrong"
    ;;
  esac
}

if [[ $# -eq 0 || "$1" == "--help" || "$1" == "-h" ]] ; then
  cat <<EOS
S3UPLOAD

Usage: S3UPLOAD [file ...]

More info: https://github.com/0xnu/docker-wordpress-utils
EOS

    exit 1
fi

for file in "$@"
do
  putS3 "$file"
done
