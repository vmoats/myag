#!/bin/bash -e

# Patched qtwayland that outputs a fixed screen size
# Clone qtwayland submodule, checkout, apply patch, qmake, make
# VERSION=5.15.13-lts-lgpl
VERSION=5.12.9

cd /tmp
git clone --branch v${VERSION} https://github.com/qt/qtwayland.git
cd qtwayland

git apply /tmp/agnos/patch-qtwayland-v5.12

mkdir /tmp/build && cd /tmp/build
qmake /tmp/qtwayland

export MAKEFLAGS="-j$(nproc)"
make

# remove "--fstrans=no" when checkinstall is fixed (still not fixed in 24.04)
checkinstall -yD --install=no --fstrans=no --pkgversion="${VERSION}" --pkgname=qtwayland5 --pkgarch=arm64 --replaces=qtwayland5,libqt5waylandclient5,libqt5waylandcompositor5
mv qtwayland5*.deb /tmp/qtwayland5.deb
