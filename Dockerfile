# syntax=docker/dockerfile:1-labs

FROM rubylang/ruby:3.2.0-dev-jammy as base

RUN --mount=type=cache,target=/var/lib/apt <<COMMAND
    apt-get update
    apt-get upgrade -yy
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential bison gperf unzip autoconf libyaml-dev
COMMAND

FROM base as source
ARG MRUBY_VERSION

RUN <<COMMAND
    if [ -z "${MRUBY_VERSION}" ]; then
        echo "MRUBY_VERSION is not set"
        exit 1
    fi
    wget https://github.com/mruby/mruby/archive/${MRUBY_VERSION}.zip -O mruby.zip
    unzip mruby.zip
    mv mruby-${MRUBY_VERSION} mruby
COMMAND

FROM base

COPY --from=source /mruby /mruby
COPY entrypoint.rb /entrypoint.rb

WORKDIR /build
ENTRYPOINT [ "/entrypoint.rb" ]
