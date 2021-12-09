#!/bin/bash

JRUBY_VER=9.2.14.0

if [ -d "/home/${USER}/jruby" ]; then
  # Docker container
  export PATH="/home/${USER}/jruby/bin:${PATH}"
else
  export PATH="${PWD}/jruby-${JRUBY_VER}/bin:${PATH}"
fi

jruby "$@"
