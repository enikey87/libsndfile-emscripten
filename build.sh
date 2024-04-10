mkdir build
cd build

# ./configure
emcmake cmake -DBUILD_TESTING=OFF -DENABLE_CPACK=OFF -DINSTALL_PKGCONFIG_MODULE=OFF -DINSTALL_MANPAGES=OFF ..

# make
emmake make