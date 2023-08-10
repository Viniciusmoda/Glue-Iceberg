#!/bin/bash

set -eo pipefail
IFS=$'\n\t'

exec docker run \
  -it --rm \
  -v "$HOME/.aws:/home/glue_user/.aws" \
  -v "$PWD/notebooks:/home/glue_user/workspace/jupyter_workspace/" \
  -e DISABLE_SSL=true \
  -e AWS_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  -e AWS_SESSION_EXPIRATION \
  -e datalake_formats=iceberg \
  -e extra-py-files=pyiceberg\
  -p 4040:4040 \
  -p 18080:18080 \
  -p 8998:8998 \
  -p 8888:8888 \
  --name glue_jupyter_lab \
  amazon/aws-glue-libs:glue_libs_4.0.0_image_01 \
  /home/glue_user/jupyter/jupyter_start.sh
