#!/bin/bash

export REPO_DIR=$PWD
export DEPS_DIR=${REPO_DIR}/deps
export DEPS_INCLUDE_DIR=${DEPS_DIR}/include

#
# ACTIVATE EMSCRIPTEN TOOLCHAIN
#

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
    pwd
fi

rm -rf build
mkdir build
cd build

export OGG_LIBRARY=${DEPS_DIR}/lib/libogg.a
export OGG_INCLUDE_DIR=${DEPS_INCLUDE_DIR}
export OGG_FOUND=1

export OPUS_LIBRARY=${DEPS_DIR}/lib/libopus.a
export OPUS_INCLUDE_DIR=${DEPS_INCLUDE_DIR}

export FLAC_LIBRARY=${DEPS_DIR}/lib/libFLAC.a
export FLAC_INCLUDE_DIR=${DEPS_INCLUDE_DIR}

export Vorbis_Vorbis_INCLUDE_DIR=${DEPS_INCLUDE_DIR}
export Vorbis_Enc_INCLUDE_DIR=${DEPS_INCLUDE_DIR}
export Vorbis_File_INCLUDE_DIR=${DEPS_INCLUDE_DIR}

export Vorbis_Vorbis_LIBRARY=${DEPS_DIR}/lib/libvorbis.a
export Vorbis_Enc_LIBRARY=${DEPS_DIR}/lib/libvorbisenc.a
export Vorbis_File_LIBRARY=${DEPS_DIR}/lib/libvorbisfile.a

export PKG_CONFIG_PATH=${REPO_DIR}/deps/lib/pkgconfig
export EM_PKG_CONFIG_PATH=${PKG_CONFIG_PATH}

# FIXME: first attempt always fails no matter what with OGG_FOUND undefined related errors
emcmake cmake -DBUILD_TESTING=OFF -DENABLE_CPACK=OFF -DINSTALL_PKGCONFIG_MODULE=ON -DINSTALL_MANPAGES=OFF -DBUILD_PROGRAMS=OFF -DBUILD_EXAMPLES=OFF ..

# Exit immediately if a command exits with a non-zero status.
set -e

# But second attempt to configure project should succeed
emcmake cmake -DBUILD_TESTING=OFF -DENABLE_CPACK=OFF -DINSTALL_PKGCONFIG_MODULE=ON -DINSTALL_MANPAGES=OFF -DBUILD_PROGRAMS=OFF -DBUILD_EXAMPLES=OFF ..
emmake make
