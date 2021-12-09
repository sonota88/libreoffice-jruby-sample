FROM ubuntu:18.04

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    ca-certificates \
    libreoffice-calc \
    libreoffice-dev \
    libreoffice-java-common \
    openjdk-8-jre-headless \
    wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG USER
ARG GROUP

RUN groupadd ${USER} \
  && useradd ${USER} -g ${GROUP} -m

USER ${USER}
ENV USER $USER

# --------------------------------

WORKDIR /home/${USER}

ARG JRUBY_VER=9.2.14.0

RUN wget --quiet -O- \
    https://repo1.maven.org/maven2/org/jruby/jruby-dist/${JRUBY_VER}/jruby-dist-${JRUBY_VER}-bin.tar.gz \
    > jruby.tar.gz \
  && tar xf jruby.tar.gz \
  && rm jruby.tar.gz \
  && mv jruby-${JRUBY_VER} jruby

# --------------------------------

WORKDIR /home/${USER}/work
