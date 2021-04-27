#!/bin/bash

JRUBY_VER=9.2.14.0

if [ -d "/opt/jruby-${JRUBY_VER}" ]; then
  # Docker container
  export PATH="/opt/jruby-${JRUBY_VER}/bin:${PATH}"
else
  export PATH="${PWD}/jruby-${JRUBY_VER}/bin:${PATH}"
fi

jruby "$@"
