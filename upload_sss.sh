#!/usr/bin/bash
src=${1}
if [[ $src =~ \/$ ]]; then
# folder upload
dst=${2}
aws s3 cp $src s3://sy-workz-front-sss/$dst --recursive
else
# file upload
dst=${2}
aws s3 cp ${1} s3://sy-workz-front-sss/$dst
fi

