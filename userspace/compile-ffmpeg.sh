#!/bin/bash -e

VERSION=4.2.2

# Install build requirements
apt-get update && apt-get install -yq --no-install-recommends \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libmp3lame-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    liblzma-dev \
    rsync \
    texinfo \
    zlib1g-dev

# Build ffmpeg (the one from the ubuntu repos doesn't work with our libOpenCL)
cd /tmp
wget https://ffmpeg.org/releases/ffmpeg-${VERSION}.tar.bz2
tar xvf ffmpeg-${VERSION}.tar.bz2
cd ffmpeg-${VERSION}

export DEBFULLNAME=comma
export LOGNAME=comma

dh_make --createorig -s -p ffmpeg_${VERSION} -y

# avoid makeinfo: error parsing ./doc/t2h.pm: Undefined subroutine &Texinfo::Config::set_from_init_file called at ./doc/t2h.pm line 24.
# with --disable-htmlpages
# --disable-doc works too, disables building documentation completely
# https://gist.github.com/omegdadi/6904512c0a948225c81114b1c5acb875
# https://github.com/7Ji/archrepo/issues/10
echo -e "override_dh_auto_configure:\n\t./configure --enable-shared --disable-static --disable-htmlpages" >> debian/rules
echo -e "override_dh_usrlocal:" >> debian/rules

DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -us -uc -nc

 mv ../ffmpeg*.deb /tmp/ffmpeg.deb
