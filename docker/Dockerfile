# syntax=docker/dockerfile:1-labs

FROM rubylang/ruby:3.3-jammy as base

RUN --mount=type=cache,target=/var/lib/apt <<COMMAND
    apt-get update
    apt-get upgrade -yy
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential git bison gperf libtool-bin autoconf libyaml-dev \
        gcc-mingw-w64 g++-mingw-w64 unzip xz-utils wget gosu jq
COMMAND

FROM base as source
ARG MRUBY_VERSION=3.2.0

RUN <<COMMAND
    wget https://github.com/mruby/mruby/archive/${MRUBY_VERSION}.zip -O mruby.zip
    unzip mruby.zip
    mv mruby-${MRUBY_VERSION} mruby

    if [ "${MRUBY_VERSION}" = "master" ]; then
        REF="heads/master"
    else
        REF="tags/${MRUBY_VERSION}"
    fi
    wget -q -O - https://api.github.com/repos/mruby/mruby/commits/${REF} | jq -r '.sha' > /mruby/COMMIT
COMMAND

COPY mrbgems/mruby-commit-id /mruby/mrbgems/mruby-commit-id

RUN <<COMMAND
    sed -i 's/%COMMIT_ID%/'`cat /mruby/COMMIT`'/' /mruby/mrbgems/mruby-commit-id/src/commit_id.c
COMMAND

FROM base as zig
ARG ZIG_VERSION=0.11.0
ENV ZIG_MINISIGN_PUBKEY=RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U

RUN <<COMMAND
    wget https://github.com/jedisct1/minisign/releases/download/0.11/minisign-0.11-linux.tar.gz -O minisign.tar.gz
    tar -xf minisign.tar.gz
    mv minisign-linux/x86_64/minisign /usr/local/bin

    wget https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz
    wget https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz.minisig
    minisign -Vm zig-linux-x86_64-${ZIG_VERSION}.tar.xz -P ${ZIG_MINISIGN_PUBKEY}

    tar -xf zig-linux-x86_64-${ZIG_VERSION}.tar.xz
    mv zig-linux-x86_64-${ZIG_VERSION} zig
COMMAND

FROM base as MacOS_SDK
ARG MACOS_SDK_VERSION=11.3

RUN <<COMMAND
    wget https://github.com/phracker/MacOSX-SDKs/releases/download/${MACOS_SDK_VERSION}/MacOSX${MACOS_SDK_VERSION}.sdk.tar.xz -O macos_sdk.tar.xz
    tar xf macos_sdk.tar.xz
    mv MacOSX${MACOS_SDK_VERSION}.sdk MacOSX.sdk
COMMAND

# reduce file size
RUN rm -r MacOSX.sdk/usr/share/man

FROM base

COPY --from=source /mruby /mruby

COPY --from=zig zig /usr/local/share/zig
RUN ln -s /usr/local/share/zig/zig /usr/local/bin/zig

COPY --from=MacOS_SDK MacOSX.sdk /usr/local/share/MacOSX.sdk
ENV MACOSX_SDK_PATH=/usr/local/share/MacOSX.sdk

COPY entrypoint.sh /entrypoint.sh
COPY Rakefile /Rakefile

WORKDIR /src
ENTRYPOINT [ "/entrypoint.sh" ]
