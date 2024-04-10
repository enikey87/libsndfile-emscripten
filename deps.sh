#!/bin/sh

REPO_DIR=$PWD

#
# DOWNLOAD DEPENDENCIES REQUIRED TO BUILD libsndfile for fluidsynth to support SF3 format.
#

rm -rf deps
mkdir -p deps
cd deps

DEPS_DIR=$PWD
echo "DEPS_DIR: ${DEPS_DIR}"

echo "Downloading libogg..."
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.xz
tar xvf libogg-1.3.3.tar.xz

echo "Downloading libvorbis..."
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz
tar xvf libvorbis-1.3.6.tar.xz

echo "Downloading libflac..."
wget http://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz
tar xvf flac-1.3.2.tar.xz

echo "Downloading libopus..."
wget -c https://github.com/xiph/opus/archive/refs/tags/v1.1.2.tar.gz -O opus-1.1.2.tar.gz
tar -xzf opus-1.1.2.tar.gz

cd ..

ls -ll deps/libogg-1.3.3/
ls -ll deps/libvorbis-1.3.6/
ls -ll deps/flac-1.3.2/
ls -ll deps/libsndfile-1.0.25/
ls -ll deps/opus-1.1.2/

# ACTIVATE EMSCRIPTEN TOOLCHAIN

if command -v emcmake >/dev/null 2>&1; then
    echo "emcmake is available"
    # Proceed with your script that uses emcmake
else
    echo "emcmake is not available"

    # Check if the emsdk directory does not exist
    if [ ! -d "../emsdk" ]; then
        # Clone the emsdk repository into the parent directory
        git clone https://github.com/emscripten-core/emsdk.git ../emsdk
    fi

    cd ../emsdk

    ./emsdk install latest
    ./emsdk activate latest

    source ./emsdk_env.sh
    cd $REPO_DIR
fi

#
# COMPILE DEPS TO WEBASSEMBLY MODULES
#

# Exit immediately if a command exits with a non-zero status.
set -e

cd deps

export CFLAGS="-O3 -flto"
export CXXFLAGS="-O3 -flto"

echo "Building libogg..."
cd libogg-1.3.3
emconfigure ./configure --enable-static --disable-shared --prefix=$DEPS_DIR --libdir=$DEPS_DIR/lib --includedir=$DEPS_DIR/include
emmake make
emmake make install
cd ..

echo "Building libvorbis..."
cd libvorbis-1.3.6
emconfigure ./configure --enable-static --disable-shared --prefix=$DEPS_DIR --libdir=$DEPS_DIR/lib --includedir=$DEPS_DIR/include
emmake make CPPFLAGS="-I$DEPS_DIR/libogg-1.3.3/include"
emmake make install
cd ..

echo "Building libflac..."
cd flac-1.3.2
emconfigure ./configure --enable-static --disable-shared --prefix=$DEPS_DIR --libdir=$DEPS_DIR/lib --includedir=$DEPS_DIR/include --with-ogg-libraries=$DEPS_DIR/lib --with-ogg-includes=$DEPS_DIR/include --host=asmjs
emmake make
emmake make install
cd ..

echo "Building opus..."
cd opus-1.1.2
./autogen.sh
emconfigure ./configure --enable-static --disable-shared --prefix=$DEPS_DIR --libdir=$DEPS_DIR/lib --includedir=$DEPS_DIR/include
emmake make
emmake make install
cd ..

echo "What was built:"
find . -name "*.a" -ls
find . -name "*.la" -ls
