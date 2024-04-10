# libsndfile-emscripten

libsndfile + dependencies built with emscripten toolchain for [fluidsynth-emscripten](https://github.com/enikey87/fluidsynth-emscripten) to support sf3.

Rough draft.

See [original README](README.orig.md) for details of libsnd itself.
## Building from command line

```shell
# download & compile dependencies to emscripten static libraries
./deps.sh
# build libsndfile with emscripten toolchain itself, output is in build folder
./build.sh
````
