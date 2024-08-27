#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# Add armhf as supported architecture
dpkg --add-architecture armhf

apt-fast update && apt-fast install --no-install-recommends -yq \
    libi2c-dev \
    libncursesw5-dev \
    libnss-myhostname \
    libgdbm-dev \
    libc6-dev \
    libsqlite3-dev \
    libssl-dev \
    libffi-dev \
    libacl1:armhf \
    libasan6-armhf-cross \
    libatomic1-armhf-cross \
    libattr1:armhf \
    libaudit1:armhf \
    libblkid1:armhf \
    libc6:armhf \
    libc6-armhf-cross \
    libc6-dev:armhf \
    libc6-dev-armhf-cross \
    libcairo2:armhf \
    libcap2:armhf \
    libdrm2:armhf \
    libevdev2:armhf \
    libexpat1:armhf \
    libffi8:armhf \
    libfontconfig1:armhf \
    libfreetype6:armhf \
    libgbm1:armhf \
    libgcc-11-dev-armhf-cross \
    libglib2.0-0t64:armhf \
    libgomp1-armhf-cross \
    libgudev-1.0-0:armhf \
    libinput-bin:armhf \
    libinput-dev:armhf \
    libinput10:armhf \
    libjpeg-dev:armhf \
    libjpeg-turbo8:armhf \
    libjpeg-turbo8-dev:armhf \
    libjpeg8:armhf \
    libjpeg8-dev:armhf \
    libkmod2:armhf \
    libmtdev1t64:armhf \
    libpam0g:armhf \
    libpam0g-dev:armhf \
    libpcre3:armhf \
    libpixman-1-0:armhf \
    libpng16-16t64:armhf \
    libselinux1:armhf \
    libstdc++6:armhf \
    libstdc++6-armhf-cross \
    libubsan1-armhf-cross \
    libudev-dev:armhf \
    libudev1:armhf \
    libuuid1:armhf \
    libwacom9:armhf \
    libx11-6:armhf \
    libxau6:armhf \
    libxcb-render0:armhf \
    libxcb-shm0:armhf \
    libxcb1:armhf \
    libxdmcp6:armhf \
    libxext6:armhf \
    libxkbcommon0:armhf \
    libxrender1:armhf \
    linux-libc-dev:armhf \
    linux-libc-dev-armhf-cross \
    zlib1g:armhf \
    libegl1 \
    libegl-dev \
    libgles1 \
    libgles2 \
    libgles-dev \
    libgtk2.0-dev \
    libxml2:armhf \
