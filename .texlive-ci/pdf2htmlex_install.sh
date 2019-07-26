#!/bin/bash
# pdf2htmlEX install shell script for Ubuntu 16.04, using latest sources
# Created by James A. Prempeh ( github.com/prmph )

mkdir /tmp/dependency_builds
HOME_PATH=$(cd "/tmp/dependency_builds" && pwd)
LINUX_ARCH="$(lscpu | grep 'Architecture' | awk -F\: '{ print $2 }' | tr -d ' ')"
POPPLER_SOURCE="https://poppler.freedesktop.org/poppler-0.43.0.tar.xz"
FONTFORGE_SOURCE="https://github.com/fontforge/fontforge.git"
PDF2HTMLEX_SOURCE="https://github.com/akhuettel/pdf2htmlEX.git"

if [ "$LINUX_ARCH" == "x86_64" ]; then
cd $HOME_PATH

  echo "Updating all Ubuntu software repository lists ..."
  sudo apt-get update

  echo "Installing gnu m4..."
  wget -nc ftp://ftp.gnu.org/gnu/m4/m4-1.4.17.tar.gz
  tar -xvzf m4-1.4.17.tar.gz
  cd m4-1.4.17
  ./configure --prefix=/usr/local/m4
  make
  sudo make install
  cd "$HOME_PATH"

  echo "Installing basic dependencies ..."
  sudo apt-get install -qq -y cmake gcc libgetopt++-dev git

  echo "Installing poppler dependencies..."
  sudo apt-get install -qq -y pkg-config libopenjpeg-dev libfontconfig1-dev libfontforge-dev poppler-data poppler-utils poppler-dbg

  echo "Downloading poppler via source ..."
  wget -nc "$POPPLER_SOURCE" --no-check-certificate
  tar -xvf poppler-0.43.0.tar.xz
  cd poppler-0.43.0/
  ./configure --enable-xpdf-headers
  make
  sudo make install

  echo "Installing fontforge dependencies..."
  cd "$HOME_PATH"
  sudo apt-get install -qq -y packaging-dev pkg-config python-dev libpango1.0-dev libglib2.0-dev libxml2-dev giflib-dbg
  sudo apt-get install -qq -y libjpeg-dev libtiff-dev uthash-dev libspiro-dev python3-dev
  sudo add-apt-repository ppa:fontforge/fontforge --yes
  sudo apt-get install -qq -y libfontforge-dev

  # [DEPRECATED]: this stuff doesn't work on travis-ci
  # echo "cloning fontforge via source ..."
  # git clone --depth 1 "$FONTFORGE_SOURCE"
  # cd fontforge/
  # ./bootstrap
  # ./configure --without-libuninameslist
  # make
  # sudo make install

  echo "Installing Pdf2htmlEx ..."
  cd "$HOME_PATH"
  git clone --depth 1 "$PDF2HTMLEX_SOURCE"
  cd pdf2htmlEX/
  cmake .
  make
  sudo make install

  echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
  source ~/.bashrc

  # cd "$HOME_PATH" && rm -rf "poppler-0.43.0.tar.xz"
  # cd "$HOME_PATH" && rm -rf "poppler-0.43.0"
  # cd "$HOME_PATH" && rm -rf "fontforge"
  # cd "$HOME_PATH" && rm -rf "pdf2htmlEX"

else
  echo "********************************************************************"
  echo "This script currently doesn't supports $LINUX_ARCH Linux archtecture"
fi

echo "----------------------------------"
echo "Restart your Ubuntu session for installation to complete..."
