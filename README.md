# libsndfile-emscripten

libsndfile + dependencies built with emscripten toolchain for [fluidsynth-emscripten](https://github.com/enikey87/fluidsynth-emscripten) to support sf3.

Rough draft.

See [original README](README.orig.md) for details of libsnd itself.
## Building from command line

```shell
# download & compile dependencies to emscripten static libraries into deps folder
./deps.sh
# build libsndfile with emscripten toolchain itself, compiled version is in deps folder along with libsnd compiled dependencies
./build.sh
````
