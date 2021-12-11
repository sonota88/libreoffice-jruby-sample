#!/bin/bash

docker run --rm -it \
  -v "$(pwd):/home/${USER}/work" \
  -p 4567:4567 \
  my:libo-jruby-webapi-2021 \
  "$@"
