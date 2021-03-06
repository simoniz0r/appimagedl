#!/bin/bash -e
# Title: appimagedl
# Description: Downloads and installs AppImages and precompiled tar archives.  Can also upgrade and remove installed packages.
# Dependencies: GNU coreutils, tar, wget
# Author: simonizor
# Website: http://www.simonizor.gq
# License: GPL v2.0 only
# Script for building releases of appimagedl

BUILD_DIR="/run/media/simonizor/0d208b29-3b29-4ffc-99be-1043b9f3c258/github/all-releases"
VERSION="0.0.5"
mkdir -p "$BUILD_DIR"/deps/extracted
mkdir "$BUILD_DIR"/appimagedl.AppDir

debiangetlatestdebfunc () {
    DEB_RELEASE="$1"
    DEB_ARCH="$2"
    DEB_NAME="$3"
    LATEST_DEB_URL="$(wget "https://packages.debian.org/$DEB_RELEASE/$DEB_ARCH/$DEB_NAME/download" -qO - | grep "<li>*..*$DEB_ARCH.deb" | cut -f2 -d'"' | head -n 1)"
    wget --no-verbose --read-timeout=30 "$LATEST_DEB_URL" -O "$BUILD_DIR"/deps/"$DEB_NAME".deb
}
debiangetlatestdebfunc "buster" amd64 "wget"
debiangetlatestdebfunc "buster" amd64 "libgnutls30"
debiangetlatestdebfunc "buster" amd64 "libidn2-0"
debiangetlatestdebfunc "buster" amd64 "libunistring2"
debiangetlatestdebfunc "buster" amd64 "libnettle6"
debiangetlatestdebfunc "buster" amd64 "libpcre3"
debiangetlatestdebfunc "buster" amd64 "libpsl5"
debiangetlatestdebfunc "buster" amd64 "libuuid1"
debiangetlatestdebfunc "buster" amd64 "zlib1g"

cd "$BUILD_DIR"/deps/extracted
debextractfunc () {
    ar x "$BUILD_DIR"/deps/"$1"
    rm -f "$BUILD_DIR"/deps/extracted/control.tar.gz
    rm -f "$BUILD_DIR"/deps/extracted/debian-binary
    tar -xf "$BUILD_DIR"/deps/extracted/data.tar.* -C "$BUILD_DIR"/deps/extracted/
    rm -f "$BUILD_DIR"/deps/extracted/data.tar.*
    if [ -f "$BUILD_DIR"/deps/extracted/usr/share/doc/git/contrib/subtree/COPYING ]; then
        rm "$BUILD_DIR"/deps/extracted/usr/share/doc/git/contrib/subtree/COPYING
    fi
    if [ -f "$BUILD_DIR"/deps/extracted/usr/share/doc/git/contrib/persistent-https/LICENSE ]; then
        rm "$BUILD_DIR"/deps/extracted/usr/share/doc/git/contrib/persistent-https/LICENSE
    fi
    cp -r "$BUILD_DIR"/deps/extracted/* "$BUILD_DIR"/appimagedl.AppDir/
    rm -rf "$BUILD_DIR"/deps/extracted/*
}

debextractfunc "wget.deb"
debextractfunc "libgnutls30.deb"
debextractfunc "libnettle6.deb"
debextractfunc "libidn2-0.deb"
debextractfunc "libunistring2.deb"
debextractfunc "libpcre3.deb"
debextractfunc "libpsl5.deb"
debextractfunc "libuuid1.deb"
debextractfunc "zlib1g.deb"
rm -rf "$BUILD_DIR"/deps

mkdir -p "$BUILD_DIR"/appimagedl.AppDir/usr/share/appimagedl
cp ~/github/appimagedl/appimagedl "$BUILD_DIR"/appimagedl.AppDir/usr/bin/
cp ~/github/appimagedl/appimagedl.1 "$BUILD_DIR"/appimagedl.AppDir/usr/share/appimagedl
cp ~/github/appimagedl/LICENSE "$BUILD_DIR"/appimagedl.AppDir/usr/share/appimagedl
cp ~/github/appimagedl/jq "$BUILD_DIR"/appimagedl.AppDir/usr/bin/
cp ~/github/appimagedl/appimagedl.json "$BUILD_DIR"/appimagedl.AppDir/usr/bin/.appimagedl.json
cp /usr/local/bin/appimageupdatetool "$BUILD_DIR"/appimagedl.AppDir/usr/bin/
cp ~/github/appimagedl/appimagedl.desktop "$BUILD_DIR"/appimagedl.AppDir/
cp ~/github/appimagedl/appimagedl.png "$BUILD_DIR"/appimagedl.AppDir/

wget "https://raw.githubusercontent.com/simoniz0r/spm-repo/aibs/resources/AppRun" -O "$BUILD_DIR"/appimagedl.AppDir/AppRun
chmod a+x "$BUILD_DIR"/appimagedl.AppDir/AppRun
chmod a+x "$BUILD_DIR"/appimagedl.AppDir/usr/bin/appimagedl

cat >"$BUILD_DIR"/AppRun.conf << EOL
APPRUN_SET_PATH="TRUE"
APPRUN_SET_LD_LIBRARY_PATH="TRUE"
APPRUN_SET_PYTHONPATH="FALSE"
APPRUN_SET_PYTHONHOME="FALSE"
APPRUN_SET_PYTHONDONTWRITEBYTECODE="FALSE"
APPRUN_SET_XDG_DATA_DIRS="TRUE"
APPRUN_SET_PERLLIB="FALSE"
APPRUN_SET_GSETTINGS_SCHEMA_DIR="FALSE"
APPRUN_SET_QT_PLUGIN_PATH="FALSE"
APPRUN_EXEC="./usr/bin/appimagedl"
EOL

appimagetool "$BUILD_DIR"/appimagedl.AppDir "$BUILD_DIR"/appimagedl-"$VERSION"-x86_64.AppImage || exit 1
rm -rf "$BUILD_DIR"/appimagedl.AppDir
exit 0
